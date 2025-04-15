import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spectrum_bar_chart/source/helper/rest_helper.dart';
import 'package:spectrum_bar_chart/source/repository/amplifier/amplifier_repository.dart';
import 'package:spectrum_bar_chart/source/serialized/amplifier_configuration/amplifier_configuration.dart';

class AmplifierRepositoryImpl implements AmplifierRepository {
  @override
  Future<Map<String, dynamic>> dsAutoAlignmentSpectrumData({
    required String apiUrl,
    required BuildContext context,
    required bool isRefresh,
    required Map<String, String>? customHeaders,
    required Map<String, String>? body,
  }) async {
    try {
      final restHelper = RestHelper.instance;
      final response = await restHelper.postRestCallWithResponse(url: apiUrl, customHeaders: customHeaders, context: context, body: body);
      if (response != null && response.body.isNotEmpty) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['result'] != null) {
          DSAutoAlignSpectrum dsAutoAlignSpectrum = DSAutoAlignSpectrum.fromJson(responseData);
          return {'body': dsAutoAlignSpectrum, 'headers': response.headers};
        } else {
          return {'body': responseData, 'headers': response.headers};
        }
      }
      return {
        'body': DSAutoAlignSpectrum.empty(),
        'headers': {"updated_at": null}
      };
    } on SocketException catch (e) {
      debugLogs('catch exception in dsAutoAlignment ---> ${e.message}');
    }
    return {
      'body': DSAutoAlignSpectrum.empty(),
      'headers': {"updated_at": null}
    };
  }
}