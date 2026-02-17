import 'package:businessbuddy/common/live_location.dart';
import 'package:businessbuddy/utils/exported_path.dart';

@lazySingleton
class LocationController extends GetxController {
  final LocationService _locationService;

  LocationController(this._locationService);

  final RxDouble latitude = 0.0.obs;
  final RxDouble longitude = 0.0.obs;
  final RxBool isLocationReady = false.obs;

  /// ✅ Call at app start
  Future<void> fetchInitialLocation() async {
    if (isLocationReady.value) return;

    try {
      final position = await _locationService.getCurrentLocation();
      if (position == null) return;

      latitude.value = position.latitude;
      longitude.value = position.longitude;
      isLocationReady.value = true;

      await LocalStorage.setString('address_source', 'gps');
    } finally {}
  }

  /// ✅ When user searches a new location
  void updateLocation({required double lat, required double lng}) async {
    latitude.value = lat;
    longitude.value = lng;
    isLocationReady.value = true;

    await LocalStorage.setString('address_source', 'manual');
  }

  Future<bool> get isManual async =>
      await LocalStorage.getString('address_source') == 'manual';
}
