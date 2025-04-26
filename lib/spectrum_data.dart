import 'package:flutter/material.dart';
import 'package:spectrum_bar_chart/constant/app_constant.dart';
import 'package:spectrum_bar_chart/source/pages/spectrum_bar_chart.dart';

class SpectrumDataChart extends StatefulWidget {
  const SpectrumDataChart({super.key});

  @override
  State<SpectrumDataChart> createState() => _SpectrumDataChartState();
}

class _SpectrumDataChartState extends State<SpectrumDataChart> {
  List<DSPointData> dataPoints = [
    DSPointData(freq: 351, reference: 35.23, level: 36.1),
    DSPointData(freq: 753, reference: 42.02, level: 41.4),
    DSPointData(freq: 1005, reference: 44.83, level: 44.7),
    DSPointData(freq: 1701, reference: 47.64, level: 47.8),
  ];

  DateTime? dsSpectrumOnTapTime;
  Duration ? dsSpectrumDifferenceTime;
  bool dsSpectrumIsShowText = true;
  DateTime? updateTime;
  bool refreshStatus = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialCall();

  }
  initialCall()async{
    dsSpectrumIsShowText = true;
    dsSpectrumOnTapTime = DateTime.now();
    updateTime = DateTime.now();
    refreshStatus = true;
    setState(() {

    });
    await Future.delayed(Duration(seconds: 5));
    refreshStatus = false;
    dsSpectrumDifferenceTime = DateTime.now().difference(DateTime.now().subtract(const Duration(seconds: 5)));
    setState(() {

    });
    await Future.delayed(Duration(seconds: 2));
    dsSpectrumIsShowText = false;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    final dependencies = SpectrumBarChartDependencies(
      isSwitchOfAuto: true,
      saveButtonPressed: () {},
      revertButtonPressed: () {},
      maximumYAxisValue: 50,
      minimumYAxisValue: 0,
      xAxisTitle: 'MHz',
      yAxisTitle: 'dBmV',
      isSaveRevertUnable: true,
      saveRevertApiStatus: false,
      isStartDownStream: false,
      downStreamAutoAlignmentError: null,
      // downStreamAutoAlignmentError: "Some thing wrong",
      startAutoButtonPressed: () {},
      lastUpdateColor: refreshStatus == true || dsSpectrumDifferenceTime == null ? AppColorConstants.colorAppbar : AppColorConstants.colorGrn,
      lastUpdateString: !dsSpectrumIsShowText ? 'Last Updated: $updateTime' : (refreshStatus == true && dsSpectrumOnTapTime != null
          ? 'Please wait refreshing data...'
          : dsSpectrumDifferenceTime != null
          ? '${ 'The refresh completed in '}${dsSpectrumDifferenceTime?.inSeconds}.${dsSpectrumDifferenceTime!.inMilliseconds ~/ 10}s'
          : updateTime != null ? 'Last Updated: $updateTime' : " not Defined show"),
      onTapRefreshButton: () {
        setState(() {
          dataPoints = [
            DSPointData(freq: 351, reference: 33.23, level: 18.1),
            DSPointData(freq: 753, reference: 30.02, level: 23.4),
            DSPointData(freq: 1005, reference: 55.83, level: 45.7),
            DSPointData(freq: 1701, reference: 22.64, level: 37.8),
          ];
        });
        initialCall();
        Future.delayed(const Duration(seconds: 5), () {});
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spectrum Data Chart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SpectrumBarChart(
          dataPoints: dataPoints.map((e) => SpectrumChartItem(freq: e.freq.toInt(), level: e.level, reference: e.reference)).toList(),
          dependencies: dependencies,
        ),
      ),
    );
  }
}


class DSPointData {
  final double freq;
  final double level;
  final double reference;

  DSPointData({required this.freq, required this.level, required this.reference});
}
