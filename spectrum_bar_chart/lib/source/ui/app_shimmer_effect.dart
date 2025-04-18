
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spectrum_bar_chart/source/constant/app_constant.dart';

class AppShimmerEffectView extends StatelessWidget {
  final double? height;
  final double? width;
  final double? borderRadius;

  const AppShimmerEffectView({super.key, this.height, this.width, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColorConstants.colorWhite200,
      highlightColor: AppColorConstants.colorWhite100,
      child: Container(
        height: height ?? 30,
        width: width ?? 50,
        decoration: BoxDecoration(
          color: AppColorConstants.colorWhite200,
          borderRadius: BorderRadius.circular(borderRadius ?? 4),
        ),
      ),
    );
  }
}
