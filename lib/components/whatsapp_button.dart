import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class WhatsAppButton extends StatelessWidget {
  final String phone;
  final String message;
  final Widget child;

  const WhatsAppButton({
    super.key,
    required this.phone,
    this.message = '',
    required this.child,
  });

  Future<void> _openWhatsApp() async {
    final formattedPhone = phone.replaceAll('+', '');
    final uri = Uri.parse(
      'https://wa.me/$formattedPhone?text=${Uri.encodeComponent(message)}',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error',
        'WhatsApp not installed',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: _openWhatsApp, child: child);
  }
}
