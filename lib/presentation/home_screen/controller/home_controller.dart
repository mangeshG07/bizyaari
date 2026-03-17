import 'package:businessbuddy/utils/exported_path.dart' hide Position;
import 'package:geolocator/geolocator.dart';

@lazySingleton
class HomeController extends GetxController {
  final ApiService _apiService = Get.find();

  final isLoading = false.obs;
  final isMainLoading = false.obs;
  final showNotificationDot = false.obs;
  final isAvailable = false.obs;
  final feedsList = [].obs;
  final categoryList = [].obs;
  final requirementList = [].obs;
  final sliderList = [].obs;

  final _initialApiCalled = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialHome();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestLocationPermission();
    });

    // 🔄 React to location readiness
    final locationController = getIt<LocationController>();

    ever(locationController.isLocationReady, (ready) {
      if (ready == true && _initialApiCalled.value) {
        getHomeApi(showLoading: false);
      }
    });
  }

  Future<void> _loadInitialHome() async {
    isMainLoading.value = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getHomeApi();
    });
    _initialApiCalled.value = true;
    isMainLoading.value = false;
  }

  /// ✅ Permission should NEVER block UI
  Future<bool> requestLocationPermission() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        // _showSnackbar('Location Disabled', 'Please enable location services');
        _showLocationDialog();
        return false;
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        // _showSnackbar(
        //   'Permission Required',
        //   'Location permission is required to continue',
        // );
        return false;
      }

      if (permission == LocationPermission.deniedForever) {
        // _showSnackbar(
        //   'Permission Required',
        //   'Enable location permission from settings',
        // );
        await Geolocator.openAppSettings();
        return false;
      }

      return true; // ✅ permission granted
    } catch (e) {
      // debugPrint('Location permission error: $e');
      return false;
    }
  }

  // void _showLocationDialog() {
  //   if (Get.overlayContext == null) return;
  //   Get.dialog(
  //     Dialog(
  //       insetPadding: const EdgeInsets.all(12),
  //       backgroundColor: Colors.white,
  //       surfaceTintColor: Colors.white,
  //       child: Padding(
  //         padding: const EdgeInsets.all(12),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           // spacing: 12.h,
  //           children: [
  //             HugeIcon(
  //               icon: HugeIcons.strokeRoundedLocationOffline03,
  //               size: 40,
  //             ),
  //             SizedBox(height: 8),
  //             CustomText(
  //               title: "Location permission not enabled",
  //               fontSize: 16.sp,
  //               textAlign: TextAlign.center,
  //               fontWeight: FontWeight.bold,
  //               maxLines: 2,
  //             ),
  //             SizedBox(height: 4),
  //             CustomText(
  //               title:
  //                   "Please enable location permission for a better services to continue",
  //               fontSize: 14.sp,
  //               textAlign: TextAlign.center,
  //               maxLines: 2,
  //             ),
  //             TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
  //             CustomButton(
  //               width: Get.width.w,
  //               backgroundColor: primaryColor,
  //               isLoading: false.obs,
  //               onPressed: () async {
  //                 Get.back();
  //                 await Geolocator.openLocationSettings();
  //               },
  //               text: 'Open Settings',
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  void _showLocationDialog() {
    if (Get.overlayContext == null) return;

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.all(20),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated icon container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedLocationOffline03,
                    size: 48,
                    color: primaryColor,
                  ),
                ),

                const SizedBox(height: 20),

                // Title with better typography
                Text(
                  "Location Access Required",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // Description with improved readability
                Text(
                  "To provide you with the best experience and accurate services, we need access to your location.",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black54,
                    height: 1.5,
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.center,
                ),

                Column(
                  spacing: 12.h,
                  children: [
                    Divider(),

                    GestureDetector(
                      onTap: () async {
                        Get.back();
                        await Geolocator.openLocationSettings();
                      },
                      child: Text(
                        "Open Settings",
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    Divider(),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Text(
                        "Not Now",
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🛡 Safe Snackbar Wrapper
  void _showSnackbar(String title, String message) {
    if (Get.overlayContext != null) {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> getHomeApi({bool showLoading = true}) async {
    final locationController = getIt<LocationController>();

    final hasLocation = locationController.isLocationReady.value;

    final latLng = hasLocation
        ? '${locationController.latitude.value},${locationController.longitude.value}'
        : '18.5204,73.8567';

    // final lat = getIt<LocationController>().latitude.value.toString();
    // final lng = getIt<LocationController>().longitude.value.toString();

    if (showLoading) isLoading.value = true;

    try {
      final userId = await LocalStorage.getString('user_id') ?? '';

      final response = await _apiService.getHome(latLng, userId);

      if (response['common']['status'] == true) {
        final data = response['data'] ?? {};
        isAvailable.value = response['common']['no_data_found'] ?? false;
        feedsList.value = data['feeds'] ?? [];
        categoryList.value = data['categories'] ?? [];
        requirementList.value = data['business_requirements'] ?? [];
        sliderList.value = data['sliders'] ?? [];
        showNotificationDot.value = data['show_notification'] ?? false;
      } else {
        isAvailable.value = response['common']['no_data_found'] ?? false;
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }
}
