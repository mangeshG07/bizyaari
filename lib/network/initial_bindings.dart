import '../utils/exported_path.dart';
import 'get_dio.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    final dio = DioClient.getInstance();
    Get.put(GlobalVideoMuteController(), permanent: true);
    Get.put<ApiService>(ApiService(dio), permanent: true);
    Get.lazyPut<NavigationController>(
      () => NavigationController(),
      fenix: true,
    );
  }
}
