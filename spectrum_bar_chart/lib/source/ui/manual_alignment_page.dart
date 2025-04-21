import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spectrum_bar_chart/source/constant/app_constant.dart';
import 'package:spectrum_bar_chart/source/controller/ds_amplifier_controller.dart';
import 'package:spectrum_bar_chart/source/helper/app_ui_helper.dart';
import 'package:spectrum_bar_chart/source/helper/enum_helper.dart';
import 'package:spectrum_bar_chart/source/helper/rest_helper.dart';
import 'package:spectrum_bar_chart/source/model/alignment_setting_model.dart';
import 'package:spectrum_bar_chart/source/pages/AmplifierConfigurationHelper.dart';
import 'package:spectrum_bar_chart/source/serialized/amplifier/amplifier.dart';
import 'package:spectrum_bar_chart/source/ui/app_button.dart';
import 'package:spectrum_bar_chart/source/ui/app_image_assets.dart';
import 'package:spectrum_bar_chart/source/ui/app_loader.dart';
import 'package:spectrum_bar_chart/source/ui/app_refresh.dart';
import 'package:spectrum_bar_chart/source/ui/app_screen_layout.dart';
import 'package:spectrum_bar_chart/source/ui/custom_error_view.dart';


class ManualAlignmentPage extends StatefulWidget {
  final bool isSwitchOfAuto;
  final ScreenLayoutType screenLayoutType;

  final DsAmplifierController dsAmplifierController;
  final AmplifierConfigurationHelper amplifierConfigurationHelper;
  final DsManualAlignmentItem dsManualAlignmentItem;
  final AlignmentSettingModel settingModel;

  final Function onTapWrite;
  final Function onRefreshClicked;
  final Function onTapSave;
  final Function onTapRevert;
  final Widget buttonView;
  final bool isOffline;

  final bool isDSAlignment;
  final bool isSaveRevertDisplay;

  const ManualAlignmentPage({
    super.key,
    required this.isSwitchOfAuto,
    required this.screenLayoutType,
    required this.dsAmplifierController,
    required this.amplifierConfigurationHelper,
    required this.dsManualAlignmentItem,
    required this.onTapWrite,
    required this.onRefreshClicked,
    required this.onTapSave,
    required this.onTapRevert,
    required this.isOffline,
    required this.isDSAlignment,
    required this.buttonView,
    required this.settingModel,
    required this.isSaveRevertDisplay
  });

  @override
  State<ManualAlignmentPage> createState() => _ManualAlignmentPageState();
}

