import 'package:businessbuddy/presentation/home_screen/widget/explorer/widget/explore_filter.dart';
import 'package:businessbuddy/utils/exported_path.dart';

class CategoryList extends StatefulWidget {
  final String categoryName;
  final String categoryId;

  const CategoryList({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final navController = getIt<NavigationController>();
  final controller = getIt<ExplorerController>();
  final feedsController = getIt<FeedsController>();

  @override
  void initState() {
    controller.getBusinesses(widget.categoryId, isRefresh: true);
    controller.addressController.clear();
    controller.addressList.value = [];
    controller.lat.value = '';
    controller.lng.value = '';
    controller.lng.value = '';
    controller.selectedRatings.clear(); // ⭐
    controller.offerAvailable.value = false; // ⭐
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll is ScrollEndNotification &&
              scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 50 &&
              controller.hastBusinessMore &&
              !controller.isBusinessLoadMore.value &&
              !controller.isBusinessLoading.value) {
            controller.getBusinesses(widget.categoryId);
          }
          return false;
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 40.h),
                  // /// 🔹 Header
                  // Container(
                  //   color: Theme.of(context).scaffoldBackgroundColor,
                  //   padding: EdgeInsets.symmetric(
                  //     horizontal: 8.w,
                  //     vertical: 4.h,
                  //   ),
                  //   child: Row(
                  //     spacing: 8,
                  //     children: [
                  //       GestureDetector(
                  //         onTap: () => navController.goBack(),
                  //         child: Icon(Icons.arrow_back, color: primaryBlack),
                  //       ),
                  //       CustomText(
                  //         title: widget.categoryName,
                  //         fontSize: 18.sp,
                  //         fontWeight: FontWeight.bold,
                  //         color: primaryBlack,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Divider(color: lightGrey),

                  /// 🔹 Category List
                  Obx(() {
                    if (controller.isBusinessLoading.isTrue) {
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        itemCount: 6, // shimmer items
                        itemBuilder: (_, i) => CatItemCardShimmer(),
                      );
                    }

                    /// 🔹 Empty State
                    if (controller.businessList.isEmpty) {
                      return commonNoDataFound();
                    }

                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      itemCount: controller.businessList.length,
                      itemBuilder: (_, i) {
                        final item = controller.businessList[i];
                        return CatItemCard(
                          followersCount:
                              item['followers_count']?.toString() ?? '0',
                          offers: item['offers'] ?? [],
                          latitude: item['latitude'] ?? '',
                          isFollowed: item['is_followed'] ?? false,
                          isSelf: item['self_business'] ?? false,
                          longitude: item['longitude'] ?? '',
                          distance: item['distance']?.toString() ?? '',
                          name: item['name'] ?? '',
                          location: item['address'] ?? '',
                          category: item['category'] ?? '',
                          rating: item['total_rating']?.toString() ?? '0',
                          reviewCount: item['reviews_count']?.toString() ?? '0',
                          offerText: '${item['offers_count']} Offers ',
                          phoneNumber: item['whatsapp_number'] ?? '',
                          imagePath: item['image'] ?? '',
                          onCall: () {
                            if (!getIt<DemoService>().isDemo) {
                              ToastUtils.showLoginToast();
                              return;
                            }
                            if (item['mobile_number'] != null) {
                              makePhoneCall(item['mobile_number']);
                            }
                          },
                          onTap: () => navController.openSubPage(
                            CategoryDetailPage(
                              title: item['name'] ?? '',
                              businessId: item['id']?.toString() ?? '',
                            ),
                          ),
                          onFollow: () async {
                            if (!getIt<DemoService>().isDemo) {
                              ToastUtils.showLoginToast();
                              return;
                            }
                            if (item['is_followed'] == true) {
                              await feedsController.unfollowBusiness(
                                item['follow_id'].toString(),
                              );
                            } else {
                              await feedsController.followBusiness(
                                item['id'].toString(),
                              );
                            }

                            item['is_followed'] = !item['is_followed'];
                            await controller.getBusinesses(
                              widget.categoryId,
                              showLoading: false,
                            );
                          },
                        );
                      },
                    );
                  }),

                  /// 🔹 Pagination Loader
                  Obx(
                    () => controller.isBusinessLoadMore.value
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: LoadingWidget(color: primaryColor),
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            ),

            /// 🔹 STICKY HEADER (OVERLAY)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 40.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => navController.goBack(),
                            child: Icon(Icons.arrow_back, color: primaryBlack),
                          ),
                          CustomText(
                            title: widget.categoryName,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: primaryBlack,
                          ),
                        ],
                      ),
                    ),
                    _buildFilterButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Enhanced Filter Button Widget
  Widget _buildFilterButton() {
    return Obx(
      () => Container(
        margin: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: getIt<SpecialOfferController>().isApply.isTrue
              ? primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showFilterBottomSheet(),
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedFilter,
                    size: 16.r,
                    color: primaryColor,
                  ),
                  SizedBox(width: 2.w),
                  CustomText(
                    title: 'Filter',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Filter Bottom Sheet Method
  void _showFilterBottomSheet() {
    Get.bottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.grey.withValues(alpha: 0.05),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      ExploreFilter(categoryId: widget.categoryId),
    );
  }
}
