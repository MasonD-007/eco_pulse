import 'package:flutter/material.dart';
import 'base_carbon_input_page.dart';

class TransportationInputPage extends BaseCarbonInputPage {
  const TransportationInputPage({Key? key})
      : super(category: 'Transportation', key: key);

  @override
  TransportationInputPageState createState() => TransportationInputPageState();
}

class TransportationInputPageState
    extends BaseCarbonInputPageState<TransportationInputPage> {
  final _vehicleController = TextEditingController();
  final _distanceController = TextEditingController();
  String _transportationType = 'Car';
  String _fuelType = 'Gasoline';

  final List<String> _transportationTypes = [
    'Car',
    'Bus',
    'Train',
    'Motorcycle',
    'Electric Vehicle',
  ];

  final List<String> _fuelTypes = [
    'Gasoline',
    'Diesel',
    'Electric',
    'Hybrid',
    'Natural Gas',
  ];

  @override
  void dispose() {
    _vehicleController.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  @override
  Future<Map<String, dynamic>> collectInputData() async {
    return {
      'vehicle_model': _vehicleController.text,
      'distance': double.parse(_distanceController.text),
      'transportation_type': _transportationType,
      'fuel_type': _fuelType,
    };
  }

  @override
  Widget buildInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _transportationType,
          decoration: const InputDecoration(
            labelText: 'Transportation Type',
            border: OutlineInputBorder(),
          ),
          items: _transportationTypes
              .map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _transportationType = value);
            }
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _vehicleController,
          decoration: const InputDecoration(
            labelText: 'Vehicle Model',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the vehicle model';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _distanceController,
          decoration: const InputDecoration(
            labelText: 'Distance (km)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the distance';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _fuelType,
          decoration: const InputDecoration(
            labelText: 'Fuel Type',
            border: OutlineInputBorder(),
          ),
          items: _fuelTypes
              .map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _fuelType = value);
            }
          },
        ),
      ],
    );
  }
} 