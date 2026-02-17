// theme_controller.dart
import 'package:businessbuddy/utils/exported_path.dart';

@lazySingleton
class ThemeController extends GetxController {
  final isDark = false.obs;

  void toggleTheme() {
    isDark.toggle();
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
  }
}
