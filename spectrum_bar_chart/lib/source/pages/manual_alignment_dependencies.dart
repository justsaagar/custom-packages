
import 'package:flutter/material.dart';
import 'package:spectrum_bar_chart/source/ui/app_screen_layout_type.dart';

class ManualAlignmentViewDependencies {
  /// Manual Alignment Interstage ///
  final bool isOffLineInterStage;
  final Function onTapWrite;
  final Function onTapSave;
  final Function onTapRevert;
  final Function onRefreshClicked;
  final Widget buildSwitchButtonView; /// For manual alignment interstage value Add chip ///
  final AppScreenLayoutType screenLayoutType;

  /// Manual Alignment View Manage /////
  final String gainErrorMessage;
  final String tiltErrorMessage;
  final TextEditingController gainTextController;
  final TextEditingController tiltTextController;
  final VoidCallback handleButtonPress;
  final double gainValue;
  final double tiltValue;
  final bool isSaveRevertEnable;
  final bool manualAlignmentApiStatus;
  final String? manualAlignmentError;
  final double gainMaxVal;
  final double gainMinVal;
  final double tiltMaxVal;
  final double tiltMinVal;
  final VoidCallback updateValue;

  final String lastUpdateString;
  final Color lastUpdateColor;


  ManualAlignmentViewDependencies({

    /// Manual Alignment Interstage ///
    required this.isOffLineInterStage,
    required this.onTapWrite,
    required this.onTapSave,
    required this.onTapRevert,
    required this.onRefreshClicked,
    required this.buildSwitchButtonView,
    required this.screenLayoutType,

    /// /// Manual Alignment View Manage /////
    required this.gainErrorMessage,
    required this.tiltErrorMessage,
    required this.gainTextController,
    required this.tiltTextController,
    required this.handleButtonPress,
    required this.gainValue,
    required this.tiltValue,
    required this.isSaveRevertEnable,
    required this.manualAlignmentApiStatus,
    required this.manualAlignmentError,
    required this.gainMaxVal,
    required this.gainMinVal,
    required this.tiltMaxVal,
    required this.tiltMinVal,
    required this.updateValue,

    required this.lastUpdateString,
    required this.lastUpdateColor,
  });
}