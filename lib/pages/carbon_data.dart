import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home.dart';

class CarbonDataPage extends StatefulWidget {
  const CarbonDataPage({super.key});

  @override
  State<CarbonDataPage> createState() => _CarbonDataPageState();
}

class _CarbonDataPageState extends State<CarbonDataPage> {
  final _authService = AuthService();
  bool _isLoading = false;
  final List<CarbonDataItem> _items = [
    CarbonDataItem(
      title: 'Transportation',
      icon: Icons.directions_car_outlined,
      isSelected: false,
    ),
    CarbonDataItem(
      title: 'Energy Consumption',
      icon: Icons.bolt_outlined,
      isSelected: false,
    ),
    CarbonDataItem(
      title: 'Diet and Food Consumption',
      icon: Icons.restaurant_outlined,
      isSelected: false,
    ),
    CarbonDataItem(
      title: 'Shopping and Goods',
      icon: Icons.shopping_bag_outlined,
      isSelected: false,
    ),
    CarbonDataItem(
      title: 'Waste and Recycling',
      icon: Icons.delete_outline,
      isSelected: false,
    ),
    CarbonDataItem(
      title: 'Water Usage',
      icon: Icons.water_drop_outlined,
      isSelected: false,
    ),
    CarbonDataItem(
      title: 'Travel and Holidays',
      icon: Icons.flight_outlined,
      isSelected: false,
    ),
    CarbonDataItem(
      title: 'Offset Efforts',
      icon: Icons.eco_outlined,
      isSelected: false,
    ),
  ];

  Future<void> _handleNext() async {
    final selectedCategories = _items
        .where((item) => item.isSelected)
        .map((item) => item.title)
        .toList();

    if (selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one category'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.updateCarbonDataPreferences(selectedCategories);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(title: 'EcoPulse'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save preferences. Please try again.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Personal Carbon Data',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'The more information allows us to create more accurate graphs for you.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              item.isSelected = !item.isSelected;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: item.isSelected
                                  ? Colors.blue.withOpacity(0.1)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  item.icon,
                                  color: item.isSelected ? Colors.blue : Colors.grey[600],
                                  size: 24,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  item.title,
                                  style: TextStyle(
                                    color: item.isSelected ? Colors.blue : Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                if (item.isSelected)
                                  const Icon(
                                    Icons.check,
                                    color: Colors.blue,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CarbonDataItem {
  final String title;
  final IconData icon;
  bool isSelected;

  CarbonDataItem({
    required this.title,
    required this.icon,
    required this.isSelected,
  });
} 