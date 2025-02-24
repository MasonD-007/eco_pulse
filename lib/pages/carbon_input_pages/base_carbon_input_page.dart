import 'package:flutter/material.dart';
import '../../models/carbon_input.dart';
import '../../services/carbon_data_service.dart';

abstract class BaseCarbonInputPage extends StatefulWidget {
  final String category;
  
  const BaseCarbonInputPage({
    required this.category,
    Key? key,
  }) : super(key: key);

  @override
  BaseCarbonInputPageState createState();
}

abstract class BaseCarbonInputPageState<T extends BaseCarbonInputPage>
    extends State<T> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  DateTime _selectedDate = DateTime.now();
  final _carbonDataService = CarbonDataService();

  Future<void> saveData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final inputData = await collectInputData();
      final carbonInput = CarbonInput(
        category: widget.category,
        date: _selectedDate,
        data: inputData,
      );
      
      await _carbonDataService.submitCarbonInput(carbonInput);
      
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved successfully!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save data. Please try again.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> submitCarbonInput(CarbonInput input) async {
    // TODO: Implement submission to backend
    await Future.delayed(const Duration(seconds: 1)); // Simulated delay
  }

  Future<Map<String, dynamic>> collectInputData();

  Widget buildInputFields();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text('Date'),
                  subtitle: Text(_selectedDate.toString().split(' ')[0]),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                    }
                  },
                ),
                const SizedBox(height: 16),
                buildInputFields(),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : saveData,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 