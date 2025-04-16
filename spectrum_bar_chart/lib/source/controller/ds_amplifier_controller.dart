import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spectrum_bar_chart/source/repository/amplifier/amplifier_repository.dart';
import 'package:spectrum_bar_chart/source/pages/amp_ds_alignment.dart';

class DsAmplifierController extends GetxController {
  AmplifierRepository amplifierRepository = getIt.get<AmplifierRepository>();

  Future<Map<String, dynamic>> dsAutoAlignmentSpectrumData({
    required String apiUrl,
    required BuildContext context,
    required bool isRefresh,
    required Map<String, String>? customHeaders,
    required Map<String, String>? body,
  }) async {
    return await amplifierRepository.dsAutoAlignmentSpectrumData(context: context, isRefresh: isRefresh, apiUrl: apiUrl, customHeaders: customHeaders, body: body);
  }
}