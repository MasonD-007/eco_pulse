import 'package:flutter/material.dart';
import 'base_carbon_input_page.dart';

class EnergyConsumptionInputPage extends BaseCarbonInputPage {
  const EnergyConsumptionInputPage({Key? key})
      : super(category: 'Energy Consumption', key: key);

  @override
  EnergyConsumptionInputPageState createState() => EnergyConsumptionInputPageState();
}

class EnergyConsumptionInputPageState
    extends BaseCarbonInputPageState<EnergyConsumptionInputPage> {
  final _electricityController = TextEditingController();
  final _gasController = TextEditingController();
  String _energyProvider = 'Standard Grid';
  bool _hasRenewables = false;

  final List<String> _energyProviders = [
    'Standard Grid',
    'Green Energy Provider',
    'Mixed Sources',
    'Self-Generated',
  ];

  @override
  void dispose() {
    _electricityController.dispose();
    _gasController.dispose();
    super.dispose();
  }

  @override
  Future<Map<String, dynamic>> collectInputData() async {
    return {
      'electricity_kwh': double.parse(_electricityController.text),
      'natural_gas_m3': double.parse(_gasController.text),
      'energy_provider': _energyProvider,
      'has_renewables': _hasRenewables,
    };
  }

  @override
  Widget buildInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _electricityController,
          decoration: const InputDecoration(
            labelText: 'Electricity Usage (kWh)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter electricity usage';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _gasController,
          decoration: const InputDecoration(
            labelText: 'Natural Gas Usage (m³)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter gas usage';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _energyProvider,
          decoration: const InputDecoration(
            labelText: 'Energy Provider Type',
            border: OutlineInputBorder(),
          ),
          items: _energyProviders
              .map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _energyProvider = value);
            }
          },
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Do you have renewable energy sources?'),
          subtitle: const Text('Such as solar panels or wind turbines'),
          value: _hasRenewables,
          onChanged: (bool value) {
            setState(() {
              _hasRenewables = value;
            });
          },
        ),
      ],
    );
  }
} 