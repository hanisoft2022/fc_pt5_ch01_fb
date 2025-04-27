import 'package:flutter/material.dart';

extension MediaQueryExtension on BuildContext {
  double get bottomPadding => MediaQuery.of(this).padding.bottom;
}
