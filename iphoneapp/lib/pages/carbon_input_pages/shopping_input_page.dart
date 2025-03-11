import 'package:flutter/material.dart';
import 'base_carbon_input_page.dart';

class ShoppingInputPage extends BaseCarbonInputPage {
  const ShoppingInputPage({Key? key})
      : super(category: 'Shopping and Goods', key: key);

  @override
  ShoppingInputPageState createState() => ShoppingInputPageState();
}

class ShoppingInputPageState extends BaseCarbonInputPageState<ShoppingInputPage> {
  final Map<String, double> _monthlySpending = {
    'Clothing': 0,
    'Electronics': 0,
    'Furniture': 0,
    'Appliances': 0,
    'Books and Media': 0,
    'Personal Care': 0,
    'Home Goods': 0,
  };

  bool _preferSustainable = false;
  bool _preferSecondHand = false;
  String _shoppingFrequency = 'Monthly';

  final List<String> _frequencies = [
    'Weekly',
    'Monthly',
    'Quarterly',
    'Yearly',
  ];

  @override
  Future<Map<String, dynamic>> collectInputData() async {
    return {
      'monthly_spending': _monthlySpending,
      'prefer_sustainable': _preferSustainable,
      'prefer_second_hand': _preferSecondHand,
      'shopping_frequency': _shoppingFrequency,
    };
  }

  Widget _buildSpendingField(String category) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        initialValue: _monthlySpending[category]?.toString() ?? '0',
        decoration: InputDecoration(
          labelText: '$category Spending (\$)',
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter amount';
          }
          if (double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
        onChanged: (value) {
          setState(() {
            _monthlySpending[category] = double.tryParse(value) ?? 0;
          });
        },
      ),
    );
  }

  @override
  Widget buildInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _shoppingFrequency,
          decoration: const InputDecoration(
            labelText: 'Shopping Frequency',
            border: OutlineInputBorder(),
          ),
          items: _frequencies
              .map((freq) => DropdownMenuItem(
                    value: freq,
                    child: Text(freq),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _shoppingFrequency = value);
            }
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Monthly Spending by Category',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ..._monthlySpending.keys.map(_buildSpendingField).toList(),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Do you prefer sustainable products?'),
          subtitle: const Text('Eco-friendly and environmentally conscious items'),
          value: _preferSustainable,
          onChanged: (bool value) {
            setState(() {
              _preferSustainable = value;
            });
          },
        ),
        SwitchListTile(
          title: const Text('Do you buy second-hand items?'),
          subtitle: const Text('Used or refurbished products'),
          value: _preferSecondHand,
          onChanged: (bool value) {
            setState(() {
              _preferSecondHand = value;
            });
          },
        ),
      ],
    );
  }
} 