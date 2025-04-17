import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spectrum_bar_chart/source/helper/rest_helper.dart';
import 'package:spectrum_bar_chart/source/repository/amplifier/amplifier_repository.dart';
import 'package:spectrum_bar_chart/source/serialized/amplifier_configuration/amplifier_configuration.dart';

class AmplifierRepositoryImpl implements AmplifierRepository {
  RestHelper restServices = RestHelper.instance;
  @override
  Future<Map<String, dynamic>> dsAutoAlignmentSpectrumData({
    required String apiUrl,
    required BuildContext context,
    required bool isRefresh,
    required Map<String, String>? customHeaders,
    required Map<String, String>? body,
  }) async {
    try {

      final response = await restServices.postRestCallWithResponse(url: apiUrl, customHeaders: customHeaders, context: context, body: body);
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

  @override
  Future<Map<String, dynamic>> saveRevertDsAutoAlignment(
      {required String deviceEui, required BuildContext context,required bool isSave}) async {
    try {
      final response = await restServices.postRestCallWithResponse(
        url: 'https://192.168.44.176:3333/amps/$deviceEui/ds_auto_alignment?timeout=15&retries=1&refresh=true',
        context: context,
        body: isSave
            ? {"auto_alignment_op_e": 5}
            : {"auto_alignment_op_e": 6},
      );
      if (response != null && response.body.isNotEmpty) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['result'] != null) {
          DsAutoAlignmentModel dsAutoAlignmentModel = DsAutoAlignmentModel.fromJson(responseData);
          return  {'body':dsAutoAlignmentModel,'headers':response.headers };
        } else {
          return {'body': responseData, 'headers': response.headers};
        }
      }
      return  {'body':DsAutoAlignmentModel.empty(),'headers':{"updated_at":null} };
    } on SocketException catch (e) {
      debugLogs(
          'catch exception in dsAutoAlignment ---> ${e.message}');
    }
    return  {'body':DsAutoAlignmentModel.empty(),'headers':{"updated_at":null} } ;
  }
}