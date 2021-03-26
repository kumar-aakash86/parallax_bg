import 'package:flutter/material.dart';

class ParallaxItem {
  /// [child] must not be null. This child denotes the foreground widget
  /// [offset] is the value which helps moving foreground items
  ///
  /// default value for [offset] is 5
  final Widget child;
  final double offset;

  ParallaxItem({@required this.child, this.offset = 5});
}
