import 'package:flutter/material.dart';
import 'package:spectrum_bar_chart/constant/app_constant.dart';
import 'package:spectrum_bar_chart/source/helper/date_helper.dart';
import 'package:spectrum_bar_chart/source/ui/app_text.dart';
import 'package:spectrum_bar_chart/source/ui/custom_error_view.dart';

double getSize(double val){
  return val;
}
getMediumBoldFontWeight(){
  return FontWeight.w600;
}
FontWeight getMediumFontWeight(){
  return FontWeight.w500;
}

Widget buildLastSeenView({
  String? messageString,
  Color? textColor,
}) {
  return Align(alignment: Alignment.centerRight,
    child: Padding(
      padding: const EdgeInsets.only(top: 6),
      child: AppText(
          messageString ?? '',
          style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w500,
              fontSize: 13,
              fontFamily: 'OpenSans')),
    ),
  );
}

BoxDecoration borderViewDecoration = BoxDecoration(
  border: Border.all(color: AppColorConstants.colorChart, width: 1.8),
  borderRadius: const BorderRadius.all(Radius.circular(8)),
);

errorMessageView({required String errorMessage,double ?padding}) {
  return Padding(
    padding: EdgeInsets.all(padding ?? 8.0),
    child: CustomPaint(
      painter: DottedBorderPainter(
        borderColor: AppColorConstants.colorRedLight.withOpacity(0.8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                color: AppColorConstants.colorRedLight, size: 15),
            const SizedBox(width: 5),
            Flexible(
              child: AppText(
                errorMessage,
                style: TextStyle(
                  color: AppColorConstants.colorDarkBlue,
                  fontSize: 12,
                  fontFamily: AppAssetsConstants.openSans,
                  fontWeight: getMediumFontWeight(),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}