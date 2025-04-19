import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DiseasePieChart extends StatefulWidget {
  final Map<String, int> diseaseData;
  final String title;
  final double height;

  const DiseasePieChart({
    Key? key,
    required this.diseaseData,
    this.title = 'Disease Distribution',
    this.height = 250, // Reduced default height
  }) : super(key: key);

  @override
  State<DiseasePieChart> createState() => _DiseasePieChartState();
}

class _DiseasePieChartState extends State<DiseasePieChart> {
  int touchedIndex = -1;

  // Generate colors for the pie chart
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
              : Row(
                  children: [
                    // Pie chart on the left (smaller)
                    Expanded(
                      flex: 3,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 1,
                          centerSpaceRadius: 30,
                          sections: _generateSections(),
                        ),
                      ),
                    ),

                    // Top diseases legend on the right
                    Expanded(
                      flex: 2,
                      child: _buildCompactLegend(),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 8),
        // Full legend below
        _buildFullLegend(),
      ],
    );
  }

  List<PieChartSectionData> _generateSections() {
    final entries = widget.diseaseData.entries.toList();
    final total = entries.fold<int>(0, (sum, item) => sum + item.value);

    // Sort by value descending for better visualization
    entries.sort((a, b) => b.value.compareTo(a.value));

    return entries.mapIndexed((index, entry) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      final color = colorList[index % colorList.length];

      final percentage = (entry.value / total * 100).toStringAsFixed(1);

      // Only show percentage on the chart
      return PieChartSectionData(
        color: color,
        value: entry.value.toDouble(),
        title: '$percentage%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
        ),
      );
    }).toList();
  }

  Widget _buildCompactLegend() {
    // Show only top 5 diseases for compact legend
    final entries = widget.diseaseData.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    final topEntries = entries.take(5).toList();

    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Diseases:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...topEntries.mapIndexed((index, entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorList[index % colorList.length],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      entry.key,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: index == touchedIndex
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFullLegend() {
    final entries = widget.diseaseData.entries.toList();
    // Sort by value for consistent ordering
    entries.sort((a, b) => b.value.compareTo(a.value));

    // Calculate total
    final total = entries.fold<int>(0, (sum, item) => sum + item.value);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      height: 80, // Fixed height
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.0,
            runSpacing: 8.0,
            children: entries.mapIndexed((index, entry) {
              final percent = (entry.value / total * 100).toStringAsFixed(1);
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: colorList[index % colorList.length], width: 1.5),
                  boxShadow: index == touchedIndex
                      ? [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
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
                    const SizedBox(width: 4),
                    Text(
                      '${entry.key}: ${entry.value} ($percent%)',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: index == touchedIndex
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
