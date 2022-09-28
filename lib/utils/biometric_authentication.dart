import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:local_auth/local_auth.dart";

// For iOS integration and android integration, see below
// https://github.com/flutter/plugins/tree/main/packages/local_auth/local_auth#ios-integration
// https://github.com/flutter/plugins/tree/main/packages/local_auth/local_auth#android-integration

class BiometricAuthentication {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> canBiometricAuthenticate() async {
    List<BiometricType> availableBiometrics =
        await _auth.getAvailableBiometrics();
    return availableBiometrics.isNotEmpty;
  }

  tryBiometricAuthenticate() async {
    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to login',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      debugPrint("Biometric Authentication $didAuthenticate");
      return didAuthenticate;
    } on PlatformException catch (e) {
      // 현재 실제 인증 실패 이유랑 에러 메시지랑 정확하게 일치 하지 않음
      // 따라서 에러의 경우 전부 인증 실패로 처리
      // ex: iOS 인증 실패 시 => NotAvailable, Authentication failure., com.apple.LocalAuthentication

      debugPrint(
          "Biometric Authentication Error code: ${e.code}   Error message: ${e.message}   Error details: ${e.details}");
    }
  }
}
