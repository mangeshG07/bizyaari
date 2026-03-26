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
    controller.initialize();
  }

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
                duration: controller.transitionDuration,
                curve: Curves.fastOutSlowIn,
                style: TextStyle(
                  color: Theme.of(context).splashColor,
                  fontSize: !controller.expanded.value
                      ? controller.bigFontSize
                      : 50,
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
    return Image.asset(Images.logoText, width: Get.width * 0.6.w);
    // return Image.network('http://192.168.29.37/flutter_splash/public/uploads/splash/flutter_splash.gif', width: Get.width * 0.9.h);
  }
}
