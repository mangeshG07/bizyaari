import 'package:businessbuddy/utils/exported_path.dart' hide Position;

@lazySingleton
class FeedsController extends GetxController {
  final ApiService _apiService = Get.find();
  final isLoading = false.obs;
  final isFollowProcessing = false.obs;
  final isLikeProcessing = false.obs;
  final feedList = [].obs;

  final isLoadMore = false.obs;
  int currentPage = 1;
  int totalPages = 1;
  int perPage = 10;
  bool hasMore = true;

  Future<void> getFeeds({
    bool showLoading = true,
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      currentPage = 1;
      totalPages = 1;
      hasMore = true;
      feedList.clear();
    }

    currentPage == 1 ? isLoading.value = showLoading : isLoadMore.value = true;

    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final lat = getIt<LocationController>().latitude.value.toString();
      final lng = getIt<LocationController>().longitude.value.toString();

      final String location =
          getIt<SpecialOfferController>().lat.value.isNotEmpty &&
              getIt<SpecialOfferController>().lng.value.isNotEmpty
          ? '${getIt<SpecialOfferController>().lat.value},${getIt<SpecialOfferController>().lng.value}'
          : '';
      // print('location============<$location');
      // print('lat============<${'$lat,$lng'}');
      // print('userId============<$userId');
      final response = await _apiService.getFeeds(
        '$lat,$lng',
        userId,
        getIt<SpecialOfferController>().selectedCategory.value,
        getIt<SpecialOfferController>().selectedDateRange.value,
        location,
        currentPage.toString(),
      );

      if (response['common']['status'] == true) {
        final data = response['data'];

        final List list = data['feeds'] ?? [];

        perPage = data['per_page'] ?? perPage;
        totalPages = data['total_pages'] ?? totalPages;

        /// 🔹 IMPORTANT
        if (isRefresh || currentPage == 1) {
          feedList.assignAll(list); // 🔥 replaces list
        } else {
          feedList.addAll(list); // pagination
        }

        /// 👇 backend-accurate pagination check
        hasMore = currentPage < totalPages;

        if (hasMore) currentPage++;
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isLoading.value = false;
      isLoadMore.value = false;
    }
  }

  void updateFollowStatusForBusiness({
    required String businessId,
    required bool isFollowed,
  }) {
    for (var item in feedList) {
      if (item['business_id'].toString() == businessId) {
        item['is_followed'] = isFollowed;
      }
    }
    update();
    feedList.refresh();
  }

  final followingLoadingMap = <String, bool>{}.obs;

