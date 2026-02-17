import '../utils/exported_path.dart';

class ToastUtils {
  static void showSuccessToast(String message, {String title = 'Success'}) {
    ToastUtils.showToast(
      title: title,
      description: message,
      type: ToastificationType.success,
      icon: Icons.check_circle,
    );
  }

  static void showErrorToast(String message, {String title = 'Error'}) {
    ToastUtils.showToast(
      title: title,
      description: message,
      type: ToastificationType.error,
      icon: Icons.error,
    );
  }

  static void showWarningToast(String message, {String title = 'Warning'}) {
    ToastUtils.showToast(
      title: title,
      description: message,
      type: ToastificationType.warning,
      icon: Icons.warning,
    );
  }

  static void showToast({
    required String title,
    String? description,
    ToastificationType type = ToastificationType.info,
    Duration duration = const Duration(seconds: 2),
    ToastificationStyle style = ToastificationStyle.minimal,
    Alignment alignment = Alignment.topCenter,
    IconData? icon,
  }) {
    toastification.show(
      title: Text(title),
      description: description != null ? Text(description) : null,
      type: type,
      style: style,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      alignment: alignment,
      autoCloseDuration: duration,
      icon: icon != null ? Icon(icon) : null,
    );
  }

  static void showLoginToast() {
    toastification.show(
      context: Get.context!,
      type: ToastificationType.error,
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topCenter,
      style: ToastificationStyle.minimal,
      animationDuration: const Duration(milliseconds: 300),
      borderRadius: BorderRadius.circular(12),
      closeButton: ToastCloseButton(),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      showProgressBar: false,
      title: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Please Login.",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "You need to login to use this feature.",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              foregroundColor: Colors.white,
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            onPressed: () {
              toastification.dismissAll();
              Get.offAllNamed(Routes.login);
            },
            child: const Text("Login", style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }

  // final snackBar = SnackBar(
  //   padding: const EdgeInsets.symmetric(horizontal: 5),
  //   content: ListTile(
  //     textColor: Colors.white,
  //     iconColor: Colors.white,
  //     contentPadding: const EdgeInsets.symmetric(horizontal: 5),
  //     dense: true,
  //     leading: const Icon(Icons.person_2),
  //     title: const Text('Please Login.'),
  //     trailing: ElevatedButton(
  //       style: ElevatedButton.styleFrom(
  //         foregroundColor: Colors.white,
  //         backgroundColor: primaryColor,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //       ),
  //       onPressed: () {
  //         Get.offAllNamed(Routes.login);
  //       },
  //       child: const Text('Login'),
  //     ),
  //   ),
  //   backgroundColor: Colors.black.withValues(alpha: 0.5),
  //   duration: const Duration(seconds: 2),
  // );
  // ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
}
