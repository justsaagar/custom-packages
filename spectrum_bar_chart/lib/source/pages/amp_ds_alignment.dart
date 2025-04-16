library spectrum_bar_chart;


import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:spectrum_bar_chart/source/constant/app_constant.dart';
import 'package:spectrum_bar_chart/source/controller/amplifier_controller.dart';
import 'package:spectrum_bar_chart/source/helper/app_ui_helper.dart';
import 'package:spectrum_bar_chart/source/helper/enum_helper.dart';
import 'package:spectrum_bar_chart/source/pages/AmplifierConfigurationHelper.dart';
import 'package:spectrum_bar_chart/source/serialized/amplifier_configuration/amplifier_configuration.dart';
import 'package:spectrum_bar_chart/source/ui/app_refresh.dart';
import 'package:spectrum_bar_chart/source/ui/app_screen_layout.dart';
import 'package:spectrum_bar_chart/source/ui/custom_error_view.dart';

final getIt = GetIt.instance;
class AmpDsAlignmentDependencies {

  /// Save and Revert Button ///
  final bool isSwitchOfAuto;

  /// Api Status ///
  final BuildContext context;

  /// Chart Height and Width ///
  final double Function(double) getSize;

  final FontWeight Function() getMediumBoldFontWeight;
  final Widget Function() saveButton;
  final Widget Function() revertButton;
  final double maximumYAxisValue;
  final double minimumYAxisValue;
  final double referenceWidth;
  final BorderRadius referenceBorder;
  final double levelBarWidth;
  final BorderRadius levelBarBorder;
  final Color refBarColor;
  final Color levelBarColor;
  final TextStyle tooltipTextStyle;
  final TextStyle axisLabelTextStyle;


  /// buildFLTitlesData ///
  final String xAxisTitle;
  final TextStyle xAxisTitleStyle;
  final Color refGraphColor;
  final Color levelGraphColor;
  final String yAxisTitle;
  final TextStyle yAxisTitleStyle;

  /// Api Configuration ///
  final String? apiUrl;
  final Map<String, String>? customHeaders;
  final Map<String, String>? bodyMap;

  AmpDsAlignmentDependencies({
    required this.isSwitchOfAuto,
    required this.context,
    required this.getSize,
    required this.getMediumBoldFontWeight,
    required this.saveButton,
    required this.revertButton,
    required this.refBarColor,
    required this.levelBarColor,
    required this.tooltipTextStyle,
    required this.axisLabelTextStyle,
    required this.maximumYAxisValue,
    required this.minimumYAxisValue,
    required this.referenceWidth,
    required this.referenceBorder,
    required this.levelBarWidth,
    required this.levelBarBorder,

    /// buildFLTitlesData ///
    required this.xAxisTitle,
    required this.xAxisTitleStyle,
    required this.refGraphColor,
    required this.levelGraphColor,
    required this.yAxisTitle,
    required this.yAxisTitleStyle,

    /// Api Configuration ///
    required this.apiUrl,
    required this.customHeaders,
    required this.bodyMap,
  });
}

class AmpDsAlignment extends StatefulWidget {
  final List<DSPointData> dataPoints;
  final AmpDsAlignmentDependencies dependencies;

  const AmpDsAlignment({
    super.key,
    required this.dataPoints,
    required this.dependencies,
  });

  @override
  State<AmpDsAlignment> createState() => AmpDsAlignmentState();
}

