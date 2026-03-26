import 'package:businessbuddy/utils/exported_path.dart';

class HomeGateScreen extends StatefulWidget {
  const HomeGateScreen({super.key});

  @override
  State<HomeGateScreen> createState() => _HomeGateScreenState();
}

class _HomeGateScreenState extends State<HomeGateScreen>
    with WidgetsBindingObserver {
  final controller = getIt<HomeGateController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.startFlow();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      controller.refreshLocationIfGranted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.hasError.value) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_off,
                    size: 48,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.statusMessage.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      controller.hasError.value = false;
                      controller.startFlow();
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      if (!controller.isReady.value) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const LoadingWidget(color: primaryColor),
                const SizedBox(height: 16),
                Text(
                  controller.statusMessage.value,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      }

      return const HomeScreen();
    });
  }
}
