import 'package:flutter/material.dart';

extension MediaQueryExtensions on BuildContext {
  double wp(double percent) => MediaQuery.of(this).size.width * (percent / 100);
  double hp(double percent) =>
      MediaQuery.of(this).size.height * (percent / 100);

  // Scale font size based on screen width (using 360 as base width - android standard)
  double sp(double size) => size * (MediaQuery.of(this).size.width / 360);
}
