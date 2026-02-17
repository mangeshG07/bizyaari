import 'package:businessbuddy/utils/exported_path.dart';

class NewFeed extends StatefulWidget {
  const NewFeed({super.key});

  @override
  State<NewFeed> createState() => _NewFeedState();
}

class _NewFeedState extends State<NewFeed> {
  final controller = getIt<FeedsController>();
  final double _headerHeight = 30.h;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
      getIt<GlobalVideoMuteController>().makeViewFalse();
      getIt<SpecialOfferController>().resetData();
      controller.getFeeds(isRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      /// 🔹 Initial Loading (Shimmer)
      if (controller.isLoading.isTrue) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          itemCount: 5,
          itemBuilder: (_, i) => const FeedShimmer(),
        );
      }

      /// 🔹 Empty State
      if (controller.feedList.isEmpty) {
        return commonNoDataFound(isHome: true);
      }

      /// 🔹 Feeds + Pagination
      return NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll is ScrollEndNotification &&
              scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 50 &&
              controller.hasMore &&
              !controller.isLoadMore.value &&
              !controller.isLoading.value) {
            controller.getFeeds(showLoading: false);
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
                  Obx(
                    () => AnimationLimiter(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        itemCount: controller.feedList.length,
                        itemBuilder: (_, i) {
                          final item = controller.feedList[i];

                          return AnimationConfiguration.staggeredList(
                            position: i,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50,
                              child: FadeInAnimation(
                                child: item['type'] == 'offer'
                                    ? OfferCard(
                                        // key: ValueKey(item['id'].toString()),
                                        data: item,
                                        onRefresh: () async => await controller
                                            .getFeeds(showLoading: false),
                                        onLike: () => handleOfferLike(
                                          item,
                                          () async => await controller.getFeeds(
                                            showLoading: false,
                                            isRefresh: false,
                                          ),
                                        ),
                                        onFollow: () async {
                                          // if (getIt<DemoService>().isDemo ==
                                          //     false) {
                                          //   ToastUtils.showLoginToast();
                                          //   return;
                                          // }
                                          // if (item['is_followed'] == true) {
                                          //   await controller.unfollowBusiness(
                                          //     item['follow_id'].toString(),
                                          //   );
                                          // } else {
                                          //   await controller.followBusiness(
                                          //     item['business_id'].toString(),
                                          //   );
                                          // }
                                          // item['is_followed'] =
                                          //     !item['is_followed'];
                                          // controller.feedList.refresh();
                                          // // await controller.getFeeds(
                                          // //   showLoading: false,
                                          // // );
                                        },
                                        followButton: _followButton(i),
                                      )
                                    : FeedCard(
                                        // key: ValueKey(item['post_id'].toString()),
                                        onRefresh: () async =>
                                            await controller.getFeeds(
                                              showLoading: false,
                                              isRefresh: false,
                                            ),
                                        data: item,
                                        onLike: () => handleFeedLike(
                                          item,
                                          () async => await controller.getFeeds(
                                            showLoading: false,
                                            isRefresh: false,
                                          ),
                                        ),
                                        followButton: _followButton(i),
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
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

            /// 🔹 STICKY HEADER (OVERLAY)
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
                      title: 'Feeds',
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
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Obx(
  //     () => controller.isLoading.isTrue
  //         ? ListView.builder(
  //             padding: EdgeInsets.symmetric(horizontal: 8.w),
  //             itemCount: 5,
  //             itemBuilder: (_, i) => const FeedShimmer(),
  //           )
  //         : controller.feedList.isEmpty
  //         ? commonNoDataFound(isHome: true)
  //         : SingleChildScrollView(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.end,
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 Padding(
  //                   padding: EdgeInsets.symmetric(horizontal: 16.w),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       CustomText(
  //                         title: 'Feeds',
  //                         fontSize: 18.sp,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                       _buildFilterButton(),
  //                     ],
  //                   ),
  //                 ),
  //                 AnimationLimiter(
  //                   child: ListView.builder(
  //                     shrinkWrap: true,
  //                     physics: NeverScrollableScrollPhysics(),
  //                     padding: EdgeInsets.symmetric(horizontal: 8.w),
  //                     itemCount: controller.feedList.length,
  //                     itemBuilder: (_, i) {
  //                       final item = controller.feedList[i];
  //                       return AnimationConfiguration.staggeredList(
  //                         position: i,
  //                         duration: const Duration(milliseconds: 375),
  //                         child: SlideAnimation(
  //                           verticalOffset: 50,
  //                           child: FadeInAnimation(
  //                             child: item['type'] == 'offer'
  //                                 ? OfferCard(
  //                                     data: item,
  //                                     onLike: () => handleOfferLike(
  //                                       item,
  //                                       () async => await controller.getFeeds(
  //                                         showLoading: false,
  //                                       ),
  //                                     ),
  //                                   )
  //                                 : FeedCard(
  //                                     onLike: () => handleFeedLike(
  //                                       item,
  //                                       () => controller.getFeeds(
  //                                         showLoading: false,
  //                                       ),
  //                                     ),
  //
  //                                     // () async {
  //                                     //   if (controller
  //                                     //       .isLikeProcessing
  //                                     //       .isTrue) {
  //                                     //     return; // <<< stops multiple taps
  //                                     //   }
  //                                     //   controller.isLikeProcessing.value =
  //                                     //       true;
  //                                     //
  //                                     //   if (!getIt<DemoService>().isDemo) {
  //                                     //     ToastUtils.showLoginToast();
  //                                     //     controller.isLikeProcessing.value =
  //                                     //         false;
  //                                     //     return;
  //                                     //   }
  //                                     //   try {
  //                                     //     bool wasLiked = item['is_liked'];
  //                                     //     int likeCount =
  //                                     //         int.tryParse(
  //                                     //           item['likes_count'].toString(),
  //                                     //         ) ??
  //                                     //         0;
  //                                     //
  //                                     //     if (wasLiked) {
  //                                     //       await controller.unLikeBusiness(
  //                                     //         item['liked_id'].toString(),
  //                                     //       );
  //                                     //       item['likes_count'] =
  //                                     //           (likeCount - 1).clamp(
  //                                     //             0,
  //                                     //             999999,
  //                                     //           );
  //                                     //     } else {
  //                                     //       await controller.likeBusiness(
  //                                     //         item['business_id'].toString(),
  //                                     //         item['post_id'].toString(),
  //                                     //       );
  //                                     //       item['likes_count'] = likeCount + 1;
  //                                     //     }
  //                                     //
  //                                     //     // Toggle locally
  //                                     //     item['is_liked'] = !wasLiked;
  //                                     //     await controller.getFeeds(
  //                                     //       showLoading: false,
  //                                     //     );
  //                                     //   } finally {
  //                                     //     controller.isLikeProcessing.value =
  //                                     //         false;
  //                                     //   }
  //                                     // },
  //                                     data: item,
  //                                     onFollow: () async {
  //                                       if (controller
  //                                           .isFollowProcessing
  //                                           .isTrue) {
  //                                         return; // <<< stops multiple taps
  //                                       }
  //                                       controller.isFollowProcessing.value =
  //                                           true;
  //                                       if (getIt<DemoService>().isDemo ==
  //                                           false) {
  //                                         ToastUtils.showLoginToast();
  //                                         controller.isFollowProcessing.value =
  //                                             false;
  //                                         return;
  //                                       }
  //                                       try {
  //                                         if (item['is_followed'] == true) {
  //                                           await controller.unfollowBusiness(
  //                                             item['follow_id'].toString(),
  //                                           );
  //                                         } else {
  //                                           await controller.followBusiness(
  //                                             item['business_id'].toString(),
  //                                           );
  //                                         }
  //
  //                                         item['is_followed'] =
  //                                             !item['is_followed'];
  //
  //                                         await controller.getFeeds(
  //                                           showLoading: false,
  //                                         );
  //                                       } finally {
  //                                         controller.isFollowProcessing.value =
  //                                             false;
  //                                       }
  //                                     },
  //                                   ),
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //   );
  // }

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
      const FeedSheet(isFrom: 'feed'),
    );
  }

  Widget _followButton(index) {
    return Obx(() {
      final data = controller.feedList[index];

      if (data['self_business'] == true) return SizedBox();

      final isFollowing = data['is_followed'] == true;

      final key = isFollowing
          ? data['follow_id']?.toString() ?? ''
          : data['business_id']?.toString() ?? '';

      final isLoading =
          key.isNotEmpty && controller.followingLoadingMap[key] == true;
      return AbsorbPointer(
        absorbing: isLoading, // 🔒 blocks taps
        child: isLoading
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
                      color: isFollowing
                          ? Colors.grey.shade300
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    spacing: 4.w,
                    children: [
                      Icon(
                        isFollowing ? Icons.check : Icons.add,
                        size: 14.sp,
                        color: isFollowing
                            ? Colors.grey.shade600
                            : Colors.white,
                      ),
                      CustomText(
                        title: isFollowing ? 'Following' : 'Follow',
                        fontSize: 12.sp,
                        color: isFollowing
                            ? Colors.grey.shade700
                            : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ),
      );
    });
  }

  void _onFollow(dynamic item) async {
    final businessId = item['business_id'].toString();

    // ⛔ HARD BLOCK
    if (controller.followingLoadingMap[businessId] == true) return;

    if (getIt<DemoService>().isDemo == false) {
      ToastUtils.showLoginToast();
      return;
    }

    final isFollowing = item['is_followed'] == true;
    // final key = isFollowing
    //     ? item['follow_id']?.toString() ?? ''
    //     : item['business_id']?.toString() ?? '';
    //
    // // ⛔ Prevent duplicate API calls
    // if (controller.followingLoadingMap[key] == true) return;

    if (isFollowing) {
      await controller.unfollowBusiness(item['follow_id'].toString());
    } else {
      await controller.followBusiness(item['business_id'].toString());
    }
    controller.updateFollowStatusForBusiness(
      businessId: item['business_id'].toString(),
      isFollowed: !isFollowing,
    );
  }
}
