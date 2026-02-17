import 'package:businessbuddy/presentation/socket/services/socket_events.dart';
import 'package:businessbuddy/presentation/socket/services/socket_service.dart';
import 'package:get/get.dart';
import '../view/chat_model.dart';

class ChatController extends GetxController {
  final SocketService _socketService = SocketService();

  final messages = <ChatMessage>[].obs;
  final isTyping = false.obs;

  final String userId;
  final String roomId;

  ChatController({required this.userId, required this.roomId});

  @override
  void onInit() {
    super.onInit();
    _connectSocket();
  }

  void _connectSocket() {
    _socketService.connect(userId: userId);

    _socketService.on(SocketEvents.connect, (_) {
      _socketService.emit(SocketEvents.joinRoom, {'roomId': roomId});
    });

    _socketService.on(SocketEvents.receiveMessage, (data) {
      messages.add(ChatMessage.fromJson(data));
    });

    _socketService.on(SocketEvents.typing, (_) {
      isTyping.value = true;
      Future.delayed(const Duration(seconds: 2), () {
        isTyping.value = false;
      });
    });
  }

  void sendMessage(String text) {
    final payload = {
      'roomId': roomId,
      'senderId': userId,
      'message': text,
      'time': DateTime.now().toIso8601String(),
    };

    _socketService.emit(SocketEvents.sendMessage, payload);

    messages.add(ChatMessage.fromJson(payload));
  }

  void sendTyping() {
    _socketService.emit(SocketEvents.typing, {'roomId': roomId});
  }

  @override
  void onClose() {
    _socketService.disconnect();
    super.onClose();
  }
}
