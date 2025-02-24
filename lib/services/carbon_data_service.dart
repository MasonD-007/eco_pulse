import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/carbon_input.dart';

class CarbonDataService {
  static final CarbonDataService _instance = CarbonDataService._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  factory CarbonDataService() {
    return _instance;
  }

  CarbonDataService._internal();

  String? get _userId => _auth.currentUser?.uid;

  Future<void> submitCarbonInput(CarbonInput input) async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      final userDoc = _firestore.collection('users').doc(_userId);
      final carbonDataRef = userDoc.collection('carbon_data');

      // Create a new document with the current timestamp
      await carbonDataRef.add({
        'category': input.category,
        'date': input.date.toIso8601String(),
        'data': input.data,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Update the category totals
      final categoryRef = userDoc.collection('category_totals').doc(input.category);
      await _firestore.runTransaction((transaction) async {
        final categoryDoc = await transaction.get(categoryRef);
        
        if (categoryDoc.exists) {
          final currentTotal = categoryDoc.data()?['total'] ?? 0.0;
          transaction.update(categoryRef, {
            'total': currentTotal + _calculateEmissions(input),
            'last_updated': FieldValue.serverTimestamp(),
          });
        } else {
          transaction.set(categoryRef, {
            'total': _calculateEmissions(input),
            'last_updated': FieldValue.serverTimestamp(),
          });
        }
      });
    } catch (e) {
      print('Error submitting carbon data: $e');
      throw Exception('Failed to submit carbon data');
    }
  }

  Future<Map<String, dynamic>> getCarbonSummary() async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      final userDoc = _firestore.collection('users').doc(_userId);
      
      // Get category totals
      final categoryTotals = await userDoc.collection('category_totals').get();
      final Map<String, double> categoryEmissions = {};
      double totalEmissions = 0;
      
      for (var doc in categoryTotals.docs) {
        final total = (doc.data()['total'] ?? 0.0).toDouble();
        categoryEmissions[doc.id] = total;
        totalEmissions += total;
      }

      // Get historical data
      final historicalData = await userDoc
          .collection('carbon_data')
          .orderBy('timestamp', descending: true)
          .limit(30)
          .get();

      final List<Map<String, dynamic>> history = [];
      for (var doc in historicalData.docs) {
        final data = doc.data();
        history.add({
          'date': data['date'],
          'emissions': _calculateEmissions(CarbonInput(
            category: data['category'],
            date: DateTime.parse(data['date']),
            data: Map<String, dynamic>.from(data['data']),
          )),
          'breakdown': data['data'],
        });
      }

      // Calculate offset and reduction
      final offsetData = await userDoc.collection('carbon_data')
          .where('category', isEqualTo: 'Offset Efforts')
          .get();
      
      double offsetAmount = 0;
      for (var doc in offsetData.docs) {
        final data = doc.data();
        offsetAmount += _calculateOffsetAmount(data['data']);
      }

      // Calculate reduction percentage (comparing to previous month)
      final reductionPercentage = await _calculateReductionPercentage(userDoc);

