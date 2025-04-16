import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spectrum_bar_chart/source/constant/app_constant.dart';
import 'package:spectrum_bar_chart/source/controller/ds_amplifier_controller.dart';
import 'package:spectrum_bar_chart/source/helper/rest_helper.dart';
import 'package:spectrum_bar_chart/source/pages/amp_ds_alignment.dart';
import 'package:spectrum_bar_chart/source/serialized/amplifier_configuration/amplifier_configuration.dart';

class SpectrumDataChart extends StatefulWidget {
  const SpectrumDataChart({super.key});

  @override
  State<SpectrumDataChart> createState() => _SpectrumDataChartState();
}

class _SpectrumDataChartState extends State<SpectrumDataChart> {


  List<DSPointData> dsSpectrumDataPoints = [];
  String deviceEui = '002926000002049a';

  @override
  Widget build(BuildContext context) {
    debugLogs("Current Screen ------> $runtimeType");
    String apiUrl = 'https://192.168.44.176:3333/amps/$deviceEui/ds_auto_alignment_spectrum_data?timeout=15&retries=1&refresh=true';
    Map<String, String> customHeaders = {};
    Map<String,String> body = {};
    final dependencies = AmpDsAlignmentDependencies(
      isSwitchOfAuto: true,
      apiUrl: apiUrl,
      customHeaders: customHeaders,
      bodyMap: body,
      context: context,
      getSize: (size) => size,
      getMediumBoldFontWeight: () => FontWeight.normal,
      saveButtonText: "Save",
      revertButtonText: "Revert",
      saveButtonPressed: () {},
      revertButtonPressed: () {},
      axisLabelTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 12,
        fontWeight: FontWeight.w900,
      ),
      tooltipTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 12,
        fontWeight: FontWeight.w900,
      ),
      maximumYAxisValue: 50,
      minimumYAxisValue: 0,
      xAxisTitle: 'MHz',
      xAxisTitleStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 16,
      ),
      yAxisTitle: 'dBmV',
      yAxisTitleStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 16,
      ),
    );
    return GetBuilder(
      init: DsAmplifierController(),
      builder: (DsAmplifierController controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Spectrum Data Chart'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AmpDsAlignment(
                    dependencies: dependencies,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AmpDsAlignment(
                    dependencies: dependencies,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
