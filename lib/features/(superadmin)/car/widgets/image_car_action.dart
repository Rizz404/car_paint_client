import 'dart:io';
import 'package:flutter/material.dart';
import 'package:paint_car/ui/shared/image_network.dart';

class ImageCarAction extends StatelessWidget {
  final File? selectedImage;
  final String? logoUrl;
  final VoidCallback onPickImage;

  const ImageCarAction({
    Key? key,
    required this.selectedImage,
    required this.logoUrl,
    required this.onPickImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // kalo ada gambar lokal, tampilin gambar nya
    if (selectedImage != null) return _buildLocalImage();
    // kalo ga ada gambar lokal, tapi ada url
    if (logoUrl != null) return _buildImageFromUrl();
    // kalo ga ada gambar sama sekali
    return _buildPickImageButton();
  }

  Widget _image() {
    return GestureDetector(
      onTap: onPickImage,
      child: Image.file(
        selectedImage!,
        fit: BoxFit.contain,
        height: 400,
        cacheHeight: 400,
      ),
    );
  }

  Widget _buildLocalImage() {
    return _image();
  }

  Widget _buildImageFromUrl() {
    return ImageNetwork(
      src: logoUrl!,
      width: 400,
      height: 400,
    );
  }

  Widget _buildPickImageButton() {
    return ElevatedButton(
      onPressed: onPickImage,
      child: const Text("Pick Image"),
    );
  }
}
