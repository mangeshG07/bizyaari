import 'package:geolocator/geolocator.dart';
import '../../../utils/exported_path.dart';

@lazySingleton
class HomeGateController extends GetxController {
  final homeController = getIt<HomeController>();
  final locationController = getIt<LocationController>();
  final searchController = getIt<SearchNewController>();

  final isReady = false.obs;
  final hasError = false.obs;
  final statusMessage = 'Starting…'.obs;

  Future<void> startFlow() async {
    try {
      if (searchController.address.value.isEmpty) {
        statusMessage.value = "Checking location permission...";

        final permissionGranted = await locationController
            .requestLocationPermission();

        if (!permissionGranted) {
          /// fallback Pune
          PopupManager().add(AllDialogs().showLocationDialog);

          statusMessage.value = "Using default location: Pune";

          locationController.updateLocation(lat: 18.5204, lng: 73.8567);
          searchController.getLiveLocation(forcePune: true);
        } else {
          statusMessage.value = "Getting your location...";

          await locationController.fetchInitialLocation();
          searchController.getLiveLocation();
        }

        statusMessage.value = "Loading nearby data...";
        await homeController.getHomeApi();

        PopupManager().add(checkInternetAndShowPopup);
        PopupManager().add(getIt<UpdateController>().checkForUpdate);
        PopupManager().add(homeController.showAlertSheet);

        /// ✅ 🔥 ADD SHOWCASE AT LAST
        PopupManager().add(() async {
          final isDone = await LocalStorage.getBool('intro_done') ?? false;

          if (!isDone) {
            final navController = getIt<NavigationController>();

            /// wait UI ready
            await Future.delayed(const Duration(milliseconds: 500));

            navController.startTopShowcase();
          }
        });

        /// Optional: wait before showing UI
        await PopupManager().waitUntilDone();
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

      searchController.getLiveLocation();

      await homeController.getHomeApi();
    }
  }
}
