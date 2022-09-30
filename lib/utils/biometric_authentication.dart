import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:local_auth/local_auth.dart";

// For iOS integration and android integration, see below
// https://github.com/flutter/plugins/tree/main/packages/local_auth/local_auth#ios-integration
// https://github.com/flutter/plugins/tree/main/packages/local_auth/local_auth#android-integration

// 2022-10-01 Test Local_aut test 결과 (By Eunsol)

// iPhone 12 Pro Max Physical Device
// (초기 앱 인스톨 후 설정) 설정 - Face ID 및 암호 - 기타 앱 -> 없음!!!!!
// canCheckBiometrics: true, isDeviceSupported: true, availableBiometrics: [BiometricType.face]
// 허용 or not 등록이 한번 뜸 그리고 이 때 plist에 NSFaceIDUsageDescription 등록한 거 뜸
// (앱에서 허용 설정) 설정 - Face ID 및 암호 - 기타 앱 - 선택 후 옵션 켜기
// canCheckBiometrics: true, isDeviceSupported: true, availableBiometrics: [BiometricType.face]
// (변경 상태에서의 앱 설정) 설정 - Face ID 및 암호 - 기타 앱 - 선택 후 옵션 끄기
// canCheckBiometrics: false, isDeviceSupported: true, availableBiometrics: []
// 이 때 인증 시도 시
// Error code: NotAvailable   message: Biometry is not available.   details: com.apple.LocalAuthentication

// Pixel 5 API 30 Android Emulator
// (초기 앱 인스톨 후)
// canCheckBiometrics: true, isDeviceSupported: falase, availableBiometrics: []
// (Fragment Activity를 앱에 등록 안하고 인증 시도 시)
// Error code: no_fragment_activity   message: local_auth plugin requires activity to be a FragmentActivity.   details: null
// (제대로 등록되었을 시 but security 등록 안되었을 시)
// Error code: NotAvailable   message: Required security features not enabled   details: null

// 허용 or not 등록이 한번 뜸 그리고 이 때 plist에 NSFaceIDUsageDescription 등록한 거 뜸
// (앱에서 허용 설정) 설정 - Face ID 및 암호 - 기타 앱 - 선택 후 옵션 켜기
// canCheckBiometrics: true, isDeviceSupported: true, availableBiometrics: [BiometricType.face]
// (변경 상태에서의 앱 설정) 설정 - Face ID 및 암호 - 기타 앱 - 선택 후 옵션 끄기
// canCheckBiometrics: false, isDeviceSupported: true, availableBiometrics: []
// Error code: NotAvailable   message: Biometry is not available.   details: com.apple.LocalAuthentication

// iPhone 12 Pro Max Physical Device (정상 설정 시))
// 바이오 인증 시도 후 취소 or 다시 시도 후 취소
// didAuthenticate => false
// 바이오 두번 시도 후 암호 입력
// Error code: NotAvailable   message: Authentication failure.   details: com.apple.LocalAuthentication

// Pixel 5 API 30 Android Emulator (정상 설정 시)
// 바이오 인증 n 번 시도 후 취소
// didAuthenticate => false
// 바이오 인증 n 번 시도 후 실패
// Error code: LockedOut   Error message: The operation was canceled because the API is locked out due to too many attempts. This occurs after 5 failed attempts, and lasts for 30 seconds.   Error details: null

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
      // 현재 Error code, Erorr message가 불일치하는 경우가 있음. 따라서 에러의 경우 전부 인증 실패로 처리
      // ex: iOS 인증 실패 시 => NotAvailable, Authentication failure., com.apple.LocalAuthentication
      debugPrint(
          "Biometric Authentication Error code: ${e.code}   Error message: ${e.message}   Error details: ${e.details}");
      return false;
    }
  }
}
