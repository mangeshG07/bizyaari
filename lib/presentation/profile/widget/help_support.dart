import 'package:businessbuddy/utils/exported_path.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarPlain(title: 'Help & Support'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Or use Icon:
            HugeIcon(
              icon: HugeIcons.strokeRoundedCustomerService01,
              size: 150,
              color: primaryColor,
            ),
            const SizedBox(height: 40),

            // Title
            const Text(
              'Need Help?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 20),

            // Description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'If you have any questions, issues, or feedback regarding our app, feel free to reach out to our support team. We\'re here to help!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 40),

            // Email Button
            ElevatedButton.icon(
              onPressed: () =>
                  sendingMails(getIt<ProfileController>().helpMail.value),
              icon: const Icon(Icons.email, color: Colors.white),
              label: const Text(
                'Email Support Team',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
