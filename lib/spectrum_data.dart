import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    Map<String, String> customHeaders = {};
    Map<String,String> body = {};
    final dependencies = AmpDsAlignmentDependencies(
      isSwitchOfAuto: true,
      deviceId: deviceEui,
      customHeaders: customHeaders,
      bodyMap: body,
      context: context,
      maximumYAxisValue: 50,
      minimumYAxisValue: 0,
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
            child: Expanded(
              child: AmpDsAlignment(
                dependencies: dependencies,
              ),
            ),
          ),
        );
      },
    );
  }
}
