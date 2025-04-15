import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spectrum_bar_chart/source/controller/amplifier_controller.dart';
import 'package:spectrum_bar_chart/source/helper/configuration_helper.dart';
import 'package:spectrum_bar_chart/source/helper/enum_helper.dart';
import 'package:spectrum_bar_chart/source/helper/rest_helper.dart';
import 'package:spectrum_bar_chart/source/pages/spectrum_bar_chart.dart';
import 'package:spectrum_bar_chart/source/serialized/amplifier_configuration/amplifier_configuration.dart';

class SpectrumDataChart extends StatefulWidget {
  const SpectrumDataChart({super.key});

  @override
  State<SpectrumDataChart> createState() => _SpectrumDataChartState();
}

class _SpectrumDataChartState extends State<SpectrumDataChart> {


  List<DSPointData> dsSpectrumDataPoints = [];

  @override
  Widget build(BuildContext context) {
    debugLogs("Current Screen ------> $runtimeType");
    String apiUrl = 'https://192.168.44.176:3333/amps/002926000002049a/ds_auto_alignment_spectrum_data?timeout=15&retries=1&refresh=false';
    Map<String, String> customHeaders = {};
    Map<String,String> body = {};
    final dependencies = SpectrumBarChartDependencies(
      isSwitchOfAuto: true,
      apiUrl: apiUrl,
      customHeaders: customHeaders,
      bodyMap: body,
      amplifierConfigurationHelper: AmplifierConfigurationHelper(ApiStatus.success),
      context: context,
      getSize: (size) => size,
      getMediumBoldFontWeight: () => FontWeight.normal,
      saveButton: () => InkWell(
        onTap: () {},
        child: Container(
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: const EdgeInsets.symmetric(horizontal: 10),
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
          margin: const EdgeInsets.symmetric(horizontal: 10),
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
      refBarColor: const Color.fromARGB(255, 255, 165, 0),
      levelBarColor: const Color.fromARGB(255, 120, 0, 255),
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
      refGraphColor: const Color.fromARGB(100, 255, 165, 0),
      levelGraphColor: const Color.fromARGB(120, 179, 113, 255),
    );
    return GetBuilder(
      init: AmplifierController(),
      builder: (AmplifierController controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Spectrum Data Chart'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SpectrumBarChart(
              dataPoints: dsSpectrumDataPoints,
              dependencies: dependencies,
            ),
          ),
        );
      },
    );
  }
}
