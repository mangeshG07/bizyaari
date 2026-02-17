// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:businessbuddy/common/check_demo.dart' as _i771;
import 'package:businessbuddy/common/global_search_controller.dart' as _i812;
import 'package:businessbuddy/common/live_location.dart' as _i55;
import 'package:businessbuddy/common/location_controller.dart' as _i686;
import 'package:businessbuddy/common/notification_controller.dart' as _i27;
import 'package:businessbuddy/common/update_app.dart' as _i930;
import 'package:businessbuddy/components/mute_controller.dart' as _i396;
import 'package:businessbuddy/network/api_service.dart' as _i889;
import 'package:businessbuddy/presentation/business_partner/controller/partner_controller.dart'
    as _i235;
import 'package:businessbuddy/presentation/home_screen/controller/home_controller.dart'
    as _i103;
import 'package:businessbuddy/presentation/home_screen/controller/home_gate_controller.dart'
    as _i160;
import 'package:businessbuddy/presentation/home_screen/controller/search_controller.dart'
    as _i726;
import 'package:businessbuddy/presentation/home_screen/controller/update_firebase_token.dart'
    as _i757;
import 'package:businessbuddy/presentation/home_screen/widget/business/controller/my_bussiness_controller.dart'
    as _i745;
import 'package:businessbuddy/presentation/home_screen/widget/explorer/controller/explorer_controller.dart'
    as _i481;
import 'package:businessbuddy/presentation/home_screen/widget/feeds/controller/feeds_controller.dart'
    as _i729;
import 'package:businessbuddy/presentation/inbox/controller/inbox_controller.dart'
    as _i655;
import 'package:businessbuddy/presentation/navigation/controller/navigation_controller.dart'
    as _i445;
import 'package:businessbuddy/presentation/onboarding/controller/onboarding_controller.dart'
    as _i736;
import 'package:businessbuddy/presentation/onboarding/controller/splash_controller.dart'
    as _i446;
import 'package:businessbuddy/presentation/profile/controller/profile_controller.dart'
    as _i634;
import 'package:businessbuddy/presentation/profile/controller/tutorials_controller.dart'
    as _i592;
import 'package:businessbuddy/presentation/special_offer/controller/special_offer_controller.dart'
    as _i68;
import 'package:businessbuddy/utils/theme_controller.dart' as _i1040;
import 'package:businessbuddy/utils/video_player_controller.dart' as _i557;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i771.DemoService>(() => _i771.DemoService());
    gh.lazySingleton<_i812.GlobalSearchController>(
      () => _i812.GlobalSearchController(),
    );
    gh.lazySingleton<_i55.LocationService>(() => _i55.LocationService());
    gh.lazySingleton<_i27.NotificationController>(
      () => _i27.NotificationController(),
    );
    gh.lazySingleton<_i930.UpdateController>(() => _i930.UpdateController());
    gh.lazySingleton<_i396.GlobalVideoMuteController>(
      () => _i396.GlobalVideoMuteController(),
    );
    gh.lazySingleton<_i235.PartnerDataController>(
      () => _i235.PartnerDataController(),
    );
    gh.lazySingleton<_i103.HomeController>(() => _i103.HomeController());
    gh.lazySingleton<_i160.HomeGateController>(
      () => _i160.HomeGateController(),
    );
    gh.lazySingleton<_i726.SearchNewController>(
      () => _i726.SearchNewController(),
    );
    gh.lazySingleton<_i757.FirebaseTokenController>(
      () => _i757.FirebaseTokenController(),
    );
    gh.lazySingleton<_i745.LBOController>(() => _i745.LBOController());
    gh.lazySingleton<_i481.ExplorerController>(
      () => _i481.ExplorerController(),
    );
    gh.lazySingleton<_i729.FeedsController>(() => _i729.FeedsController());
    gh.lazySingleton<_i655.InboxController>(() => _i655.InboxController());
    gh.lazySingleton<_i445.NavigationController>(
      () => _i445.NavigationController(),
    );
    gh.lazySingleton<_i736.OnboardingController>(
      () => _i736.OnboardingController(),
    );
    gh.lazySingleton<_i446.SplashController>(() => _i446.SplashController());
    gh.lazySingleton<_i634.ProfileController>(() => _i634.ProfileController());
    gh.lazySingleton<_i592.TutorialsController>(
      () => _i592.TutorialsController(),
    );
    gh.lazySingleton<_i68.SpecialOfferController>(
      () => _i68.SpecialOfferController(),
    );
    gh.lazySingleton<_i1040.ThemeController>(() => _i1040.ThemeController());
    gh.factory<_i889.ApiService>(() => _i889.ApiService(gh<_i361.Dio>()));
    gh.lazySingleton<_i686.LocationController>(
      () => _i686.LocationController(gh<_i55.LocationService>()),
    );
    gh.lazySingleton<_i557.VideoPlayerControllerX>(
      () => _i557.VideoPlayerControllerX(gh<String>()),
    );
    return this;
  }
}