class AmpDsAlignmentState extends State<AmpDsAlignment> {
  AmplifierConfigurationHelper? amplifierConfigurationHelper;
  DsAmplifierController? dsAmplifierController;
  double constraintsWidth = 0.0;
  late ScreenLayoutType screenLayoutType;
  bool isSwitchOfAuto = true;
  /// This function is called when this object is inserted into the tree.///


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    amplifierConfigurationHelper?.spectrumApiStatus = ApiStatus.loading;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      amplifierConfigurationHelper?.getDsAutoAlignmentSpectrumData(apiUrl: widget.dependencies.apiUrl ?? "", context: context,);
    });

  }
  @override
  Widget build(BuildContext context) {
    amplifierConfigurationHelper ?? (amplifierConfigurationHelper = AmplifierConfigurationHelper(this));
    return GetBuilder(
      init: DsAmplifierController(),
      builder: (DsAmplifierController controller) {
        dsAmplifierController = controller;
        return ScreenLayoutTypeBuilder(builder: (context, screenType, constraints) {
          screenLayoutType = screenType;
          constraintsWidth = constraints.maxWidth;
          if (widget.dependencies.apiUrl != null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAmpDsAlignment(
                  dataPoints: amplifierConfigurationHelper?.dsSpectrumDataPoints ?? [],
                  dependencies: widget.dependencies,
                ),
            ],
          );
          }
          amplifierConfigurationHelper?.spectrumApiStatus = ApiStatus.failed;
          return const Center(child: Text('No data or API URL provided'));
        },);
    },);
  }
  /// Chart Ui Built ////
  Widget buildAmpDsAlignment({
    required List<DSPointData> dataPoints,
    required AmpDsAlignmentDependencies dependencies,
  }) {
    double height = (screenLayoutType == ScreenLayoutType.mobile) ? 630 : (!isSwitchOfAuto) ? 600 : 615;
    return Container(
      height: amplifierConfigurationHelper?.spectrumApiStatus == ApiStatus.success ? height : null,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppColorConstants.colorChart , width: 1.8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (amplifierConfigurationHelper?.spectrumApiStatus == ApiStatus.success) ...[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                                  toY: point.reference.toDouble(),
                                  color: dependencies.refBarColor,
                                  width: dependencies.referenceWidth,
                                  borderRadius: dependencies.referenceBorder,
                                ),
                                BarChartRodData(
                                  toY: point.level.toDouble(),
                                  color: dependencies.levelBarColor,
                                  width: dependencies.levelBarWidth,
                                  borderRadius: dependencies.levelBarBorder,
                                ),
                              ],
                            );
                          }).toList(),
                          titlesData: buildFLTitlesData(dependencies),
                          barTouchData: buildBarTouchData(dependencies),
                          gridData: buildFlGridData(dependencies),
                          borderData: FlBorderData(
                            border: Border(
                              bottom: BorderSide(color: AppColorConstants.colorDivider, width: 1),
                              left: BorderSide(color:  AppColorConstants.colorDivider, width: 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (dependencies.isSwitchOfAuto) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        children: [
                          dependencies.saveButton(),
                          const SizedBox(width: 50),
                          dependencies.revertButton(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    saveRevertInfo()
                  ],
                ],
              ),
            ),
          ],
          refreshingBar(),
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
              child: Text(
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

  Widget refreshingBar() {
    final String? errorMessage =
        amplifierConfigurationHelper
            ?.dsSpectrumDataError;
    return Column(
      children: [
        if (errorMessage != null)
          Align(alignment: AlignmentDirectional.centerStart ,child: errorMessageView(errorMessage: errorMessage)),
        buildDsSpectrumLastSeenViewWithRefreshButton(),
      ],
    );
  }

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
                  style: const TextStyle(
                    color: AppColorConstants.colorDarkBlue,
                    fontSize: 12,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDsSpectrumLastSeenViewWithRefreshButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: buildLastSeenView(
              onTapTime: amplifierConfigurationHelper?.dsSpectrumOnTapTime,
              apiStatus: amplifierConfigurationHelper?.spectrumApiStatus,
              difference: amplifierConfigurationHelper?.dsSpectrumDifferenceTime,
              isShow: amplifierConfigurationHelper?.dsSpectrumIsShowText ?? true,
              isOffline: false,
              textColor: AppColorConstants.colorPrimary,
              /// Use Model //
              updateTime: amplifierConfigurationHelper?.dsSpectrumUpdateTime,
              differenceMessage:
              amplifierConfigurationHelper?.dsSpectrumDataError != null
                  ? "The refresh failed in "
                  : null),
        ),
        AppRefresh(
          buttonColor: AppColorConstants.colorPrimary,
          loadingStatus: amplifierConfigurationHelper?.spectrumApiStatus ?? ApiStatus.loading,
          onPressed: () {
            if(amplifierConfigurationHelper?.spectrumApiStatus != ApiStatus.loading) {
              amplifierConfigurationHelper?.getDsAutoAlignmentSpectrumData(apiUrl: widget.dependencies.apiUrl ?? "", context: context,isRefresh: true);
            }
          },
          enabled: true
        )
      ],
    );
  }


}







