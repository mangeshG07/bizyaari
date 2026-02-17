import '../../../utils/exported_path.dart';

@lazySingleton
class HomeGateController extends GetxController {
  final homeController = getIt<HomeController>();
  final locationController = getIt<LocationController>();

  final isReady = false.obs;
  final hasError = false.obs;
  final statusMessage = 'Starting…'.obs;

  @override
  void onInit() {
    super.onInit();
    startFlow();
  }

  Future<void> startFlow() async {
    try {
      if (getIt<SearchNewController>().address.value.isEmpty) {
        statusMessage.value = 'Checking location permission…';

        final permissionGranted = await homeController
            .requestLocationPermission();

        if (!permissionGranted) {
          // 🔹 Fallback to Pune
          statusMessage.value = 'Using default location: Pune';

          locationController.updateLocation(lat: 18.5204, lng: 73.8567);

          getIt<SearchNewController>().getLiveLocation(forcePune: true);
        } else {
          // Permission granted → fetch actual location
          statusMessage.value = 'Getting your location…';
          await locationController.fetchInitialLocation();
          getIt<SearchNewController>().getLiveLocation();
        }

        statusMessage.value = 'Loading nearby data…';
      }

      await homeController.getHomeApi();
      isReady.value = true;
    } catch (e) {
      statusMessage.value = 'Something went wrong. Please try again.';
      hasError.value = true;
    }
  }
}
