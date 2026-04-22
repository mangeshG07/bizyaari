import 'package:businessbuddy/components/alert_helper.dart';
import 'package:businessbuddy/utils/alert_bottomsheet.dart';
import 'package:businessbuddy/utils/exported_path.dart' hide Position;

@lazySingleton
class HomeController extends GetxController {
  final ApiService _apiService = Get.find();

  final isLoading = false.obs;
  final isMainLoading = false.obs;
  final isAvailable = false.obs;
  final showNotificationDot = false.obs;

  final feedsList = [].obs;
  final categoryList = [].obs;
  final requirementList = [].obs;
  final sliderList = [].obs;
  final cautionData = {}.obs;

  final _initialApiCalled = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialHome();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   requestLocationPermission();
    // });

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

  // /// ✅ Permission should NEVER block UI
  // Future<bool> requestLocationPermission() async {
  //   try {
  //     final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //
  //     if (!serviceEnabled) {
  //       // _showSnackbar('Location Disabled', 'Please enable location services');
  //       PopupManager().add(() async {
  //         AllDialogs().showLocationDialog();
  //       });
  //
  //       return false;
  //     }
  //
  //     var permission = await Geolocator.checkPermission();
  //
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //     }
  //
  //     if (permission == LocationPermission.denied) {
  //       // _showSnackbar(
  //       //   'Permission Required',
  //       //   'Location permission is required to continue',
  //       // );
  //       return false;
  //     }
  //
  //     if (permission == LocationPermission.deniedForever) {
  //       // _showSnackbar(
  //       //   'Permission Required',
  //       //   'Enable location permission from settings',
  //       // );
  //       await Geolocator.openAppSettings();
  //       return false;
  //     }
  //
  //     return true; // ✅ permission granted
  //   } catch (e) {
  //     // debugPrint('Location permission error: $e');
  //     return false;
  //   }
  // }

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

  Future<void> getHomeApi({bool showLoading = true}) async {
    final locationController = getIt<LocationController>();

    final hasLocation = locationController.isLocationReady.value;

    final latLng = hasLocation
        ? '${locationController.latitude.value},${locationController.longitude.value}'
        : '18.5204,73.8567';

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
        cautionData.value = data['caution_message'] ?? {};
        // showAlertSheet(data['caution_message'] ?? {});
      } else {
        isAvailable.value = response['common']['no_data_found'] ?? false;
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> showAlertSheet() async {
    final shouldShow = await AlertHelper.shouldShowAlert();
    if (!shouldShow) return;

    if (shouldShow) {
      await Get.bottomSheet(
        AlertBottomsheet(data: cautionData),
        isDismissible: true,
      );
      await AlertHelper.saveTodayDate();
    }
  }
}
