import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String title;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextStyle? style;
  final bool ? isSelectableText;

  const AppText(
    this.title, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.style,
    this.isSelectableText = true,
  });

  @override
  Widget build(BuildContext context) {
    if(isSelectableText!){
      return SelectableText(
        title,
        textAlign: textAlign ,
        maxLines: maxLines,
        style: style,
      );
    }
    return AppText(
      title,
      textAlign: textAlign ,
      maxLines: maxLines,
      style: style,
    );
  }
}