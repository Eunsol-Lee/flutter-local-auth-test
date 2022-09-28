import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_test/utils/biometric_authentication.dart';
import 'package:local_auth_test/utils/device_info.dart';

enum DeviceType {
  android,
  ios,
  etc,
}

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  final PlatformType _platformType = DeviceInfo.platformType();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  bool? _canCheckBiometrics;
  bool? _isDeviceSupported;
  List<BiometricType>? _availableBiometrics;

  void _tryBioAuthLogin() async {
    final BiometricAuthentication bioAuto = BiometricAuthentication();
    bioAuto.tryBiometricAuthenticate();
  }

  void _getDeviceStatus() async {
    _deviceData = await DeviceInfo.deviceData();
    setState(() {});
  }

  void getApiStatus() async {
    final LocalAuthentication auth = LocalAuthentication();
    // indicate whether hardware support is available
    _canCheckBiometrics = await auth.canCheckBiometrics;
    _isDeviceSupported = await auth.isDeviceSupported();
    // to get a list of enrolled biometrics
    _availableBiometrics = await auth.getAvailableBiometrics();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getApiStatus();
    _getDeviceStatus();
  }

  Widget _deviceInfo() {
    return Column(
      children: [
        const Text(
          "Device Information",
          style: TextStyle(fontSize: 20),
        ),
        Text("Device Type: $_platformType"),
        Text("Device Data: $_deviceData"),
      ],
    );
  }

  Widget _bioAuthInfo() {
    return Column(
      children: [
        const Text(
          "Local Auth API Info",
          style: TextStyle(fontSize: 20),
        ),
        Text("canCheckBiometrics: ${_canCheckBiometrics ?? 'null'}"),
        Text("isDeviceSupported: $_isDeviceSupported"),
        Text("availableBiometrics: $_availableBiometrics"),
        const Divider(
          height: 5,
          thickness: 5,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Local Auth API Test"),
      ),
      body: Column(
        children: [
          _deviceInfo(),
          const Divider(
            height: 5,
            thickness: 5,
          ),
          _bioAuthInfo(),
          ElevatedButton(
            onPressed: _tryBioAuthLogin,
            child: const Text("Try Bio Auth Login"),
          )
        ],
      ),
    );
  }
}
