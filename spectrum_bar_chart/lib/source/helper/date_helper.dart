import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spectrum_bar_chart/constant/app_constant.dart';
import 'package:spectrum_bar_chart/source/ui/app_text.dart';




String lastUpdateDateFormat = "MM-dd-yyyy hh:mm:ss a";

Widget getTimeDurationView({
  bool? refreshStatus,
  DateTime? updateTime,
  DateTime? onTapTime,
  Duration? difference,
  String? differenceMessage,
  String? waitingMessage,
  Alignment? alignment,
  Color? textColor
}) {
  return Align(alignment:alignment?? Alignment.centerRight,
    child: Padding(
      padding: const EdgeInsets.only(top: 6),
      child: AppText(
          refreshStatus == true && onTapTime != null
              ? waitingMessage ?? 'Please wait refreshing data...'
              : difference != null
              ? '${differenceMessage ?? 'The refresh completed in '}${difference.inSeconds}.${difference.inMilliseconds ~/ 10}s'
              : updateTime != null ? 'Last Updated: ${DateFormat(lastUpdateDateFormat).format(updateTime)}' : " not Defined show",
          style: TextStyle(
              color: refreshStatus == true || textColor == null || difference == null ? AppColorConstants.colorAppbar : textColor,
              fontWeight: FontWeight.w500,
              fontSize: 13,
              fontFamily: 'OpenSans')),
    ),
  );
}

Widget getLastSeenView(DateTime ?lastUpdateTime, {Color? textColor, bool offline = false,Alignment? alignment}) {
  if (lastUpdateTime != null) {
    return Align(alignment: alignment??Alignment.centerRight,
      child: Padding(
        padding:  const EdgeInsets.only(right: 10,top:6),
        child: AppText(
          "Last Updated: ${DateFormat(lastUpdateDateFormat).format(lastUpdateTime)}",
          style:  TextStyle(
              fontSize: 13,
              //color:textColor?? AppColorConstants.colorAppbar,
              color: offline? AppColorConstants.colorH1Grey : AppColorConstants.colorAppbar,
              fontFamily: "OpenSans",fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
  return Container();
}

DateTime? getLastUpdateTime(String ?lastUpdateTime) { // From API
  if(lastUpdateTime == null) return null;
  int microseconds = (double.parse(lastUpdateTime) * 1000000).toInt();
  return DateTime.fromMicrosecondsSinceEpoch(microseconds);
}
