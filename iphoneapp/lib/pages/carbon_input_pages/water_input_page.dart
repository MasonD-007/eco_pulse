import 'package:flutter/material.dart';
import 'base_carbon_input_page.dart';

class WaterInputPage extends BaseCarbonInputPage {
  const WaterInputPage({Key? key})
      : super(category: 'Water Usage', key: key);

  @override
  WaterInputPageState createState() => WaterInputPageState();
}

class WaterInputPageState extends BaseCarbonInputPageState<WaterInputPage> {
  final _monthlyUsageController = TextEditingController();
  final Map<String, bool> _waterSavingMethods = {
    'Low-flow Fixtures': false,
    'Rainwater Harvesting': false,
    'Water-efficient Appliances': false,
    'Drought-resistant Landscaping': false,
    'Greywater Recycling': false,
  };

  String _usageType = 'Residential';
  bool _waterConservation = false;

  final List<String> _usageTypes = [
    'Residential',
    'Commercial',
    'Agricultural',
    'Industrial',
  ];

  @override
  void dispose() {
    _monthlyUsageController.dispose();
    super.dispose();
  }

  @override
  Future<Map<String, dynamic>> collectInputData() async {
    return {
      'monthly_usage_liters': double.parse(_monthlyUsageController.text),
      'usage_type': _usageType,
      'water_conservation': _waterConservation,
      'water_saving_methods': _waterSavingMethods,
    };
  }

  @override
  Widget buildInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _usageType,
          decoration: const InputDecoration(
            labelText: 'Usage Type',
            border: OutlineInputBorder(),
          ),
          items: _usageTypes
              .map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _usageType = value);
            }
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _monthlyUsageController,
          decoration: const InputDecoration(
            labelText: 'Monthly Water Usage (Liters)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter water usage';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Water Conservation Methods',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ..._waterSavingMethods.entries.map(
          (entry) => CheckboxListTile(
            title: Text(entry.key),
            value: entry.value,
            onChanged: (bool? value) {
              if (value != null) {
                setState(() {
                  _waterSavingMethods[entry.key] = value;
                });
              }
            },
          ),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Do you actively conserve water?'),
          subtitle: const Text('Regular monitoring and conscious reduction efforts'),
          value: _waterConservation,
          onChanged: (bool value) {
            setState(() {
              _waterConservation = value;
            });
          },
        ),
      ],
    );
  }
} 