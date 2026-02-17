import 'package:businessbuddy/utils/exported_path.dart';

class SpecialOffer extends StatefulWidget {
  const SpecialOffer({super.key});

  @override
  State<SpecialOffer> createState() => _SpecialOfferState();
}

class _SpecialOfferState extends State<SpecialOffer> {
  final controller = getIt<SpecialOfferController>();
  final _feedController = getIt<FeedsController>();
  final double _headerHeight = 30.h;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
      getIt<GlobalVideoMuteController>().makeViewFalse();
      controller.resetData();
      controller.getSpecialOffer(isRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() {
        /// 🔹 Feeds + Pagination
        return NotificationListener<ScrollNotification>(
          onNotification: (scroll) {
            if (scroll is ScrollEndNotification &&
                scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 50 &&
                controller.hasMore &&
                !controller.isLoadMore.value &&
                !controller.isLoading.value) {
              controller.getSpecialOffer(showLoading: false);
            }
            return false;
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(top: _headerHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    /// 🔹 Feed List
                    controller.isLoading.isTrue
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            itemCount: 5,
                            itemBuilder: (_, i) => const FeedShimmer(),
                          )
                        : controller.offerList.isEmpty
                        ? SizedBox(
                            height: Get.height * 0.5.h,
                            child: commonNoDataFound(),
                          )
                        : AnimationLimiter(
                            child: ListView.builder(
                              shrinkWrap: true,
                              addAutomaticKeepAlives: false,
                              addRepaintBoundaries: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              itemCount: controller.offerList.length,
                              itemBuilder: (_, i) {
                                final item = controller.offerList[i];
                                return AnimationConfiguration.staggeredList(
                                  position: i,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: RepaintBoundary(
                                        child: OfferCard(
                                          followButton: _followButton(i),
                                          data: item,
                                          onRefresh: () async =>
                                              await controller.getSpecialOffer(
                                                showLoading: false,
                                              ),
                                          onLike: () => handleOfferLike(
                                            item,
                                            () async => await controller
                                                .getSpecialOffer(
                                                  showLoading: false,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                    /// 🔹 Pagination Loader
                    Obx(
                      () => controller.isLoadMore.value
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: LoadingWidget(color: primaryColor),
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: _headerHeight,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        title: 'Special Offers',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: primaryBlack,
                      ),
                      _buildFilterButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),

      // Obx(
      //   () => controller.isLoading.isTrue
      //       ? ListView.builder(
      //           padding: EdgeInsets.symmetric(horizontal: 8.w),
      //           itemCount: 5,
      //           itemBuilder: (_, i) => const FeedShimmer(),
      //         )
      //       : controller.offerList.isEmpty
      //       ? commonNoDataFound()
      //       : SingleChildScrollView(
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.end,
      //             mainAxisAlignment: MainAxisAlignment.end,
      //             children: [
      //               Padding(
      //                 padding: EdgeInsets.symmetric(horizontal: 16.w),
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     CustomText(
      //                       title: 'Special Offers',
      //                       fontSize: 18.sp,
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                     _buildFilterButton(),
      //                   ],
      //                 ),
      //               ),
      //               AnimationLimiter(
      //                 child: ListView.builder(
      //                   shrinkWrap: true,
      //                   physics: NeverScrollableScrollPhysics(),
      //                   padding: EdgeInsets.symmetric(horizontal: 8.w),
      //                   itemCount: controller.offerList.length,
      //                   itemBuilder: (_, i) {
      //                     final item = controller.offerList[i];
      //                     return AnimationConfiguration.staggeredList(
      //                       position: i,
      //                       duration: const Duration(milliseconds: 375),
      //                       child: SlideAnimation(
      //                         verticalOffset: 50.0,
      //                         child: FadeInAnimation(
      //                           child: OfferCard(
      //                             data: item,
      //                             onLike: () => handleOfferLike(
      //                               item,
      //                               () async => await controller
      //                                   .getSpecialOffer(showLoading: false),
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //                     );
      //                   },
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      // ),
    );
  }

  Widget _followButton(index) {
    return Obx(() {
      final data = controller.offerList[index];

      if (data['self_business'] == true) return SizedBox();

      final isFollowing = data['is_followed'] == true;

      final key = isFollowing
          ? data['follow_id'].toString()
          : data['business_id'].toString();

      final isLoading =
          key.isNotEmpty && _feedController.followingLoadingMap[key] == true;
      return isLoading
          ? LoadingWidget(color: primaryColor, size: 20.r)
          : GestureDetector(
              onTap: () => _onFollow(data),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: isFollowing
                      ? null
                      : LinearGradient(
                          colors: [
                            primaryColor,
                            primaryColor.withValues(alpha: 0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isFollowing ? lightGrey : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Row(
                  spacing: 4.w,
                  children: [
                    Icon(
                      isFollowing ? Icons.check : Icons.add,
                      size: 14.sp,
                      color: isFollowing ? textLightGrey : Colors.white,
                    ),
                    CustomText(
                      title: isFollowing ? 'Following' : 'Follow',
                      fontSize: 12.sp,
                      color: isFollowing ? textLightGrey : Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            );
    });
  }

  int findFeedIndex(dynamic item) {
    return controller.offerList.indexWhere((e) {
      return e['id'].toString() == item['id'].toString();
    });
  }

  void _onFollow(dynamic item) async {
    if (getIt<DemoService>().isDemo == false) {
      ToastUtils.showLoginToast();
      return;
    }

    final index = findFeedIndex(item);
    if (index == -1) return;

    final isFollowed = controller.offerList[index]['is_followed'] == true;
    if (isFollowed) {
      await _feedController.unfollowBusiness(item['follow_id'].toString());
      _updateFollowStatusForBusiness(
        businessId: item['business_id'].toString(),
        isFollowed: !isFollowed,
      );
    } else {
      await _feedController.followBusiness(item['business_id'].toString());
      _updateFollowStatusForBusiness(
        businessId: item['business_id'].toString(),
        isFollowed: !isFollowed,
      );
    }
  }

  void _updateFollowStatusForBusiness({
    required String businessId,
    required bool isFollowed,
  }) async {
    for (var item in controller.offerList) {
      if (item['business_id'].toString() == businessId) {
        item['is_followed'] = isFollowed;
      }
    }
    controller.offerList.refresh();
    await controller.getSpecialOffer(showLoading: false);
  }

  // Enhanced Filter Button Widget
  Widget _buildFilterButton() {
    return Container(
      margin: EdgeInsets.only(right: 4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: primaryColor.withValues(alpha: 0.1),
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
      const FeedSheet(isFrom: 'offer'),
    );
  }
}
