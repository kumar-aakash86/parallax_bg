import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parallax_bg/src/parallax_item.dart';
import 'package:sensors_plus/sensors_plus.dart';
// import 'package:flutter_sensors/flutter_sensors.dart';

enum Direction { LEFT, RIGHT, TOP, BOTTOM }

class ParallaxBackground extends StatefulWidget {
  ///
  /// Creates container for parallax background
  ///
  /// The arguments [backgroundImage], [foregroundChilds] must
  /// not be null.
  /// [reverse] can be used for reverse direction of foreground childs
  /// [child] will be the widget to draw over this background
  /// [fallback] will don't show the error message & render the background even without sensors
  ///
  final String backgroundImage;
  final List<ParallaxItem> foregroundChilds;
  final Widget? child;
  final bool reverse;
  final bool fallback;

  const ParallaxBackground(
      {Key? key,
      required this.backgroundImage,
      required this.foregroundChilds,
      this.child,
      this.reverse = false,
      this.fallback = false})
      : super(key: key);
  @override
  _ParallaxBackgroundState createState() => _ParallaxBackgroundState();
}

class _ParallaxBackgroundState extends State<ParallaxBackground> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  AccelerometerEvent? _acceleration;

  @override
  void initState() {
    super.initState();
    setupSensor();
  }

  setupSensor() async {
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          setState(() {
            _acceleration = event;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: _acceleration != null || widget.fallback
          ? Stack(
              children: _generateBody(),
            )
          : Center(
              child: Text("Supported sensors not available on your device"),
            ),
    );
  }

  _generateBody() {
    List<Widget> widgets = [];
    widgets.add(
      Positioned.fill(
        child: Container(
          // constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(widget.backgroundImage), fit: BoxFit.none),
          ),
        ),
      ),
    );
    widgets = _generateForeground(widgets);

    if (widget.child != null) widgets.add(widget.child!);
    return widgets;
  }

  _generateForeground(List<Widget> widgets) {
    widget.foregroundChilds.forEach((element) {
      widgets.add(AnimatedPositioned(
        duration: Duration(milliseconds: 100),
        child: Container(
          width: MediaQuery.of(context).size.width + (element.offset * 10),
          height: MediaQuery.of(context).size.height + (element.offset * 10),
          child: element.child,
        ),
        bottom: _calculateOffset(Direction.BOTTOM, element.offset),
        top: _calculateOffset(Direction.TOP, element.offset),
        left: _calculateOffset(Direction.LEFT, element.offset),
        right: _calculateOffset(Direction.RIGHT, element.offset),
      ));
    });

    return widgets;
  }

  _calculateOffset(Direction _direction, double offset) {
    double _itemOffset = 0;
    if (widget.reverse) {
      switch (_direction) {
        case Direction.LEFT:
          _itemOffset = (_acceleration!.x > 0
                      ? _acceleration!.x
                      : -_acceleration!.x.abs()) *
                  offset -
              (offset * 10);
          break;
        case Direction.RIGHT:
          _itemOffset = (_acceleration!.x > 0
                      ? -_acceleration!.x.abs()
                      : _acceleration!.x.abs()) *
                  offset -
              (offset * 10);
          break;
        case Direction.TOP:
          _itemOffset = (_acceleration!.y > 0
                      ? -_acceleration!.y.abs()
                      : _acceleration!.y.abs()) *
                  offset -
              (offset * 10);
          break;
        case Direction.BOTTOM:
          _itemOffset = (_acceleration!.y > 0
                      ? _acceleration!.y
                      : -_acceleration!.y.abs()) *
                  offset -
              (offset * 10);
          break;
      }
    } else {
      switch (_direction) {
        case Direction.RIGHT:
          _itemOffset = (_acceleration!.x > 0
                      ? _acceleration!.x
                      : -_acceleration!.x.abs()) *
                  offset -
              (offset * 10);
          break;
        case Direction.LEFT:
          _itemOffset = (_acceleration!.x > 0
                      ? -_acceleration!.x.abs()
                      : _acceleration!.x.abs()) *
                  offset -
              (offset * 10);
          break;
        case Direction.BOTTOM:
          _itemOffset = (_acceleration!.y > 0
                      ? -_acceleration!.y.abs()
                      : _acceleration!.y.abs()) *
                  offset -
              (offset * 10);
          break;
        case Direction.TOP:
          _itemOffset = (_acceleration!.y > 0
                      ? _acceleration!.y
                      : -_acceleration!.y.abs()) *
                  offset -
              (offset * 10);
          break;
      }
    }

    return _itemOffset;
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }
}

class AccelerometerData {
  final double x;
  final double y;
  final double z;

  AccelerometerData(this.x, this.y, this.z);
}
