import 'dart:convert';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit fit;
  final IconData errorIcon;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius = 12,
    this.fit = BoxFit.cover,
    this.errorIcon = Icons.image_outlined,
  });

  Widget _buildError() {
    return Container(
      width: width,
      height: height,
      color: AppColors.primary.withValues(alpha: 0.06),
      child: Icon(errorIcon, color: AppColors.primary, size: 32),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: _buildError(),
      );
    }

    final bool isBase64 = imageUrl.startsWith('data:image');
    final bool isNetwork =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
    Widget imageWidget;

    if (isBase64) {
      try {
        final base64Str = imageUrl.split(',').last;
        imageWidget = Image.memory(
          base64Decode(base64Str),
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (ctx, err, trace) => _buildError(),
        );
      } catch (e) {
        imageWidget = _buildError();
      }
    } else if (isNetwork) {
      imageWidget = Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (ctx, err, trace) => _buildError(),
      );
    } else {
      imageWidget = Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (ctx, err, trace) => _buildError(),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: imageWidget,
    );
  }
}
