import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';

class ShadowedImage extends StatefulWidget {
  final double width;
  final double height;
  final Uint8List? imageBytes;
  final String? assetPath;
  final Color? colour;
  const ShadowedImage({super.key, required this.width, required this.height, this.imageBytes, this.assetPath, this.colour});

  @override
  State<ShadowedImage> createState() => _ShadowedImageState();
}

class _ShadowedImageState extends State<ShadowedImage> {
  @override
  Widget build(BuildContext context) {
    if (widget.assetPath == null && widget.imageBytes == null) {
      return SizedBox(height: widget.height, width: widget.width);
    }

    return RepaintBoundary(
      child: SizedBox(
      height: widget.height,
      width: widget.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Shadow layer
          Padding(
            padding: EdgeInsetsGeometry.only(top: 4),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(Colors.black87, BlendMode.srcIn),
                child: SizedBox(
                  height: widget.height + 2,
                  width: widget.width,
                  child: widget.imageBytes == null
                      ? Image(image: AssetImage(widget.assetPath!), fit: BoxFit.contain, gaplessPlayback: true)
                      : Image.memory(widget.imageBytes!, fit: BoxFit.contain, gaplessPlayback: true),
                ),
              ),
            ),
          ),
          SizedBox(
            height: widget.height - 4,
            width: widget.width - 4,
            child: widget.imageBytes == null
                ? Image(image: AssetImage(widget.assetPath!), fit: BoxFit.contain, gaplessPlayback: true, color: widget.colour)
                : Image.memory(widget.imageBytes!, fit: BoxFit.contain, gaplessPlayback: true, color: widget.colour),
          ),
        ],
      ),
      ),
    );
  }
}
