import 'package:flutter/material.dart';
import 'base_carbon_input_page.dart';

class WasteInputPage extends BaseCarbonInputPage {
  const WasteInputPage({Key? key})
      : super(category: 'Waste and Recycling', key: key);

  @override
  WasteInputPageState createState() => WasteInputPageState();
}

class WasteInputPageState extends BaseCarbonInputPageState<WasteInputPage> {
  final Map<String, double> _weeklyWaste = {
    'General Waste': 0,
    'Plastic': 0,
    'Paper': 0,
    'Glass': 0,
    'Metal': 0,
    'Organic': 0,
    'Electronic': 0,
  };

  bool _composting = false;
  String _recyclingFrequency = 'Weekly';
  bool _wasteReduction = false;

  final List<String> _frequencies = [
    'Daily',
    'Weekly',
    'Bi-weekly',
    'Monthly',
  ];

  @override
  Future<Map<String, dynamic>> collectInputData() async {
    return {
      'weekly_waste': _weeklyWaste,
      'composting': _composting,
      'recycling_frequency': _recyclingFrequency,
      'active_waste_reduction': _wasteReduction,
    };
  }

  Widget _buildWasteField(String category) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(category),
          ),
          Expanded(
            flex: 3,
            child: Slider(
              value: _weeklyWaste[category] ?? 0,
              min: 0,
              max: 50,
              divisions: 50,
              label: '${_weeklyWaste[category]?.toStringAsFixed(1)} kg',
              onChanged: (value) {
                setState(() {
                  _weeklyWaste[category] = value;
                });
              },
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              '${_weeklyWaste[category]?.toStringAsFixed(1)} kg',
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
          value: _recyclingFrequency,
          decoration: const InputDecoration(
            labelText: 'Recycling Frequency',
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
              setState(() => _recyclingFrequency = value);
            }
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Weekly Waste by Category (kg)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ..._weeklyWaste.keys.map(_buildWasteField).toList(),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Do you practice composting?'),
          subtitle: const Text('Converting organic waste into fertilizer'),
          value: _composting,
          onChanged: (bool value) {
            setState(() {
              _composting = value;
            });
          },
        ),
        SwitchListTile(
          title: const Text('Do you actively try to reduce waste?'),
          subtitle: const Text('Using reusable items, avoiding single-use products'),
          value: _wasteReduction,
          onChanged: (bool value) {
            setState(() {
              _wasteReduction = value;
            });
          },
        ),
      ],
    );
  }
} 