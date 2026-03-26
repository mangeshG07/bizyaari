import 'package:businessbuddy/utils/exported_path.dart';
import 'package:flutter/foundation.dart';

@lazySingleton
class SplashController extends GetxController {
  final expanded = false.obs;
  final transitionDuration = const Duration(seconds: 1);
  final _isNavigated = false.obs;
  final double bigFontSize = kIsWeb ? 234 : 160;

  Future<void> initialize() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_isNavigated.value) return;

      await Future.delayed(const Duration(seconds: 1));
      if (NotificationService.hasHandledNotificationNavigation) return;

      expanded.value = true;

      final token = (await LocalStorage.getString('auth_key') ?? '').trim();
      final isOnboarded = await LocalStorage.getBool('isOnboarded') ?? false;
      final connectivityResult = await (Connectivity().checkConnectivity());

      if (connectivityResult.contains(ConnectivityResult.none)) {
        AllDialogs().noInternetDialog();
        return;
      }
      if (_isNavigated.value) return;
      _isNavigated.value = true;

      // 🔥 Clean token validation
      final isValidToken =
          token.isNotEmpty && token != "null" && token != "demo";

      // 🔥 Navigation Logic (FIXED ORDER)
      if (isValidToken) {
        print('in Routes.mainScreen');
        Get.offAllNamed(Routes.mainScreen);
      } else if (isOnboarded) {
        print('in Routes.login');
        Get.offAllNamed(Routes.login);
      } else {
        print('in Routes.onboarding');
        Get.offAllNamed(Routes.onboarding);
      }
    });
  }
}
