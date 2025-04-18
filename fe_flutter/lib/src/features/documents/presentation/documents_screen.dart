import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/api_models.dart';
import '../../../core/providers.dart';

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  Future<void> _uploadFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        final response =
            await ref.read(documentsAPIProvider).uploadDocument(file);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Uploaded: ${response.message}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    }
  }

  Future<void> _refreshDocuments() async {
    setState(() {}); // This will trigger a rebuild and fetch new data
  }

  String _formatFileSize(int bytes) {
    const suffixes = ["B", "KB", "MB", "GB"];
    var i = 0;
    double size = bytes.toDouble();

    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }

    return '${size.toStringAsFixed(1)} ${suffixes[i]}';
  }

  String _formatDate(double timestamp) {
    final date =
        DateTime.fromMillisecondsSinceEpoch((timestamp * 1000).round());
    return DateFormat('MMM dd, yyyy HH:mm').format(date);
  }

  Future<void> _openPdf(String filename) async {
    try {
      final url =
          await ref.read(documentsAPIProvider).getDocumentViewUrl(filename);
      if (kIsWeb) {
        html.window.open(url, '_blank');
      } else {
        // For mobile platforms
        if (!await launchUrl(Uri.parse(url))) {
          throw 'Could not launch $url';
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening file: $e')),
      );
    }
  }

  Widget _buildActionButtons(DocumentFile doc) {
    if (kIsWeb) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Link(
            uri: Uri.parse(
                'http://localhost:8033/documents/${doc.filename}/view'),
            target: LinkTarget.blank,
            builder: (context, followLink) => IconButton(
              icon: const Icon(Icons.visibility),
              tooltip: 'View PDF',
              onPressed: followLink,
            ),
          ),
          Link(
            uri: Uri.parse('http://localhost:8033/documents/${doc.filename}'),
            target: LinkTarget.blank,
            builder: (context, followLink) => IconButton(
              icon: const Icon(Icons.download),
              tooltip: 'Download PDF',
              onPressed: followLink,
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.visibility),
            tooltip: 'View PDF',
            onPressed: () => _openPdf(doc.filename),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Download PDF',
            onPressed: () async {
              final url = await ref
                  .read(documentsAPIProvider)
                  .getDocumentDownloadUrl(doc.filename);
              await launchUrl(Uri.parse(url));
            },
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Documents'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshDocuments,
          ),
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: _uploadFile,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDocuments,
        child: FutureBuilder<List<DocumentFile>>(
          future: ref.watch(documentsAPIProvider).getAllDocuments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: ${snapshot.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => setState(() {}),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final documents = snapshot.data ?? [];

            if (documents.isEmpty) {
              return const Center(
                child: Text('No documents found'),
              );
            }

            return ListView.builder(
              itemCount: documents.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final doc = documents[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading:
                        const Icon(Icons.picture_as_pdf, color: Colors.red),
                    title: Text(
                      doc.filename,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${_formatFileSize(doc.size)} • ${_formatDate(doc.created)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: _buildActionButtons(doc),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadFile,
        child: const Icon(Icons.add),
      ),
    );
  }
}
