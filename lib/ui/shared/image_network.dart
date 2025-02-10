import 'package:flutter/material.dart';
import 'package:paint_car/dependencies/services/log_service.dart';

class ImageNetwork extends StatefulWidget {
  final String src;
  final double width;
  final double height;
  final BoxFit fit;

  const ImageNetwork({
    Key? key,
    required this.src,
    required this.width,
    required this.height,
    this.fit = BoxFit.contain,
  }) : super(key: key);

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
      width: widget.width,
      height: widget.height,
      cacheWidth: widget.width.toInt(),
      cacheHeight: widget.height.toInt(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Image.asset(
          "assets/images/placeholder-image-general.webp",
          fit: widget.fit,
          width: widget.width,
          height: widget.height,
        );
      },
      errorBuilder: (context, error, stackTrace) {
        // TODO: DELETE THIS
        LogService.e("Error loading image: ${widget.src}, $error");
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).disabledColor,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.signal_wifi_off,
              size: widget.width / 2,
              color: Theme.of(context).disabledColor,
            ),
          ),
        );
      },
    );
  }
}
