import 'package:flutter/material.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';
import 'package:qrty/core/theme/app_colors.dart';

class QRScannerOverlay extends StatelessWidget {
  const QRScannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: QRScannerPainter(context),
      child: const SizedBox.expand(),
    );
  }
}

class QRScannerPainter extends CustomPainter {
  final BuildContext context;

  QRScannerPainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final scanAreaSize = context.wp(75);
    final left = (size.width - scanAreaSize) / 2;
    final top = (size.height - scanAreaSize) / 2;

    // Draw semi-transparent overlay
    final overlayPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final overlayPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(Rect.fromLTWH(left, top, scanAreaSize, scanAreaSize))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(overlayPath, overlayPaint);

    // Draw corner brackets
    final bracketPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = context.wp(1.5)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final bracketLength = context.wp(10);
    final radius = context.wp(5);

    // Top-left corner
    canvas.drawPath(
      Path()
        ..moveTo(left + radius, top)
        ..lineTo(left, top)
        ..lineTo(left, top + bracketLength),
      bracketPaint,
    );

    // Top-right corner
    canvas.drawPath(
      Path()
        ..moveTo(left + scanAreaSize - radius, top)
        ..lineTo(left + scanAreaSize, top)
        ..lineTo(left + scanAreaSize, top + bracketLength),
      bracketPaint,
    );

    // Bottom-left corner
    canvas.drawPath(
      Path()
        ..moveTo(left, top + scanAreaSize - bracketLength)
        ..lineTo(left, top + scanAreaSize)
        ..lineTo(left + radius, top + scanAreaSize),
      bracketPaint,
    );

    // Bottom-right corner
    canvas.drawPath(
      Path()
        ..moveTo(left + scanAreaSize, top + scanAreaSize - bracketLength)
        ..lineTo(left + scanAreaSize, top + scanAreaSize)
        ..lineTo(left + scanAreaSize - radius, top + scanAreaSize),
      bracketPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