/// ToolTip Data Chart Pillar Data values ///
BarTouchData buildBarTouchData(AmpDsAlignmentDependencies dependencies) {
  return BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      maxContentWidth: 70,
      getTooltipColor: (group) => Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 0,
      getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
          ) {
        return BarTooltipItem(
            textAlign: rodIndex == 0 ? TextAlign.left : TextAlign.right,
            rod.toY == 0 ? " " : (rodIndex == 0 ? rod.toY.toStringAsFixed(2).padRight(18) : rod.toY.toStringAsFixed(2).padLeft(18)),
            dependencies.tooltipTextStyle.copyWith(
              color: rodIndex == 0 ? dependencies.refBarColor : dependencies.levelBarColor,
            ));
      },
    ),
  );

}


/// X Cord Tile And Y Cord Tile Which On Suggestion Value ////
FlTitlesData buildFLTitlesData(AmpDsAlignmentDependencies dependencies) {
  return FlTitlesData(
    bottomTitles: AxisTitles(
      axisNameSize: 100,
      axisNameWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dependencies.xAxisTitle,
            style: dependencies.xAxisTitleStyle
          ),
          SizedBox(
            height: dependencies.getSize(60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: dependencies.getSize(11),
                    width: dependencies.getSize(12),
                    decoration: BoxDecoration(
                      color: dependencies.refGraphColor,
                      border: Border.all(color: dependencies.refBarColor),
                    ),
                  ),
                ),
                Text(
                  'Ref',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: dependencies.getSize(13),
                    fontWeight: dependencies.getMediumBoldFontWeight(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: dependencies.getSize(11),
                    width: dependencies.getSize(12),
                    decoration: BoxDecoration(
                      color: dependencies.levelGraphColor,
                      border: Border.all(color: dependencies.levelBarColor),
                    ),
                  ),
                ),
                Text(
                  'Level',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: dependencies.getSize(13),
                    fontWeight: dependencies.getMediumBoldFontWeight(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      sideTitles: SideTitles(
        getTitlesWidget: (value, meta) => Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            "$value",
            style: dependencies.axisLabelTextStyle,
          ),
        ),
        showTitles: true,
      ),
    ),
    leftTitles: AxisTitles(
      axisNameSize: 30,
      axisNameWidget: Text(
        dependencies.yAxisTitle,
        style: dependencies.yAxisTitleStyle,
      ),
      sideTitles: SideTitles(
        interval: 10,
        showTitles: true,
        getTitlesWidget: (value, meta) => Text(
          "$value",
          style: dependencies.axisLabelTextStyle,
        ),
        reservedSize: 40,
      ),
    ),
    rightTitles: const AxisTitles(drawBelowEverything: false),
    topTitles: const AxisTitles(drawBelowEverything: false),
  );
}

/// Chart In To Grid Lines Data Design ///
FlGridData buildFlGridData(AmpDsAlignmentDependencies dependencies) {
  return FlGridData(
    show: true,
    horizontalInterval: 10,
    getDrawingHorizontalLine: (value) => const FlLine(
      color: Colors.grey,
      strokeWidth: 0.5,
    ),
  );
}