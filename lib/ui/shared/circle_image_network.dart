import 'package:flutter/material.dart';
import 'package:paint_car/data/models/user_model.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class CircleImageNetwork extends StatelessWidget {
  const CircleImageNetwork({
    super.key,
    required this.imageUrl,
  });
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: NetworkImage(
        imageUrl ??
            "https://banner2.cleanpng.com/20190329/tul/kisspng-clip-art-vector-graphics-openclipart-download-port-user-configuration-svg-png-icon-free-download-35-1713899737483.webp",
      ),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.green,
      foregroundImage: NetworkImage(
        imageUrl ??
            "https://banner2.cleanpng.com/20190329/tul/kisspng-clip-art-vector-graphics-openclipart-download-port-user-configuration-svg-png-icon-free-download-35-1713899737483.webp",
      ),
      onBackgroundImageError: (exception, stackTrace) {
        SnackBarUtil.showSnackBar(
          context: context,
          message: "Error loading image",
          type: SnackBarType.error,
        );
      },
      onForegroundImageError: (exception, stackTrace) =>
          SnackBarUtil.showSnackBar(
        context: context,
        message: "Error loading image",
        type: SnackBarType.error,
      ),
    );
  }
}
