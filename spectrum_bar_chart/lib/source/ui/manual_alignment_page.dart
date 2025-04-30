import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spectrum_bar_chart/constant/app_constant.dart';
import 'package:spectrum_bar_chart/source/helper/app_ui_helper.dart';
import 'package:spectrum_bar_chart/source/ui/app_button.dart';
import 'package:spectrum_bar_chart/source/ui/app_image_assets.dart';
import 'package:spectrum_bar_chart/source/ui/app_loader.dart';
import 'package:spectrum_bar_chart/source/ui/app_refresh.dart';
import 'package:spectrum_bar_chart/source/ui/app_screen_layout_type.dart';
import 'package:spectrum_bar_chart/source/ui/app_text.dart';


class ManualAlignmentPage extends StatefulWidget {

  final bool isSwitchOfAuto;
  final AppScreenLayoutType screenLayoutType;
  final Function onTapWrite;
  final Function onRefreshClicked;
  final Function onTapSave;
  final Function onTapRevert;
  final Widget buttonView;
  final bool isOffline;
  final bool isDSAlignment;
  /// Alignment Setting Model Variables ///
  final double gainValue;
  final double tiltValue;
  final TextEditingController gainTextController;
  final TextEditingController tiltTextController;
  final String gainErrorMessage;
  final String tiltErrorMessage;

  /// Ds Manual Values Model Variables ///
  final double gainMinVal;
  final double tiltMinVal;
  final double gainMaxVal;
  final double tiltMaxVal;
  final VoidCallback handleButtonPress;

  ///  AmplifierConfigurationHelper variable manage ///
  final String? manualAlignmentError;


  /// Added Variable For Api status ///
  bool manualAlignmentApiStatus;
  bool saveRevertApiStatus;

  /// Save revert Enable ///
  final bool isSaveRevertEnable;

  /// Enable increment and decrement ///
  final VoidCallback updateValue;

  ManualAlignmentPage({
    super.key,
    required this.isSwitchOfAuto,
    required this.screenLayoutType,
    required this.onTapWrite,
    required this.onRefreshClicked,
    required this.onTapSave,
    required this.onTapRevert,
    required this.isOffline,
    required this.isDSAlignment,
    required this.buttonView,

    /// Alignment Setting Model Variables ///
    required this.gainValue,
    required this.tiltValue,
    required this.gainTextController,
    required this.tiltTextController,
    required this.gainErrorMessage,
    required this.tiltErrorMessage,

    /// Ds Manual Values Model Variables ///
    this.gainMinVal = 0.0,
    this.tiltMinVal = 0.0,
    this.gainMaxVal = 0.0,
    this.tiltMaxVal = 0.0,
    required this.handleButtonPress,

    ///  AmplifierConfigurationHelper variable manage ///
    required this.manualAlignmentError,

    /// Added Variable For Api status ///
    required this.manualAlignmentApiStatus,
    required this.saveRevertApiStatus,

    /// Save revert Enable ///
    required this.isSaveRevertEnable,

    /// Enable increment and decrement ///
    required this.updateValue

  });

  @override
  State<ManualAlignmentPage> createState() => _ManualAlignmentPageState();
}

