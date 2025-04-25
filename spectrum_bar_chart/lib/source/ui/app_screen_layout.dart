// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

enum ScreenLayoutType { mobile, desktop , tablet ,monitor}

class ScreenLayoutTypeBuilder extends StatelessWidget {
  final Widget Function(BuildContext, ScreenLayoutType,BoxConstraints) builder;

  const ScreenLayoutTypeBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (width < 750) {
          return builder(context, ScreenLayoutType.mobile, constraints);
        } else if (width < 900) {
          return builder(context, ScreenLayoutType.tablet, constraints);
        }  else {
          return builder(context, ScreenLayoutType.desktop, constraints);
        }
      },
    );
  }
}
