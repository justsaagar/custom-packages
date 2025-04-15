import 'package:flutter/material.dart';
import 'package:spectrum_bar_chart/source/helper/date_helper.dart';
import 'package:spectrum_bar_chart/source/helper/enum_helper.dart';

Widget buildLastSeenView({
  ApiStatus? apiStatus,
  DateTime? onTapTime,
  Duration? difference,
  bool isShow = true,
  DateTime? updateTime,
  Color? textColor,
  String? differenceMessage,
  bool isOffline = false,
}) {
  if (isShow) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: getTimeDurationView(
          differenceMessage: differenceMessage,
          refreshStatus: apiStatus,
          updateTime: updateTime,
          onTapTime: onTapTime,
          difference: difference,
          textColor: textColor),
    );
  } else {
    if (updateTime != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: getLastSeenView(updateTime, textColor: textColor, offline: isOffline),
      );
    } else {
      return Container(height: 35);
    }
  }
}