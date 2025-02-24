import 'package:flutter/material.dart';
import 'base_carbon_input_page.dart';

class OffsetInputPage extends BaseCarbonInputPage {
  const OffsetInputPage({Key? key})
      : super(category: 'Offset Efforts', key: key);

  @override
  OffsetInputPageState createState() => OffsetInputPageState();
}

class OffsetInputPageState extends BaseCarbonInputPageState<OffsetInputPage> {
  final Map<String, bool> _offsetActivities = {
    'Tree Planting': false,
    'Renewable Energy Investment': false,
    'Carbon Credit Purchase': false,
    'Community Projects': false,
    'Sustainable Agriculture': false,
    'Ocean Conservation': false,
  };

  final Map<String, double> _offsetAmounts = {
    'Tree Planting': 0,
    'Renewable Energy Investment': 0,
    'Carbon Credit Purchase': 0,
    'Community Projects': 0,
    'Sustainable Agriculture': 0,
    'Ocean Conservation': 0,
  };

  String _offsetFrequency = 'Monthly';
  bool _hasVerification = false;

  final List<String> _frequencies = [
    'Weekly',
    'Monthly',
    'Quarterly',
    'Yearly',
  ];

  @override
  Future<Map<String, dynamic>> collectInputData() async {
    return {
      'offset_activities': _offsetActivities,
      'offset_amounts': _offsetAmounts,
      'offset_frequency': _offsetFrequency,
      'has_verification': _hasVerification,
    };
  }

  Widget _buildOffsetActivityField(String activity) {
    return Column(
      children: [
        CheckboxListTile(
          title: Text(activity),
          value: _offsetActivities[activity],
          onChanged: (bool? value) {
            if (value != null) {
              setState(() {
                _offsetActivities[activity] = value;
              });
            }
          },
        ),
        if (_offsetActivities[activity] ?? false)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Slider(
                    value: _offsetAmounts[activity] ?? 0,
                    min: 0,
                    max: 1000,
                    divisions: 100,
                    label: '\$${_offsetAmounts[activity]?.toStringAsFixed(0)}',
                    onChanged: (value) {
                      setState(() {
                        _offsetAmounts[activity] = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: Text(
                    '\$${_offsetAmounts[activity]?.toStringAsFixed(0)}',
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget buildInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _offsetFrequency,
          decoration: const InputDecoration(
            labelText: 'Offset Contribution Frequency',
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
              setState(() => _offsetFrequency = value);
            }
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Offset Activities and Contributions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ..._offsetActivities.keys.map(_buildOffsetActivityField).toList(),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Do you have verified carbon offsets?'),
          subtitle: const Text('Official certification or verification of offset activities'),
          value: _hasVerification,
          onChanged: (bool value) {
            setState(() {
              _hasVerification = value;
            });
          },
        ),
      ],
    );
  }
} 