

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spectrum_bar_chart/source/constant/app_constant.dart';

import 'app_shimmer_effect.dart';

class AppImageAsset extends StatelessWidget {
  final String? image;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;
  final bool isFile;
  final Widget? errorWidget;

  const AppImageAsset({
    super.key,
    @required this.image,
    this.fit = BoxFit.cover,
    this.height,
    this.width,
    this.color,
    this.isFile = false,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return image!.contains('http')
        ? CachedNetworkImage(
            imageUrl: '$image',
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            placeholder: (context, url) => AppShimmerEffectView(
              height: height ?? double.maxFinite,
              width: width ?? double.maxFinite,
            ),
            errorWidget: (context, url, error) =>
                errorWidget ??  Icon(Icons.error, color: AppColorConstants.colorRed),
          )
        : isFile
            ? Image.file(File(image!), fit: fit, height: height, width: width, color: color)
            : image!.isEmpty || image!.split('.').last != 'svg'
                ? Image.asset(
                    image!,
                    fit: fit,
                    height: height,
                    width: width,
                    color: color,
                    errorBuilder: (context, url, error) => errorWidget ?? const SizedBox(),
                  )
                // ignore: deprecated_member_use
                : SvgPicture.asset(image!, height: height, width: width, color: color);
  }
}
