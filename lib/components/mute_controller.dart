import 'package:businessbuddy/utils/exported_path.dart';

@lazySingleton
class GlobalVideoMuteController extends GetxController {
  final isMuted = false.obs; // default muted like Instagram
  final isSingleView = false.obs; // default muted like Instagram

  void toggleMute() {
    isMuted.toggle();
  }

  void toggleView() {
    isSingleView.toggle();
  }

  void makeViewFalse() => isSingleView.value = false;
  void makeViewTrue() => isSingleView.value = true;

  void mute() => isMuted.value = true;
  void unmute() => isMuted.value = false;
}
