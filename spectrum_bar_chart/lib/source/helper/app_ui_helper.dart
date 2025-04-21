import 'package:spectrum_bar_chart/app_import.dart';


getSize(double val){
  return val;
}

getMediumBoldFontWeight(){
  return FontWeight.w600;
}
getMediumFontWeight(){
  return FontWeight.w500;
}
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
              child: Text(
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

