// import 'dart:html';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class Network extends StatefulWidget {
  const Network({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NetworkState();
  }
}

class _NetworkState extends State<Network> {
  List<Text> _connectionStatus = <Text>[];
  final NetworkInfo _networkInfo = NetworkInfo();

  @override
  void initState() {
    super.initState();
    _initNetworkInfo();
  }

  Future<void> _initNetworkInfo() async {
    String? wifiName,
        wifiBSSID,
        wifiIPv4,
        wifiIPv6,
        wifiGatewayIP,
        wifiBroadcast,
        wifiSubmask;

    try {
      if (!kIsWeb && Platform.isIOS) {
        var permit = await Permission.location;
        if (await permit.isDenied) {
          await Permission.location.request();
        }
        wifiName = await _networkInfo.getWifiName();
      } else {
        wifiName = await _networkInfo.getWifiName();
      }
      if (wifiName == null) throw Exception();
    } catch (e) {
      wifiName = 'Failed to get wifi name';
    }
    try {
      if (!kIsWeb && Platform.isIOS) {
        var status = await Permission.location;
        if (await status.isDenied) {
          await Permission.location.request();
        }
        wifiBSSID = await _networkInfo.getWifiBSSID();
      } else {
        wifiBSSID = await _networkInfo.getWifiBSSID();
      }
      if (wifiBSSID == null) throw Exception();
    } catch (e) {
      wifiBSSID = 'Failed to get wifi BSSID';
    }
    try {
      wifiIPv4 = await _networkInfo.getWifiIP();
      if (wifiIPv4 == null) throw Exception();
    } catch (e) {
      wifiIPv4 = 'Failed to get wifi IPv4';
    }
    try {
      wifiIPv6 = await _networkInfo.getWifiIPv6();
      if (wifiIPv6 == null) throw Exception();
    } catch (e) {
      wifiIPv6 = 'Failed to get wifi IPv6';
    }
    try {
      wifiGatewayIP = await _networkInfo.getWifiGatewayIP();
      if (wifiGatewayIP == null) throw Exception();
    } catch (e) {
      wifiGatewayIP = 'Failed to get wifi Gateway IP';
    }
    try {
      wifiBroadcast = await _networkInfo.getWifiBroadcast();
      if (wifiBroadcast == null) throw Exception();
    } catch (e) {
      wifiBroadcast = 'Failed to get wifi Broadcast';
    }
    try {
      wifiSubmask = await _networkInfo.getWifiSubmask();
      if (wifiSubmask == null) throw Exception();
    } catch (e) {
      wifiSubmask = 'Failed to get wifi Submask';
    }

    setState(() {
      _connectionStatus = [
        const Text(
          "Network: ",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(wifiName.toString()),
        Text(wifiBSSID.toString()),
        Text(wifiIPv4.toString()),
        Text(wifiIPv6.toString()),
        Text(wifiGatewayIP.toString()),
        Text(wifiBroadcast.toString()),
        Text(wifiSubmask.toString())
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _connectionStatus,
      ),
    );
  }
}
