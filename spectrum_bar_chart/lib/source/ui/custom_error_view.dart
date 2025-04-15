import 'package:flutter/material.dart';

class DottedBorderPainter extends CustomPainter {
  final Color borderColor;
  final double ?cornerRadiusValue;
  final double ?strokeWidth;

  DottedBorderPainter({required this.borderColor, this.cornerRadiusValue = 4.0, this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = borderColor
      ..strokeWidth = strokeWidth ?? 1.5
      ..style = PaintingStyle.stroke;

    double dashWidth = 5, dashSpace = 2.5;
    double cornerRadius = cornerRadiusValue??4.0;

    Path path = Path();

    // Top border
    double startX = cornerRadius;
    while (startX < size.width - cornerRadius) {
      path.moveTo(startX, 0);
      path.lineTo(startX + dashWidth, 0);
      startX += dashWidth + dashSpace;
    }

    // Right border
    double startY = cornerRadius;
    while (startY < size.height - cornerRadius) {
      path.moveTo(size.width, startY);
      path.lineTo(size.width, startY + dashWidth);
      startY += dashWidth + dashSpace;
    }

    // Bottom border
    startX = cornerRadius;
    while (startX < size.width - cornerRadius) {
      path.moveTo(startX, size.height);
      path.lineTo(startX + dashWidth, size.height);
      startX += dashWidth + dashSpace;
    }

    // Left border
    startY = cornerRadius;
    while (startY < size.height - cornerRadius) {
      path.moveTo(0, startY);
      path.lineTo(0, startY + dashWidth);
      startY += dashWidth + dashSpace;
    }

    // Top-left corner
    path.addArc(Rect.fromCircle(center: Offset(cornerRadius, cornerRadius), radius: cornerRadius), -3.14, 1.57);

    // Top-right corner
    path.addArc(Rect.fromCircle(center: Offset(size.width - cornerRadius, cornerRadius), radius: cornerRadius), -1.57, 1.57);

    // Bottom-right corner
    path.addArc(Rect.fromCircle(center: Offset(size.width - cornerRadius, size.height - cornerRadius), radius: cornerRadius), 0, 1.57);

    // Bottom-left corner
    path.addArc(Rect.fromCircle(center: Offset(cornerRadius, size.height - cornerRadius), radius: cornerRadius), 1.57, 1.57);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}