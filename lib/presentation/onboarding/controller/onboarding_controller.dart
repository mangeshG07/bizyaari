import 'dart:io';
import 'package:businessbuddy/utils/exported_path.dart';

@lazySingleton
class OnboardingController extends GetxController {
  final ApiService _apiService = Get.find();
  final loginKey = GlobalKey<FormState>();
  final verifyKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final isVerifyLoading = false.obs;

  final numberController = TextEditingController();
  final otpController = TextEditingController();

  var start = 30.obs;
  Timer? _timer;

  void startTimer() {
    start.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (start.value == 0) {
        timer.cancel();
      } else {
        start.value--;
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  ////////////////////////register User/////////////////////////////
  final registerKey = GlobalKey<FormState>();
  final isRegLoading = false.obs;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  var profileImage = Rx<File?>(null);

  void pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  Future<void> sendOtpApi() async {
    isLoading.value = true;
    try {
      final response = await _apiService.sendOtp(numberController.text.trim());
      if (response['common']['status'] == true) {
        Get.offAllNamed(Routes.verify);
        ToastUtils.showSuccessToast(response['common']['message'].toString());
      } else {
        ToastUtils.showErrorToast(response['common']['message'].toString());
      }
    } catch (e) {
      ToastUtils.showErrorToast('Something went wrong please try later.');
      // debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtpApi() async {
    isVerifyLoading.value = true;
    try {
      final response = await _apiService.verifyOtp(
        numberController.text.trim(),
        otpController.text.trim(),
      );
      if (response['common']['status'] == true) {
        await getIt<DemoService>().updateDemoStatus(
          response['data']['user_details']['auth_key']!.toString(),
        );
        // await LocalStorage.setString(
        //   'auth_key',
        //   response['data']['user_details']['auth_key']?.toString() ?? 'demo',
        // );
        await LocalStorage.setString(
          'user_id',
          response['data']['user_details']['user_id'].toString(),
        );
        await LocalStorage.setString(
          'mobile_no',
          response['data']['user_details']['mobile_number'].toString(),
        );
        numberController.clear();
        otpController.clear();
        getIt<FirebaseTokenController>().updateToken();
        getIt<NavigationController>().updateBottomIndex(0);
        Get.offAllNamed(Routes.mainScreen);
        ToastUtils.showSuccessToast(response['common']['message'].toString());
      } else {
        if (response['common']['message'] == 'Incorrect OTP') {
          ToastUtils.showErrorToast(response['common']['message'].toString());
        } else {
          Get.offAllNamed(Routes.register);
          ToastUtils.showErrorToast(response['common']['message'].toString());
        }
      }
    } catch (e) {
      ToastUtils.showErrorToast('Something went wrong please try later.');
      // debugPrint("Error: $e");
    } finally {
      isVerifyLoading.value = false;
    }
  }

  Future<void> registerApi() async {
    isRegLoading.value = true;
    try {
      final response = await _apiService.register(
        numberController.text.trim(),
        nameController.text.trim(),
        emailController.text.trim(),
        profileImage: profileImage.value,
      );
      if (response['common']['status'] == true) {
        await getIt<DemoService>().updateDemoStatus(
          response['data']['user_details']['auth_key']!.toString(),
        );

        await LocalStorage.setString(
          'auth_key',
          response['data']['user_details']['auth_key']?.toString() ?? 'demo',
        );
        await LocalStorage.setString(
          'mobile_no',
          response['data']['user_details']['mobile_number'].toString(),
        );
        await LocalStorage.setString(
          'user_id',
          response['data']['user_details']['user_id'].toString(),
        );
        getIt<FirebaseTokenController>().updateToken();

        numberController.clear();
        nameController.clear();
        emailController.clear();
        getIt<NavigationController>().updateBottomIndex(0);
        Get.offAllNamed(Routes.mainScreen);
        ToastUtils.showSuccessToast(response['common']['message'].toString());
      } else {
        ToastUtils.showErrorToast(response['common']['message'].toString());
      }
    } catch (e) {
      ToastUtils.showErrorToast('Something went wrong please try later.');
      // debugPrint("Error: $e");
    } finally {
      isRegLoading.value = false;
    }
  }
}
