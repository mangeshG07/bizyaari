import 'dart:io';
import 'package:businessbuddy/utils/exported_path.dart' hide Position;
import 'package:intl/intl.dart';

@lazySingleton
class LBOController extends GetxController {
  final ApiService _apiService = Get.find();
  final navController = getIt<NavigationController>();

  final currentPostsList = [].obs;
  final currentIndex = 0.obs;
  final currentType = 'post'.obs;

  // Navigation methods
  void goToNextItem() {
    if (currentIndex.value < currentPostsList.length - 1) {
      currentIndex.value++;
      loadCurrentItem();
    }
  }

  void goToPreviousItem() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      loadCurrentItem();
    }
  }

  Future<void> loadCurrentItem() async {
    if (currentPostsList.isEmpty) return;

    final currentItem = currentPostsList[currentIndex.value];
    if (currentType.value == 'post') {
      await getSinglePost(currentItem['id'].toString());
    } else {
      await getSingleOffer(currentItem['id'].toString());
    }
  }

  /// ------------------------
  /// IMAGE PICKER
  /// ------------------------
  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
      }
    } catch (e) {
      showError(e);
    }
  }

  /// ------------------------
  /// BUSINESS LIST
  /// ------------------------
  final isBusinessLoading = false.obs;
  final businessList = <dynamic>[].obs;
  final postList = <dynamic>[].obs;
  final offerList = <dynamic>[].obs;
  final selectedBusinessId = ''.obs;
  final isBusinessApproved = ''.obs;
  final isDetailsLoading = false.obs;
  final businessDetails = {}.obs;
  final tabIndex = 0.obs;

  Future<void> getMyBusinesses({bool showLoading = true}) async {
    if (showLoading) isBusinessLoading.value = true;
    businessList.clear();
    final userId = await LocalStorage.getString('user_id') ?? '';

    try {
      final response = await _apiService.myBusiness(userId);

      if (response['common']['status'] == true) {
        businessList.value = response['data']['businesses'] ?? [];

        if (businessList.isNotEmpty) {
          final firstBusiness = businessList.first;

          postList.value = firstBusiness['posts'] ?? [];
          offerList.value = firstBusiness['offers'] ?? [];
          selectedBusinessId.value = firstBusiness['id'].toString();
          isBusinessApproved.value = firstBusiness['is_business_approved']
              .toString();
        }
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isBusinessLoading.value = false;
    }
  }

  Future<void> getMyBusinessDetails(
    String businessId, {
    bool showLoading = true,
  }) async {
    if (showLoading) isDetailsLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    // businessDetails.clear();
    try {
      final lat = getIt<LocationController>().latitude.value.toString();
      final lng = getIt<LocationController>().longitude.value.toString();
      // Position position = await Geolocator.getCurrentPosition(
      //   desiredAccuracy: LocationAccuracy.high,
      // );
      final response = await _apiService.myBusinessDetails(
        businessId,
        '$lat,$lng',
        userId,
      );
      if (response['common']['status'] == true) {
        businessDetails.value = response['data'] ?? {};
        setBusinessDetails(response['data']);
      }
    } catch (e) {
      ToastUtils.showToast(
        title: 'Something went wrong',
        description: e.toString(),
        type: ToastificationType.error,
        icon: Icons.error,
      );
      // debugPrint("Error: $e");
    } finally {
      if (showLoading) isDetailsLoading.value = false;
    }
  }

  /// ------------------------
  /// ADD NEW BUSINESS
  /// ------------------------
  final profileImage = Rx<File?>(null);
  final businessKey = GlobalKey<FormState>();

  final shopName = TextEditingController();
  // final address = TextEditingController();
  final referCode = TextEditingController();
  final numberCtrl = TextEditingController();
  final whatsappCtrl = TextEditingController();
  final aboutCtrl = TextEditingController();
  final offering = RxnString();
  final attachments = <File>[].obs;
  final oldAttachments = [].obs;
  final selectedBusiness = RxnInt();
  final isAddBusinessLoading = false.obs;
  // final address = ''.obs;
  final addressList = [].obs;
  final addressController = TextEditingController();
  final lat = ''.obs;
  final lng = ''.obs;

  Future<void> addNewBusiness() async {
    isAddBusinessLoading.value = true;

    final userId = await LocalStorage.getString('user_id') ?? '';

    try {
      // Position position = await Geolocator.getCurrentPosition(
      //   desiredAccuracy: LocationAccuracy.high,
      // );
      // final lat = getIt<LocationController>().latitude.value.toString();
      // final lng = getIt<LocationController>().longitude.value.toString();
      final docs = await prepareDocuments(attachments);

      final response = await _apiService.addBusiness(
        userId,
        shopName.text.trim(),
        addressController.text.trim(),
        numberCtrl.text.trim(),
        offering.value,
        aboutCtrl.text.trim(),
        '$lat,$lng',
        whatsappCtrl.text.trim(),
        referCode.text.trim(),
        profileImage: profileImage.value,
        attachment: docs,
      );

      if (response['common']['status'] == true) {
        navController.backToHome();
        clearData();
        ToastUtils.showSuccessToast(response['common']['message'].toString());
      } else {
        ToastUtils.showErrorToast(response['common']['message'].toString());
      }
    } catch (e) {
      showError(e);
    } finally {
      isAddBusinessLoading.value = false;
    }
  }

  Future<void> editBusiness(String businessId) async {
    isAddBusinessLoading.value = true;
    try {
      // final lat = getIt<LocationController>().latitude.value.toString();
      // final lng = getIt<LocationController>().longitude.value.toString();
      final docs = await prepareDocuments(attachments);

      final response = await _apiService.editBusiness(
        businessId,
        shopName.text.trim(),
        addressController.text.trim(),
        numberCtrl.text.trim(),
        offering.value,
        aboutCtrl.text.trim(),
        '$lat,$lng',
        whatsappCtrl.text.trim(),
        List<String>.from(oldAttachments),
        profileImage: profileImage.value,
        attachment: docs,
      );

      if (response['common']['status'] == true) {
        Get.offAllNamed(Routes.mainScreen);
        clearData();
        ToastUtils.showSuccessToast(response['common']['message'].toString());
      } else {
        ToastUtils.showErrorToast(response['common']['message'].toString());
      }
    } catch (e) {
      showError(e);
    } finally {
      isAddBusinessLoading.value = false;
    }
  }

  void clearData() {
    shopName.clear();
    addressController.clear();
    numberCtrl.clear();
    whatsappCtrl.clear();
    aboutCtrl.clear();
    referCode.clear();
    offering.value = null;
    offering.value = null;
    profileImage.value = null;
    attachments.clear();
    addressList.clear();
    lat.value = '';
    lng.value = '';
  }

  void setBusinessDetails(Map<String, dynamic> data) {
    businessDetails.value = data;
    shopName.text = data['name'] ?? '';
    lat.value = data['latitude'] ?? '';
    lng.value = data['longitude'] ?? '';
    addressController.text = data['address'] ?? '';
    numberCtrl.text = data['mobile_number'] ?? '';
    whatsappCtrl.text = data['whatsapp_number'] ?? '';
    offering.value = data['category_id']?.toString();
    aboutCtrl.text = data['about_business'] ?? '';
    oldAttachments.value = data['attachments'] ?? [];
  }

  // void preselectedBusiness({dynamic data}) {
  //   print('businessDetails.data==========>${data}');
  //   print('businessDetails.before==========>${businessDetails}');
  //
  //   businessDetails.value = data ?? businessDetails;
  //   print('businessDetails.after==========>${businessDetails}');
  //   shopName.text = businessDetails['name'] ?? '';
  //   address.text = businessDetails['address'] ?? '';
  //   numberCtrl.text = businessDetails['mobile_number'] ?? '';
  //   offering.value = businessDetails['category_id']?.toString() ?? null;
  //   aboutCtrl.text = businessDetails['about_business'] ?? '';
  //   oldAttachments.value = businessDetails['attachments'] ?? [];
  // }

  /// ------------------------
  /// ADD  NEW POST &&& EDIT POST
  /// ------------------------
  final postImage = Rx<File?>(null);
  final postVideo = Rx<File?>(null);
  final postAbout = TextEditingController();
  final isPostLoading = false.obs;

  Future<void> addNewPost() async {
    isPostLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';

    try {
      final response = await _apiService.addPost(
        userId,
        selectedBusinessId.value,
        postAbout.text.trim(),
        profileImage: postImage.value,
        videoFile: postVideo.value,
      );

      if (response['common']['status'] == true) {
        Get.offAllNamed(Routes.mainScreen);
        ToastUtils.showSuccessToast(response['common']['message'].toString());
      } else {
        ToastUtils.showErrorToast(response['common']['message'].toString());
      }
    } catch (e) {
      showError(e);
    } finally {
      isPostLoading.value = false;
    }
  }

  Future<void> editPost(String postId) async {
    isPostLoading.value = true;

    try {
      final response = await _apiService.editPost(
        postId,
        postAbout.text.trim(),
        profileImage: postImage.value,
        videoFile: postVideo.value,
      );

      if (response['common']['status'] == true) {
        Get.offAllNamed(Routes.mainScreen);
        ToastUtils.showSuccessToast(response['common']['message'].toString());
      } else {
        ToastUtils.showErrorToast(response['common']['message'].toString());
      }
    } catch (e) {
      showError(e);
    } finally {
      isPostLoading.value = false;
    }
  }

  /// ------------------------
  /// ADD NEW OFFER &&& EDIT OFFER
  /// ------------------------
  final offerImage = Rx<File?>(null);
  final offerVideo = Rx<File?>(null);
  final titleCtrl = TextEditingController();
  final startDateCtrl = TextEditingController();
  final endDateCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final highlightCtrl = TextEditingController();
  final points = <String>[].obs;
  final isOfferLoading = false.obs;
  final offerKey = GlobalKey<FormState>();

  Future<void> addNewOffer() async {
    isOfferLoading.value = true;

    final userId = await LocalStorage.getString('user_id') ?? '';

    try {
      final response = await _apiService.addOffer(
        userId,
        selectedBusinessId.value,
        titleCtrl.text.trim(),
        descriptionCtrl.text.trim(),
        startDateCtrl.text.trim(),
        endDateCtrl.text.trim(),
        points,
        profileImage: offerImage.value,
        videoFile: offerVideo.value,
      );

      if (response['common']['status'] == true) {
        clearOfferData();
        Get.offAllNamed(Routes.mainScreen);
        ToastUtils.showSuccessToast(response['common']['message'].toString());
      } else {
        ToastUtils.showErrorToast(response['common']['message'].toString());
      }
    } catch (e) {
      showError(e);
    } finally {
      isOfferLoading.value = false;
    }
  }

  Future<void> editOffer(String offerId) async {
    isOfferLoading.value = true;
    final startDate = formatDate(startDateCtrl.text.trim());
    final endDate = formatDate(endDateCtrl.text.trim());

    try {
      final response = await _apiService.editOffer(
        offerId,
        titleCtrl.text.trim(),
        descriptionCtrl.text.trim(),
        startDate,
        endDate,
        points,
        profileImage: offerImage.value,
        videoFile: offerVideo.value,
      );

      if (response['common']['status'] == true) {
        clearOfferData();
        Get.offAllNamed(Routes.mainScreen);
        ToastUtils.showSuccessToast(response['common']['message'].toString());
      } else {
        ToastUtils.showErrorToast(response['common']['message'].toString());
      }
    } catch (e) {
      showError(e);
    } finally {
      isOfferLoading.value = false;
    }
  }

  String formatDate(String date) {
    if (date.isEmpty || date.contains('-0001')) return '';

    try {
      // Case 1: ISO format → 2025-12-10
      if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date)) {
        return DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
      }

      // Case 2: Readable format → Dec 31, 2025
      final parsed = DateFormat('MMM dd, yyyy').parse(date);
      return DateFormat('yyyy-MM-dd').format(parsed);
    } catch (e) {
      // debugPrint('Date parse error: $e');
      return '';
    }
  }

  void clearOfferData() {
    offerImage.value = null;
    offerVideo.value = null;
    titleCtrl.clear();
    startDateCtrl.clear();
    endDateCtrl.clear();
    descriptionCtrl.clear();
    highlightCtrl.clear();
    points.clear();
  }

  void preselectedOffer(dynamic data) {
    titleCtrl.text = data['offer_name'] ?? '';
    startDateCtrl.text = data['start_date'] ?? '';
    endDateCtrl.text = data['end_date'] ?? '';
    descriptionCtrl.text = data['details'] ?? '';
    points.value = List<String>.from(data['highlight_points'] ?? []);
    offerImage.value = null;
    offerVideo.value = null;
  }

  /// ------------------------
  /// SINGLE POST DETAILS
  /// ------------------------
  final singlePost = <String, dynamic>{}.obs;
  final isSinglePostLoading = false.obs;

  Future<void> getSinglePost(String postId, {bool showLoading = true}) async {
    if (showLoading) isSinglePostLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.postDetails(postId, userId);

      if (response['common']['status'] == true) {
        singlePost.value = response['data'] ?? {};
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isSinglePostLoading.value = false;
    }
  }

  /// ------------------------
  /// SINGLE OFFER DETAILS
  /// ------------------------
  final singleOffer = <String, dynamic>{}.obs;
  final isSingleOfferLoading = false.obs;
  final comments = [].obs;

  Future<void> getSingleOffer(String offerId, {bool showLoading = true}) async {
    if (showLoading) isSingleOfferLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    comments.clear();
    try {
      final response = await _apiService.offerDetails(offerId, userId);

      if (response['common']['status'] == true) {
        singleOffer.value = response['data'] ?? {};
        comments.value = response['data']['comments'] ?? [];
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isSingleOfferLoading.value = false;
    }
  }

  final isOfferCommentLoading = false.obs;

  Future<void> addOfferComment(
    String comment, {
    bool showLoading = true,
  }) async {
    if (showLoading) isOfferCommentLoading.value = true;

    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.addOfferComment(
        userId,
        singleOffer['business_id'].toString(),
        singleOffer['id'].toString(),
        comment,
      );

      if (response['common']['status'] == true) {
        await getSingleOffer(singleOffer['id'].toString(), showLoading: false);
        ToastUtils.showSuccessToast(response['common']['message']);
      } else {
        ToastUtils.showWarningToast(response['common']['message']);
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isOfferCommentLoading.value = false;
    }
  }

  /// ------------------------
  /// COMMON ERROR HANDLER
  /// ------------------------
  ///
  Future<void> deleteBusiness(
    String businessId, {
    bool showLoading = true,
  }) async {
    if (showLoading) isDetailsLoading.value = true;
    try {
      final response = await _apiService.deleteBusiness(businessId);

      if (response['common']['status'] == true) {
        ToastUtils.showSuccessToast(response['common']['message']);
        Get.offAllNamed(Routes.mainScreen);
      } else {
        ToastUtils.showWarningToast(response['common']['message']);
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isDetailsLoading.value = false;
    }
  }
}
