import 'package:flutter/widgets.dart';

extension Context on BuildContext {
  double get width => MediaQuery.of(this).size.width;
}