class _ManualAlignmentPageState extends State<ManualAlignmentPage> {
  AlignmentSettingModel settingModel = AlignmentSettingModel.empty();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    settingModel = widget.settingModel;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: getSize(10), horizontal:widget.screenLayoutType==ScreenLayoutType.mobile?0: getSize(20)),
      decoration: borderViewDecoration,
      child: Column(
        children: [
          (widget.amplifierConfigurationHelper.manualAlignmentApiStatus ==
              ApiStatus.success || widget.dsManualAlignmentItem.dsValues.isNotEmpty)
              ? manualAlignmentBody()
              : Container(),
          refreshingBar(),
        ],
      ),
    );
  }

  //Refreshing Top bar with Error Message and Refresh Button.
  Widget refreshingBar() {
    final String? errorMessage =
        widget.amplifierConfigurationHelper.manualAlignmentError;
    bool isDesktop = widget.screenLayoutType == ScreenLayoutType.desktop;
    return Column(
      children: [
        if (!widget.isDSAlignment && isDesktop)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (errorMessage != null)
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
              isShow: widget
                  .amplifierConfigurationHelper.isShowTextOfManualAlignment,
              difference: widget
                  .amplifierConfigurationHelper.differenceTimeOfManualAlignment,
              onTapTime: widget
                  .amplifierConfigurationHelper.onTapTimeOfManualAlignment,
              apiStatus:
              widget.amplifierConfigurationHelper.manualAlignmentApiStatus,
              updateTime:
              widget.amplifierConfigurationHelper.manualAlignmentUpdateTime,
              textColor:
              widget.amplifierConfigurationHelper.manualAlignmentError ==
                  null
                  ? AppColorConstants.colorGrn
                  : AppColorConstants.colorAppbar,
              differenceMessage:
              widget.amplifierConfigurationHelper.manualAlignmentError !=
                  null
                  ? "The refresh failed in" : null),
        ),
        AppRefresh(
          buttonColor: AppColorConstants.colorPrimary,
          loadingStatus:
          widget.amplifierConfigurationHelper.manualAlignmentApiStatus,
          onPressed: () => widget.onRefreshClicked(),
          enabled: widget.isOffline,
        )
      ],
    );
  }

  manualAlignmentBody() {
    return Column(
      children: [
        widget.buttonView,
        if (!widget.isSwitchOfAuto)
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: titleText(
              "Amplifier Interstage Values Fine Tuning",
            ),
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
                        child: titleText(
                          "Amplifier Interstage Values",
                        ),
                      ),
                      const SizedBox(height: 60),
                      ctrlStageWidget(),
                      SizedBox(height: (!widget.isSwitchOfAuto) ? 20 : 60),
                      if (!widget.isSwitchOfAuto)
                        Obx(() {
                          return Column(
                            children: [
                              (widget.amplifierConfigurationHelper
                                  .saveRevertApiStatus.value ==
                                  ApiStatus.loading)
                                  ? const SizedBox(
                                  height: 85, width: 50, child: AppLoader())
                                  : saveRevertButtonWidget(),
                              saveRevertInfo()
                            ],
                          );
                        }),
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
    return Obx(() {
      return Card(color: AppColorConstants.colorWhite,
        elevation: 6,
        child: Container(
          padding:  EdgeInsets.symmetric(vertical: 20, horizontal: widget.screenLayoutType==ScreenLayoutType.mobile?10:30),
          child: Stack(alignment: Alignment.center,
            children: [
              Column(
                children: [
                  const SizedBox(height: 16),
                  buildControlRow(
                      "Gain (dB)",
                      settingModel.gainDbValues.minVal / 10,
                      settingModel.gainDbValues.maxVal / 10,
                      settingModel.gainValue.value,
                      true,
                      settingModel.gainErrorMessage),
                  const SizedBox(height: 16),
                  buildControlRow(
                      "Tilt (dB)",
                      settingModel.tiltDbValues.minVal / 10,
                      settingModel.tiltDbValues.maxVal / 10,
                      settingModel.tiltValue.value,
                      false,
                      settingModel.tiltErrorMessage),
                ],
              ),
              if (widget.dsManualAlignmentItem.isProgressing.value) ...[
                Positioned.fill(
                  child: AbsorbPointer(
                    child: Container(
                      color:AppColorConstants.colorTransparent,
                      child: const SizedBox(
                          height: 100,
                          width: 100,
                          child: AppLoader()), // Optional: Semi-transparent overlay
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
  void updateValue(bool isGainControl, bool isIncrement) {
    if (isGainControl) {
      _updateControlValue(
        textController: settingModel.gainTextController,
        valueNotifier: settingModel.gainValue,
        errorNotifier: settingModel.gainErrorMessage,
        minValue: settingModel.gainDbValues.minVal / 10,
        maxValue: settingModel.gainDbValues.maxVal / 10,
        isIncrement: isIncrement,
      );
    } else {
      _updateControlValue(
        textController: settingModel.tiltTextController,
        valueNotifier: settingModel.tiltValue,
        errorNotifier: settingModel.tiltErrorMessage,
        minValue: settingModel.tiltDbValues.minVal / 10,
        maxValue: settingModel.tiltDbValues.maxVal / 10,
        isIncrement: isIncrement,
      );
    }
  }

  void _updateControlValue({
    required TextEditingController textController,
    required RxDouble valueNotifier,
    required RxString errorNotifier,
    required double minValue,
    required double maxValue,
    required bool isIncrement,
  }) {
    String inputText = textController.text.trim();

    if (inputText.isEmpty) {
      errorNotifier.value =
      "Value must be between ${minValue.toStringAsFixed(1)} dB and ${maxValue.toStringAsFixed(1)} dB.";
      return;
    }

    double currentValue = double.tryParse(inputText)  ?? 0.0;

    currentValue = currentValue.clamp(minValue, maxValue);

    if (isIncrement && currentValue < maxValue) {
      currentValue += 0.1;
      errorNotifier.value = "";
    } else if (!isIncrement && currentValue > minValue) {
      currentValue -= 0.1;
      errorNotifier.value = "";
    } else {
      errorNotifier.value =
      "Value must be between ${minValue.toStringAsFixed(1)} dB and ${maxValue.toStringAsFixed(1)} dB.";
    }

    valueNotifier.value = currentValue;
    textController.text = currentValue.toStringAsFixed(1);
  }

  Widget buildControlRow(String label,num minValue,num maxValue, double value, bool isGainControl , RxString errorMessage) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(  verticalDirection:  VerticalDirection.down,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: widget.screenLayoutType==ScreenLayoutType.mobile?75:100,
              margin: const EdgeInsets.only(top: 5),
              child: Text(
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
                  width: widget.screenLayoutType==ScreenLayoutType.mobile?30:40,
                  child: Column(
                    children: [
                      AppButton(
                        buttonRadius: 0,
                        onPressed: () => updateValue(isGainControl, false),
                        buttonStyle: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6), // Adjust the radius as needed
                          ),
                          padding: const EdgeInsets.all(6),
                          backgroundColor: AppColorConstants.colorChartBackGround,
                        ),
                        buttonName: "-",
                      ),
                      Text(minValue.toStringAsFixed(1),style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppAssetsConstants.openSans,
                      ))
                    ],
                  ),
                ),

                // Value Display
                Container(
                  width:widget.screenLayoutType==ScreenLayoutType.mobile?65:80,
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
                      controller: isGainControl ? settingModel.gainTextController : settingModel.tiltTextController,
                      /*onChanged: (value) {
                        if(isGainControl){
                          settingModel.gainValue.value = double.parse(value);
                        }else{
                          settingModel.tiltValue.value = double.parse(value);
                        }
                      },*/
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
                        onPressed: () => updateValue(isGainControl, true),
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
                      Text(maxValue.toStringAsFixed(1),style: const TextStyle(
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
                  onPressed: () => _handleButtonPress(isGainControl),
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
        if(errorMessage.value.isNotEmpty) Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Text(
            errorMessage.value,
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

  void _handleButtonPress(bool isGainControl) {
    var controller = isGainControl ? settingModel.gainTextController : settingModel.tiltTextController;
    var errorNotifier = isGainControl ? settingModel.gainErrorMessage : settingModel.tiltErrorMessage;
    var dbValues = isGainControl ? settingModel.gainDbValues : settingModel.tiltDbValues;
    var controlType = isGainControl ? 1 : 2; // 1 for Gain, 2 for Tilt

    double maxValue = dbValues.maxVal / 10;
    double minValue = dbValues.minVal / 10;
    double oldValue = dbValues.value / 10;

    String inputText = controller.text.trim();

    if (inputText.isEmpty) {
      errorNotifier.value =
      "Value must be between ${minValue.toStringAsFixed(1)} dB and ${maxValue.toStringAsFixed(1)} dB.";
      return;
    }

    double? parsedValue = double.tryParse(inputText);
    if (parsedValue == null || parsedValue < minValue || parsedValue > maxValue) {
      errorNotifier.value =
      "Value must be between ${minValue.toStringAsFixed(1)} dB and ${maxValue.toStringAsFixed(1)} dB.";
      return;
    } else if (oldValue >= minValue &&
        (parsedValue > (oldValue) + 3 || parsedValue < (oldValue) - 3)) {
      errorNotifier.value =
      "Address the risk of adjusting the Gain (+/-3 db)  \n- it could put the amplifier offline.";
      return;
    }

    errorNotifier.value = "";
    widget.dsManualAlignmentItem.isProgressing.value = true;
    dbValues.ctrlType = controlType;
    dbValues.dirty = true;
    dbValues.value = (parsedValue * 10).roundToDouble();

    // Create and send the DsManualAlignmentItem
    DsManualAlignmentItem dsManualAlignmentItem = DsManualAlignmentItem([dbValues]);
    widget.onTapWrite(dsManualAlignmentItem);
  }

  ctrlStageWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (isVisibleManualBox(1, 1, 2, 1))
              displayStageTitleWidget("Input Stage"),
            if (isVisibleManualBox(1, 2, 2, 2)) ...[
              const SizedBox(width: 20),
              displayStageTitleWidget("Intermediate Stage")
            ],
            if (isVisibleManualBox(1, 3, 2, 3)) ...[
              const SizedBox(width: 20),
              displayStageTitleWidget('Output Stage')
            ],
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isVisibleManualBox(1, 1, 2, 1))
              buildAmplifierInterstageValuesView('Input Stage', 1, 1, 2, 1),
            if (isVisibleManualBox(1, 2, 2, 2)) ...[
              getRightArrow(),
              buildAmplifierInterstageValuesView('Intermediate Stage', 1, 2, 2, 2),
            ],
            if (isVisibleManualBox(1, 3, 2, 3)) ...[
              getRightArrow(),
              buildAmplifierInterstageValuesView('Output Stage', 1, 3, 2, 3),
            ]
          ],
        ),
      ],
    );
  }

  saveRevertButtonWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 35, bottom: 10),
      child: Wrap(
        children: [
          AppButton(
            buttonWidth: 80,
            buttonRadius: 8,
            buttonHeight: 32,
            buttonColor: widget.isSaveRevertDisplay ? null : Colors.grey,
            borderColor: widget.isSaveRevertDisplay ? null : Colors.grey,
            padding: WidgetStateProperty.all(const EdgeInsets.all(12)),
            buttonName: 'Save',
            fontSize: 16,
            onPressed: !widget.isSaveRevertDisplay
                ? null
                : () {
              DsManualAlignmentItem dsManualAlignmentItem =
              DsManualAlignmentItem([],
                  manual_align_ctrl_type_enum: 5);
              widget.onTapSave(dsManualAlignmentItem);
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
            buttonColor: widget.isSaveRevertDisplay ? null : Colors.grey,
            borderColor: widget.isSaveRevertDisplay ? null : Colors.grey,
            padding: WidgetStateProperty.all(const EdgeInsets.all(12)),
            buttonName: 'Revert',
            fontSize: 16,
            onPressed: !widget.isSaveRevertDisplay
                ? null
                : () {
              DsManualAlignmentItem dsManualAlignmentItem =
              DsManualAlignmentItem([],
                  manual_align_ctrl_type_enum: 6);
              widget.onTapRevert(dsManualAlignmentItem);
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
          Text(
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
        child: Text(
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

  Widget buildAmplifierInterstageValuesView(String title, int ctrl_type1, int stage1,
      int ctrl_type2, int stage2) {
    DSManualValues? firstManualValue = findDsManualValues(ctrl_type1, stage1);
    DSManualValues? secondManualValue = findDsManualValues(ctrl_type2, stage2);
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: CustomPaint(
        painter: DottedBorderPainter(
          cornerRadiusValue: 20,
          strokeWidth: 2.7,
          borderColor: AppColorConstants.colorChart,
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColorConstants.colorBackgroundDark,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              (firstManualValue == null)
                  ? const SizedBox(
                height: 0,
              )
                  : amplifierInterstageColumnView(
                  getCtrlType(ctrl_type1, stage1),
                  getValue(firstManualValue.initialValue),
                  isEQUView: true,
                  AppAssetsConstants.attnIcon, onTap: () {
                // onSelectControl();
                // widget.amplifierController.update();
              }, isSelected: checkIsSelected(ctrl_type1, stage1)),
              (secondManualValue == null)
                  ? const SizedBox(
                height: 0,
              )
                  : amplifierInterstageColumnView(
                  getCtrlType(ctrl_type2, stage2),
                  getValue(secondManualValue.initialValue),
                  isEQUView: false,
                  AppAssetsConstants.equIcon, onTap: () {

                //onSelectControl();
                // widget.amplifierController.update();
              }, isSelected: checkIsSelected(ctrl_type2, stage2))
            ],
          ),
        ),
      ),
    );
  }

  String getValue(double value) {
    return (value / widget.dsManualAlignmentItem.factor).toString();
  }


  Widget amplifierInterstageColumnView(String title, String value, String iconImage,
      {bool? isEQUView,
        required GestureTapCallback onTap,
        required bool isSelected}) {
    debugLogs(
        "title=$title---Value--$value---isEQUView=$isEQUView---isSelected=$isSelected");
    return Column(
      children: [
        Text(
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
        Text(
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

  selectedInputStageWidget() {
    DSManualValues dsManualValues = getSelectedManualValue();
    debugLogs("------Step 1 ------selectedInputStageWidget - ${dsManualValues.maxVal}");
    if (dsManualValues.minVal == 0 && dsManualValues.maxVal == 0) {
      return Container();
    }
    if (dsManualValues.minVal > dsManualValues.value) {
      dsManualValues.value = dsManualValues.minVal;
    }
    if (dsManualValues.maxVal < dsManualValues.value) {
      dsManualValues.value = dsManualValues.maxVal;
    }

    double value = double.parse(getValue(dsManualValues.value));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Container(
              width: 200,
              alignment: Alignment.center,
              child: Text(
                getSelectedStageName(dsManualValues.stage),
                style: TextStyle(
                    fontFamily: AppAssetsConstants.openSans,
                    fontWeight: getMediumBoldFontWeight(),
                    letterSpacing: 0.32,
                    color: AppColorConstants.colorLightBlue,
                    fontSize: getSize(18)),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Obx(() {
            return commonSliderView(
              controller:
              TextEditingController(text: value.toString()),
              onChangedSlider: (value) {
                var newValue =
                    value.toInt() * widget.dsManualAlignmentItem.factor;
                dsManualValues.value = newValue.toDouble();
                widget.dsAmplifierController.update();
              },
              isProgressing: false,
              title: getSelectedCtrlType(
                  dsManualValues.ctrlType, dsManualValues.stage),
              min: double.parse(getValue(dsManualValues.minVal)),
              max: double.parse(getValue(dsManualValues.maxVal)),
              indicatorValue: value,
              onPressed: () {
                DsManualAlignmentItem dsManualAlignmentItem =
                DsManualAlignmentItem([dsManualValues]);
                dsManualValues.dirty = true;
                widget.onTapWrite(dsManualAlignmentItem);
              },
              onChanged: (value) {
                dsManualValues.value = double.parse(value) * widget.dsManualAlignmentItem.factor;
                widget.dsAmplifierController.update();
              },
            );
          }),
        ],
      ),
    );
  }

  Widget commonSliderView({
    required String title,
    required double min,
    required double max,
    required double indicatorValue,
    required ValueChanged<double> onChangedSlider,
    required VoidCallback onPressed,
    required bool isProgressing,
    required TextEditingController controller,
    required ValueChanged<String>? onChanged,
  }) {
    final formKey = GlobalKey<FormState>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0).copyWith(bottom: 20),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
                fontFamily: AppAssetsConstants.openSans,
                fontSize: 15,
                fontWeight: FontWeight.w500),
          ),
          Text('[$max]',
              style: const TextStyle(
                  fontFamily: AppAssetsConstants.openSans,
                  fontSize: 14,
                  fontWeight: FontWeight.w400)),
          SizedBox(
            height: 250,
            child: RotatedBox(
              quarterTurns: 3,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                    trackHeight: 7,
                    disabledThumbColor: AppColorConstants.colorLimeGray,
                    thumbColor: AppColorConstants.colorWhite,
                    overlayColor: AppColorConstants.colorLightBlue,
                    thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 6.5),
                    overlayShape:
                    const RoundSliderOverlayShape(overlayRadius: 13),
                    showValueIndicator: ShowValueIndicator.onlyForContinuous),
                child: Slider(
                  inactiveColor: AppColorConstants.colorLimeGray,
                  value: indicatorValue,
                  max: max,
                  min: min,
                  onChanged: onChangedSlider,
                ),
              ),
            ),
          ),
          Text("[$min]",
              style: TextStyle(
                  fontFamily: AppAssetsConstants.openSans,
                  fontSize: 14,
                  color: AppColorConstants.colorBlackBlue,
                  fontWeight: FontWeight.w400)),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints:
            const BoxConstraints(minHeight: 40, maxHeight: 60, maxWidth: 60),
            child: Form(
              key: formKey,
              child: TextFormField(
                controller: controller,
                maxLines: 1,
                style: const TextStyle(fontSize: 12),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  helperText: "",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: BorderSide(color: AppColorConstants.colorH2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide:
                    BorderSide(color: AppColorConstants.colorPrimary),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: BorderSide(color: AppColorConstants.colorH2),
                  ),
                ),
                textAlign: TextAlign.center,
                onTapOutside: (value) {
                  double dValue = num.parse(controller.text).toDouble();
                  if (dValue <= max && dValue >= min) {
                    onChanged!(controller.text);
                  }
                },
                validator: (value) {
                  if (value == null) return null;
                  double dValue = num.parse(value).toDouble();
                  if (dValue > max || dValue < min) {
                    return "";
                  }
                  return null;
                },
                onChanged: (value) {
                  if (formKey.currentState!.validate()) {
                    double dValue = num.parse(value).toDouble();
                    if (dValue > max || dValue < min) {
                      value = min.toString();
                      // controller.text = value;
                    }
                  }
                },
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ),
          const SizedBox(height: 30),
          (isProgressing)
              ? const SizedBox(height: 40, width: 50, child: AppLoader())
              : AppButton(
            buttonWidth: 60,
            buttonRadius: 8,
            buttonHeight: 32,
            padding: WidgetStateProperty.all(const EdgeInsets.all(12)),
            buttonName: 'Write',
            fontSize: 16,
            onPressed: onPressed,
            fontFamily: AppAssetsConstants.openSans,
          ),
        ],
      ),
    );
  }

  getSelectedManualValue() {
    return widget.dsManualAlignmentItem.dsValues.singleWhere(
            (element) => element.isSelected == true,
        orElse: DSManualValues.empty);
  }

  bool isVisibleManualBox(int ctrlType1, int stage1, int ctrlType2, int stage2) {
    // Find the matching DSManualValues based on ctrlType1 and stage1
    DSManualValues dsManualValuesNew1 = widget.dsManualAlignmentItem.dsValues
        .singleWhere(
            (element) =>
        (element.ctrlType == ctrlType1 && element.stage == stage1),
        orElse: () =>
            DSManualValues
                .empty() // Ensure this returns an instance of DSManualValues
    );

    // Find the matching DSManualValues based on ctrlType2 and stage2
    DSManualValues dsManualValuesNew2 = widget.dsManualAlignmentItem.dsValues
        .singleWhere(
            (element) =>
        (element.ctrlType == ctrlType2 && element.stage == stage2),
        orElse: () =>
            DSManualValues
                .empty() // Ensure this returns an instance of DSManualValues
    );

    // Determine visibility based on maxVal and minVal for both sets of values
    bool isVisible1 =
    !(dsManualValuesNew1.maxVal == 0 && dsManualValuesNew1.minVal == 0);
    bool isVisible2 =
    !(dsManualValuesNew2.maxVal == 0 && dsManualValuesNew2.minVal == 0);

    // Return true if either condition is met
    return isVisible1 || isVisible2;
  }

  DSManualValues? findDsManualValues(int ctrlType, int stage) {
    DSManualValues dsManualValuesNew = widget.dsManualAlignmentItem.dsValues
        .singleWhere(
            (element) =>
        (element.ctrlType == ctrlType && element.stage == stage),
        orElse: DSManualValues.empty);
    return (dsManualValuesNew.maxVal == 0 && dsManualValuesNew.minVal == 0)
        ? null
        : dsManualValuesNew;
  }

  bool checkIsSelected(int type, int stage) {
    return widget.dsManualAlignmentItem.dsValues
        .singleWhere(
            (element) =>
        (element.ctrlType == type && element.stage == stage),
        orElse: DSManualValues.empty)
        .isSelected;
  }

  titleText(String title) {
    return Text(
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

  bool isManual() {
    return !widget.isSwitchOfAuto;
  }

  String getCtrlType(int type, int stage) {
    return "${(type == 1) ? 'ATTN-' : (type == 2) ? 'EQ-' : "-"}$stage";
  }

  String getSelectedCtrlType(int type, int stage) {
    return "${(type == 1) ? 'ATTN' : (type == 2) ? 'EQ' : "-"}$stage";
  }

  String getSelectedStageName(int stage) {
    debugLogs("--Stage == $stage");
    return (stage == 1)
        ? 'Input Stage'
        : (stage == 2)
        ? 'Intermediate Stage'
        : (stage == 3)
        ? 'Output Stage'
        : "";
  }
}