// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

enum AppScreenLayoutType { mobile, desktop , tablet ,monitor}

class ScreenLayoutTypeBuilder extends StatelessWidget {
  final Widget Function(BuildContext, AppScreenLayoutType,BoxConstraints) builder;

  const ScreenLayoutTypeBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (width < 750) {
          return builder(context, AppScreenLayoutType.mobile, constraints);
        } else if (width < 900) {
          return builder(context, AppScreenLayoutType.tablet, constraints);
        }  else {
          return builder(context, AppScreenLayoutType.desktop, constraints);
        }
      },
    );
  }
}
