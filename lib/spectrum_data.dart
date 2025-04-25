import 'package:flutter/material.dart';
import 'package:spectrum_bar_chart/source/pages/spectrum_bar_chart.dart';

class SpectrumDataChart extends StatefulWidget {
  const SpectrumDataChart({super.key});

  @override
  State<SpectrumDataChart> createState() => _SpectrumDataChartState();
}

class _SpectrumDataChartState extends State<SpectrumDataChart> {
  List <SpectrumChartItem> dataPoints = [
    SpectrumChartItem(freq: 351, reference: 35.23, level: 36.1),
    SpectrumChartItem(freq: 753, reference: 42.02, level: 41.4),
    SpectrumChartItem(freq: 1005, reference: 44.83, level: 44.7),
    SpectrumChartItem(freq: 1701, reference: 47.64, level: 47.8),
  ];

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
      refreshButtonPressed: () {},
      lastStatusView: const Text("Last update Time is 1 min ago"),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spectrum Data Chart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SpectrumBarChart(
          dataPoints: dataPoints,
          dependencies: dependencies,
        ),
      ),
    );
  }
}
