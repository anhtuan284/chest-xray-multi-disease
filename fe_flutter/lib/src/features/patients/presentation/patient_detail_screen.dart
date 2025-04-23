import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/patient_models.dart';
import '../services/patient_api_service.dart';
import 'patient_image_viewer_dialog.dart';

class PatientDetailScreen extends StatefulWidget {
  final String documentId;

  const PatientDetailScreen({super.key, required this.documentId});

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  final PatientApiService _patientApiService = PatientApiService();
  bool _isLoading = true;
  String? _errorMessage;
  Patient? _patient;
  final String _baseUrl = 'http://atuan-ubuntu2404:1337';

  @override
  void initState() {
    super.initState();
    _fetchPatientDetails();
  }

  Future<void> _fetchPatientDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final patient = await _patientApiService
          .getPatientDetailsByDocumentId(widget.documentId);
      setState(() {
        _patient = patient;
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_patient?.fullName ?? 'Patient Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchPatientDetails,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorWidget()
              : _buildPatientDetails(),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'Failed to load patient details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.red.shade700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Unknown error occurred',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red.shade700),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _fetchPatientDetails,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientDetails() {
    if (_patient == null) {
      return const Center(child: Text('No patient data available'));
    }

    // Format dates
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('HH:mm:ss');

    DateTime createdAt = DateTime.parse(_patient!.createdAt);
    String formattedCreatedDate = dateFormat.format(createdAt);
    String formattedCreatedTime = timeFormat.format(createdAt);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPatientHeader(),
          const SizedBox(height: 24),

          // Personal Information Card
          _buildInfoCard(
            'Personal Information',
            Icons.person,
            [
              _buildInfoRow('Full Name', _patient!.fullName),
              _buildInfoRow('Date of Birth', _patient!.formattedDOB),
              _buildInfoRow('Health Status', _patient!.heathStatus,
                  valueColor: _patient!.healthStatusColor),
            ],
          ),
          const SizedBox(height: 16),

          // Contact Information Card
          _buildInfoCard(
            'Contact Information',
            Icons.contact_phone,
            [
              _buildInfoRow('Email', _patient!.email),
              _buildInfoRow('Phone Number', _patient!.formattedPhoneNumber),
            ],
          ),
          const SizedBox(height: 16),

          // Chest X-Ray Images Section
          if (_patient!.chestXray != null && _patient!.chestXray!.isNotEmpty)
            _buildChestXraySection(),

          const SizedBox(height: 16),

          // System Information Card
          _buildInfoCard(
            'System Information',
            Icons.info_outline,
            [
              _buildInfoRow('ID', _patient!.id.toString()),
              _buildInfoRow('Document ID', _patient!.documentId),
              _buildInfoRow(
                  'Created', '$formattedCreatedDate at $formattedCreatedTime'),
            ],
          ),

          const SizedBox(height: 24),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // In a real app, this would navigate to patient edit screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Edit patient functionality would go here')),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // In a real app, this would navigate to add X-ray screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Add X-ray functionality would go here')),
                    );
                  },
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text('New X-Ray'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChestXraySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Chest X-Ray Images',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _patient!.chestXray!.length,
            itemBuilder: (context, index) {
              final xray = _patient!.chestXray![index];
              // Use the large format if available, otherwise the original URL
              final imageUrl = xray.formats.containsKey('large')
                  ? '$_baseUrl${xray.formats['large']!.url}'
                  : '$_baseUrl${xray.url}';

              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: GestureDetector(
                  onTap: () {
                    _showFullScreenImage(imageUrl, xray.name);
                  },
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 150,
                              width: 150,
                              color: Colors.grey[200],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 150,
                              width: 150,
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        xray.name,
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        DateFormat('MMM d, yyyy').format(
                          DateTime.parse(xray.createdAt),
                        ),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showFullScreenImage(String imageUrl, String title) {
    _loadImageAndShow(imageUrl, title);
  }

  void _loadImageAndShow(String imageUrl, String title) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200 && mounted) {
        showDialog(
          context: context,
          builder: (context) => PatientImageViewerDialog(
            imageSource: response.bodyBytes,
            title: title,
          ),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to load image: ${response.statusCode}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Widget _buildPatientHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _patient!.fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _patient!.healthStatusColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _patient!.heathStatus.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
