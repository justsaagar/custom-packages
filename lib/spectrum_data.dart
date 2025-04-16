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
    String apiUrl = 'https://192.168.44.176:3333/amps/$deviceEui/ds_auto_alignment_spectrum_data?timeout=15&retries=1&refresh=false';
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
      saveButton: () => InkWell(
        onTap: () {},
        child: Container(
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            "Save",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      revertButton: () => InkWell(
        onTap: () {},
        child: Container(
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            "Revert",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      refBarColor: AppColorConstants.colorRefChartBorder,
      levelBarColor: AppColorConstants.colorLevelChartBorder,
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
      referenceWidth: 10,
      referenceBorder: const BorderRadius.only(
        topLeft: Radius.circular(4),
        topRight: Radius.circular(4),
      ),
      levelBarWidth: 10,
      levelBarBorder: const BorderRadius.only(
        topLeft: Radius.circular(4),
        topRight: Radius.circular(4),
      ),
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
      refGraphColor: AppColorConstants.colorRefChartBackGround,
      levelGraphColor: AppColorConstants.colorLevelChartBackGround,
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
            child: AmpDsAlignment(
              dataPoints: dsSpectrumDataPoints,
              dependencies: dependencies,
            ),
          ),
        );
      },
    );
  }
}
