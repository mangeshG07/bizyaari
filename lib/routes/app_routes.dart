import 'package:businessbuddy/common/global_search.dart';
import '../utils/exported_path.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: Routes.splash, page: () => SplashScreen()),
    GetPage(name: Routes.onboarding, page: () => IntroScreen()),
    GetPage(name: Routes.login, page: () => LoginScreen()),
    GetPage(name: Routes.verify, page: () => VerifyOtpScreen()),
    GetPage(name: Routes.register, page: () => RegisterScreen()),
    GetPage(name: Routes.mainScreen, page: () => NavigationScreen()),
    GetPage(name: Routes.addOffer, page: () => AddOffer()),
    GetPage(name: Routes.editOffer, page: () => EditOffer()),
    GetPage(name: Routes.addPost, page: () => AddPost()),
    GetPage(name: Routes.editPost, page: () => EditPost()),
    GetPage(name: Routes.businessDetails, page: () => BusinessDetails()),
    GetPage(name: Routes.profile, page: () => ProfileScreen()),
    GetPage(name: Routes.editProfile, page: () => EditProfile()),
    GetPage(name: Routes.followingList, page: () => FollowingList()),
    GetPage(name: Routes.editBusiness, page: () => EditBusiness()),
    // GetPage(name: Routes.deleteAccount, page: () => DeleteAccount()),
    GetPage(name: Routes.notificationList, page: () => NotificationList()),
    GetPage(name: Routes.globalSearch, page: () => GlobalSearch()),
    GetPage(name: Routes.followersList, page: () => FollowersList()),
    // GetPage(name: Routes.chat, page: () => ChatView(), binding: ChatBinding()),
    GetPage(name: Routes.tutorials, page: () => TutorialsList()),
    GetPage(name: Routes.helpAndSupport, page: () => HelpSupportScreen()),
    GetPage(name: Routes.blockUserList, page: () => BlockUserList()),
  ];
}
