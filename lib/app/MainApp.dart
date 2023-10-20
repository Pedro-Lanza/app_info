import 'package:app_info/app/connectivity_plus/connection.dart';
import 'package:app_info/app/pages/home/home_page.dart';
import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
