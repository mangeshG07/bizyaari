import 'package:businessbuddy/presentation/socket/services/socket_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatView extends GetView<ChatController> {
  final TextEditingController _textCtrl = TextEditingController();

  ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.messages.length,
                itemBuilder: (_, i) {
                  final msg = controller.messages[i];
                  return Align(
                    alignment: msg.senderId == controller.userId
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(msg.message),
                    ),
                  );
                },
              ),
            ),
          ),

          Obx(
            () => controller.isTyping.value
                ? const Text("Typing...")
                : const SizedBox(),
          ),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textCtrl,
                  onChanged: (_) => controller.sendTyping(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  if (_textCtrl.text.trim().isNotEmpty) {
                    controller.sendMessage(_textCtrl.text.trim());
                    _textCtrl.clear();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
