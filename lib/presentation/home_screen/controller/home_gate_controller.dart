import 'package:geolocator/geolocator.dart';
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
    // start flow after UI ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startFlow();
    });
  }

  Future<void> startFlow() async {
    try {
      if (getIt<SearchNewController>().address.value.isEmpty) {
        statusMessage.value = "Checking location permission...";

        final permissionGranted = await homeController
            .requestLocationPermission();

        if (!permissionGranted) {
          /// fallback Pune
          statusMessage.value = "Using default location: Pune";

          locationController.updateLocation(lat: 18.5204, lng: 73.8567);

          getIt<SearchNewController>().getLiveLocation(forcePune: true);
        } else {
          statusMessage.value = "Getting your location...";

          await locationController.fetchInitialLocation();

          getIt<SearchNewController>().getLiveLocation();
        }

        statusMessage.value = "Loading nearby data...";

        await homeController.getHomeApi();

        isReady.value = true;
      } else {
        await homeController.getHomeApi();
        isReady.value = true;
      }
    } catch (e) {
      hasError.value = true;
      statusMessage.value = "Something went wrong";
    }
  }

  /// Called when user returns from settings
  Future<void> refreshLocationIfGranted() async {
    final permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      statusMessage.value = "Updating your location...";

      await locationController.fetchInitialLocation();

      getIt<SearchNewController>().getLiveLocation();

      await homeController.getHomeApi();
    }
  }
}
