import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:parallax_bg/parallax_bg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _planetOffset = 1;
  double _meteorOffset = 5;

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Sample App'),
        // ),
        body: Column(mainAxisSize: MainAxisSize.max, children: [
          Expanded(
              child: _loading
                  ? Center(child: CircularProgressIndicator())
                  : _parallaxBody()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text("Planet"),
                Expanded(
                  child: Slider(
                    value: _planetOffset,
                    onChanged: (val) {
                      setState(() {
                        _planetOffset = val;
                      });
                    },
                    min: 1,
                    max: 10,
                  ),
                ),
                Text(_planetOffset.toStringAsFixed(0)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Text("Meteor"),
                Expanded(
                  child: Slider(
                    value: _meteorOffset,
                    onChanged: (val) {
                      setState(() {
                        _meteorOffset = val;
                      });
                    },
                    min: 5,
                    max: 20,
                  ),
                ),
                Text(_meteorOffset.toStringAsFixed(0)),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  _parallaxBody() {
    return ParallaxBackground(
      backgroundImage: "assets/images/galaxy.jpg",
      foregroundChilds: [
        ParallaxItem(
            child: Image.asset("assets/images/planet.png"),
            offset: _planetOffset),
        ParallaxItem(
            child: Image.asset("assets/images/meteor.png"),
            offset: _meteorOffset),
      ],
      // fallback: true,
    );
  }
}
