import 'package:flutter/foundation.dart';
import '../../../utils/exported_path.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final controller = getIt<SplashController>();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 1));
      if (NotificationService.hasHandledNotificationNavigation) return;
      controller.expanded.value = true;

      final token = await LocalStorage.getString('auth_key');
      final isOnboarded = await LocalStorage.getBool('isOnboarded');

      bool isConnected = await InternetConnectionChecker.instance.hasConnection;

      if (isConnected) {
        // Get.offAllNamed(Routes.login);
        token != null
            ? Get.offAllNamed(Routes.mainScreen)
            : isOnboarded == true
            ? Get.offAllNamed(Routes.login)
            : Get.offAllNamed(Routes.onboarding);
      } else {
        AllDialogs().noInternetDialog();
      }
    });
  }

  final transitionDuration = const Duration(seconds: 1);
  final double _bigFontSize = kIsWeb ? 234 : 160;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Material(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedDefaultTextStyle(
                duration: transitionDuration,
                curve: Curves.fastOutSlowIn,
                style: TextStyle(
                  color: Theme.of(context).splashColor,
                  fontSize: !controller.expanded.value ? _bigFontSize : 50,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
                child: Image.asset(Images.appIcon, height: 75),
              ),
              AnimatedCrossFade(
                firstCurve: Curves.fastOutSlowIn,
                crossFadeState: !controller.expanded.value
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: controller.transitionDuration,
                firstChild: Container(),
                secondChild: _logoRemainder(),
                alignment: Alignment.centerLeft,
                sizeCurve: Curves.easeInOut,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logoRemainder() {
    return Image.asset(Images.logoText, width: Get.width * 0.6.h);
    // return Image.network('http://192.168.29.37/flutter_splash/public/uploads/splash/flutter_splash.gif', width: Get.width * 0.9.h);
  }
}
