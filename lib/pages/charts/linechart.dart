import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardChart extends StatelessWidget {
  final Map<String, List<Map<String, dynamic>>> stageData;

  const DashboardChart({Key? key, required this.stageData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate stage counts
    final stageCounts = {
      'stage-1': stageData['stage-1']?.length ?? 0,
      'stage-2': stageData['stage-2']?.length ?? 0,
      'stage-3': stageData['stage-3']?.length ?? 0,
      'stage-4': stageData['stage-4']?.length ?? 0,
      'no data yet': stageData['no data yet']?.length ?? 0,
    };

    // Calculate daily uploads
    final dailyCounts = <String, int>{};
    stageData.forEach((stage, data) {
      for (final entry in data) {
        final date = entry['date'] as String? ?? 'Mango Trees';
        dailyCounts[date] = (dailyCounts[date] ?? 0) + 1;
      }
    });

    final gradientColors = [
      Colors.blueAccent,
      Colors.lightBlueAccent,
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0), 
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stage Distribution Chart
            _buildChartCard(
              title: 'Mango Tree Stages Distribution',
              barGroups: stageCounts.entries.map((entry) {
                return BarChartGroupData(
                  x: stageCounts.keys.toList().indexOf(entry.key),
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.toDouble(),
                      borderRadius: BorderRadius.circular(4),
                      width: 12, // Reduced bar width
                      gradient: LinearGradient(colors: gradientColors),
                    ),
                  ],
                  showingTooltipIndicators: [0],
                );
              }).toList(),
              maxY: stageCounts.values.reduce((a, b) => a > b ? a : b).toDouble(),
              labels: stageCounts.keys.toList(),
              color: Colors.blueAccent,
            ),

            const SizedBox(height: 16), // Reduced spacing

            // Daily Uploads Chart
            _buildChartCard(
              title: 'Total Daily Uploads',
              barGroups: dailyCounts.entries.map((entry) {
                return BarChartGroupData(
                  x: dailyCounts.keys.toList().indexOf(entry.key),
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.toDouble(),
                      borderRadius: BorderRadius.circular(4),
                      gradient: const LinearGradient(
                        colors: [Colors.greenAccent, Colors.lightGreen],
                      ),
                      width: 12, // Reduced bar width
                    ),
                  ],
                  showingTooltipIndicators: [0],
                );
              }).toList(),
              maxY: dailyCounts.values.reduce((a, b) => a > b ? a : b).toDouble(),
              labels: dailyCounts.keys.toList(),
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard({
    required String title,
    required List<BarChartGroupData> barGroups,
    required double maxY,
    required List<String> labels,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Reduced border radius
      elevation: 3, // Reduced elevation
      shadowColor: Colors.grey.withOpacity(0.4),
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Reduced padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16, // Reduced font size
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12), // Reduced spacing
            AspectRatio(
              aspectRatio: 2.0, // Increased aspect ratio to make charts shorter
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY.toDouble(),
                  barGroups: barGroups,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${labels[group.x]}: ${rod.toY.toInt()}',
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 12, // Reduced font size
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        reservedSize: 30, // Reduced reserved size
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10), // Reduced font size
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        reservedSize: 30, // Reduced reserved size
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < labels.length) {
                            return Text(
                              labels[value.toInt()],
                              style: const TextStyle(fontSize: 10), // Reduced font size
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}