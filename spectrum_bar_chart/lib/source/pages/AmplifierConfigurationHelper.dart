
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:spectrum_bar_chart/source/controller/ds_amplifier_controller.dart';
import 'package:spectrum_bar_chart/source/helper/date_helper.dart';
import 'package:spectrum_bar_chart/source/helper/enum_helper.dart';
import 'package:spectrum_bar_chart/source/helper/rest_helper.dart';
import 'package:spectrum_bar_chart/source/pages/amp_ds_alignment.dart';
import 'package:spectrum_bar_chart/source/serialized/amplifier_configuration/amplifier_configuration.dart';

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

  List<DSPointData> parseSpectrumData(DSAutoAlignSpectrumItem? data) {
    if (data == null) return [];
    return (data.dsSpectrumData)
        .map((item) => DSPointData(
      freq: item.frequency.toDouble(),
      level: item.level.toDouble() / 100,
      reference: item.reference.toDouble() / 100,
    )).toList();
  }


}