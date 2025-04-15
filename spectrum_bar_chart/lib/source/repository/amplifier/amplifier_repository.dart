import 'package:flutter/material.dart';

abstract class AmplifierRepository {
  Future<Map<String, dynamic>> dsAutoAlignmentSpectrumData({
    required String apiUrl,
    required BuildContext context,
    required bool isRefresh,
    required Map<String, String>? customHeaders,
    required Map<String, String>? body,
  });
}
