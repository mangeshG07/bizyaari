import 'package:businessbuddy/utils/exported_path.dart';

@lazySingleton
class SpecialOfferController extends GetxController {
  final ApiService _apiService = Get.find();
  final isLoading = false.obs;
  final isApply = false.obs;
  final offerList = [].obs;
  final address = ''.obs;
  final addressList = [].obs;
  final addressController = TextEditingController();
  final lat = ''.obs;
  final lng = ''.obs;
  final isLoadMore = false.obs;
  int currentPage = 1;
  int totalPages = 1;
  int perPage = 10;
  bool hasMore = true;

  Future<void> getSpecialOffer({
    bool showLoading = true,
    bool isRefresh = false,
  }) async {
    if (isRefresh == true) {
      // print('in refresh');
      currentPage = 1;
      totalPages = 1;
      hasMore = true;
      offerList.clear();
    }

    currentPage == 1 ? isLoading.value = showLoading : isLoadMore.value = true;

    final userId = await LocalStorage.getString('user_id') ?? '';
    final latitude = getIt<LocationController>().latitude.value.toString();
    final longitude = getIt<LocationController>().longitude.value.toString();
    final String location = lat.value.isNotEmpty && lng.value.isNotEmpty
        ? '${lat.value},${lng.value}'
        : '';
    try {
      final response = await _apiService.getSpecialOffer(
        userId,
        selectedCategory.value,
        selectedDateRange.value,
        '$latitude,$longitude',
        location,
        currentPage.toString(),
      );
      // print('response');
      // print(response);
      if (response['common']['status'] == true) {
        final data = response['data'];

        final List list = data['special_offers'] ?? [];

        perPage = data['per_page'] ?? perPage;
        totalPages = data['total_pages'] ?? totalPages;

        /// 🔹 IMPORTANT
        if (isRefresh || currentPage == 1) {
          offerList.assignAll(list); // 🔥 replaces list
        } else {
          offerList.addAll(list); // pagination
        }

        /// 👇 backend-accurate pagination check
        hasMore = currentPage < totalPages;

        if (hasMore) currentPage++;

        // {
        //   feedList.value = response['data'] ?? [];
      }
      // if (response['common']['status'] == true) {
      //   offerList.value = response['data'] ?? [];
      // }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  ///////////////////////////////////////////filter//////////////////////////////////
  final selectedCategory = RxnString();

  final locations = ["Pune", "Mumbai", "Nagpur", "Delhi", "Bangalore"].obs;
  final selectedLocation = RxnString();

  final selectedDateRange = RxnString();
  DateTime? customStart, customEnd;

  Future<void> pickCustomDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: Get.context!,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      currentDate: DateTime.now(),
      saveText: 'Select',
    );

    if (picked != null) {
      customStart = picked.start;
      customEnd = picked.end;
      selectedDateRange.value =
          "${_formatDate(picked.start)},${_formatDate(picked.end)}";
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  void resetData() {
    selectedCategory.value = null;
    selectedLocation.value = null;
    customStart = null;
    customEnd = null;
    selectedDateRange.value = null;
    isApply.value = false;
    lat.value = '';
    lng.value = '';
    address.value = '';
    addressList.clear();
    addressController.clear();
  }
}
