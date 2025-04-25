// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:spectrum_bar_chart/constant/app_constant.dart';
import 'package:spectrum_bar_chart/source/helper/app_ui_helper.dart';
import 'package:spectrum_bar_chart/source/ui/app_text.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? margin;
  final String buttonName;
  final String ? fontFamily;
  final double? fontSize;
  final MaterialStateProperty<EdgeInsetsGeometry?>? padding;
  final MaterialStateProperty<Size?>? minimumSize;
  final Color fontColor;
  final double? buttonRadius;
  final double? borderWidth;
  final Color? buttonColor;
  final Color? borderColor;
  final double? buttonHeight;
  final double ?buttonWidth;
  final bool isActive;
  final ButtonStyle? buttonStyle;
  final bool loadingStatus;

  const AppButton({
    super.key,
    this.onPressed,
    this.margin,
    this.padding,
    this.minimumSize,
    required this.buttonName,
    this.fontSize,
    this.borderWidth,
    this.fontColor = Colors.white,
    this.buttonRadius,
    this.buttonColor,
    this.borderColor,
    this.fontFamily,
    this.buttonHeight,
    this.buttonWidth,
    this.isActive = true,
    this.buttonStyle,
    this.loadingStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed == null
          ? null
          : () async {
              onPressed!.call();
            },
      style: buttonStyle??ButtonStyle(padding:padding,
            backgroundColor:
            MaterialStateProperty.all(
                buttonColor??AppColorConstants.colorLightBlue),
            shadowColor: MaterialStateProperty.all(
                Colors.transparent),
            shape: MaterialStateProperty.all<
                RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(buttonRadius??4),
                    side:  BorderSide(width:borderWidth ?? 0,
                        color: borderColor??AppColorConstants.colorLightBlue))),minimumSize: minimumSize),
        child: Container(width: buttonWidth,
          alignment: Alignment.center,
          height: buttonHeight,
          //decoration: getButtonBoxDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (loadingStatus == true)
                Lottie.asset(
                  AppAssetsConstants.loaderAnimation,
                  delegates: LottieDelegates(
                    values: [
                      ValueDelegate.color(
                        ['**'],
                        value: Colors.white, // Replace with your desired color
                      ),
                    ],
                  ),
                )
              else
                AppText(
                  buttonName,
                  style: TextStyle(
                      color: fontColor, fontSize: fontSize ?? 16, fontWeight: getMediumFontWeight(), fontFamily: fontFamily),
                  textAlign: TextAlign.center,
                ),
            ],
          )),
    );
  }
}

