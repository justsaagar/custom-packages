import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:spectrum_bar_chart/source/constant/app_constant.dart';
import 'package:spectrum_bar_chart/source/helper/enum_helper.dart';

class AppRefresh extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? buttonColor;
  final double? buttonHeight;
  final double ?buttonWidth;
  final ApiStatus loadingStatus;
  final bool enabled;

  const AppRefresh({
    super.key,
    this.onPressed,
    this.buttonColor,
    this.buttonHeight,
    this.buttonWidth,
    this.loadingStatus = ApiStatus.initial,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: enabled? "":'Offline',
      child: SizedBox(
        width: 32,
        height: 32,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            padding: EdgeInsets.zero, // Remove the default padding// Use transparent background
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Adjust if needed
            ), // Remove elevation if you want a flat button
          ),
          onPressed: enabled?() async {
            if (onPressed == null) return;
            onPressed!.call();
          }: null,
          child: Container(
              width: buttonWidth ?? 30,
              margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              alignment: Alignment.center,
              height: buttonHeight ?? 30,
              // decoration: getButtonBoxDecoration(),
              child: (loadingStatus == ApiStatus.loading)
                  ? ColorFiltered(
                colorFilter: ColorFilter.mode(
                  buttonColor ??
                      AppColorConstants.colorPrimary,
                  BlendMode.srcIn,
                ),
                child: Lottie.asset(
                  AppAssetsConstants.refreshAnimation,
                ),
              ) : Icon(
                Icons.refresh,
                color: enabled?(buttonColor ?? AppColorConstants.colorPrimary):AppColorConstants.colorH1Grey,
                size: 25,
              )),
        ),
      ),
    );
  }
}
