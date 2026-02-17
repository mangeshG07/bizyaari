import 'dart:io';
import 'package:businessbuddy/utils/exported_path.dart';

@lazySingleton
class ProfileController extends GetxController {
  final ApiService _apiService = Get.find();
  final profileImage = Rx<File?>(null);
  final nameCtrl = TextEditingController();
  final aboutCtrl = TextEditingController();
  final educationCtrl = TextEditingController();
  final experienceCtrl = TextEditingController();
  final specialization = RxnString();
  final isLoading = false.obs;
  final isFollowLoading = false.obs;
  final profileDetails = {}.obs;
  final followList = [].obs;
  final isMe = true.obs;
  final isBlocked = false.obs;

  void setPreselected() {
    nameCtrl.text = profileDetails['name'] ?? '';
    aboutCtrl.text = profileDetails['about'] ?? '';
    educationCtrl.text = profileDetails['education'] ?? '';
    experienceCtrl.text = profileDetails['experience']?.toString() ?? '';
    specialization.value =
        profileDetails['specialization_id']?.toString() ?? null;
  }

  Future<void> getProfile({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.getMyProfile(userId);

      if (response['common']['status'] == true) {
        profileDetails.value = response['data'] ?? {};
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> getUserProfile(String userId, {bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    final myId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.getUserProfile(userId, myId);
      if (response['common']['status'] == true) {
        profileDetails.value = response['data'] ?? {};
        isBlocked.value = response['data']['is_block'] ?? false;
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> updateProfile({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.updateProfile(
        userId,
        nameCtrl.text.trim(),
        experienceCtrl.text.trim(),
        educationCtrl.text.trim(),
        specialization.value!,
        aboutCtrl.text.trim(),
        profileImage: profileImage.value,
      );
      if (response['common']['status'] == true) {
        Get.back();
        await getProfile();
        ToastUtils.showSuccessToast(response['common']['message']);
      } else {
        ToastUtils.showWarningToast(response['common']['message']);
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  final isLoadMore = false.obs;
  int currentPage = 1;
  int totalPages = 1;
  int perPage = 10;
  bool hasMore = true;

  Future<void> getFollowList({
    String? user = '',
    bool showLoading = true,
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      currentPage = 1;
      totalPages = 1;
      hasMore = true;
      followList.clear();
    }

    currentPage == 1
        ? isFollowLoading.value = showLoading
        : isLoadMore.value = true;
    final userId = await LocalStorage.getString('user_id');
    try {
      final response = await _apiService.getFollowList(
        user ?? userId,
        currentPage.toString(),
      );
      if (response['common']['status'] == true) {
        final data = response['data'];

        final List list = data['businesses'] ?? [];

        perPage = data['per_page'] ?? perPage;
        totalPages = data['total_pages'] ?? totalPages;

        /// 🔹 IMPORTANT
        if (isRefresh || currentPage == 1) {
          followList.assignAll(list); // 🔥 replaces list
        } else {
          followList.addAll(list); // pagination
        }

        /// 👇 backend-accurate pagination check
        hasMore = currentPage < totalPages;

        if (hasMore) currentPage++;
      }
      // if (response['common']['status'] == true) {
      //   followList.value = response['data']['businesses'] ?? [];
      // }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isFollowLoading.value = false;
      isLoadMore.value = false;
    }
  }

  ///////////////////////////////Legal Page//////////////////////////////////////

  final legalPageList = [].obs;
  final legalPageDetails = {}.obs;
  final legalLoading = false.obs;
  final detailsLoading = false.obs;

  Future<void> legalPageListApi({bool showLoading = true}) async {
    if (showLoading) legalLoading.value = true;

    try {
      final response = await _apiService.legalPageList();

      if (response['common']['status'] == true) {
        legalPageList.value = response['data']['pages'] ?? [];
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) legalLoading.value = false;
    }
  }

  Future<void> legalPageDetailsApi(
    String slug, {
    bool showLoading = true,
  }) async {
    if (showLoading) detailsLoading.value = true;

    try {
      final response = await _apiService.legalPageDetails(slug);

      if (response['common']['status'] == true) {
        legalPageDetails.value = response['data'] ?? {};
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) detailsLoading.value = false;
    }
  }

  /////////////////////////delete profile///////////////////////////////
  Future<void> deleteProfile({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.deleteAccount(userId);

      if (response['common']['status'] == true) {
        ToastUtils.showSuccessToast(response['common']['message']);
        await LocalStorage.clear();
        Get.offAllNamed(Routes.login);
      } else {
        ToastUtils.showWarningToast(response['common']['message']);
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  /////////////////////////followers List/////////////////////////
  final isFollowerLoading = false.obs;
  final isFollowLoadMore = false.obs;
  int currentFollowPage = 1;
  int totalFollowPages = 1;
  int perFollowPage = 10;
  bool hasFollowMore = true;
  final followersList = [].obs;

  Future<void> getFollowersList({
    String? businessId = '',
    bool showLoading = true,
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      currentFollowPage = 1;
      totalFollowPages = 1;
      hasFollowMore = true;
      followersList.clear();
    }

    currentFollowPage == 1
        ? isFollowerLoading.value = showLoading
        : isFollowLoadMore.value = true;
    try {
      final response = await _apiService.getFollowersList(
        businessId,
        currentFollowPage.toString(),
      );
      if (response['common']['status'] == true) {
        final data = response['data'];

        final List list = data['followers'] ?? [];

        perFollowPage = data['per_page'] ?? perFollowPage;
        totalFollowPages = data['total_pages'] ?? totalFollowPages;

        /// 🔹 IMPORTANT
        if (isRefresh || currentFollowPage == 1) {
          followersList.assignAll(list); // 🔥 replaces list
        } else {
          followersList.addAll(list); // pagination
        }

        /// 👇 backend-accurate pagination check
        hasFollowMore = currentFollowPage < totalFollowPages;

        if (hasFollowMore) currentFollowPage++;
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isFollowerLoading.value = false;
      isFollowLoadMore.value = false;
    }
  }

  //////////////////////////////////////////help and support////////////////////////////////////////
  final isHelpLoading = false.obs;
  final helpMail = ''.obs;

  Future<void> helpAndSupport({bool showLoading = true}) async {
    if (showLoading) isHelpLoading.value = true;

    try {
      final response = await _apiService.helpAndSupport();

      if (response['common']['status'] == true) {
        helpMail.value = response['data']['email'] ?? '';
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isHelpLoading.value = false;
    }
  }

  Future<void> blockUser(String otherUserId, {bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.blockUser(userId, otherUserId);

      if (response['common']['status'] == true) {
        ToastUtils.showSuccessToast(response['common']['message']);
        await getUserProfile(otherUserId);
      } else {
        ToastUtils.showWarningToast(response['common']['message']);
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  ///////////////////////block User list///////////////////////////////

  final isBlockListLoading = false.obs;
  final blockList = [].obs;
  final isBlockLoading = false.obs;
  final isBlockLoadMore = false.obs;
  int currentBlockPage = 1;
  int totalBlockPages = 1;
  int perBlockPage = 10;
  bool hasBlockMore = true;

  Future<void> getBlockList({
    bool showLoading = true,
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      currentBlockPage = 1;
      totalBlockPages = 1;
      hasBlockMore = true;
      blockList.clear();
    }

    currentBlockPage == 1
        ? isBlockListLoading.value = showLoading
        : isBlockLoadMore.value = true;
    try {
      final userId = await LocalStorage.getString('user_id') ?? '';
      final response = await _apiService.blockUserList(
        userId,
        currentBlockPage.toString(),
      );
      if (response['common']['status'] == true) {
        final data = response['data'];

        final List list = data['blocked_users'] ?? [];

        perBlockPage = data['per_page'] ?? perBlockPage;
        totalBlockPages = data['total_pages'] ?? totalBlockPages;

        /// 🔹 IMPORTANT
        if (isRefresh || currentBlockPage == 1) {
          blockList.assignAll(list); // 🔥 replaces list
        } else {
          blockList.addAll(list); // pagination
        }

        /// 👇 backend-accurate pagination check
        hasBlockMore = currentBlockPage < totalBlockPages;

        if (hasBlockMore) currentBlockPage++;
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isBlockListLoading.value = false;
      isBlockLoadMore.value = false;
    }
  }

  /////////////////////////////////////////////////send chat request////////////////////////////////////////////////
  final chatReqLoading = false.obs;

  Future<void> sendChatReq(
    String otherUserId, {
    bool showLoading = true,
  }) async {
    if (showLoading) chatReqLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.sendChatRequest(userId, otherUserId);

      if (response['common']['status'] == true) {
        ToastUtils.showSuccessToast(response['common']['message']);
        await getUserProfile(otherUserId);
      } else {
        ToastUtils.showWarningToast(response['common']['message']);
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) chatReqLoading.value = false;
    }
  }
}
