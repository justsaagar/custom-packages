import 'package:flutter/material.dart';
import 'package:spectrum_bar_chart/source/serialized/amplifier/data_amplifier.dart';

abstract class AmplifierRepository {
  Future<Map<String, dynamic>> dsAutoAlignmentSpectrumData({
    required String apiUrl,
    required BuildContext context,
    required bool isRefresh,
    required Map<String, String>? customHeaders,
    required Map<String, String>? body,
  });

  Future<Map<String, dynamic>> saveRevertDsAutoAlignment(
      {required bool isSave ,required String deviceEui, required BuildContext context});

  Future<Map<String, dynamic>> dsAutoAlignment(
      {required String deviceEui, required BuildContext context, required bool isStatusCheck });

  Future<Map<String, dynamic>> dsManualAlignment(
      {required String deviceEui, required BuildContext context});

  Future<Map<String, dynamic>> setDsManualAlignment(
      {required DsManualAlignmentItem dsManualAlignmentItem,required String deviceEui, required BuildContext context});

  Future<Map<String, dynamic>> saveRevertDsManualAlignment(
      {required DsManualAlignmentItem dsManualAlignmentItem,required String deviceEui, required BuildContext context});
}
