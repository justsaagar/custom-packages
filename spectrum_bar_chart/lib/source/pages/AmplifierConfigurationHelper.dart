
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:spectrum_bar_chart/source/controller/ds_amplifier_controller.dart';
import 'package:spectrum_bar_chart/source/helper/date_helper.dart';
import 'package:spectrum_bar_chart/source/helper/enum_helper.dart';
import 'package:spectrum_bar_chart/source/helper/rest_helper.dart';
import 'package:spectrum_bar_chart/source/model/alignment_setting_model.dart';
import 'package:spectrum_bar_chart/source/pages/amp_ds_alignment.dart';
import 'package:spectrum_bar_chart/source/serialized/amplifier/amplifier.dart';
import 'package:spectrum_bar_chart/source/serialized/amplifier_configuration/amplifier_configuration.dart';
import 'package:spectrum_bar_chart/source/ui/app_toast.dart';

class AmplifierConfigurationHelper{
  AmpDsAlignmentState state;
  ApiStatus spectrumApiStatus = ApiStatus.initial;
  List<DSPointData> dsSpectrumDataPoints = [];
  String? dsSpectrumDataError;
  DateTime? dsSpectrumOnTapTime;
  Duration ? dsSpectrumDifferenceTime;
  bool dsSpectrumIsShowText = true;
  /// THis Date TIme USing Model
  DateTime? dsSpectrumUpdateTime;
  dynamic downStreamAutoAlignmentError;
  Timer? dsSpectrumRefreshTimer;
  Rx<ApiStatus> saveRevertApiStatusOfAutoAlign = ApiStatus.initial.obs;
  ApiStatus autoAlignmentApiStatus = ApiStatus.initial;
  DsAutoAlignmentModel dsAutoAlignmentModel = DsAutoAlignmentModel.empty();


  /// THis AllVariables For Manual Alignment set Right Side View ///
  ApiStatus manualAlignmentApiStatus = ApiStatus.initial;
  String? manualAlignmentError;
  bool isShowTextOfManualAlignment = true;
  Duration ? differenceTimeOfManualAlignment;
  DateTime? onTapTimeOfManualAlignment;
  DateTime? manualAlignmentUpdateTime;
  Rx<ApiStatus> saveRevertApiStatus = ApiStatus.initial.obs;
  DsManualAlignmentItem dsManualAlignmentItem = DsManualAlignmentItem.empty();
  AlignmentSettingModel dsAlignmentSettingModel = AlignmentSettingModel.empty();
  Timer? refreshTimerOfManualAlignment;



  AmplifierConfigurationHelper(this.state) {
    SchedulerBinding.instance.addPostFrameCallback(
          (timeStamp) async {
            state.dsAmplifierController = Get.put(DsAmplifierController());
      },
    );
  }

  void dsSpectrumInitializeTimer(DateTime? dsSpectrumUpdateTime) {
    dsSpectrumUpdateTime == null;
    dsSpectrumDifferenceTime = null;
    dsSpectrumOnTapTime = DateTime.now();
    dsSpectrumIsShowText = true;
    dsSpectrumRefreshTimer?.cancel();
  }

