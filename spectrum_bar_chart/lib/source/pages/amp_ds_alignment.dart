library spectrum_bar_chart;


import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:spectrum_bar_chart/source/constant/app_constant.dart';
import 'package:spectrum_bar_chart/source/controller/ds_amplifier_controller.dart';
import 'package:spectrum_bar_chart/source/helper/app_ui_helper.dart';
import 'package:spectrum_bar_chart/source/helper/date_helper.dart';
import 'package:spectrum_bar_chart/source/helper/enum_helper.dart';
import 'package:spectrum_bar_chart/source/helper/rest_helper.dart';
import 'package:spectrum_bar_chart/source/model/amplifier_status_item.dart';
import 'package:spectrum_bar_chart/source/pages/AmplifierConfigurationHelper.dart';
import 'package:spectrum_bar_chart/source/serialized/amplifier/amplifier.dart';
import 'package:spectrum_bar_chart/source/serialized/amplifier_configuration/amplifier_configuration.dart';
import 'package:spectrum_bar_chart/source/ui/app_button.dart';
import 'package:spectrum_bar_chart/source/ui/app_loader.dart';
import 'package:spectrum_bar_chart/source/ui/app_refresh.dart';
import 'package:spectrum_bar_chart/source/ui/app_screen_layout.dart';
import 'package:spectrum_bar_chart/source/ui/app_toast.dart';
import 'package:spectrum_bar_chart/source/ui/custom_error_view.dart';
import 'package:spectrum_bar_chart/source/ui/manual_alignment_page.dart';
import 'package:spectrum_bar_chart/source/utils/dialog_utils.dart';

final getIt = GetIt.instance;
class AmpDsAlignmentDependencies {

  /// Save and Revert Button ///
  final bool isSwitchOfAuto;

  /// Api Status ///
  final BuildContext context;

  final double maximumYAxisValue;
  final double minimumYAxisValue;
  final TextStyle? tooltipTextStyle;
  final TextStyle? axisLabelTextStyle;

  /// Api Configuration ///
  final String deviceId;
  final Map<String, String>? customHeaders;
  final Map<String, String>? bodyMap;

  AmpDsAlignmentDependencies({
    required this.isSwitchOfAuto,
    required this.context,
    this.tooltipTextStyle,
    this.axisLabelTextStyle,
    required this.maximumYAxisValue,
    required this.minimumYAxisValue,

    /// Api Configuration ///
    required this.deviceId,
    required this.customHeaders,
    required this.bodyMap,
  });
}

class AmpDsAlignment extends StatefulWidget {
  final AmpDsAlignmentDependencies dependencies;

