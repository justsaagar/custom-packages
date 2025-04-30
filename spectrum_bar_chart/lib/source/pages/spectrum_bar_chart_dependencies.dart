import 'dart:ui';

class SpectrumBarChartDependencies {
  final bool isSwitchOfAuto;
  final VoidCallback? saveButtonPressed;
  final VoidCallback? revertButtonPressed;
  final double maximumYAxisValue;
  final double minimumYAxisValue;
  final String xAxisTitle;
  final String yAxisTitle;
  final bool isSaveRevertUnable;
  final bool spectrumApiStatus;
  final bool isStartDownStream;
  final String? downStreamAutoAlignmentError;
  final VoidCallback? startAutoButtonPressed;
  final bool saveRevertApiStatusOfAutoAlign;

  /// Last update refresh text widget show ///
  final String lastUpdateString;
  final Color lastUpdateColor;
  final VoidCallback onTapRefreshButton;
  final bool isRefreshEnable;


  SpectrumBarChartDependencies({
    required this.isSwitchOfAuto,
    required this.saveButtonPressed,
    required this.revertButtonPressed,
    required this.maximumYAxisValue,
    required this.minimumYAxisValue,
    required this.xAxisTitle,
    required this.yAxisTitle,
    required this.isSaveRevertUnable,
    required this.spectrumApiStatus,
    required this.isStartDownStream,
    required this.downStreamAutoAlignmentError,
    required this.startAutoButtonPressed,
    required this.lastUpdateString,
    required this.lastUpdateColor,
    required this.onTapRefreshButton,
    required this.saveRevertApiStatusOfAutoAlign,
    required this.isRefreshEnable,
  });
}
