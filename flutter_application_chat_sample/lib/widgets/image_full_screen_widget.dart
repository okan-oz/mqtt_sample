import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageFullScreenWidget extends StatelessWidget {
  const ImageFullScreenWidget({
    this.memoryImage,
    this.tag = 'Tag',
    this.url = 'https://upload.wikimedia.org/wikipedia/commons/0/0a/Gnome-stock_person.svg',
  });

  final String? url;
  final String? tag;
  final String? memoryImage;

  Widget _buildImage() {
    if (memoryImage != null) {
      return Image(
        image: MemoryImage(base64Decode(memoryImage!)),
      );
    } else {
      return tag != null
          ? Hero(tag: tag!, child: CachedNetworkImage(imageUrl: url!))
          : CachedNetworkImage(
              imageUrl: url!,
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 12.0,
          top: 10.0,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 40.0,
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            color: Colors.black,
            child: _buildImage(),
          ),
        ),
      ],
    );
  }
}
