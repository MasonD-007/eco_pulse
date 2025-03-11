import 'package:flutter/material.dart';
import 'base_carbon_input_page.dart';

class TravelInputPage extends BaseCarbonInputPage {
  const TravelInputPage({Key? key})
      : super(category: 'Travel and Holidays', key: key);

  @override
  TravelInputPageState createState() => TravelInputPageState();
}

class TravelInputPageState extends BaseCarbonInputPageState<TravelInputPage> {
  final _flightHoursController = TextEditingController();
  final Map<String, double> _travelModes = {
    'Flights': 0,
    'Train': 0,
    'Bus': 0,
    'Cruise Ship': 0,
    'Rental Car': 0,
  };

  String _travelFrequency = 'Few times a year';
  bool _offsetsCarbon = false;
  bool _prefersSustainable = false;

  final List<String> _frequencies = [
    'Monthly',
    'Few times a year',
    'Yearly',
    'Rarely',
  ];

  @override
  void dispose() {
    _flightHoursController.dispose();
    super.dispose();
  }

  @override
  Future<Map<String, dynamic>> collectInputData() async {
    return {
      'travel_modes_hours': _travelModes,
      'travel_frequency': _travelFrequency,
      'offsets_carbon': _offsetsCarbon,
      'prefers_sustainable': _prefersSustainable,
    };
  }

  Widget _buildTravelModeField(String mode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(mode),
          ),
          Expanded(
            flex: 3,
            child: Slider(
              value: _travelModes[mode] ?? 0,
              min: 0,
              max: 100,
              divisions: 100,
              label: '${_travelModes[mode]?.toStringAsFixed(1)} hours',
              onChanged: (value) {
                setState(() {
                  _travelModes[mode] = value;
                });
              },
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              '${_travelModes[mode]?.toStringAsFixed(1)}h',
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
          value: _travelFrequency,
          decoration: const InputDecoration(
            labelText: 'Travel Frequency',
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
              setState(() => _travelFrequency = value);
            }
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Travel Hours by Mode (Annual)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ..._travelModes.keys.map(_buildTravelModeField).toList(),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Do you offset your travel carbon emissions?'),
          subtitle: const Text('Through carbon offset programs or initiatives'),
          value: _offsetsCarbon,
          onChanged: (bool value) {
            setState(() {
              _offsetsCarbon = value;
            });
          },
        ),
        SwitchListTile(
          title: const Text('Do you prefer eco-friendly travel options?'),
          subtitle: const Text('Such as choosing direct flights or train travel'),
          value: _prefersSustainable,
          onChanged: (bool value) {
            setState(() {
              _prefersSustainable = value;
            });
          },
        ),
      ],
    );
  }
} 