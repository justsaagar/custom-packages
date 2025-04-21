import 'package:spectrum_bar_chart/app_import.dart';


class AlignmentSettingModel {
  RxDouble gainValue;
  RxDouble tiltValue;
  TextEditingController gainTextController;
  TextEditingController tiltTextController;
  RxString gainErrorMessage;
  RxString tiltErrorMessage;
  DSManualValues gainDbValues;
  DSManualValues tiltDbValues;

  AlignmentSettingModel({
    required this.gainValue,
    required this.tiltValue,
    required this.gainTextController,
    required this.tiltTextController,
    required this.gainErrorMessage,
    required this.tiltErrorMessage,
    required this.gainDbValues,
    required this.tiltDbValues,
  });

  factory AlignmentSettingModel.empty() {
    return AlignmentSettingModel(
      gainValue: 0.0.obs,
      tiltValue: 0.0.obs,
      gainTextController: TextEditingController(),
      tiltTextController: TextEditingController(),
      gainErrorMessage: ''.obs,
      tiltErrorMessage: ''.obs,
      gainDbValues: DSManualValues.empty(),
      tiltDbValues: DSManualValues.empty(),
    );
  }
}