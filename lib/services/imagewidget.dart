import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'loading_widget.dart';

class ImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;

  const ImageWidget({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                imageUrl: imageUrl!,
                width: width,
                height: height,
                placeholder: (context, url) => const LoadingWidget(),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error_outline),
              ),
            )
          : const Icon(Icons.image_not_supported_outlined),
    );
  }
}

class StageImageWidget extends StatelessWidget {
  final String? stageImageUrl;
  final double width;
  final double height;

  const StageImageWidget({
    super.key,
    required this.stageImageUrl,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: stageImageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                imageUrl: stageImageUrl!,
                width: width,
                height: height,
                placeholder: (context, url) => const LoadingWidget(),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error_outline),
              ),
            )
          : const Icon(Icons.image_not_supported_outlined),
    );
  }
}
