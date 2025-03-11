import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/carbon_visualization.dart';
import '../services/carbon_data_service.dart';

class CarbonVisualizationWidget extends StatefulWidget {
  final String category;

  const CarbonVisualizationWidget({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<CarbonVisualizationWidget> createState() => _CarbonVisualizationWidgetState();
}

class _CarbonVisualizationWidgetState extends State<CarbonVisualizationWidget> {
  final _carbonDataService = CarbonDataService();
  bool _isLoading = true;
  CategoryBreakdown? _breakdown;
  String _selectedTimeRange = 'Month';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final data = await _carbonDataService.getCategoryBreakdown(widget.category);
      setState(() {
        _breakdown = CategoryBreakdown.fromJson(data);
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

  List<PieChartSectionData> _getSections() {
    if (_breakdown == null) return [];

    final colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
    ];

    return _breakdown!.subCategories.entries.map((entry) {
      final index = _breakdown!.subCategories.keys.toList().indexOf(entry.key);
      return PieChartSectionData(
        value: entry.value,
        title: '${entry.key}\n${entry.value.toStringAsFixed(1)}',
        color: colors[index % colors.length],
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  List<LineChartBarData> _getLineData() {
    if (_breakdown == null) return [];

    final subCategories = _breakdown!.subCategories.keys.toList();
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
    ];

    return subCategories.map((category) {
      final index = subCategories.indexOf(category);
      return LineChartBarData(
        spots: _breakdown!.history.map((point) {
          return FlSpot(
            point.date.millisecondsSinceEpoch.toDouble(),
            point.values[category] ?? 0,
          );
        }).toList(),
        isCurved: true,
        color: colors[index % colors.length],
        barWidth: 2,
        dotData: FlDotData(show: false),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_breakdown == null) {
      return const Center(child: Text('No data available'));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.category,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<String>(
                value: _selectedTimeRange,
                items: ['Week', 'Month', 'Year']
                    .map((range) => DropdownMenuItem(
                          value: range,
                          child: Text(range),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedTimeRange = value);
                    _loadData();
                  }
                },
              ),
            ],
          ),
        ),
        AspectRatio(
          aspectRatio: 1.5,
          child: PieChart(
            PieChartData(
              sections: _getSections(),
              centerSpaceRadius: 40,
              sectionsSpace: 2,
            ),
          ),
        ),
        const SizedBox(height: 24),
        AspectRatio(
          aspectRatio: 1.7,
          child: LineChart(
            LineChartData(
              lineBarsData: _getLineData(),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                      return Text(
                        '${date.month}/${date.day}',
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: true),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Emissions: ${_breakdown!.totalEmissions.toStringAsFixed(2)} kg CO2e',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Breakdown by subcategory:',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                ..._breakdown!.subCategories.entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key),
                        Text('${entry.value.toStringAsFixed(2)} kg CO2e'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 