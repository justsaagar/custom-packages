library spectrum_bar_chart;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spectrum_bar_chart/constant/app_constant.dart';
import 'package:spectrum_bar_chart/source/helper/app_ui_helper.dart';
import 'package:spectrum_bar_chart/source/pages/spectrum_bar_chart_dependencies.dart';
import 'package:spectrum_bar_chart/source/ui/app_button.dart';
import 'package:spectrum_bar_chart/source/ui/app_loader.dart';
import 'package:spectrum_bar_chart/source/ui/app_refresh.dart';
import 'package:spectrum_bar_chart/source/ui/app_screen_layout_type.dart';
import 'package:spectrum_bar_chart/source/ui/app_text.dart';
import 'package:spectrum_bar_chart/source/ui/custom_error_view.dart';

class SpectrumChartItem {
  final int freq;
  final double level;
  final double reference;

  SpectrumChartItem({
    required this.freq,
    required this.level,
    required this.reference,
  });
}


class SpectrumBarChart extends StatelessWidget {
  final List<SpectrumChartItem> dataPoints;
  final SpectrumBarChartDependencies dependencies;


  const SpectrumBarChart({
    super.key,
    required this.dataPoints,
    required this.dependencies,
  });

  @override
  Widget build(BuildContext context) {
    late AppScreenLayoutType screenLayoutType;

    return ScreenLayoutTypeBuilder(builder: (context, screenType, constraints) {
      screenLayoutType = screenType;
      return buildSpectrumBarChart(
        dataPoints: dataPoints,
        dependencies: dependencies,
        screenLayoutType: screenLayoutType,
      );
    });
  }


  /// Refresh Bar ///
  Widget refreshingBar() {
    final String? errorMessage = dependencies.downStreamAutoAlignmentError;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (errorMessage != null)
          Align(alignment: AlignmentDirectional.centerStart ,child: errorMessageView(errorMessage: errorMessage)),
        buildDsSpectrumLastSeenViewWithRefreshButton(),
      ],
    );
  }

  /// Last update TIme View String show ///
  Widget buildDsSpectrumLastSeenViewWithRefreshButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if(dependencies.downStreamAutoAlignmentError != null)
          SizedBox(width: getSize(10))
        else
        Flexible(
          child: buildLastSeenView(
            messageString: dependencies.lastUpdateString,
            textColor: dependencies.lastUpdateColor,
          ),
        ),
        AppRefresh(
          buttonColor: AppColorConstants.colorPrimary,
          loadingStatus: dependencies.spectrumApiStatus,
          onPressed: dependencies.onTapRefreshButton,
          enabled: dependencies.isRefreshEnable,
        )
      ],
    );
  }



  /// Auto Alignment Button ///
  Widget startAutoAlignmentWidget(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AppButton(
          buttonRadius: 9,
          loadingStatus: dependencies.isStartDownStream,
          buttonHeight: getSize(35),
          buttonWidth: getSize(220),
          fontColor: dependencies.isSwitchOfAuto
          // && getDetectedStatusType(ampItem.status) == DetectedStatusType.online    /// Api Into online Offline Status manage
              ? AppColorConstants.colorWhite
              : AppColorConstants.colorH1Grey,
          borderColor: dependencies.isSwitchOfAuto
          // && getDetectedStatusType(ampItem.status) == DetectedStatusType.online   /// Api Into online Offline Status manage
              ? AppColorConstants.colorLightBlue.withOpacity(0.5)
              : AppColorConstants.colorH1.withOpacity(0.5),
          buttonName: "Start Auto Alignment",
          onPressed: dependencies.startAutoButtonPressed,
          buttonColor: dependencies.isStartDownStream
              ? AppColorConstants.colorLightBlue.withOpacity(0.6)
              : dependencies.isSwitchOfAuto
          // && getDetectedStatusType(ampItem.status) == DetectedStatusType.online ? // Api Into online Offline Status manage
              ? AppColorConstants.colorLightBlue
              : AppColorConstants.colorBackgroundDark,
          fontSize: getSize(16),
        ),
        if (dependencies.downStreamAutoAlignmentError != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: CustomPaint(
              painter: DottedBorderPainter(
                borderColor: AppColorConstants.colorRedLight.withOpacity(0.8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, color: AppColorConstants.colorRedLight, size: 15),
                    const SizedBox(width: 5),
                    Flexible(
                      child: AppText(
                        "${dependencies.downStreamAutoAlignmentError}",
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
          )
        else
          Container(height: 35),
      ],
    );
  }

  Widget buildSpectrumBarChart({
    required List<SpectrumChartItem> dataPoints,
    required SpectrumBarChartDependencies dependencies,
    required AppScreenLayoutType screenLayoutType
  }) {
    double height = (screenLayoutType == AppScreenLayoutType.mobile) ? 630 : (screenLayoutType == AppScreenLayoutType.tablet) ? 600 : 615;
    return Container(
      height: dependencies.spectrumApiStatus == true ?  null : height,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFFE0E0E0) , width: 1.8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if(dependencies.spectrumApiStatus == false) ...[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: dependencies.maximumYAxisValue,
                          minY: dependencies.minimumYAxisValue,
                          barGroups: dataPoints.map((point) {
                            return BarChartGroupData(
                              showingTooltipIndicators: [0, 1],
                              x: point.freq.toInt(),
                              barRods: [
                                BarChartRodData(
                                  toY: point.reference,
                                  color: AppColorConstants.colorRefChartBorder,
                                  width: 10,
                                  borderRadius:const BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4),
                                  ),
                                ),
                                BarChartRodData(
                                  toY: point.level,
                                  color: AppColorConstants.colorLevelChartBorder,
                                  width: 10,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                          titlesData: buildFLTitlesData(dependencies),
                          barTouchData: buildBarTouchData(dependencies),
                          gridData: buildFlGridData(dependencies),
                          borderData: FlBorderData(
                            border: const Border(
                              bottom: BorderSide(color: Colors.grey, width: 1),
                              left: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (dependencies.isSwitchOfAuto)
                    Column(
                      children: [
                        saveRevertButtonOfAutoAlignWidget(),
                        saveRevertInfo()
                      ],
                    ),
                ],
              ),
            ),
          ],
          refreshingBar(),
        ],
      ),
    );
  }

  saveRevertButtonOfAutoAlignWidget() {
    if(dependencies.saveRevertApiStatusOfAutoAlign == true) {
      return const SizedBox(
          height: 85, width: 50, child: AppLoader());
    }
    return  Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Wrap(
        children: [
          AppButton(
            buttonWidth: 80,
            buttonRadius: 8,
            buttonHeight: 32,
            buttonColor: dependencies.isSaveRevertUnable ? null : Colors.grey,
            borderColor: dependencies.isSaveRevertUnable ? null : Colors.grey,
            padding: WidgetStateProperty.all(const EdgeInsets.all(12)),
            buttonName: "Save",
            fontSize: 16,
            onPressed: !dependencies.isSaveRevertUnable ? null : dependencies.saveButtonPressed,
            fontFamily: AppAssetsConstants.openSans,
          ),
          const SizedBox(
            width: 50,
          ),
          AppButton(
            buttonWidth: 80,
            buttonRadius: 8,
            buttonHeight: 32,
            buttonColor: dependencies.isSaveRevertUnable ? null : Colors.grey,
            borderColor: dependencies.isSaveRevertUnable ? null : Colors.grey,
            padding: WidgetStateProperty.all(const EdgeInsets.all(12)),
            buttonName: "Revert",
            fontSize: 16,
            onPressed: !dependencies.isSaveRevertUnable ? null : dependencies.revertButtonPressed,
            fontFamily: AppAssetsConstants.openSans,
          ),
        ],
      ),
    );
  }

  saveRevertInfo() {
    return const Column(
      children: [
        SizedBox(height: 5,),
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info, color: Colors.grey),
            SizedBox(width: 5,),
            Flexible(
              child: AppText(
                "Click Save to save the Values permanently",
                style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.32,
                    color: Colors.grey,
                    fontSize: 12),
              ),
            ),
          ],
        )
      ],);
  }

}



