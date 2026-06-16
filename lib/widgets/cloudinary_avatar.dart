import 'dart:io';
import 'package:flutter/material.dart';

class CloudinaryAvatar extends StatelessWidget {
  const CloudinaryAvatar({
    super.key,
    required this.radius,
    required this.imageUrl,
    this.localFile,
    this.assetFallback = 'assets/images/Ellipse.png',
    this.backgroundColor = Colors.black,
  });

  final double radius;
  final String imageUrl;
  final File? localFile;
  final String assetFallback;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;

    Widget imageWidget;

    if (imageUrl.isNotEmpty) {
      imageWidget = Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: size,
        height: size,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return Container(
            width: size,
            height: size,
            color: backgroundColor,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes == null
                  ? null
                  : loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!,
              strokeWidth: 2.5,
              color: Colors.white,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            assetFallback,
            fit: BoxFit.cover,
            width: size,
            height: size,
          );
        },
      );
    } else if (localFile != null) {
      imageWidget = Image.file(
        localFile!,
        fit: BoxFit.cover,
        width: size,
        height: size,
      );
    } else {
      imageWidget = Image.asset(
        assetFallback,
        fit: BoxFit.cover,
        width: size,
        height: size,
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: ClipOval(child: imageWidget),
    );
  }
}
