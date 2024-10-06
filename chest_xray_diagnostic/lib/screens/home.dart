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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Instructions Text
              const Text(
                'Vui lòng chọn mô hình:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Đây chỉ là mô hình thử nghiệm, chọn mô hình để tiếp tục...',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Dropdown for model selection
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

              // Button to select an image
              Center(
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          await showImagePickerDialog(context);
                        },
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Chọn ảnh'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showImagePickerDialog(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        isLoading = true;
      });

      // Check if YOLO or DenseNet is selected
      if (selectedOption == 'DenseNet') {
        // Fetch multiple images for DenseNet
        final List<XFile>? images = await fetchImagesFromServer(
            pickedFile, 'http://10.0.3.2:5000/densenet_predict');
        setState(() {
          isLoading = false;
        });

        if (images != null && images.isNotEmpty) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DisplayImages(images: images),
          ));
        }
      } else if (selectedOption == 'YOLO') {
        // Fetch single image for YOLO
        final XFile? image = await fetchSingleImageFromServer(
            pickedFile, 'http://10.0.3.2:5000/yolo_predict');
        setState(() {
          isLoading = false;
        });

        if (image != null) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DisplaySingleImage(image: image),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No model selected or error fetching data'),
          ),
        );
      }
    }
  }

  Future<List<XFile>?> fetchImagesFromServer(
      XFile pickedFile, String apiUrl) async {
    try {
      final url = Uri.parse(apiUrl);

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
        // If response is a ZIP file, extract images
        final Uint8List zipBytes = response.bodyBytes;

        // Extract images from the zip file
        final List<XFile> extractedImages =
            await extractImagesFromZip(zipBytes);

        if (extractedImages.isNotEmpty) {
          return extractedImages;
        } else {
          print('No images found in the response.');
          return null;
        }
      } else {
        print('Failed to load images. Status Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching images: $e');
      return null;
    }
  }

  Future<List<XFile>> extractImagesFromZip(Uint8List zipBytes) async {
    // Decode the zip file
    final Archive archive = ZipDecoder().decodeBytes(zipBytes);
    final List<XFile> imageFiles = [];

    // Iterate over each file in the zip
    for (final ArchiveFile file in archive) {
      if (file.isFile && file.name.endsWith('.jpg')) {
        final Uint8List fileData = file.content as Uint8List;

        // Convert the file data to XFile
        final XFile xFile = XFile.fromData(
          fileData,
          name: file.name,
          mimeType: 'image/jpeg',
        );

        imageFiles.add(xFile);
      }
    }

    return imageFiles;
  }

  Future<XFile?> fetchSingleImageFromServer(
      XFile pickedFile, String apiUrl) async {
    try {
      final url = Uri.parse(apiUrl);

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
        final Uint8List bytes = response.bodyBytes;

        // Create an XFile from the byte data
        final xFile = XFile.fromData(
          bytes,
          name: 'yolo_output.jpg',
          mimeType: 'image/jpeg',
        );

        return xFile;
      } else {
        print('Failed to load images. Status Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching image: $e');
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
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Điều hướng sang trang xem ảnh full-size
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FullImageScreen(imageFile: images[index]),
                      ),
                    );
                  },
                  child: FutureBuilder(
                    future: images[index].readAsBytes(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: Text('Error loading image'));
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(child: Text('No image data found'));
                      }

                      return Image.memory(
                        snapshot.data as Uint8List,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class DisplaySingleImage extends StatelessWidget {
  const DisplaySingleImage({super.key, required this.image});

  final XFile image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YOLO Prediction Result')),
      body: Center(
        child: FutureBuilder(
          future: image.readAsBytes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Error loading image');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Text('No image data found');
            }

            return Image.memory(
              snapshot.data as Uint8List,
              fit: BoxFit.contain,
            );
          },
        ),
      ),
    );
  }
}

class FullImageScreen extends StatelessWidget {
  const FullImageScreen({super.key, required this.imageFile});

  final XFile imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Full Size Image')),
      body: Center(
        child: FutureBuilder(
          future: imageFile.readAsBytes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Error loading image');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Text('No image data found');
            }

            return InteractiveViewer(
              child: Image.memory(
                snapshot.data as Uint8List,
                fit: BoxFit.contain,
              ),
            );
          },
        ),
      ),
    );
  }
}
