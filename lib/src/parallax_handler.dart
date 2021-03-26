import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parallax_bg/src/parallax_item.dart';
import 'package:flutter_sensors/flutter_sensors.dart';

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
  final Widget child;
  final bool reverse;
  final bool fallback;

  const ParallaxBackground(
      {Key key,
      @required this.backgroundImage,
      @required this.foregroundChilds,
      this.child,
      this.reverse = false,
      this.fallback = false})
      : super(key: key);
  @override
  _ParallaxBackgroundState createState() => _ParallaxBackgroundState();
}

class _ParallaxBackgroundState extends State<ParallaxBackground> {
  var _event = AccelerometerData(0, 0, 0);
  bool accelerometerAvailable = true;

  StreamSubscription _accelSubscription;

  @override
  void initState() {
    super.initState();
    setupSensor();
  }

  setupSensor() async {
    accelerometerAvailable =
        await SensorManager().isSensorAvailable(Sensors.ACCELEROMETER);

    if (accelerometerAvailable) {
      final stream = await SensorManager().sensorUpdates(
        sensorId: Sensors.ACCELEROMETER,
        interval: Sensors.SENSOR_DELAY_GAME,
      );

      _accelSubscription = stream.listen((sensorEvent) {
        setState(() {
          _event = AccelerometerData(
              sensorEvent.data[0], sensorEvent.data[1], sensorEvent.data[2]);
        });
      });

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: accelerometerAvailable || widget.fallback
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

    if (widget.child != null) widgets.add(widget.child);
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
          _itemOffset = (_event.x > 0 ? _event.x : -_event.x.abs()) * offset -
              (offset * 10);
          break;
        case Direction.RIGHT:
          _itemOffset =
              (_event.x > 0 ? -_event.x.abs() : _event.x.abs()) * offset -
                  (offset * 10);
          break;
        case Direction.TOP:
          _itemOffset =
              (_event.y > 0 ? -_event.y.abs() : _event.y.abs()) * offset -
                  (offset * 10);
          break;
        case Direction.BOTTOM:
          _itemOffset = (_event.y > 0 ? _event.y : -_event.y.abs()) * offset -
              (offset * 10);
          break;
      }
    } else {
      switch (_direction) {
        case Direction.RIGHT:
          _itemOffset = (_event.x > 0 ? _event.x : -_event.x.abs()) * offset -
              (offset * 10);
          break;
        case Direction.LEFT:
          _itemOffset =
              (_event.x > 0 ? -_event.x.abs() : _event.x.abs()) * offset -
                  (offset * 10);
          break;
        case Direction.BOTTOM:
          _itemOffset =
              (_event.y > 0 ? -_event.y.abs() : _event.y.abs()) * offset -
                  (offset * 10);
          break;
        case Direction.TOP:
          _itemOffset = (_event.y > 0 ? _event.y : -_event.y.abs()) * offset -
              (offset * 10);
          break;
      }
    }

    return _itemOffset;
  }

  @override
  void dispose() {
    super.dispose();
    _accelSubscription.cancel();
  }
}

class AccelerometerData {
  final double x;
  final double y;
  final double z;

  AccelerometerData(this.x, this.y, this.z);
}
