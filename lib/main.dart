import 'package:businessbuddy/utils/exported_path.dart';

/// Firebase background notification handler
@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  Map<String, dynamic> data = message.data;
  NotificationService().handleNotificationNavigation(data, '');

  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Firebase
  await Firebase.initializeApp();
  NotificationService().init();

  /// Dependency Injection
  await configureDependencies();

  /// Global controllers
  Get.put(DeepLinkController());
  await getIt<DemoService>().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeController = getIt<ThemeController>();

    return ScreenUtilConfig.init(
      context: context,
      child: ToastificationWrapper(
        child: Obx(
          () => AnimatedTheme(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            data: themeController.isDark.value
                ? AppTheme.darkTheme
                : AppTheme.lightTheme,
            child: FeatureDiscovery(
              child: GetMaterialApp(
                title: 'BizYaari',
                debugShowCheckedModeBanner: false,

                /// Routing & bindings
                initialRoute: Routes.splash,
                initialBinding: InitialBindings(),
                getPages: AppRoutes.routes,

                /// Theme configuration
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: ThemeMode.system,

                /// Transitions
                defaultTransition: Transition.fadeIn,
                transitionDuration: const Duration(milliseconds: 300),

                /// Global MediaQuery control
                builder: (context, child) {
                  final mediaQueryData = MediaQuery.of(context);

                  final textScaler = TextScaler.linear(
                    mediaQueryData.textScaler.scale(1.0).clamp(0.8, 1.0),
                  );
                  final newMediaQueryData = mediaQueryData.copyWith(
                    boldText: false,
                    textScaler: textScaler,
                  );
                  return MediaQuery(data: newMediaQueryData, child: child!);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
