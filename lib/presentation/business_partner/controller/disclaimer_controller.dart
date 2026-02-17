// import 'package:businessbuddy/utils/disclaimer.dart';
//
// import '../../../utils/exported_path.dart';
//
// @lazySingleton
// class DisclaimerController extends GetxController {
//   static const _key = 'disclaimerAccepted';
//
//   Future<bool?> isAccepted() async {
//     return await LocalStorage.getBool(_key) ?? false;
//   }
//
//   Future<void> saveAccepted() async {
//     await LocalStorage.setBool(_key, true);
//   }
//
//   /// Call this before any critical action
//   Future<bool> confirmDisclaimer() async {
//     final accepted = await isAccepted();
//     if (accepted!) return true;
//
//     final result = await Get.dialog<bool>(
//       DisclaimerDialog(),
//       barrierDismissible: false,
//     );
//
//     if (result == true) {
//       await saveAccepted();
//       return true;
//     }
//     return false;
//   }
//
//   /// Call this in onInit() if you want auto-show on app start
//   Future<void> showDisclaimerIfNeeded() async {
//     // final accepted = await isAccepted();
//     // if (accepted!) return;
//
//     final result = await Get.dialog<bool>(
//       DisclaimerDialog(),
//       barrierDismissible: false,
//     );
//
//     if (result == true) {
//       await saveAccepted();
//     }
//   }
// }