class _ManualAlignmentPageState extends State<ManualAlignmentPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (widget.manualAlignmentApiStatus == true // || widget.dsManualAlignmentItem.dsValues.isNotEmpty
        )
            ? manualAlignmentBody()
            : Container(),
        refreshingBar(),
      ],
    );
  }

  //Refreshing Top bar with Error Message and Refresh Button.
  Widget refreshingBar() {
    final String? errorMessage =
        widget.manualAlignmentError;
    bool isDesktop = widget.screenLayoutType == AppScreenLayoutType.desktop;
    return Column(
      children: [
        if (!widget.isDSAlignment && isDesktop)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (errorMessage != null && errorMessage.isNotEmpty)
                Flexible(flex: 5, child: errorMessageView(errorMessage: errorMessage))
              else
                const Spacer(),
              Flexible(flex: 1, child: buildLastSeenWithRefreshButton()),
            ],
          )
        else
          ...[
            if (errorMessage != null)
              Align(alignment: AlignmentDirectional.centerStart,
                child: errorMessageView(errorMessage: errorMessage),),
            buildLastSeenWithRefreshButton(),
          ],
      ],
    );
  }

  //Refresh Button
  buildLastSeenWithRefreshButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: buildLastSeenView(
              textColor:
              widget.manualAlignmentError == null
                  ? AppColorConstants.colorGrn
                  : AppColorConstants.colorAppbar,
              messageString:
              widget.manualAlignmentError != null
                  ? 'The refresh failed in '
                  : null),
        ),
        AppRefresh(
          buttonColor: AppColorConstants.colorPrimary,
          loadingStatus:
          widget.manualAlignmentApiStatus,
          onPressed: () => widget.onRefreshClicked(),
          enabled: widget.isOffline,
        )
      ],
    );
  }

  manualAlignmentBody() {
    return Column(
      children: [
        if (!widget.isSwitchOfAuto)
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: titleText('Amplifier Interstage Values Fine Tuning'),
          ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  if(!widget.isSwitchOfAuto) gainAndTiltSettingView(),
                  const SizedBox(height: 20,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                        EdgeInsets.only(top: (!widget.isSwitchOfAuto) ? 0 : 40),
                        child: titleText('Amplifier Interstage Values'),
                      ),
                      const SizedBox(height: 60),

/// =================================  Container Show View ===================///
                      // ctrlStageWidget(),
                      SizedBox(height: (!widget.isSwitchOfAuto) ? 20 : 60),
                      if (!widget.isSwitchOfAuto)
                        Column(
                          children: [
                            (widget.saveRevertApiStatus == true)
                                ? const SizedBox(height: 85, width: 50, child: AppLoader())
                                : saveRevertButtonWidget(),
                            saveRevertInfo()
                          ],
                        ),
                    ],
                  ),
                ],
              ),
              //if(!widget.isSwitchOfAuto) selectedInputStageWidget(),
            ],
          ),
        ),
      ],
    );
  }

  Widget gainAndTiltSettingView() {
    return Card(color: AppColorConstants.colorWhite,
      elevation: 6,
      child: Container(
        padding:  EdgeInsets.symmetric(vertical: 20, horizontal: widget.screenLayoutType==AppScreenLayoutType.mobile?10:30),
        child: Stack(alignment: Alignment.center,
          children: [
            Column(
              children: [
                const SizedBox(height: 16),
                buildControlRow(
                    "Gain (dB)",
                    widget.gainMinVal / 10,
                    widget.gainMaxVal / 10,
                    widget.gainValue,
                    true,
                    widget.gainErrorMessage),
                const SizedBox(height: 16),
                buildControlRow(
                    "Tilt (dB)",
                    widget.tiltMinVal / 10,
                    widget.tiltMaxVal / 10,
                    widget.tiltValue,
                    false,
                    widget.tiltErrorMessage),
              ],
            ),
            // if (widget.dsManualAlignmentItem.isProgressing.value) ...[
            //   Positioned.fill(
            //     child: AbsorbPointer(
            //       child: Container(
            //         color:AppColorConstants.colorTransparent,
            //         child: const SizedBox(
            //             height: 100,
            //             width: 100,
            //             child: AppLoader()), // Optional: Semi-transparent overlay
            //       ),
            //     ),
            //   ),
            // ],
          ],
        ),
      ),
    );
  }
  void updateValue(bool isGainControl, bool isIncrement) {
    if (isGainControl) {
      _updateControlValue(
        textController: widget.gainTextController,
        valueNotifier: widget.gainValue,
        errorNotifier: widget.gainErrorMessage,
        minValue: widget.gainMinVal / 10,
        maxValue: widget.gainMaxVal / 10,
        isIncrement: isIncrement,
      );
    } else {
      _updateControlValue(
        textController: widget.tiltTextController,
        valueNotifier: widget.tiltValue,
        errorNotifier: widget.tiltErrorMessage,
        minValue: widget.tiltMinVal / 10,
        maxValue: widget.tiltMaxVal / 10,
        isIncrement: isIncrement,
      );
    }
  }

  void _updateControlValue({
    required TextEditingController textController,
    required double valueNotifier,
    required String errorNotifier,
    required double minValue,
    required double maxValue,
    required bool isIncrement,
  }) {
    String inputText = textController.text.trim();

    if (inputText.isEmpty) {
      errorNotifier =
      "Value must be between ${minValue.toStringAsFixed(1)} dB and ${maxValue.toStringAsFixed(1)} dB.";
      return;
    }

    double currentValue = double.tryParse(inputText)  ?? 0.0;

    currentValue = currentValue.clamp(minValue, maxValue);

    if (isIncrement && currentValue < maxValue) {
      currentValue += 0.1;
      errorNotifier = "";
    } else if (!isIncrement && currentValue > minValue) {
      currentValue -= 0.1;
      errorNotifier = "";
    } else {
      errorNotifier =
      "Value must be between ${minValue.toStringAsFixed(1)} dB and ${maxValue.toStringAsFixed(1)} dB.";
    }

    valueNotifier = currentValue;
    textController.text = currentValue.toStringAsFixed(1);
  }

  Widget buildControlRow(String label,num minValue,num maxValue, double value, bool isGainControl , String errorMessage) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(  verticalDirection:  VerticalDirection.down,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: widget.screenLayoutType==AppScreenLayoutType.mobile?75:100,
              margin: const EdgeInsets.only(top: 5),
              child: AppText(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppAssetsConstants.openSans,
                ),
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 5),
            Row(
              verticalDirection:  VerticalDirection.down,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Minus Button
                SizedBox(
                  width: widget.screenLayoutType==AppScreenLayoutType.mobile?30:40,
                  child: Column(
                    children: [
                      AppButton(
                        buttonRadius: 0,
                        onPressed: () => widget.updateValue,
                        buttonStyle: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6), // Adjust the radius as needed
                          ),
                          padding: const EdgeInsets.all(6),
                          backgroundColor: AppColorConstants.colorChartBackGround,
                        ),
                        buttonName: "-",
                      ),
                      AppText(minValue.toStringAsFixed(1),style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppAssetsConstants.openSans,
                      ))
                    ],
                  ),
                ),

                // Value Display
                Container(
                  width:widget.screenLayoutType==AppScreenLayoutType.mobile?65:80,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColorConstants.colorH3),
                    borderRadius: const BorderRadius.all(Radius.circular(3)),
                  ),
                  child: Center(
                    child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*$')), // Allows only valid numbers
                      ],
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      controller: isGainControl ? widget.gainTextController : widget.tiltTextController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true, // Ensures compact TextField
                        contentPadding: EdgeInsets.zero, // Removes extra padding
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 40,
                  child: Column(
                    children: [
                      AppButton(
                        onPressed: () => widget.updateValue,
                        buttonStyle: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6), // Adjust the radius as needed
                          ),
                          backgroundColor: AppColorConstants.colorChartBackGround,
                          padding: const EdgeInsets.all(6),
                        ),
                        buttonName: "+",

                        fontSize: 15,
                      ),
                      AppText(maxValue.toStringAsFixed(1),style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppAssetsConstants.openSans,
                      ))
                    ],
                  ),
                ),

                // Check Button
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => widget.handleButtonPress,
                  // onPressed: () => _handleButtonPress(isGainControl),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(8),
                    backgroundColor: AppColorConstants.colorLightBlue,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
        if(errorMessage.isNotEmpty) Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: AppText(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColorConstants.colorRed,
                fontFamily: AppAssetsConstants.openSans,
                fontSize: 13),
          ),
        ),
        // Plus Button
      ],
    );
  }

  // ctrlStageWidget() {
  //   return Column(
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: [
  //           if (isVisibleManualBox(1, 1, 2, 1))
  //             displayStageTitleWidget('Input Stage'),
  //           if (isVisibleManualBox(1, 2, 2, 2)) ...[
  //             const SizedBox(width: 20),
  //             displayStageTitleWidget('Intermediate Stage')
  //           ],
  //           if (isVisibleManualBox(1, 3, 2, 3)) ...[
  //             const SizedBox(width: 20),
  //             displayStageTitleWidget('Output Stage')
  //           ],
  //         ],
  //       ),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           if (isVisibleManualBox(1, 1, 2, 1))
  //             buildAmplifierInterstageValuesView(
  //                 'Input Stage', 1, 1, 2, 1),
  //           if (isVisibleManualBox(1, 2, 2, 2)) ...[
  //             getRightArrow(),
  //             buildAmplifierInterstageValuesView(
  //                 'Intermediate Stage', 1, 2, 2, 2),
  //           ],
  //           if (isVisibleManualBox(1, 3, 2, 3)) ...[
  //             getRightArrow(),
  //             buildAmplifierInterstageValuesView(
  //                 'Output Stage', 1, 3, 2, 3),
  //           ]
  //         ],
  //       ),
  //     ],
  //   );
  // }

  saveRevertButtonWidget() {
    // bool isSaveRevertDisplay = isSaveRevertEnable();
    // Color? color = !isSaveRevertDisplay ? Colors.grey : null;
    return Padding(
      padding: const EdgeInsets.only(top: 35, bottom: 10),
      child: Wrap(
        children: [
          AppButton(
            buttonWidth: 80,
            buttonRadius: 8,
            buttonHeight: 32,
            buttonColor: widget.isSaveRevertEnable ? null : Colors.grey,
            borderColor: widget.isSaveRevertEnable ? null : Colors.grey,
            padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
            buttonName: 'Save',
            fontSize: 16,
            onPressed: !widget.isSaveRevertEnable
                ? null
                : () {
              // DsManualAlignmentItem dsManualAlignmentItem =
              // DsManualAlignmentItem([],
              //     manual_align_ctrl_type_enum: 5);
              // widget.onTapSave(dsManualAlignmentItem);
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
            buttonColor: widget.isSaveRevertEnable ? null : Colors.grey,
            borderColor: widget.isSaveRevertEnable ? null : Colors.grey,
            padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
            buttonName: 'Revert',
            fontSize: 16,
            onPressed: !widget.isSaveRevertEnable
                ? null
                : () {
              // DsManualAlignmentItem dsManualAlignmentItem =
              // DsManualAlignmentItem([],
              //     manual_align_ctrl_type_enum: 6);
              // widget.onTapRevert(dsManualAlignmentItem);
            },
            fontFamily: AppAssetsConstants.openSans,
          ),
        ],
      ),
    );
  }

  saveRevertInfo() {
    return Column(children: [
      const SizedBox(height: 5,),
      Row(
        children: [
          const Icon(Icons.info, color: Colors.grey,),
          const SizedBox(width: 5,),
          AppText(
            'Click Save to save the values permanently',
            style: TextStyle(
                fontFamily: AppAssetsConstants.openSans,
                fontWeight: getMediumBoldFontWeight(),
                letterSpacing: 0.32,
                color: Colors.grey,
                fontSize: getSize(12)),
          ),
        ],
      )
    ],);
  }

  Widget displayStageTitleWidget(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Center(
        child: AppText(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            fontFamily: AppAssetsConstants.openSans,
            color: AppColorConstants.colorH1,
          ),
        ),
      ),
    );
  }

  Widget getRightArrow() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: AppImageAsset(
        fit: BoxFit.fitWidth,
        width: 50,
        image: AppAssetsConstants.rightArrowIcon,
        color: AppColorConstants.colorH2,
      ),
    );
  }

  // Widget buildAmplifierInterstageValuesView(String title, int ctrl_type1, int stage1,
  //     int ctrl_type2, int stage2) {
  //   DSManualValues? firstManualValue = findDsManualValues(ctrl_type1, stage1);
  //   DSManualValues? secondManualValue = findDsManualValues(ctrl_type2, stage2);
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 15),
  //     child: CustomPaint(
  //       painter: DottedBorderPainter(
  //         cornerRadiusValue: 20,
  //         strokeWidth: 2.7,
  //         borderColor: AppColorConstants.colorChart,
  //       ),
  //       child: Container(
  //         padding: const EdgeInsets.all(12),
  //         decoration: BoxDecoration(
  //           color: AppColorConstants.colorBackgroundDark,
  //           borderRadius: const BorderRadius.all(Radius.circular(20)),
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.max,
  //           children: [
  //             (firstManualValue == null)
  //                 ? const SizedBox(
  //               height: 0,
  //             )
  //                 : amplifierInterstageColumnView(
  //                 getCtrlType(ctrl_type1, stage1),
  //                 getValue(firstManualValue.initialValue),
  //                 isEQUView: true,
  //                 AppAssetsConstants.attnIcon, onTap: () {
  //               final ampPageHelper = widget.amplifierConfigurationHelper.amplifierPageHelper;
  //               final index = ampPageHelper.listTabs.indexWhere((tab) =>
  //               tab.title == ampPageHelper.amplifierItem.deviceEui);
  //               ampPageHelper.listTabs[index].ampDeviceItem.mapCtrlStage = {ctrl_type1: stage1};
  //               // onSelectControl();
  //               // widget.amplifierController.update();
  //             }, isSelected: checkIsSelected(ctrl_type1, stage1)),
  //             (secondManualValue == null)
  //                 ? const SizedBox(
  //               height: 0,
  //             )
  //                 : amplifierInterstageColumnView(
  //                 getCtrlType(ctrl_type2, stage2),
  //                 getValue(secondManualValue.initialValue),
  //                 isEQUView: false,
  //                 AppAssetsConstants.equIcon, onTap: () {
  //               final ampPageHelper = widget.amplifierConfigurationHelper.amplifierPageHelper;
  //               final index = ampPageHelper.listTabs.indexWhere((tab) =>
  //               tab.title == ampPageHelper.amplifierItem.deviceEui);
  //               ampPageHelper.listTabs[index].ampDeviceItem.mapCtrlStage = {ctrl_type2: stage2};
  //               //onSelectControl();
  //               // widget.amplifierController.update();
  //             }, isSelected: checkIsSelected(ctrl_type2, stage2))
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // String getValue(double value) {
  //   return (value / widget.dsManualAlignmentItem.factor).toString();
  // }

  Widget amplifierInterstageColumnView(String title, String value, String iconImage,
      {bool? isEQUView,
        required GestureTapCallback onTap,
        required bool isSelected}) {
    print(
        "title=$title---Value--$value---isEQUView=$isEQUView---isSelected=$isSelected");
    return Column(
      children: [
        AppText(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            fontFamily: AppAssetsConstants.openSans,
            color: isEQUView!
                ? AppColorConstants.colorPrimary
                : AppColorConstants.colorLightBlue,
          ),
        ),
        const SizedBox(height: 3),
        InkWell(
          onTap: widget.isSwitchOfAuto ? null : null,
          child: Container(
            decoration: BoxDecoration(
                color: isSelected
                    ? AppColorConstants.colorGreen1
                    : isEQUView
                    ? AppColorConstants.colorLightPurple
                    : AppColorConstants.colorChartLine1,
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            height: 50,
            width: 50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppImageAsset(image: iconImage),
            ),
          ),
        ),
        const SizedBox(height: 3),
        AppText(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            fontFamily: AppAssetsConstants.openSans,
            color: isEQUView
                ? AppColorConstants.colorPrimary
                : AppColorConstants.colorLightBlue,
          ),
        ),
      ],
    );
  }

  // bool isVisibleManualBox(int ctrlType1, int stage1, int ctrlType2, int stage2) {
  //   // Find the matching DSManualValues based on ctrlType1 and stage1
  //   DSManualValues dsManualValuesNew1 = widget.dsManualAlignmentItem.dsValues
  //       .singleWhere(
  //           (element) =>
  //       (element.ctrlType == ctrlType1 && element.stage == stage1),
  //       orElse: () =>
  //           DSManualValues
  //               .empty() // Ensure this returns an instance of DSManualValues
  //   );
  //
  //   // Find the matching DSManualValues based on ctrlType2 and stage2
  //   DSManualValues dsManualValuesNew2 = widget.dsManualAlignmentItem.dsValues
  //       .singleWhere(
  //           (element) =>
  //       (element.ctrlType == ctrlType2 && element.stage == stage2),
  //       orElse: () =>
  //           DSManualValues
  //               .empty() // Ensure this returns an instance of DSManualValues
  //   );
  //
  //   // Determine visibility based on maxVal and minVal for both sets of values
  //   bool isVisible1 =
  //   !(dsManualValuesNew1.maxVal == 0 && dsManualValuesNew1.minVal == 0);
  //   bool isVisible2 =
  //   !(dsManualValuesNew2.maxVal == 0 && dsManualValuesNew2.minVal == 0);
  //
  //   // Return true if either condition is met
  //   return isVisible1 || isVisible2;
  // }

  // DSManualValues? findDsManualValues(int ctrlType, int stage) {
  //   DSManualValues dsManualValuesNew = widget.dsManualAlignmentItem.dsValues
  //       .singleWhere(
  //           (element) =>
  //       (element.ctrlType == ctrlType && element.stage == stage),
  //       orElse: DSManualValues.empty);
  //   return (dsManualValuesNew.maxVal == 0 && dsManualValuesNew.minVal == 0)
  //       ? null
  //       : dsManualValuesNew;
  // }

  // bool checkIsSelected(int type, int stage) {
  //   return widget.dsManualAlignmentItem.dsValues
  //       .singleWhere(
  //           (element) =>
  //       (element.ctrlType == type && element.stage == stage),
  //       orElse: DSManualValues.empty)
  //       .isSelected;
  // }

  titleText(String title) {
    return AppText(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontFamily: AppAssetsConstants.openSans,
          fontWeight: getMediumBoldFontWeight(),
          letterSpacing: 0.32,
          color: AppColorConstants.colorLightBlue,
          fontSize: getSize(18)),
    );
  }

  String getCtrlType(int type, int stage) {
    return "${(type == 1) ? 'ATTN-' : (type == 2) ? 'EQ-' : "-"}$stage";
  }

  String getSelectedCtrlType(int type, int stage) {
    return "${(type == 1) ? 'ATTN' : (type == 2) ? 'EQ' : "-"}$stage";
  }

  String getSelectedStageName(int stage) {
    log("--Stage == $stage");
    return (stage == 1)
        ? 'Input Stage'
        : (stage == 2)
        ? 'Intermediate Stage'
        : (stage == 3)
        ? 'Output Stage'
        : "";
  }
}