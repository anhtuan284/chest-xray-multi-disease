import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chest X-Ray Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: 24),
            _buildStatsSection(),
            const SizedBox(height: 24),
            _buildRecentNewsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back, Dr. Smith',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You have analyzed 12 X-rays this week',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weekly Statistics',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildPieChart(),
              ),
              Expanded(
                flex: 2,
                child: _buildStatsList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: 35,
            title: '35%',
            color: Colors.blue,
            radius: 60,
          ),
          PieChartSectionData(
            value: 40,
            title: '40%',
            color: Colors.green,
            radius: 60,
          ),
          PieChartSectionData(
            value: 25,
            title: '25%',
            color: Colors.orange,
            radius: 60,
          ),
        ],
        sectionsSpace: 2,
      ),
    );
  }

  Widget _buildStatsList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _StatItem(
          color: Colors.blue,
          label: 'Normal Cases',
          value: '42',
        ),
        SizedBox(height: 8),
        _StatItem(
          color: Colors.green,
          label: 'Pneumonia',
          value: '48',
        ),
        SizedBox(height: 8),
        _StatItem(
          color: Colors.orange,
          label: 'Other',
          value: '30',
        ),
      ],
    );
  }

  Widget _buildRecentNewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Latest Updates',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildNewsCard(
          title: 'New AI Model Released',
          description:
              'Our latest CNN model shows 95% accuracy in detecting pneumonia cases.',
          date: '2 hours ago',
          icon: Icons.analytics,
        ),
        const SizedBox(height: 12),
        _buildNewsCard(
          title: 'Updated Guidelines',
          description:
              'WHO releases new guidelines for chest X-ray interpretation.',
          date: '1 day ago',
          icon: Icons.book,
        ),
        const SizedBox(height: 12),
        _buildNewsCard(
          title: 'Research Paper Published',
          description:
              'New findings on early detection of tuberculosis using deep learning.',
          date: '2 days ago',
          icon: Icons.science,
        ),
      ],
    );
  }

  Widget _buildNewsCard({
    required String title,
    required String description,
    required String date,
    required IconData icon,
  }) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.withOpacity(0.1),
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(description),
            const SizedBox(height: 4),
            Text(
              date,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _StatItem({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
