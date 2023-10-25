import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Sensors extends StatefulWidget {
  const Sensors({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SensorsState();
  }
}

class _SensorsState extends State<Sensors> {
  List<double>? _userAccelerometerValues;
  List<double>? _accelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _magnetometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    _streamSubscriptions
        .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        _userAccelerometerValues = <double>[event.x, event.y, event.z];
      });
    }, onError: (e) {
      setState(() {
        _userAccelerometerValues = null;
      });
    }));
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = <double>[event.x, event.y, event.z];
      });
    }, onError: (e) {
      setState(() {
        _accelerometerValues = null;
      });
    }));
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = <double>[event.x, event.y, event.z];
      });
    }, onError: (e) {
      _gyroscopeValues = null;
    }));
    _streamSubscriptions
        .add(magnetometerEvents.listen((MagnetometerEvent event) {
      setState(() {
        _magnetometerValues = <double>[event.x, event.y, event.z];
      });
    }, onError: (e) {
      _magnetometerValues = null;
    }));
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAccelerometer = _userAccelerometerValues == null
        ? "Device doesn't support User Accelerometer"
        : _userAccelerometerValues
            ?.map((double v) => v.toStringAsFixed(1))
            .toList()
            .join(" ");
    final accelerometer = _accelerometerValues == null
        ? "Device doesn't support Accelerometer"
        : _accelerometerValues
            ?.map((double v) => v.toStringAsFixed(1))
            .toList()
            .join(" ");
    final gyroscope = _gyroscopeValues == null
        ? "Device doesn't support Gyroscope"
        : _gyroscopeValues
            ?.map((double v) => v.toStringAsFixed(1))
            .toList()
            .join(" ");
    final magnetometer = _magnetometerValues == null
        ? "Device doesn't support Magnetometer"
        : _magnetometerValues
            ?.map((double v) => v.toStringAsFixed(1))
            .toList()
            .join(" ");

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sensors: ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text("User Accelerometer: $userAccelerometer"),
          Text("Accelerometer: $accelerometer"),
          Text("Gyroscope: $gyroscope"),
          Text("Magnetometer: $magnetometer"),
        ],
      ),
    );
  }
}