  const AmpDsAlignment({
    super.key,
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
  String apiUrl = '';
  bool isStartDownStream = false;
  DateTime? dsAutoAlignUpdateTime;
  DateTime? autoAlignmentOnTapTime;
  Duration ? autoAlignmentDifferenceTime;
  bool autoAlignmentIsShowText = true;
  Timer? autoAlignmentRefreshTimer;
  bool isSaveRevertUnable = false;


  /// This function is called when this object is inserted into the tree.///


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    amplifierConfigurationHelper?.spectrumApiStatus = ApiStatus.loading;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      apiUrl = 'https://192.168.44.176:3333/amps/${widget.dependencies.deviceId}/ds_auto_alignment_spectrum_data?timeout=15&retries=1&refresh=true';
      amplifierConfigurationHelper?.getDsAutoAlignmentSpectrumData(apiUrl: apiUrl, context: context);
      amplifierConfigurationHelper?.getDsManualAlignment(context,widget.dependencies.deviceId);
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
            if (apiUrl.isNotEmpty) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        startAutoAlignmentWidget(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: buildAmpDsAlignment(
                            dataPoints: amplifierConfigurationHelper?.dsSpectrumDataPoints ?? [],
                            dependencies: widget.dependencies,
                          ),
                        ),
                        SizedBox(width: getSize(10)),
                        Expanded(
                          child: ampInterstageValuesView()
                        ),
                      ],
                    )
                  ],
                ),
              );
            }
            amplifierConfigurationHelper?.spectrumApiStatus = ApiStatus.failed;
            return const Center(child: Text('No data or API URL provided'));
          },
        );
      },
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
          loadingStatus: isStartDownStream ? ApiStatus.loading : ApiStatus.success,
          buttonHeight: getSize(35),
          buttonWidth: getSize(220),
          fontColor: isSwitchOfAuto
              // && getDetectedStatusType(ampItem.status) == DetectedStatusType.online    /// Api Into online Offline Status manage
              ? AppColorConstants.colorWhite
              : AppColorConstants.colorH1Grey,
          borderColor: isSwitchOfAuto
              // && getDetectedStatusType(ampItem.status) == DetectedStatusType.online   /// Api Into online Offline Status manage
              ? AppColorConstants.colorLightBlue.withOpacity(0.5)
              : AppColorConstants.colorH1.withOpacity(0.5),
          buttonName: "Start Auto Alignment",
          onPressed: () async {
            if (isSwitchOfAuto && !isStartDownStream) {
              DialogUtils().confirmationDialog(
                context,
                "Confirm ?",
                "Are you sure you want to perform auto-alignment?",
                "Yes",
                "No", () async {
                Navigator.pop(context);
                await getDsAlignment(context, widget.dependencies.deviceId).then((value) {});
              },
                    () => Navigator.pop(context),
              );
            }
          },
          buttonColor: isStartDownStream
              ? AppColorConstants.colorLightBlue.withOpacity(0.6)
              : isSwitchOfAuto
              // && getDetectedStatusType(ampItem.status) == DetectedStatusType.online ? // Api Into online Offline Status manage
              ? AppColorConstants.colorLightBlue
              : AppColorConstants.colorBackgroundDark,
          fontSize: getSize(16),
        ),
        if (amplifierConfigurationHelper?.downStreamAutoAlignmentError != null)
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
                      child: Text(
                        "${amplifierConfigurationHelper?.downStreamAutoAlignmentError}",
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
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 400,
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
                                color: AppColorConstants.colorRefChartBorder,
                                width: 10,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                ),
                              ),
                              BarChartRodData(
                                toY: point.level.toDouble(),
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
                          border: Border(
                            bottom: BorderSide(color: AppColorConstants.colorDivider, width: 1),
                            left: BorderSide(color:  AppColorConstants.colorDivider, width: 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isSwitchOfAuto)
                    Obx(() => Column(
                          children: [
                            saveRevertButtonOfAutoAlignWidget(),
                            saveRevertInfo()
                          ],
                        )),
                ],
              ),
            ),
          ],
          refreshingBar(),
        ],
      ),
    );
  }

  Widget ampInterstageValuesView() {
    return ManualAlignmentPage(
      isSwitchOfAuto: isSwitchOfAuto,
      isDSAlignment: true,
      screenLayoutType: screenLayoutType,
      dsAmplifierController: dsAmplifierController!,
      isOffline : true, /// THis Condition is Pending
      amplifierConfigurationHelper: amplifierConfigurationHelper!,
      dsManualAlignmentItem: amplifierConfigurationHelper!.dsManualAlignmentItem,
      onTapWrite: (DsManualAlignmentItem dsManualAlignmentItem) async {
        await amplifierConfigurationHelper?.setDsManualAlignment(context, widget.dependencies.deviceId, dsManualAlignmentItem);
        await amplifierConfigurationHelper?.getDsManualAlignment(
            context,
            widget.dependencies.deviceId,
            isFromSetAPI: (isSwitchOfAuto == false),isRefreshDSSpectrum: true);
      },
      onTapSave: (DsManualAlignmentItem dsManualAlignmentItem) {
        amplifierConfigurationHelper?.saveRevertDsManualAlignment(
            context, widget.dependencies.deviceId, dsManualAlignmentItem,true);
      },
      onTapRevert: (DsManualAlignmentItem dsManualAlignmentItem) {
        amplifierConfigurationHelper?.saveRevertDsManualAlignment(
            context, widget.dependencies.deviceId, dsManualAlignmentItem,false);
      },
      onRefreshClicked: () {
        amplifierConfigurationHelper?.getDsManualAlignment(context, widget.dependencies.deviceId,isFromSetAPI: (isSwitchOfAuto == false));
      },
      buttonView: buildSwitchButtonView(),
      settingModel:amplifierConfigurationHelper!.dsAlignmentSettingModel,
      isSaveRevertDisplay: isSaveRevertUnable,
    );
  }

  Widget buildSwitchButtonView(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
         'Enable Manual Mode',
          style: TextStyle(fontStyle:   FontStyle.italic,
              fontFamily: AppAssetsConstants.openSans,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.32,
              color: AppColorConstants.colorPrimary,
              fontSize: getSize(15)),
        ),
        SizedBox(width: getSize(10)),
        CupertinoSwitch(
          activeColor: AppColorConstants.colorPrimary,
          value: !isSwitchOfAuto,
          onChanged: (onChangeValue) async {
            debugLogs("On Change Value : $onChangeValue");
            debugLogs("is Switch Auto : $isSwitchOfAuto");
            if (!onChangeValue) {
              //Auto Alignment ON

              isSwitchOfAuto = !onChangeValue;
              print("-------VALUE 1-------");
              dsAmplifierController?.update();
            }else{
              //Auto Alignment OFF
              isSwitchOfAuto = !onChangeValue;
              print("-------VALUE 2-------");
              dsAmplifierController?.update();
            }
          },
        ),
      ],
    );
  }

  saveRevertButtonOfAutoAlignWidget() {
    if(amplifierConfigurationHelper
        ?.saveRevertApiStatusOfAutoAlign.value ==
        ApiStatus.loading) {
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
            buttonColor: isSaveRevertUnable ? null : Colors.grey,
            borderColor: isSaveRevertUnable ? null : Colors.grey,
            padding: WidgetStateProperty.all(const EdgeInsets.all(12)),
            buttonName: "Save",
            fontSize: 16,
            loadingStatus: amplifierConfigurationHelper!.saveRevertApiStatusOfAutoAlign.value,
            onPressed: !isSaveRevertUnable ? null :() {
              amplifierConfigurationHelper?.saveRevertDsAutoAlignment(context, widget.dependencies.deviceId, true);
            },
            fontFamily: AppAssetsConstants.openSans,
          ),
          const SizedBox(
            width: 50,
          ),
          AppButton(
            buttonWidth: 80,
            buttonRadius: 8,
            buttonHeight: 32,
            buttonColor: isSaveRevertUnable ? null : Colors.grey,
            borderColor: isSaveRevertUnable ? null : Colors.grey,
            padding: WidgetStateProperty.all(const EdgeInsets.all(12)),
            buttonName: "Revert",
            fontSize: 16,
            loadingStatus: amplifierConfigurationHelper!.saveRevertApiStatusOfAutoAlign.value,
            onPressed: !isSaveRevertUnable ? null :() {
              amplifierConfigurationHelper?.saveRevertDsAutoAlignment(context, widget.dependencies.deviceId, false);
            },
            fontFamily: AppAssetsConstants.openSans,
          ),
        ],
      ),
    );
  }

  Future<dynamic> getDsAlignment(BuildContext context, String deviceEui) async {
    autoAlignmentInitializeTimer();
    amplifierConfigurationHelper?.downStreamAutoAlignmentError= null;
    isStartDownStream = true;

    dsAmplifierController?.update();
    try {
      int? status;
      await dsAmplifierController?.dsAutoAlignment(deviceEui: deviceEui, context: context, isStatusCheck: false)
          .then((value) async {
        if (value['body'] is DsAutoAlignmentModel) {
          DsAutoAlignmentModel model = value['body'];
          if (model.result != null) {
            status = model.result!.sampDownstreamAutoAlignStatus!.autoAlignStatus;
          }
        }else{
          debugLogs("dsAlignmentFailed--> ");
          amplifierConfigurationHelper?.downStreamAutoAlignmentError = value['body']['detail'];
          'DS alignment failed.'.showError(context);
          return;
        }
      });
      //Step 3: Check status up to 3 times
      if (status != null) {
        await Future.delayed(const Duration(seconds: 10));
        await checkDsAutoAlignmentStatus(deviceEui);
      } else if (amplifierConfigurationHelper?.downStreamAutoAlignmentError == null && status == null) {
        'DS alignment failed.'.showError(context);
      }
    } catch (e) {
      debugLogs("getDsAutoAlignment--> ${e.toString()}");
      'DS alignment failed.'.showError(context);
      amplifierConfigurationHelper?.downStreamAutoAlignmentError = 'Something went wrong';
    } finally {
      autoAlignmentGetDifferenceTime();
      isStartDownStream = false;
      dsAmplifierController?.update();
    }
  }

  void autoAlignmentInitializeTimer() {
    dsAutoAlignUpdateTime == null;
    autoAlignmentDifferenceTime = null;
    autoAlignmentOnTapTime = DateTime.now();
    autoAlignmentIsShowText = true;
    autoAlignmentRefreshTimer?.cancel();
  }

  autoAlignmentGetDifferenceTime() {
    autoAlignmentDifferenceTime = DateTime.now().difference(autoAlignmentOnTapTime!);
    autoAlignmentRefreshTimer=Timer(const Duration(seconds: 3), () {
      if (mounted) {
        autoAlignmentIsShowText = false;
        dsAmplifierController?.update();
      }
    });
  }

  Future<void> checkDsAutoAlignmentStatus(String deviceEui) async {
    const int maxAttempts = 3;
    const Duration delayBetweenAttempts = Duration(seconds: 10);
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      final response = await dsAmplifierController?.dsAutoAlignment(
        deviceEui: deviceEui,
        context: context,
        isStatusCheck: true,
      );
      if (response?['body'] is DsAutoAlignmentModel) {
        DsAutoAlignmentModel model = response?['body'];
        if (model.result != null) {
          int status = model.result!.sampDownstreamAutoAlignStatus!.autoAlignStatus;
          if (status == 3) {
            await amplifierConfigurationHelper?.getDsAutoAlignmentSpectrumData(apiUrl: apiUrl, context: context,isRefresh: true);
            isSaveRevertUnable = true;
            dsAutoAlignUpdateTime= getLastUpdateTime(response?['headers']['updated_at']);
            return; // Exit on success
          } else if (attempt == maxAttempts) {
            'DS alignment failed.'.showError(context);
            isSaveRevertUnable = false;
          }
        }
      } else {
        amplifierConfigurationHelper?.downStreamAutoAlignmentError = 'Something went wrong';
        break;
      }
      if (attempt < maxAttempts) {
        await Future.delayed(delayBetweenAttempts);
      }else{
        amplifierConfigurationHelper?.downStreamAutoAlignmentError = "Auto alignment failed.";
      }
    }
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
            differenceMessage: amplifierConfigurationHelper?.dsSpectrumDataError != null ? "The refresh failed in " : null,
          ),
        ),
        AppRefresh(
          buttonColor: AppColorConstants.colorPrimary,
          loadingStatus: amplifierConfigurationHelper?.spectrumApiStatus ?? ApiStatus.loading,
          onPressed: () {
            if (amplifierConfigurationHelper?.spectrumApiStatus != ApiStatus.loading) {
              amplifierConfigurationHelper?.getDsAutoAlignmentSpectrumData(
                  apiUrl: apiUrl, context: context, isRefresh: true);
            }
          },
          enabled: true,
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
      getTooltipItem: (BarChartGroupData group, int groupIndex, BarChartRodData rod, int rodIndex) {
        return BarTooltipItem(
          textAlign: rodIndex == 0 ? TextAlign.left : TextAlign.right,
          rod.toY == 0
              ? " "
              : (rodIndex == 0 ? rod.toY.toStringAsFixed(2).padRight(18) : rod.toY.toStringAsFixed(2).padLeft(18)),
          dependencies.tooltipTextStyle ??
              TextStyle(
                fontSize: 11,
                color: rodIndex == 0 ? AppColorConstants.colorRefChartBorder : AppColorConstants.colorLevelChartBorder,
                fontWeight: FontWeight.bold,
              ),
        );
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
            'MHz',
            style: TextStyle(color: AppColorConstants.colorH1, fontSize: 16),
          ),
          SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 11,
                    width: 12,
                    decoration: BoxDecoration(
                      color: AppColorConstants.colorRefChartBackGround,
                      border: Border.all(color: AppColorConstants.colorRefChartBackGround),
                    ),
                  ),
                ),
                const Text(
                  'Ref',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
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
                const Text(
                  'Level',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) => Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            '$value',
            style: dependencies.axisLabelTextStyle ?? TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ),
      ),
    ),
    leftTitles: AxisTitles(
      axisNameSize: 30,
      axisNameWidget: Text(
        'dBmV',
        style: TextStyle(color: AppColorConstants.colorH1, fontSize: 16),
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