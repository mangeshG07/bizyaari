import 'package:businessbuddy/utils/exported_path.dart';

@lazySingleton
class GlobalSearchController extends GetxController {
  final ApiService _apiService = Get.find();
  final isLoading = false.obs;
  final searchController = TextEditingController();
  final searchText = ''.obs;
  final businessList = [].obs;
  final categoryList = [].obs;
  final requirementList = [].obs;
  final expertList = [].obs;

  final debouncer = Debouncer(milliseconds: 500);

  void updateSearchText(String value) {
    searchText.value = value;
  }

  bool get isAllListEmpty =>
      categoryList.isEmpty &&
      businessList.isEmpty &&
      requirementList.isEmpty &&
      expertList.isEmpty;

  void clearAllLists() {
    isLoading.value = false;
    searchText.value = '';
    categoryList.clear();
    businessList.clear();
    requirementList.clear();
    expertList.clear();
  }

  Future<void> searchData({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    try {
      final userId = await LocalStorage.getString('user_id') ?? '';
      final response = await _apiService.globalSearch(
        searchController.text.trim(),userId
      );

      if (response['common']['status'] == true) {
        final data = response['data'] ?? {};
        businessList.value = data['businesses'] ?? [];
        categoryList.value = data['categories'] ?? [];
        requirementList.value = data['business_requirements'] ?? [];
        expertList.value = data['expert_users'] ?? [];
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }
}
