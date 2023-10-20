import 'dart:ffi';

import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Package extends StatefulWidget {
  const Package({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PackageState();
  }
}

class _PackageState extends State<Package> {
  PackageInfo _packageInfo = PackageInfo(
      appName: 'Desconhecido',
      packageName: 'Desconhecido',
      version: 'Desconhecido',
      buildNumber: 'Desconhecido');

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Widget Status(String text, String status) {
    return Text(
        "$text: ${status.isEmpty || status == "null" ? 'not set' : status.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Package: ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Status("App Name", _packageInfo.appName),
          Status("Package Name", _packageInfo.packageName),
          Status("Version", _packageInfo.version),
          Status("Build Number", _packageInfo.buildNumber),
          Status("Build Signature", _packageInfo.buildSignature),
          Status("Installer Store", _packageInfo.installerStore.toString())
        ],
      ),
    );
  }
}