      return {
        'total_emissions': totalEmissions,
        'category_emissions': categoryEmissions,
        'history': history,
        'offset_amount': offsetAmount,
        'reduction_percentage': reductionPercentage,
      };
    } catch (e) {
      print('Error fetching carbon summary: $e');
      throw Exception('Failed to fetch carbon summary');
    }
  }

  Future<Map<String, dynamic>> getCategoryBreakdown(String category) async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      final userDoc = _firestore.collection('users').doc(_userId);
      
      // Get category data
      final categoryData = await userDoc
          .collection('carbon_data')
          .where('category', isEqualTo: category)
          .orderBy('timestamp', descending: true)
          .limit(30)
          .get();

      final Map<String, double> subCategories = {};
      final List<Map<String, dynamic>> history = [];
      double totalEmissions = 0;

      for (var doc in categoryData.docs) {
        final data = doc.data();
        final inputData = Map<String, dynamic>.from(data['data']);
        
        // Aggregate subcategory totals
        inputData.forEach((key, value) {
          if (value is num) {
            subCategories[key] = (subCategories[key] ?? 0) + value.toDouble();
          }
        });

        // Build history points
        history.add({
          'date': data['date'],
          'values': inputData,
        });

        // Calculate total emissions for this category
        totalEmissions += _calculateEmissions(CarbonInput(
          category: category,
          date: DateTime.parse(data['date']),
          data: inputData,
        ));
      }

      return {
        'category': category,
        'sub_categories': subCategories,
        'history': history,
        'total_emissions': totalEmissions,
      };
    } catch (e) {
      print('Error fetching category breakdown: $e');
      throw Exception('Failed to fetch category breakdown');
    }
  }

  double _calculateEmissions(CarbonInput input) {
    // Implement emission calculation logic based on category and data
    // This is a simplified example - you should implement proper calculation formulas
    switch (input.category) {
      case 'Transportation':
        return (input.data['distance'] ?? 0) * 0.2; // Example: 0.2 kg CO2 per km
      case 'Energy Consumption':
        return (input.data['electricity_kwh'] ?? 0) * 0.5; // Example: 0.5 kg CO2 per kWh
      case 'Diet and Food Consumption':
        double total = 0;
        (input.data['food_consumption'] as Map<String, dynamic>).forEach((key, value) {
          total += (value as num) * _getFoodEmissionFactor(key);
        });
        return total;
      // Add cases for other categories
      default:
        return 0;
    }
  }

  double _getFoodEmissionFactor(String foodType) {
    // Example emission factors (kg CO2e per kg of food)
    switch (foodType) {
      case 'Beef': return 60;
      case 'Pork': return 7;
      case 'Poultry': return 6;
      case 'Fish': return 5;
      case 'Dairy': return 21;
      case 'Vegetables': return 2;
      case 'Fruits': return 1;
      case 'Grains': return 2.7;
      default: return 1;
    }
  }

  double _calculateOffsetAmount(Map<String, dynamic> offsetData) {
    double total = 0;
    final amounts = Map<String, double>.from(offsetData['offset_amounts'] ?? {});
    amounts.forEach((activity, amount) {
      // Example: Convert monetary amount to CO2e offset
      // You should implement proper conversion factors
      total += amount * 0.1; // Example: $1 = 0.1 kg CO2e offset
    });
    return total;
  }

  Future<double> _calculateReductionPercentage(DocumentReference userDoc) async {
    try {
      final now = DateTime.now();
      final thisMonth = DateTime(now.year, now.month);
      final lastMonth = DateTime(now.year, now.month - 1);

      final thisMonthData = await userDoc
          .collection('carbon_data')
          .where('date', isGreaterThanOrEqualTo: thisMonth.toIso8601String())
          .get();

      final lastMonthData = await userDoc
          .collection('carbon_data')
          .where('date', isGreaterThanOrEqualTo: lastMonth.toIso8601String())
          .where('date', isLessThan: thisMonth.toIso8601String())
          .get();

      double thisMonthEmissions = 0;
      double lastMonthEmissions = 0;

      for (var doc in thisMonthData.docs) {
        final data = doc.data();
        thisMonthEmissions += _calculateEmissions(CarbonInput(
          category: data['category'],
          date: DateTime.parse(data['date']),
          data: Map<String, dynamic>.from(data['data']),
        ));
      }

      for (var doc in lastMonthData.docs) {
        final data = doc.data();
        lastMonthEmissions += _calculateEmissions(CarbonInput(
          category: data['category'],
          date: DateTime.parse(data['date']),
          data: Map<String, dynamic>.from(data['data']),
        ));
      }

      if (lastMonthEmissions == 0) return 0;
      return ((lastMonthEmissions - thisMonthEmissions) / lastMonthEmissions) * 100;
    } catch (e) {
      print('Error calculating reduction percentage: $e');
      return 0;
    }
  }
} 