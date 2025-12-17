import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullImageView extends StatelessWidget {
  final String imagePath;
  final bool isAsset;

  const FullImageView({
    super.key,
    required this.imagePath,
    this.isAsset = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: PhotoView(
          imageProvider:
              isAsset
                  ? AssetImage(imagePath)
                  : NetworkImage(imagePath) as ImageProvider,
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 3,
        ),
      ),
    );
  }
}
