import 'package:app_info/app/connectivity_plus/connection.dart';
import 'package:app_info/app/deviceinfo_plus/device_info.dart';
import 'package:app_info/app/networkinfo_plus/network_info.dart';
import 'package:app_info/app/packageinfo_plus/package_info.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("app and device info"),
      ),
      body: ListView(
        children: [
          Connection(),
          Network(),
          Package(),
          Device(),
        ],
      ),
    );
  }
}