  dsSpectrumGetDifferenceTime() {
    dsSpectrumDifferenceTime = DateTime.now().difference(dsSpectrumOnTapTime!);
    dsSpectrumRefreshTimer=Timer(const Duration(seconds: 3), () {
      dsSpectrumIsShowText = false;
      state.dsAmplifierController?.update();
    });
  }
  /// User Pass Url and header so call api and get Data in chart....  ////
  Future<dynamic> getDsAutoAlignmentSpectrumData({
    required String apiUrl,
    Map<String, String>? customHeaders,
    Map<String, String>? body,
    required BuildContext context,
    bool isRefresh = false
  }) async {
    dsSpectrumInitializeTimer(dsSpectrumUpdateTime);
    dsSpectrumDataError = null;
    downStreamAutoAlignmentError= null;
    spectrumApiStatus = ApiStatus.loading;
    state.dsAmplifierController?.update();
    try {
      await state.dsAmplifierController
          ?.dsAutoAlignmentSpectrumData(
        apiUrl: apiUrl,
        context: context,
        isRefresh: isRefresh,
        customHeaders: customHeaders,
        body: body,
      ).then(
        (value) {
          if (value['body'] is DSAutoAlignSpectrum) {
            if (value['body'].result != null) {
              DSAutoAlignSpectrumItem dsAutoAlignSpectrumItem = value['body'].result;
              dsSpectrumDataPoints = parseSpectrumData(dsAutoAlignSpectrumItem);
              spectrumApiStatus = ApiStatus.success;
            } else {
              spectrumApiStatus = ApiStatus.failed;
              dsSpectrumDataError= "${value['body'].message}";
              return;
            }
          } else {
            spectrumApiStatus = ApiStatus.failed;
            dsSpectrumDataError = value['body']['detail'];
          }
          dsSpectrumUpdateTime = getLastUpdateTime(value['headers']['updated_at']);
        },
      );
      return dsSpectrumDataPoints;
    } catch (e) {
      debugLogs("fetchChartDataWithRestHelper error--> $e");
      spectrumApiStatus = ApiStatus.failed;
      dsSpectrumDataError= "Fetch Data Error";
    }finally{
      dsSpectrumGetDifferenceTime();
      state.dsAmplifierController?.update();
    }
  }

  //GET DS Manual ALIGNMENT
  Future<dynamic> getDsManualAlignment(
      BuildContext context, String deviceEui,{bool isFromSetAPI = false, bool isRefreshDSSpectrum = false}) async {
    try {
      if(manualAlignmentApiStatus == ApiStatus.loading) return;
      manualAlignmentApiStatus = ApiStatus.loading;
      initializeManualConfiguration();
      state.dsAmplifierController?.update();
      await state.dsAmplifierController
          ?.dsManualAlignment(deviceEui: deviceEui, context: context)
          .then((value) async {
        print("---Value===${value.toString()}");
        if (value['body'] is DsManualAlignmentModel) {
          if (value['body'].result != null) {
            dsManualAlignmentItem = value['body'].result;
            if (dsManualAlignmentItem.dsValues.isNotEmpty) {
              // if (isFromSetAPI) updateSetAPIValue(dsManualAlignmentItem, index);
              if (isRefreshDSSpectrum) {
                getDsAutoAlignmentSpectrumData(apiUrl: state.apiUrl, context: context,isRefresh: true);
              }
            }
            dsAlignmentSettingModel = getInitializeDBValue(
                alignmentSettingModel: dsAlignmentSettingModel,
                manualAlignmentItem: dsManualAlignmentItem);
            manualAlignmentApiStatus = ApiStatus.success;
          } else {
            manualAlignmentApiStatus = ApiStatus.failed;
            manualAlignmentError = 'Something went wrong';
          }
        } else {
          manualAlignmentApiStatus = ApiStatus.failed;
          manualAlignmentError = value['body']['detail'];
        }
        manualAlignmentUpdateTime = getLastUpdateTime(value['headers']['updated_at']);
      });
    } catch (e) {
      debugLogs("getDsManualAlignment error--> $e");
      manualAlignmentApiStatus = ApiStatus.failed;
      manualAlignmentError = 'Something went wrong';
    } finally {
      dsManualAlignmentItem.isProgressing.value = false;
      differenceTimeOfManualAlignment = DateTime.now().difference( onTapTimeOfManualAlignment!);
      refreshTimerOfManualAlignment = Timer(const Duration(seconds: 3), () {
        isShowTextOfManualAlignment = false;
        state.dsAmplifierController?.update();
      });
      state.dsAmplifierController?.update();
    }
  }

