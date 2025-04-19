import 'package:fe_flutter/src/core/widgets/loading_animation.dart';
import 'package:flutter/material.dart';

import '../../../../core/models/disease_stats_models.dart';
import '../../../../core/services/stats_service.dart';
import 'column_chart_widget.dart';
import 'pie_chart_widget.dart';

class DiseaseStatsWidget extends StatefulWidget {
  const DiseaseStatsWidget({Key? key}) : super(key: key);

  @override
  State<DiseaseStatsWidget> createState() => _DiseaseStatsWidgetState();
}

class _DiseaseStatsWidgetState extends State<DiseaseStatsWidget> {
  final StatsService _statsService = StatsService();
  bool _isLoading = false;
  String? _errorMessage;
  WeeklyStatsResponse? _weeklyStats;
  DiseaseSummaryResponse? _summaryStats;

  @override
  void initState() {
    super.initState();
    _fetchAllStats();
  }

  Future<void> _fetchAllStats() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final futures = await Future.wait([
        _statsService.fetchWeeklyDiseaseStats(),
        _statsService.fetchDiseaseSummary(),
      ]);

      setState(() {
        _weeklyStats = futures[0] as WeeklyStatsResponse;
        _summaryStats = futures[1] as DiseaseSummaryResponse;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingWidget();
    }

    if (_errorMessage != null) {
      return _buildErrorWidget();
    }

    if (_weeklyStats == null && _summaryStats == null) {
      return const Center(child: Text('No disease statistics available.'));
    }

    return _buildStatsContent();
  }

  Widget _buildLoadingWidget() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Center(child: LottieLoadingAnimation()),
    );
  }

  Widget _buildErrorWidget() {
    return Card(
      color: Colors.red.shade50,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 36),
            const SizedBox(height: 8),
            Text(
              'Failed to load disease statistics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.red.shade700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red.shade700, fontSize: 12),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _fetchAllStats,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade100,
                foregroundColor: Colors.red.shade700,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsContent() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade700, Colors.blue.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.analytics, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Disease Analytics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: _fetchAllStats,
                  tooltip: 'Refresh data',
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Weekly disease distribution (Pie Chart)
                if (_weeklyStats != null &&
                    _weeklyStats!.data.weekly_stats.isNotEmpty)
                  _buildWeeklyPieChart(),

                // Summary section (Column Chart)
                if (_summaryStats != null) _buildSummaryColumnChart(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyPieChart() {
    final weeklyStats = _weeklyStats!.data.weekly_stats;
    if (weeklyStats.isEmpty) {
      return const SizedBox.shrink();
    }

    // Get the most recent week's data
    final latestDate = weeklyStats.keys.last;
    final latestWeekData =
        Map<String, int>.from(weeklyStats[latestDate]!.asMap());

    if (latestWeekData.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'Week of $latestDate',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
        ),
        DiseasePieChart(
          diseaseData: latestWeekData,
          title: 'Weekly Disease Distribution',
          height: 220, // Reduced height
        ),
        const Divider(height: 24),
      ],
    );
  }

  Widget _buildSummaryColumnChart() {
    if (_summaryStats == null || _summaryStats!.data.summary.isEmpty) {
      return const SizedBox.shrink();
    }

    final summaryData =
        Map<String, int>.from(_summaryStats!.data.summary.asMap());
    final totalPredictions = _summaryStats!.data.total_predictions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.info_outline, size: 16, color: Colors.blue.shade700),
            const SizedBox(width: 8),
            Text(
              'Total Predictions: $totalPredictions',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        DiseaseColumnChart(
          diseaseData: summaryData,
          title: 'Disease Frequency',
          height: 220, // Reduced height
        ),
      ],
    );
  }
}
