import 'package:spectrum_bar_chart/app_import.dart';

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
      init: TempAmplifierController(),
      builder: (TempAmplifierController controller) {
        return Scaffold(
          appBar: AppBar(
            title: const AppText('Spectrum Data Chart'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AmpDsAlignment(
              dependencies: dependencies,
            ),
          ),
        );
      },
    );
  }
}
