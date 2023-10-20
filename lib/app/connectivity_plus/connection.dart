import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Connection extends StatefulWidget {
  @override
  State<Connection> createState() {
    return _ConnectionState();
  }
}

class _ConnectionState extends State<Connection> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
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
            "Connectivity: ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(() {
            switch (_connectionStatus) {
              case ConnectivityResult.wifi:
                return "Wifi Connection";
              case ConnectivityResult.mobile:
                return "Mobile Connection";
              case ConnectivityResult.ethernet:
                return "Ethernet Connection";
              case ConnectivityResult.vpn:
                return "VPN Connection";
              case ConnectivityResult.bluetooth:
                return "Bluetooth Connection";
              case ConnectivityResult.other:
                return "Not Identified Connection";
              case ConnectivityResult.none:
                return "No Connection";
              default:
                return "Connection";
            }
          }())
          // Text('Connection Status: ${_connectionStatus.toString()}')
        ],
      ),
    );
  }
}
