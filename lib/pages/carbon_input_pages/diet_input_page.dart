import 'package:flutter/material.dart';
import 'base_carbon_input_page.dart';

class DietInputPage extends BaseCarbonInputPage {
  const DietInputPage({Key? key})
      : super(category: 'Diet and Food Consumption', key: key);

  @override
  DietInputPageState createState() => DietInputPageState();
}

class DietInputPageState extends BaseCarbonInputPageState<DietInputPage> {
  final Map<String, double> _foodConsumption = {
    'Beef': 0,
    'Pork': 0,
    'Poultry': 0,
    'Fish': 0,
    'Dairy': 0,
    'Eggs': 0,
    'Vegetables': 0,
    'Fruits': 0,
    'Grains': 0,
  };

  String _dietType = 'Omnivore';
  bool _locallySourced = false;
  bool _organicPreference = false;

  final List<String> _dietTypes = [
    'Omnivore',
    'Vegetarian',
    'Vegan',
    'Pescatarian',
    'Flexitarian',
  ];

  @override
  Future<Map<String, dynamic>> collectInputData() async {
    return {
      'diet_type': _dietType,
      'food_consumption': _foodConsumption,
      'locally_sourced': _locallySourced,
      'organic_preference': _organicPreference,
    };
  }

  Widget _buildFoodConsumptionField(String foodType) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(foodType),
          ),
          Expanded(
            flex: 3,
            child: Slider(
              value: _foodConsumption[foodType] ?? 0,
              min: 0,
              max: 10,
              divisions: 10,
              label: '${_foodConsumption[foodType]?.toStringAsFixed(1)} kg/week',
              onChanged: (value) {
                setState(() {
                  _foodConsumption[foodType] = value;
                });
              },
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              '${_foodConsumption[foodType]?.toStringAsFixed(1)}',
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _dietType,
          decoration: const InputDecoration(
            labelText: 'Diet Type',
            border: OutlineInputBorder(),
          ),
          items: _dietTypes
              .map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _dietType = value);
            }
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Weekly Food Consumption (kg)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ..._foodConsumption.keys.map(_buildFoodConsumptionField).toList(),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Do you prefer locally sourced food?'),
          value: _locallySourced,
          onChanged: (bool value) {
            setState(() {
              _locallySourced = value;
            });
          },
        ),
        SwitchListTile(
          title: const Text('Do you prefer organic food?'),
          value: _organicPreference,
          onChanged: (bool value) {
            setState(() {
              _organicPreference = value;
            });
          },
        ),
      ],
    );
  }
} 