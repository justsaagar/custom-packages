library spectrum_bar_chart;

import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:spectrum_bar_chart/source/controller/amplifier_controller.dart';
import 'package:spectrum_bar_chart/source/helper/configuration_helper.dart';
import 'package:spectrum_bar_chart/source/helper/enum_helper.dart';
import 'package:spectrum_bar_chart/source/helper/rest_helper.dart';
import 'package:spectrum_bar_chart/source/pages/spectrum_bar_chart_helper.dart';
import 'package:spectrum_bar_chart/source/serialized/amplifier_configuration/amplifier_configuration.dart';
import 'package:spectrum_bar_chart/source/ui/app_screen_layout.dart';
import 'package:spectrum_bar_chart/source/ui/app_toast.dart';

final getIt = GetIt.instance;
class SpectrumBarChartDependencies {

  /// Save and Revert Button ///
  final bool isSwitchOfAuto;

  /// Api Status ///
  final AmplifierConfigurationHelper amplifierConfigurationHelper;
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

  SpectrumBarChartDependencies({
    required this.isSwitchOfAuto,
    required this.amplifierConfigurationHelper,
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

class SpectrumBarChart extends StatefulWidget {
  final List<DSPointData> dataPoints;
  final SpectrumBarChartDependencies dependencies;

  const SpectrumBarChart({
    super.key,
    required this.dataPoints,
    required this.dependencies,
  });

  @override
  State<SpectrumBarChart> createState() => SpectrumBarChartState();
}

class SpectrumBarChartState extends State<SpectrumBarChart> {
  SpectrumBarChartHelper? spectrumBarChartHelper;
  AmplifierController? amplifierController;

  /// This function is called when this object is inserted into the tree.///
  @override
  Widget build(BuildContext context) {
    spectrumBarChartHelper ?? (spectrumBarChartHelper = SpectrumBarChartHelper(this));
    return GetBuilder(
      init: AmplifierController(),
      builder: (AmplifierController controller) {
        amplifierController = controller;
        if (widget.dependencies.apiUrl != null) {
          return FutureBuilder<List<DSPointData>>(
            future: spectrumBarChartHelper?.fetchChartDataWithRestHelper(
              apiUrl: widget.dependencies.apiUrl!,
              customHeaders: widget.dependencies.customHeaders,
              context: widget.dependencies.context,
              body: widget.dependencies.bodyMap,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                widget.dependencies.amplifierConfigurationHelper.spectrumApiStatus = ApiStatus.loading;
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                widget.dependencies.amplifierConfigurationHelper.spectrumApiStatus = ApiStatus.failed;
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                widget.dependencies.amplifierConfigurationHelper.spectrumApiStatus = ApiStatus.success;
                /// Ui Generation ///
                return buildSpectrumBarChart(
                  dataPoints: snapshot.data!,
                  dependencies: widget.dependencies,
                );
              } else {
                widget.dependencies.amplifierConfigurationHelper.spectrumApiStatus = ApiStatus.failed;
                return const Center(child: Text('No data available'));
              }
            },
          );
        }
        widget.dependencies.amplifierConfigurationHelper.spectrumApiStatus = ApiStatus.failed;
        return const Center(child: Text('No data or API URL provided'));
    },);
  }
}





/// Chart Ui Built ////
Widget buildSpectrumBarChart({
  required List<DSPointData> dataPoints,
  required SpectrumBarChartDependencies dependencies,
}) {
  return Column(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      if (dependencies.amplifierConfigurationHelper.spectrumApiStatus ==
          ApiStatus.success) ...[
        Expanded(
          child: ScreenLayoutTypeBuilder(
            builder: (context, layoutType, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(child: BarChart(
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
                          border: const Border(
                            bottom: BorderSide(color: Colors.grey, width: 1),
                            left: BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                      ),
                    ),),
                  ),
                  if (dependencies.isSwitchOfAuto) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        dependencies.saveButton(),
                        dependencies.revertButton(),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info, color: Colors.grey),
                        SizedBox(width: 10),
                        Text(
                          "Click Save to save the Values permanently",
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ],
      if(dependencies.amplifierConfigurationHelper.spectrumApiStatus == ApiStatus.loading)...[
        const Center(child: CircularProgressIndicator())
      ],
      if (dependencies.amplifierConfigurationHelper.spectrumApiStatus == ApiStatus.failed) ...[
        const Center(child: Text('Failed to load chart data')),
      ],
    ],
  );
}

/// ToolTip Data Chart Pillar Data values ///
BarTouchData buildBarTouchData(SpectrumBarChartDependencies dependencies) {
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
FlTitlesData buildFLTitlesData(SpectrumBarChartDependencies dependencies) {
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
FlGridData buildFlGridData(SpectrumBarChartDependencies dependencies) {
  return FlGridData(
    show: true,
    horizontalInterval: 10,
    getDrawingHorizontalLine: (value) => const FlLine(
      color: Colors.grey,
      strokeWidth: 0.5,
    ),
  );
}