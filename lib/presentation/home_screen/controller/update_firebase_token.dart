import '../../../utils/exported_path.dart';

@lazySingleton
class FirebaseTokenController extends GetxController {
  final ApiService _apiService = Get.find();

  Future<void> updateToken() async {
    await FirebaseMessaging.instance.deleteToken();
    String? token = await FirebaseMessaging.instance.getToken();
    // print('token firebase---->$token');
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      await _apiService.updateFirebaseToken(
        userId,
        token.toString(),
      );
      // print('updateToken---->$response');
    } catch (e) {
      // ToastUtils.showWarningToast(
      //   'Something went wrong. Please try again later.',
      // );
      // debugPrint("updateToken error: $e");
    }
  }
}