  //SET DS Manual ALIGNMENT
  Future<dynamic> setDsManualAlignment(BuildContext context, String deviceEui,
      DsManualAlignmentItem dsManualItem) async {
    try {
      await state.dsAmplifierController?.setDsManualAlignment(
          dsManualAlignmentItem: dsManualItem,
          deviceEui: deviceEui,
          context: context)
          .then((value)  {
        if (value['body'] is DsManualAlignmentModel) {
          if (value['body'].result != null) {
            dsManualAlignmentItem.dsValues = value['body'].result.dsValues;
            // addMapWritten(true);
            manualAlignmentApiStatus = ApiStatus.success;
          } else {
            displayToastNotificationSetManualAlignment(context,true,dsManualAlignmentItem,false);
          }
        }else{
          displayToastNotificationSetManualAlignment(context,true,dsManualAlignmentItem,false);
        }
      });
    } catch (ex) {
      displayToastNotificationSetManualAlignment(context,true,dsManualAlignmentItem,false);
    } finally {
      state.dsAmplifierController?.update();
    }
  }

  displayToastNotificationSetManualAlignment(
      context, bool isDsAlignment,DsManualAlignmentItem dsManualAlignmentItem, bool isSuccess) {
    String msg = "";
    debugLogs("isSuccess ===>> $isSuccess");
    if (isDsAlignment)
      msg = isSuccess
          ? 'DS alignment submitted successfully'
          : 'DS alignment write failed';
    else
      msg = isSuccess
          ? 'US alignment submitted successfully'
          : 'US alignment write failed';

    if (isSuccess)
      msg.showSuccess(context);
    else
      msg.showError(context);

    // updateSetAPIValue(dsManualAlignmentItem,index);
  }

  //Save/Revert DS Manual ALIGNMENT
  Future<dynamic> saveRevertDsManualAlignment(BuildContext context, String deviceEui,
      DsManualAlignmentItem dsManualItem, bool isSave) async {
    try {
      saveRevertApiStatus.value = ApiStatus.loading;
      await state.dsAmplifierController
          ?.saveRevertDsManualAlignment(
          dsManualAlignmentItem: dsManualItem,
          deviceEui: deviceEui,
          context: context)
          .then((value) {
        if (value['body'].result != null) {
          manualAlignmentApiStatus = ApiStatus.success;
          // clearMapWritten(true,index);
          if(!isSave){
            getDsManualAlignment(context, deviceEui,isFromSetAPI: true, isRefreshDSSpectrum: true);
          }else {
            dsManualAlignmentItem.dsValues = value['body'].result.dsValues;
            // updateSetAPIValue(dsManualAlignmentItem,index);
            dsAlignmentSettingModel = getInitializeDBValue(
                alignmentSettingModel: dsAlignmentSettingModel,
                manualAlignmentItem: dsManualAlignmentItem);
          }
        } else {
          displayToastNotification(context,true,isSave,false);
          return;
        }
      });
    } catch (ex) {
      debugLogs("Save Revert Error : ${ex.toString()}");
      displayToastNotification(context,true,isSave,false);
    } finally {
      saveRevertApiStatus.value = ApiStatus.success;
      state.dsAmplifierController?.update();
    }
  }


  //
  // void clearMapWritten(bool isDS, int index) {
  //   final listTabs = amplifierPageHelper.listTabs;
  //   isDS? listTabs[index].ampDeviceItem.mapWrittenCtrlDS.clear():listTabs[index].ampDeviceItem.mapWrittenCtrlUS.clear();
  // }

  // updateSetAPIValue(DsManualAlignmentItem dsManualAlignmentItem, int refreshIndex){
  //   final ampItem = amplifierPageHelper.listTabs[refreshIndex].ampDeviceItem;
  //   int index = dsManualAlignmentItem.dsValues.indexWhere((element) => (element.ctrlType == ampItem.mapCtrlStage.keys.first && element.stage == ampItem.mapCtrlStage.values.first));
  //   if (index != -1) {
  //     //dsManualAlignmentItem.dsValues[index].isProgressing.value = false;
  //     dsManualAlignmentItem.dsValues[index].isSelected = false;
  //   }
  // }

