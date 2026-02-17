class ChatMessage {
  final String senderId;
  final String message;
  final DateTime time;

  ChatMessage({
    required this.senderId,
    required this.message,
    required this.time,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      senderId: json['senderId'],
      message: json['message'],
      time: DateTime.parse(json['time']),
    );
  }
}
