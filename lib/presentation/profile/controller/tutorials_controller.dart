import 'package:businessbuddy/utils/exported_path.dart';

@lazySingleton
class TutorialsController extends GetxController {
  final ApiService _apiService = Get.find();
  final isLoadMore = false.obs;
  final isLoading = false.obs;
  int currentPage = 1;
  int totalPages = 1;
  int perPage = 10;
  bool hasMore = true;
  final tutorialList = [].obs;

  Future<void> getTutorials({
    bool showLoading = true,
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      currentPage = 1;
      totalPages = 1;
      hasMore = true;
      tutorialList.clear();
    }

    currentPage == 1 ? isLoading.value = showLoading : isLoadMore.value = true;
    try {
      final response = await _apiService.getTutorials(currentPage.toString());
      if (response['common']['status'] == true) {
        final data = response['data'];

        final List list = data['tutorials'] ?? [];

        perPage = data['per_page'] ?? perPage;
        totalPages = data['total_pages'] ?? totalPages;

        /// 🔹 IMPORTANT
        if (isRefresh || currentPage == 1) {
          tutorialList.assignAll(list); // 🔥 replaces list
        } else {
          tutorialList.addAll(list); // pagination
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
}
