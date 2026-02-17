import '../utils/exported_path.dart';

class DeepLinkController extends GetxController {
  final AppLinks _appLinks = AppLinks();

  @override
  void onInit() {
    super.onInit();
    _initDeepLinks();
  }

  void _initDeepLinks() async {
    try {
      final initialLink = await _appLinks.getInitialLinkString();
      if (initialLink != null) {
        _handleDeepLink(Uri.parse(initialLink.toString()));
      }
    } catch (_) {}

    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) _handleDeepLink(Uri.parse(uri.toString()));
    }, onError: (_) {});
  }

  void _handleDeepLink(Uri uri) {
    if (uri.pathSegments.length < 3) return;

    final type = uri.pathSegments[1];
    final id = uri.pathSegments[2];

    NotificationService.hasHandledNotificationNavigation = true;

    if (type == 'post') {
      Get.to(
        () => InstagramPostView(postId: id, refresh: () {}, isFrom: 'deep'),
      );
    }

    if (type == 'offer') {
      Get.to(
        () => InstagramOfferView(
          offerId: id,
          refresh: () async {},
          isFrom: 'deep',
        ),
      );
    }
  }

  // void _handleDeepLink(String link) {
  //   Uri uri = Uri.parse(link);
  //   String? id;
  //
  //   // ✅ Handle https://maharashtrajagran.com/newsDetails/{id}
  //   if (uri.scheme.startsWith('https') &&
  //       uri.host == 'businessbuddy.deepmindsit.com') {
  //     id = uri.pathSegments.last;
  //     // if (uri.pathSegments.contains("newsDetails")) {
  //     //   id = uri.pathSegments.last;
  //     // }
  //   }
  //   // ✅ Handle custom scheme: mjagran://news/details/{id}
  //   else if (uri.scheme == 'mjagran' &&
  //       uri.pathSegments.isNotEmpty &&
  //       uri.pathSegments.first == "news" &&
  //       uri.pathSegments.length > 2 &&
  //       uri.pathSegments[1] == "details") {
  //     id = uri.pathSegments[2];
  //   }
  //
  //   if (id != null) {
  //     NotificationService.hasHandledNotificationNavigation = true;
  //
  //     // Get.toNamed(Routes.newsDetails, arguments: {'newsId': id});
  //   }
  // }
}
