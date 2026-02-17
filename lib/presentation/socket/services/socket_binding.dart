import 'package:businessbuddy/presentation/socket/services/socket_chat_controller.dart';
import 'package:get/get.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
          () => ChatController(
        userId: Get.parameters['userId']!,
        roomId: Get.parameters['roomId']!,
      ),
    );
  }
}
