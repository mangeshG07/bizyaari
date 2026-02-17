import 'package:businessbuddy/network/all_url.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  late IO.Socket socket;

  void connect({required String userId}) {
    socket = IO.io(
      AllUrl.chatList,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setQuery({'user_id': userId})
          .build(),
    );

    socket.connect();
  }

  void on(String event, Function(dynamic) callback) {
    socket.on(event, callback);
  }

  void emit(String event, dynamic data) {
    socket.emit(event, data);
  }

  void disconnect() {
    socket.disconnect();
    socket.dispose();
  }
}
