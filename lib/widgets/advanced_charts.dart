import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Advanced radar chart for cognitive assessment visualization
class CognitiveRadarChart extends StatelessWidget {
  final Map<String, double> scores;
  final Color fillColor;
  final Color borderColor;
  final double maxValue;

  const CognitiveRadarChart({
    Key? key,
    required this.scores,
    this.fillColor = const Color(0xFF4A90A4),
    this.borderColor = const Color(0xFF2E7D9A),
    this.maxValue = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataEntries = scores.entries.toList();
    
    return RadarChart(
      RadarChartData(
        radarShape: RadarShape.polygon,
        tickCount: 5,
        ticksTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          fontSize: 10,
        ),
        radarBorderData: BorderSide(color: borderColor.withOpacity(0.2)),
        gridBorderData: BorderSide(color: borderColor.withOpacity(0.2), width: 1),
        tickBorderData: BorderSide(color: Colors.transparent),
        getTitle: (index, angle) {
          if (index >= dataEntries.length) return RadarChartTitle(text: '');
          final entry = dataEntries[index];
          return RadarChartTitle(
            text: _formatLabel(entry.key),
            angle: angle,
          );
        },
        dataSets: [
          RadarDataSet(
            fillColor: fillColor.withOpacity(0.3),
            borderColor: borderColor,
            borderWidth: 2,
            entryRadius: 3,
            dataEntries: dataEntries.map((e) => RadarEntry(value: e.value)).toList(),
          ),
        ],
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        titlePositionPercentageOffset: 0.15,
      ),
    );
  }

  String _formatLabel(String key) {
    return key.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join('\n');
  }
}

/// Advanced line chart for progress tracking
class ProgressLineChart extends StatelessWidget {
  final List<FlSpot> dataPoints;
  final String? title;
  final Color lineColor;
  final bool showDots;
  final bool showGrid;

  const ProgressLineChart({
    Key? key,
    required this.dataPoints,
    this.title,
    this.lineColor = const Color(0xFF2E7D9A),
    this.showDots = true,
    this.showGrid = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
        ],
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: showGrid),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: dataPoints,
                  isCurved: true,
                  color: lineColor,
                  barWidth: 3,
                  dotData: FlDotData(show: showDots),
                  belowBarData: BarAreaData(
                    show: true,
                    color: lineColor.withOpacity(0.1),
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

/// Advanced bar chart for comparative analysis
class ComparativeBarChart extends StatelessWidget {
  final Map<String, double> data;
  final String? title;
  final Color barColor;
  final double maxY;

  const ComparativeBarChart({
    Key? key,
    required this.data,
    this.title,
    this.barColor = const Color(0xFF4A90A4),
    this.maxY = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
        ],
        SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              barTouchData: BarTouchData(enabled: true),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= entries.length) return const Text('');
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _formatLabel(entries[value.toInt()].key),
                          style: const TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              barGroups: entries.asMap().entries.map((entry) {
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.value,
                      color: barColor,
                      width: 20,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  String _formatLabel(String key) {
    return key.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join('\n');
  }
}

/// Donut chart for score distribution
class ScoreDonutChart extends StatelessWidget {
  final Map<String, double> scores;
  final List<Color> colors;
  final bool showLegend;

  const ScoreDonutChart({
    Key? key,
    required this.scores,
    this.colors = const [
      Color(0xFF2E7D9A),
      Color(0xFF4A90A4),
      Color(0xFF2A9D8F),
      Color(0xFFF4A261),
      Color(0xFFE76F51),
    ],
    this.showLegend = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final entries = scores.entries.toList();
    
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: entries.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                final color = colors[index % colors.length];
                
                return PieChartSectionData(
                  value: data.value,
                  title: '${data.value.toInt()}',
                  color: color,
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 50,
            ),
          ),
        ),
        if (showLegend) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: entries.asMap().entries.map((entry) {
              final index = entry.key;
              final data = entry.value;
              final color = colors[index % colors.length];
              
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatLabel(data.key),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  String _formatLabel(String key) {
    return key.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
  }
}
