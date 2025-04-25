// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:get/get.dart';
// import 'package:spectrum_bar_chart/source/controller/amplifier_controller.dart';
// import 'package:spectrum_bar_chart/source/pages/spectrum_bar_chart.dart';
// import 'package:spectrum_bar_chart/source/ui/app_toast.dart';
//
// class SpectrumBarChartHelper{
//   SpectrumBarChartState state;
//   ApiStatus spectrumApiStatus = ApiStatus.initial;
//   List<DSPointData> dsSpectrumDataPoints = [];
//
//   SpectrumBarChartHelper(this.state) {
//     SchedulerBinding.instance.addPostFrameCallback(
//           (timeStamp) async {
//             state.amplifierController = Get.put(AmplifierController());
//       },
//     );
//   }
//
//   /// User Pass Url and header so call api and get Data in chart....  ////
//   Future<List<DSPointData>> fetchChartDataWithRestHelper({
//     required String apiUrl,
//     Map<String, String>? customHeaders,
//     Map<String, String>? body,
//     required BuildContext context,
//   }) async {
//     try {
//       await state.amplifierController?.dsAutoAlignmentSpectrumData(apiUrl: apiUrl, context: context, isRefresh: false, customHeaders: customHeaders, body: body).then(
//             (value) {
//           if (value['body'] is DSAutoAlignSpectrum) {
//             if (value['body'].result != null) {
//               spectrumApiStatus = ApiStatus.success;
//               DSAutoAlignSpectrumItem dsAutoAlignSpectrumItem = value['body'].result;
//               dsSpectrumDataPoints = parseSpectrumData(dsAutoAlignSpectrumItem);
//             } else {
//               spectrumApiStatus = ApiStatus.failed;
//               "${value['body'].message}".showError(context);
//             }
//           } else {
//             spectrumApiStatus = ApiStatus.failed;
//             "${value['body']}".showError(context);
//           }
//         },
//       );
//       return dsSpectrumDataPoints;
//     } catch (e) {
//       debugLogs("fetchChartDataWithRestHelper error--> $e");
//       return [];
//     }
//   }
//
//   List<DSPointData> parseSpectrumData(DSAutoAlignSpectrumItem? data) {
//     if (data == null) return [];
//     return (data.dsSpectrumData)
//         .map((item) => DSPointData(
//       freq: item.frequency.toDouble(),
//       level: item.level.toDouble() / 100,
//       reference: item.reference.toDouble() / 100,
//     )).toList();
//   }
//
//
// }