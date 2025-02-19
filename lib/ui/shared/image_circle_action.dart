import 'dart:io';
import 'package:flutter/material.dart';
import 'package:paint_car/ui/shared/image_network.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class ImageCircleAction extends StatelessWidget {
  final File? selectedImage;
  final String? logoUrl;
  final VoidCallback onPickImage;
  final double? radius;

  const ImageCircleAction({
    Key? key,
    required this.selectedImage,
    required this.logoUrl,
    required this.onPickImage,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // kalo ada gambar lokal, tampilin gambar nya
    if (selectedImage != null) {
      return _buildLocalImage(
        context,
      );
    }
    // kalo ga ada gambar lokal, tapi ada url
    if (logoUrl != null) return _buildImageFromUrl();
    // kalo ga ada gambar sama sekali
    return _buildPickImageButton();
  }

  Widget _image(
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: onPickImage,
      child: CircleAvatar(
        radius: radius,
        backgroundImage: FileImage(selectedImage!),
        onBackgroundImageError: (exception, stackTrace) {
          SnackBarUtil.showSnackBar(
            context: context,
            message: "Error loading image",
            type: SnackBarType.error,
          );
        },
      ),
    );
  }

  Widget _buildLocalImage(
    BuildContext context,
  ) {
    return _image(
      context,
    );
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