BarTouchData buildBarTouchData(SpectrumBarChartDependencies dependencies) {
  return BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      maxContentWidth: 70,
      getTooltipColor: (_) => Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 0,
      getTooltipItem: (group, groupIndex, rod, rodIndex) {
        return BarTooltipItem(
          rod.toY == 0 ? " " : (rodIndex == 0 ? rod.toY.toStringAsFixed(2).padRight(18) : rod.toY.toStringAsFixed(2).padLeft(18)),
          TextStyle(
            color: rodIndex == 0 ? AppColorConstants.colorRefChartBorder : AppColorConstants.colorLevelChartBorder,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
          textAlign: rodIndex == 0 ? TextAlign.left : TextAlign.right,
        );
      },
    ),
  );
}

FlTitlesData buildFLTitlesData(SpectrumBarChartDependencies dependencies) {
  return FlTitlesData(
    bottomTitles: AxisTitles(
      axisNameSize: 100,
      axisNameWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(
            dependencies.xAxisTitle,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 11,
                    width: 12,
                    decoration: BoxDecoration(
                      color: AppColorConstants.colorRefChartBackGround,
                      border: Border.all(color: AppColorConstants.colorRefChartBorder),
                    ),
                  ),
                ),
                AppText(
                  'Ref',
                  style: TextStyle(
                      color: AppColorConstants.colorBlack,
                      fontSize: 13,
                      fontFamily: AppAssetsConstants.notoSans,
                      fontWeight: getMediumBoldFontWeight()),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 11,
                    width: 12,
                    decoration: BoxDecoration(
                      color: AppColorConstants.colorLevelChartBackGround,
                      border: Border.all(color: AppColorConstants.colorLevelChartBorder),
                    ),
                  ),
                ),
                AppText(
                  'Level',
                  style: TextStyle(
                      color: AppColorConstants.colorBlack,
                      fontFamily: AppAssetsConstants.notoSans,
                      fontSize: 13,
                      fontWeight: getMediumBoldFontWeight()),
                ),
              ],
            ),
          ),
        ],
      ),
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, _) => Padding(
          padding: const EdgeInsets.only(top: 5),
          child: AppText(
            "$value",
            style: TextStyle(
              color: AppColorConstants.colorH1,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    ),
    leftTitles: AxisTitles(
      axisNameSize: 30,
      axisNameWidget: AppText(
        dependencies.yAxisTitle,
        style: TextStyle(
          color: AppColorConstants.colorH1,
          fontSize: 13,
        ),
      ),
      sideTitles: SideTitles(
        interval: 10,
        showTitles: true,
        getTitlesWidget: (value, _) => AppText(
          "$value",
          style: TextStyle(
            color: AppColorConstants.colorH1,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
        reservedSize: 40,
      ),
    ),
    rightTitles: const AxisTitles(drawBelowEverything: false),
    topTitles: const AxisTitles(drawBelowEverything: false),
  );
}

FlGridData buildFlGridData(SpectrumBarChartDependencies dependencies) {
  return FlGridData(
    show: true,
    horizontalInterval: 10,
    drawVerticalLine: false,
    getDrawingHorizontalLine: (_) => const FlLine(
      color: Colors.grey,
      strokeWidth: 0.5,
    ),
  );
}

