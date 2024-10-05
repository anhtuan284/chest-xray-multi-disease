import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:typed_data';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> options = ['YOLO', 'DenseNet'];
  String selectedOption = 'YOLO';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chest X-ray Diagnostic')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              items: options.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedOption = newValue!;
                });
              },
              value: selectedOption,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      await showImagePickerDialog(context);
                    },
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Chọn ảnh'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> showImagePickerDialog(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Start loading and show a spinner
      setState(() {
        isLoading = true;
      });

      // Fetch the images from the server
      final List<XFile>? images = await fetchImagesFromServer(pickedFile);

      // Stop loading once the images are fetched
      setState(() {
        isLoading = false;
      });

      // Navigate to the DisplayImages screen with the fetched images
      if (images != null && images.isNotEmpty) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DisplayImages(images: images),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No images found or error fetching data'),
          ),
        );
      }
    }
  }

  Future<List<XFile>?> fetchImagesFromServer(XFile pickedFile) async {
    try {
      final url = Uri.parse('http://127.0.0.1:5000/densenet_predict');

      // Prepare the request and the image file bytes
      final request = http.MultipartRequest('POST', url);
      final imageBytes = await pickedFile.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'chest_xray.jpg',
      ));

      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Decode the received ZIP file
        final bytes = response.bodyBytes;
        final archive = ZipDecoder().decodeBytes(bytes);

        // Extract each file and convert it into an XFile
        List<XFile> extractedFiles = [];
        for (var file in archive.files) {
          if (file.isFile) {
            final Uint8List fileBytes = file.content as Uint8List;

            // Create an XFile from the byte data
            final xFile = XFile.fromData(
              fileBytes,
              name: file.name, // Set a name for the file
              mimeType: 'image/jpeg', // Assuming the files are JPEG images
            );

            extractedFiles.add(xFile);
          }
        }

        return extractedFiles;
      } else {
        print('Failed to load images. Status Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching images: $e');
      return null;
    }
  }
}

class DisplayImages extends StatelessWidget {
  const DisplayImages({super.key, required this.images});

  final List<XFile> images;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display Images')),
      body: images.isEmpty
          ? const Center(child: Text('No images found'))
          : GridView.builder(
              itemCount: images.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                return Image.memory(
                  File(images[index].path).readAsBytesSync(),
                  fit: BoxFit.cover,
                );
              },
            ),
    );
  }
}