  // void addMapWritten(bool isDS,int index) {
  //   final listTabs = amplifierPageHelper.listTabs;
  //   var key = {
  //     listTabs[index].ampDeviceItem.mapCtrlStage.keys.first : listTabs[index].ampDeviceItem.mapCtrlStage.keys.first
  //   };
  //   var map = (isDS) ?   listTabs[index].ampDeviceItem.mapWrittenCtrlDS :   listTabs[index].ampDeviceItem.mapWrittenCtrlUS;
  //   if (!map.containsKey(key)) {
  //     map[key] = 1;
  //   }
  // }





  void initializeManualConfiguration() {
    manualAlignmentError = null;
    manualAlignmentUpdateTime=null;
    onTapTimeOfManualAlignment = DateTime.now();
    differenceTimeOfManualAlignment = null;
    isShowTextOfManualAlignment = true;
    refreshTimerOfManualAlignment?.cancel();
  }

  List<DSPointData> parseSpectrumData(DSAutoAlignSpectrumItem? data) {
    if (data == null) return [];
    return (data.dsSpectrumData)
        .map((item) => DSPointData(
      freq: item.frequency.toDouble(),
      level: item.level.toDouble() / 100,
      reference: item.reference.toDouble() / 100,
    )).toList();
  }

  /// OnPressed On Save Button ///

  Future<dynamic> saveRevertDsAutoAlignment(BuildContext context, String deviceEui, bool isSave) async {
    try {
      saveRevertApiStatusOfAutoAlign.value = ApiStatus.loading;
      await state.dsAmplifierController?.saveRevertDsAutoAlignment(
          isSave:isSave,
          deviceEui: deviceEui,
          context: context)
          .then((value) async {
        if (value['body'].result != null) {
          debugLogs("Save Revert Result : ${value['body'].result}");
          await getDsAutoAlignmentSpectrumData(apiUrl: state.apiUrl, context: context,isRefresh: true);
          autoAlignmentApiStatus = ApiStatus.success;
        } else {
          displayToastNotification(context,true,isSave,false);
          return;
        }
      });
    } catch (ex) {
      displayToastNotification(context,true,isSave,false);
    } finally {
      saveRevertApiStatusOfAutoAlign.value = ApiStatus.success;
      state.dsAmplifierController?.update();
    }
  }

  AlignmentSettingModel getInitializeDBValue({
    required AlignmentSettingModel alignmentSettingModel,
    required DsManualAlignmentItem manualAlignmentItem,
  }) {
    // Get gain and tilt values from the manual alignment item
    alignmentSettingModel
      ..gainDbValues = _getInitialManualValue(isGainDB: true, manualAlignmentItem: manualAlignmentItem)
      ..tiltDbValues = _getInitialManualValue(isGainDB: false, manualAlignmentItem: manualAlignmentItem)
      ..gainValue.value = alignmentSettingModel.gainDbValues.value / 10
      ..tiltValue.value = alignmentSettingModel.tiltDbValues.value / 10
      ..gainTextController.text = alignmentSettingModel.gainValue.value.toStringAsFixed(1)
      ..tiltTextController.text = alignmentSettingModel.tiltValue.value.toStringAsFixed(1);

    return alignmentSettingModel;
  }

  DSManualValues _getInitialManualValue({
    required bool isGainDB,
    required DsManualAlignmentItem manualAlignmentItem,
  }) {
    return manualAlignmentItem.dsValues.firstWhere(
          (element) => element.stage == 9 && element.ctrlType == (isGainDB ? 1 : 2),
      orElse: DSManualValues.empty,
    );
  }

  displayToastNotification(
      BuildContext context, bool isDsAlignment, bool isSave, bool isSuccess) {
    String msg = "";

    if (isDsAlignment) {
      if (isSuccess) {
        msg = isSave
            ? "DS alignment saved successfully"
            : "DS alignment reverted successfully";
      } else {
        msg = isSave
            ? "DS alignment save failed"
            : "DS alignment revert failed";
      }
    } else {
      if (isSuccess) {
        msg = isSave
            ? "US alignment saved successfully"
            : "US alignment reverted successfully";
      } else {
        msg = isSave
            ? "US alignment save failed"
            : "US alignment revert failed";
      }
    }

    if (isSuccess) {
      msg.showSuccess(context);
    } else {
      msg.showError(context);
    }
  }




}