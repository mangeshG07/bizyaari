import 'package:businessbuddy/utils/exported_path.dart';

@lazySingleton
class SearchNewController extends GetxController {
  final address = ''.obs;
  final addressList = [].obs;
  final addressController = TextEditingController();

  Future<void> getLiveLocation({bool forcePune = false}) async {
    if (forcePune) {
      setPuneLocation();
      return;
    }

    address.value = await updateUserLocation();
  }

  void setPuneLocation() {
    address.value = 'Pune, Maharashtra';
  }
}
