import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

Future<File?> pickImage(BuildContext context) async {
  final picker = ImagePicker();

  return showDialog<File>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Select Image Source'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildImageOption(
              icon: Icons.photo_library,
              label: 'Gallery',
              onTap: () async {
                final picked = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (picked != null) {
                  Navigator.of(context).pop(File(picked.path));
                }
              },
            ),
            _buildImageOption(
              icon: Icons.camera_alt,
              label: 'Camera',
              onTap: () async {
                final picked = await picker.pickImage(
                  source: ImageSource.camera,
                );
                if (picked != null) {
                  Navigator.of(context).pop(File(picked.path));
                }
              },
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildImageOption({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(icon, size: 30), const SizedBox(height: 8), Text(label)],
    ),
  );
}

Future<String?> getImageLink(
  File pickedImage,
  String fileName, {
  String dir = 'profile_images',
}) async {
  try {
    // final compressedImage = await compressImage(pickedImage, fileName);
    // if (compressedImage == null) {
    //   debugPrint('Compression failed.');
    //   return null;
    // }

    final ref = FirebaseStorage.instance.ref('$dir/$fileName.jpg');
    await ref.putFile(pickedImage);

    final imageUrl = await ref.getDownloadURL();
    return imageUrl;
  } catch (e) {
    debugPrint('Image upload failed: $e');
    return null;
  }
}

Future<File?> compressImage(File file, String fileName) async {
  try {
    final tempDir = await getTemporaryDirectory();
    final targetPath = path.join(tempDir.path, '$fileName.jpg');

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
      minWidth: 800,
      minHeight: 800,
    );

    return result != null ? File(result.path) : null;
  } catch (e) {
    debugPrint('Image compression error: $e');
    return null;
  }
}
