class CarbonSummary {
  final double totalEmissions;
  final Map<String, double> categoryEmissions;
  final List<CarbonHistoryPoint> history;
  final double offsetAmount;
  final double reductionPercentage;

  CarbonSummary({
    required this.totalEmissions,
    required this.categoryEmissions,
    required this.history,
    required this.offsetAmount,
    required this.reductionPercentage,
  });

  factory CarbonSummary.fromJson(Map<String, dynamic> json) {
    return CarbonSummary(
      totalEmissions: json['total_emissions'].toDouble(),
      categoryEmissions: Map<String, double>.from(json['category_emissions']),
      history: (json['history'] as List)
          .map((e) => CarbonHistoryPoint.fromJson(e))
          .toList(),
      offsetAmount: json['offset_amount'].toDouble(),
      reductionPercentage: json['reduction_percentage'].toDouble(),
    );
  }
}

class CarbonHistoryPoint {
  final DateTime date;
  final double emissions;
  final Map<String, double> breakdown;

  CarbonHistoryPoint({
    required this.date,
    required this.emissions,
    required this.breakdown,
  });

  factory CarbonHistoryPoint.fromJson(Map<String, dynamic> json) {
    return CarbonHistoryPoint(
      date: DateTime.parse(json['date']),
      emissions: json['emissions'].toDouble(),
      breakdown: Map<String, double>.from(json['breakdown']),
    );
  }
}

class CategoryBreakdown {
  final String category;
  final Map<String, double> subCategories;
  final List<CategoryHistoryPoint> history;
  final double totalEmissions;

  CategoryBreakdown({
    required this.category,
    required this.subCategories,
    required this.history,
    required this.totalEmissions,
  });

  factory CategoryBreakdown.fromJson(Map<String, dynamic> json) {
    return CategoryBreakdown(
      category: json['category'],
      subCategories: Map<String, double>.from(json['sub_categories']),
      history: (json['history'] as List)
          .map((e) => CategoryHistoryPoint.fromJson(e))
          .toList(),
      totalEmissions: json['total_emissions'].toDouble(),
    );
  }
}

class CategoryHistoryPoint {
  final DateTime date;
  final Map<String, double> values;

  CategoryHistoryPoint({
    required this.date,
    required this.values,
  });

  factory CategoryHistoryPoint.fromJson(Map<String, dynamic> json) {
    return CategoryHistoryPoint(
      date: DateTime.parse(json['date']),
      values: Map<String, double>.from(json['values']),
    );
  }
} 