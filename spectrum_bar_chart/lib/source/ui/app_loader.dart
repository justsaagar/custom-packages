

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:spectrum_bar_chart/constant/app_constant.dart';

class AppLoader extends StatelessWidget {
  final Color loaderColor;
  final double loaderSize;

  const AppLoader({super.key,
    this.loaderColor = Colors.orange,
    this.loaderSize = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
      color: Colors.transparent,
      child: Lottie.asset(
        AppAssetsConstants.loaderAnimation,
        height: 85,
        width: 85,
      ),
    );
  }
}
