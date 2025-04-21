
import 'package:spectrum_bar_chart/app_import.dart';

class TempAmplifierController extends GetxController {
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

  Future<Map<String, dynamic>> saveRevertDsAutoAlignment({required String deviceEui, required BuildContext context,required bool isSave}) async {
    return await amplifierRepository.saveRevertDsAutoAlignment(deviceEui: deviceEui, context: context, isSave: isSave);
  }

  Future<Map<String, dynamic>> dsAutoAlignment({required String deviceEui, required BuildContext context, required bool isStatusCheck}) async {
    return await amplifierRepository.dsAutoAlignment(deviceEui: deviceEui, context: context, isStatusCheck: isStatusCheck);
  }

  Future<Map<String, dynamic>> dsManualAlignment({required String deviceEui, required BuildContext context}) async {
    return await amplifierRepository.dsManualAlignment(deviceEui: deviceEui, context: context);
  }

  Future<Map<String, dynamic>> setDsManualAlignment({required DsManualAlignmentItem dsManualAlignmentItem,required String deviceEui, required BuildContext context}) async {
    return await amplifierRepository.setDsManualAlignment(dsManualAlignmentItem: dsManualAlignmentItem,deviceEui: deviceEui, context: context);
  }

  Future<Map<String, dynamic>> saveRevertDsManualAlignment({required DsManualAlignmentItem dsManualAlignmentItem,required String deviceEui, required BuildContext context}) async {
    return await amplifierRepository.saveRevertDsManualAlignment(dsManualAlignmentItem: dsManualAlignmentItem,deviceEui: deviceEui, context: context);
  }
}