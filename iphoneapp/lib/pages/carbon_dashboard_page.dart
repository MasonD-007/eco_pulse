import 'package:flutter/material.dart';
import '../services/carbon_data_service.dart';
import '../models/carbon_visualization.dart';
import '../widgets/carbon_visualization_widget.dart';

class CarbonDashboardPage extends StatefulWidget {
  const CarbonDashboardPage({Key? key}) : super(key: key);

  @override
  State<CarbonDashboardPage> createState() => _CarbonDashboardPageState();
}

class _CarbonDashboardPageState extends State<CarbonDashboardPage> {
  final _carbonDataService = CarbonDataService();
  bool _isLoading = true;
  CarbonSummary? _summary;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final data = await _carbonDataService.getCarbonSummary();
      setState(() {
        _summary = CarbonSummary.fromJson(data);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load carbon data')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_summary == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No data available'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carbon Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Overall Summary',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSummaryItem(
                              'Total Emissions',
                              '${_summary!.totalEmissions.toStringAsFixed(2)} kg CO2e',
                              Icons.cloud_outlined,
                            ),
                            _buildSummaryItem(
                              'Offset Amount',
                              '${_summary!.offsetAmount.toStringAsFixed(2)} kg CO2e',
                              Icons.eco_outlined,
                            ),
                            _buildSummaryItem(
                              'Reduction',
                              '${_summary!.reductionPercentage.toStringAsFixed(1)}%',
                              Icons.trending_down,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Category Breakdown',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ..._summary!.categoryEmissions.keys.map(
                (category) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CarbonVisualizationWidget(category: category),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.blue),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
} 