  Future<void> followBusiness(
    String businessId, {
    bool showLoading = true,
  }) async {
    followingLoadingMap[businessId] = true;
    followingLoadingMap.refresh();
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.followBusiness(userId, businessId);

      if (response['common']['status'] == true) {
        await getFeeds(showLoading: false);
        ToastUtils.showSuccessToast(response['common']['message']);
      } else {
        ToastUtils.showWarningToast(response['common']['message']);
      }
    } catch (e) {
      showError(e);
    } finally {
      followingLoadingMap[businessId] = false;
      followingLoadingMap.refresh();
    }
  }

  Future<void> unfollowBusiness(
    String followId, {
    bool showLoading = true,
  }) async {
    followingLoadingMap[followId] = true;
    followingLoadingMap.refresh();

    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.unfollowBusiness(userId, followId);

      if (response['common']['status'] == true) {
        await getFeeds(showLoading: false);
        ToastUtils.showSuccessToast(response['common']['message']);
      } else {
        ToastUtils.showWarningToast(response['common']['message']);
      }
    } catch (e) {
      showError(e);
    } finally {
      followingLoadingMap[followId] = false;
      followingLoadingMap.refresh();
    }
  }

  final likeLoadingMap = <String, bool>{}.obs;

  Future<void> likeBusiness(
    String businessId,
    String postId, {
    bool showLoading = true,
  }) async {
    likeLoadingMap[postId] = true;
    likeLoadingMap.refresh();
    // print('businessId==========================>$businessId');
    // print('postId==========================>$postId');

    final userId = await LocalStorage.getString('user_id') ?? '';
    // print('userId==========================>$userId');
    try {
      final response = await _apiService.likeBusiness(
        userId,
        businessId,
        postId,
      );
      // print('like response==========================>$response');
      if (response['common']['status'] == true) {
        ToastUtils.showSuccessToast(response['common']['message']);
      } else {
        ToastUtils.showWarningToast(response['common']['message']);
      }
    } catch (e) {
      showError(e);
    } finally {
      likeLoadingMap[postId] = false;
      likeLoadingMap.refresh();
    }
  }

  bool isPostLikeLoading(String postId) {
    return likeLoadingMap[postId] ?? false;
  }

  void setPostLikeLoading(String postId, bool value) {
    likeLoadingMap[postId] = value;
  }

  Future<void> unLikeBusiness(String likeId, {bool showLoading = true}) async {
    likeLoadingMap[likeId] = true;
    likeLoadingMap.refresh();

    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.unlikeBusiness(userId, likeId);
      // print('unLikeBusiness response==========================>$response');
      if (response['common']['status'] == true) {
        ToastUtils.showSuccessToast(response['common']['message']);
      } else {
        ToastUtils.showWarningToast(response['common']['message']);
      }
    } catch (e) {
      showError(e);
    } finally {
      likeLoadingMap[likeId] = false;
      likeLoadingMap.refresh();
    }
  }

  /////////////////////////////////////////////offer Like//////////////////////////////////////
  final offerLikeLoadingMap = <String, bool>{}.obs;

  Future<void> offerLikeBusiness(
    String businessId,
    String offerId, {
    bool showLoading = true,
  }) async {
    offerLikeLoadingMap[offerId] = true;
    offerLikeLoadingMap.refresh();

    // print('like businessId=========>$businessId');
    // print('like offerId=========>$offerId');
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.likeOffer(userId, businessId, offerId);
      // print('offerLikeBusiness response=========>$response');
      if (response['common']['status'] == true) {
        ToastUtils.showSuccessToast(response['common']['message']);
      } else {
        ToastUtils.showWarningToast(response['common']['message']);
      }
    } catch (e) {
      showError(e);
    } finally {
      offerLikeLoadingMap[offerId] = false;
      offerLikeLoadingMap.refresh();
    }
  }

  Future<void> offerUnLikeBusiness(
    String likeId, {
    bool showLoading = true,
  }) async {
    offerLikeLoadingMap[likeId] = true;
    offerLikeLoadingMap.refresh();
    // print('offerUnLikeBusiness likeId=========>$likeId');
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.unlikeOffer(userId, likeId);
      // print('offerLikeBusiness response=========>$response');
      if (response['common']['status'] == true) {
        ToastUtils.showSuccessToast(response['common']['message']);
      } else {
        ToastUtils.showWarningToast(response['common']['message']);
      }
    } catch (e) {
      showError(e);
    } finally {
      offerLikeLoadingMap[likeId] = false;
      offerLikeLoadingMap.refresh();
    }
  }

  ///////////////////////////////////////comment////////////////////////////////
  final comments = [].obs;
  final postData = {}.obs;
  final isCommentLoading = false.obs;
  final isAddCommentLoading = false.obs;

  final newComment = ''.obs;
  final commentTextController = TextEditingController();

  Future<void> getSinglePost(String postId, {bool showLoading = true}) async {
    if (showLoading) isCommentLoading.value = true;
    postData.clear();
    comments.clear();
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.postDetails(postId, userId);

      if (response['common']['status'] == true) {
        postData.value = response['data'] ?? {};
        comments.value = response['data']['comments'] ?? [];
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isCommentLoading.value = false;
    }
  }

  @override
  void onClose() {
    commentTextController.dispose();
    super.onClose();
  }

  Future<void> addPostComment({bool showLoading = true}) async {
    if (showLoading) isAddCommentLoading.value = true;

    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.addPostComment(
        userId,
        postData['business_id'].toString(),
        postData['id'].toString(),
        commentTextController.text.trim(),
      );

      if (response['common']['status'] == true) {
        newComment.value = '';
        commentTextController.clear();
        await getSinglePost(postData['id'].toString(), showLoading: false);
        ToastUtils.showSuccessToast(response['common']['message']);
      } else {
        ToastUtils.showWarningToast(response['common']['message']);
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isAddCommentLoading.value = false;
    }
  }
}
