import 'package:flutter/material.dart';
import 'package:spectrum_bar_chart/source/pages/manual_alignment_dependencies.dart';
import 'package:spectrum_bar_chart/source/ui/manual_alignment_page.dart';

class InterstageClass extends StatelessWidget {
  final bool isSwitchOfAuto;
  final bool saveRevertApiStatusOfAutoAlign;
  final ManualAlignmentViewDependencies manualAlignmentViewDependencies;


  const InterstageClass({
    super.key,
    required this.isSwitchOfAuto,
    required this.saveRevertApiStatusOfAutoAlign,
    required this.manualAlignmentViewDependencies,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ampInterstageValuesView(),
        ],
      ),
    );
  }

  /// Interstage View /////
  ampInterstageValuesView() {
    return ManualAlignmentPage(
      isSwitchOfAuto: isSwitchOfAuto,
      saveRevertApiStatus: saveRevertApiStatusOfAutoAlign,
      isDSAlignment: true,
      screenLayoutType: manualAlignmentViewDependencies.screenLayoutType,
      isOffline : manualAlignmentViewDependencies.isOffLineInterStage,
      onTapWrite: manualAlignmentViewDependencies.onTapWrite,
      onTapSave: manualAlignmentViewDependencies.onTapSave,
      onTapRevert: manualAlignmentViewDependencies.onTapRevert,
      onRefreshClicked: manualAlignmentViewDependencies.onRefreshClicked,
      buttonView: manualAlignmentViewDependencies.buildSwitchButtonView,
      gainErrorMessage: manualAlignmentViewDependencies.gainErrorMessage,
      tiltErrorMessage: manualAlignmentViewDependencies.tiltErrorMessage,
      gainTextController: manualAlignmentViewDependencies.gainTextController,
      tiltTextController: manualAlignmentViewDependencies.tiltTextController,
      handleButtonPress: manualAlignmentViewDependencies.handleButtonPress,
      gainValue: manualAlignmentViewDependencies.gainValue,
      tiltValue: manualAlignmentViewDependencies.tiltValue,
      isSaveRevertEnable: manualAlignmentViewDependencies.isSaveRevertEnable,
      manualAlignmentApiStatus: manualAlignmentViewDependencies.manualAlignmentApiStatus,
      manualAlignmentError: manualAlignmentViewDependencies.manualAlignmentError,
      gainMaxVal: manualAlignmentViewDependencies.gainMaxVal,
      gainMinVal: manualAlignmentViewDependencies.gainMinVal,
      tiltMaxVal: manualAlignmentViewDependencies.tiltMaxVal,
      tiltMinVal: manualAlignmentViewDependencies.tiltMinVal,
      updateValue: manualAlignmentViewDependencies.updateValue,
      lastUpdateColor: manualAlignmentViewDependencies.lastUpdateColor,
      lastUpdateString: manualAlignmentViewDependencies.lastUpdateString,
    );
  }

}