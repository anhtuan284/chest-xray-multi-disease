import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DiseaseColumnChart extends StatefulWidget {
  final Map<String, int> diseaseData;
  final String title;
  final double height;

  const DiseaseColumnChart({
    Key? key,
    required this.diseaseData,
    this.title = 'Disease Distribution',
    this.height = 250, // Reduced default height
  }) : super(key: key);

  @override
  State<DiseaseColumnChart> createState() => _DiseaseColumnChartState();
}

class _DiseaseColumnChartState extends State<DiseaseColumnChart> {
  final List<Color> colorList = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.amber,
    Colors.indigo,
    Colors.lime,
    Colors.pink,
    Colors.brown,
    Colors.cyan,
    Colors.deepOrange,
    Colors.lightBlue,
  ];

  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: widget.height,
          child: widget.diseaseData.isEmpty
              ? const Center(child: Text('No data available'))
              : Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    right: 16.0,
                    bottom: 12.0,
                    left: 12.0,
                  ),
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceEvenly,
                      maxY: _getMaxValue() * 1.2,
                      barGroups: _createBarGroups(),
                      titlesData: _getTitlesData(),
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: false),
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final entries = widget.diseaseData.entries.toList();
                            final disease = entries[groupIndex].key;
                            final value = entries[groupIndex].value;
                            return BarTooltipItem(
                              '$disease: $value',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        touchCallback: (FlTouchEvent event, response) {
                          setState(() {
                            if (event is FlTapUpEvent) {
                              _touchedIndex =
                                  response?.spot?.touchedBarGroupIndex;
                            } else {
                              _touchedIndex = -1;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 8),
        _buildImprovedLegend(),
      ],
    );
  }

  double _getMaxValue() {
    if (widget.diseaseData.isEmpty) return 0;
    return widget.diseaseData.values
        .reduce((max, value) => max > value ? max : value)
        .toDouble();
  }

  List<BarChartGroupData> _createBarGroups() {
    return widget.diseaseData.entries.mapIndexed((index, entry) {
      final isTouched = index == _touchedIndex;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: colorList[index % colorList.length]
                .withOpacity(isTouched ? 1 : 0.7),
            width: 14, // Slightly narrower bars
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: _getMaxValue() * 1.2,
              color: Colors.grey.withOpacity(0.1),
            ),
          ),
        ],
      );
    }).toList();
  }

  FlTitlesData _getTitlesData() {
    return FlTitlesData(
      show: true,
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            final entries = widget.diseaseData.entries.toList();
            if (index < 0 || index >= entries.length) return const Text('');

            final disease = entries[index].key;
            // Only show abbreviated disease names
            final abbreviated =
                disease.length > 4 ? '${disease.substring(0, 3)}.' : disease;

            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                abbreviated,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (value, meta) {
            // Only show a few values on the y-axis to avoid clutter
            if (value == 0 || value % 5 != 0) {
              return const SizedBox.shrink();
            }
            return Text(
              value.toInt().toString(),
              style: const TextStyle(fontSize: 10, color: Colors.black54),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImprovedLegend() {
    final entries = widget.diseaseData.entries.toList();

    // Wrap the legend in a container with a fixed height and scrolling
    return Container(
      height: 80, // Fixed height for legend

      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          alignment: WrapAlignment.center,
          children: entries.mapIndexed((index, entry) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: colorList[index % colorList.length], width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: colorList[index % colorList.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${entry.key}: ${entry.value}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
