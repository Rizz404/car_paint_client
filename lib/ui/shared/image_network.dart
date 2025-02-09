import 'package:flutter/material.dart';

class ImageNetwork extends StatefulWidget {
  final String src;
  final double width;
  final double height;
  final BoxFit fit;
  const ImageNetwork({
    super.key,
    required this.src,
    required this.width,
    required this.height,
    this.fit = BoxFit.contain,
  });

  @override
  State<ImageNetwork> createState() => _ImageNetworkState();
}

class _ImageNetworkState extends State<ImageNetwork> {
  @override
  Widget build(BuildContext context) {
    return Image.network(
      widget.src,
      fit: widget.fit,
      headers: const {"Cache-Control": "max-age=604800"},
      cacheWidth: widget.width.toInt(),
      width: widget.width,
      cacheHeight: widget.height.toInt(),
      height: widget.height,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        // TODO: REPLACE AMA PLACEHOLDER IMAGE DARI PT
        return Image.asset(
          "assets/images/placeholder-image-general.webp",
          fit: widget.fit,
          height: widget.height,
        );
      },
    );
  }
}
