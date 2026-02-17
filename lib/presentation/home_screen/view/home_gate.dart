import 'package:businessbuddy/presentation/home_screen/controller/home_gate_controller.dart';
import 'package:businessbuddy/utils/exported_path.dart';

class HomeGateScreen extends StatefulWidget {
  const HomeGateScreen({super.key});

  @override
  State<HomeGateScreen> createState() => _HomeGateScreenState();
}

class _HomeGateScreenState extends State<HomeGateScreen> {
  final controller = getIt<HomeGateController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.startFlow();
    });
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
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
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
          backgroundColor:Theme.of(context).scaffoldBackgroundColor,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const LoadingWidget(color: primaryColor),
                const SizedBox(height: 16),
                Text(
                  controller.statusMessage.value,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
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
