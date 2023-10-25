import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';

class BatteryInfo extends StatefulWidget {
  const BatteryInfo({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BatteryInfoState();
  }
}

class _BatteryInfoState extends State<BatteryInfo> {
  final Battery _battery = Battery();
  String? batterylevel, batterysave;

  BatteryState? _batteryState;
  StreamSubscription<BatteryState>? _batteryStateSubscription;

  @override
  void initState() {
    super.initState();
    _battery.batteryState.then(_updateBatteryState);
    _batteryStateSubscription =
        _battery.onBatteryStateChanged.listen(_updateBatteryState);
  }

  void _updateBatteryState(BatteryState state) async {
    if (_batteryState == state) return;
    setState(() {
      _batteryState = state;
    });
    setText();
  }

  @override
  void dispose() {
    super.dispose();
    if (_batteryStateSubscription != null) {
      _batteryStateSubscription!.cancel();
    }
  }

  Future<void> setText() async {
    var level = await _battery.batteryLevel;
    var save = await _battery.isInBatterySaveMode;
    setState(() {
      batterylevel = "$level%";
      batterysave = "$save";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Battery: ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text("Battery Level: ${batterylevel ?? 'No battery identified'}"),
          Text(
              "Battery is in save mode: ${batterysave ?? 'No battery identified'}")
        ],
      ),
    );
  }
}
