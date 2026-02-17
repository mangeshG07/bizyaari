import 'package:businessbuddy/utils/exported_path.dart';

class OfferCard extends StatelessWidget {
  final dynamic data;
  final dynamic followButton;
  final void Function() onLike;
  final void Function()? onFollow;
  final Future<void> Function() onRefresh;
  OfferCard({
    super.key,
    this.data,
    required this.onLike,
    this.onFollow,
    this.followButton,
    required this.onRefresh,
  });

  final navController = getIt<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      color: Theme.of(context).cardColor,
      elevation: 0,
      margin: EdgeInsets.all(8.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: Get.theme.dividerColor, width: 0.5),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(),

            // Image Section
            _buildImageSection(),

            // Content Section
            _buildContentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeBadge() {
    if (data['special_offer'] == false) return SizedBox();
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).brightness == Brightness.light
            ? lightGrey
            : Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedDiscountTag02,
            size: 12.sp,
            color: Colors.red,
          ),
          SizedBox(width: 4.w),
          Text(
            'Special Offer',
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final String image = data['business_profile_image'] ?? '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// PROFILE IMAGE
        CircleAvatar(
          radius: 18.r,
          backgroundColor: Colors.grey.shade100,
          child: ClipOval(
            child: FadeInImage(
              placeholder: const AssetImage(Images.defaultImage),
              image: image.isNotEmpty
                  ? NetworkImage(image)
                  : const AssetImage(Images.defaultImage) as ImageProvider,
              width: 36.w,
              height: 36.w,
              fit: BoxFit.cover,
              imageErrorBuilder: (_, __, ___) {
                return Image.asset(
                  Images.defaultImage,
                  width: 36.w,
                  height: 36.w,
                  fit: BoxFit.cover,
                );
              },
              fadeInDuration: const Duration(milliseconds: 400),
            ),
          ),
        ),

        SizedBox(width: 8.w),

        /// BUSINESS INFO
        Expanded(
          child: GestureDetector(
            onTap: () {
              navController.openSubPage(
                CategoryDetailPage(
                  title: data['business_name'] ?? '',
                  businessId: data['business_id']?.toString() ?? '',
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// BUSINESS NAME
                CustomText(
                  title: data['business_name'] ?? '',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: primaryBlack,
                  maxLines: 1,
                ),

                SizedBox(height: 4.h),

                /// META INFO (CATEGORY • TIME • TYPE)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// CATEGORY (FIXED)
                    Flexible(
                      child: CustomText(
                        title: data['category'] ?? '',
                        fontSize: 10.sp,
                        color: textSmall,
                        maxLines: 1,
                      ),
                    ),

                    SizedBox(width: 6.w),
                    _dot(),

                    SizedBox(width: 6.w),
                    _buildTimeDisplay(),

                    SizedBox(width: 6.w),
                    _dot(),

                    SizedBox(width: 6.w),
                    ClipRect(child: _buildTypeBadge()),
                  ],
                ),
              ],
            ),
          ),
        ),

        SizedBox(width: 8.w),

        /// FOLLOW BUTTON
        followButton ?? SizedBox(),
        // _buildFollowButton(),
      ],
    );
  }

  // Widget _buildHeader() {
  Widget _dot() {
    return Container(
      width: 3.r,
      height: 3.r,
      decoration: BoxDecoration(shape: BoxShape.circle, color: textSmall),
    );
  }

  Widget _buildTimeDisplay() {
    final createdAt = data['created_at'] ?? '';
    if (createdAt == null || createdAt.toString().isEmpty) {
      return SizedBox();
    }

    return CustomText(
      title: getTimeAgo(createdAt),
      fontSize: 10.sp,
      textAlign: TextAlign.start,
      color: textSmall,
      maxLines: 1,
    );
  }

  // Widget _buildFollowButton() {
  //   if (data['self_business'] == true) return SizedBox();
  //   return Obx(() {
  //     bool isLoading = false;
  //     if (data['is_followed'] == true) {
  //       isLoading =
  //           getIt<FeedsController>().followingLoadingMap[data['follow_id']
  //               .toString()] ==
  //           true;
  //     } else {
  //       isLoading =
  //           getIt<FeedsController>().followingLoadingMap[data['business_id']
  //               .toString()] ==
  //           true;
  //     }
  //     final isFollowing = data['is_followed'] == true;
  //     return isLoading
  //         ? LoadingWidget(color: primaryColor, size: 20.r)
  //         : GestureDetector(
  //             onTap: onFollow,
  //
  //             // onTap: () async {
  //             //   if (getIt<DemoService>().isDemo == false) {
  //             //     ToastUtils.showLoginToast();
  //             //     return;
  //             //   }
  //             //   if (widget.data['is_followed'] == true) {
  //             //     await getIt<FeedsController>().unfollowBusiness(
  //             //       widget.data['follow_id'].toString(),
  //             //     );
  //             //   } else {
  //             //     await getIt<FeedsController>().followBusiness(
  //             //       widget.data['business_id'].toString(),
  //             //     );
  //             //   }
  //             //   widget.data['is_followed'] = !widget.data['is_followed'];
  //             //   await getIt<FeedsController>().getFeeds(showLoading: false);
  //             //
  //             //   // Handle follow action
  //             // },
  //             child: Container(
  //               padding: EdgeInsets.all(8.w),
  //               decoration: BoxDecoration(
  //                 gradient: isFollowing
  //                     ? null
  //                     : LinearGradient(
  //                         colors: [
  //                           primaryColor,
  //                           primaryColor.withValues(alpha: 0.8),
  //                         ],
  //                         begin: Alignment.topLeft,
  //                         end: Alignment.bottomRight,
  //                       ),
  //                 borderRadius: BorderRadius.circular(8.r),
  //                 border: Border.all(
  //                   color: isFollowing
  //                       ? Colors.grey.shade300
  //                       : Colors.transparent,
  //                   width: 1,
  //                 ),
  //               ),
  //               child: Row(
  //                 spacing: 4.w,
  //                 children: [
  //                   Icon(
  //                     isFollowing ? Icons.check : Icons.add,
  //                     size: 14.sp,
  //                     color: isFollowing ? Colors.grey.shade600 : Colors.white,
  //                   ),
  //                   CustomText(
  //                     title: isFollowing ? 'Following' : 'Follow',
  //                     fontSize: 12.sp,
  //                     color: isFollowing ? Colors.grey.shade700 : Colors.white,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //   });
  //
  //   //   GestureDetector(
  //   //   onTap: () {
  //   //     if (!getIt<DemoService>().isDemo) {
  //   //       ToastUtils.showLoginToast();
  //   //       return;
  //   //     }
  //   //   },
  //   //   child: Container(
  //   //     padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
  //   //     decoration: BoxDecoration(
  //   //       gradient: LinearGradient(
  //   //         colors: [primaryColor, primaryColor.withValues(alpha: 0.8)],
  //   //         begin: Alignment.topLeft,
  //   //         end: Alignment.bottomRight,
  //   //       ),
  //   //       borderRadius: BorderRadius.circular(8.r),
  //   //       boxShadow: [
  //   //         BoxShadow(
  //   //           color: primaryColor.withValues(alpha: 0.3),
  //   //           blurRadius: 4,
  //   //           offset: const Offset(0, 2),
  //   //         ),
  //   //       ],
  //   //     ),
  //   //     child: CustomText(
  //   //       title: data['is_followed'] == true ? 'Following' : 'Follow',
  //   //       fontSize: 12.sp,
  //   //       color: Colors.white,
  //   //       fontWeight: FontWeight.w600,
  //   //     ),
  //   //   ),
  //   // );
  // }

  Widget _buildImageSection() {
    final image = data['image'] ?? '';
    final video = data['video'] ?? '';
    final mediaType = data['media_type'] ?? '';

    return GestureDetector(
      onTap: () {
        Get.to(
          () => InstagramOfferView(
            isFrom: '',
            refresh: onRefresh,
            offerId: data['id']?.toString() ?? '',
            followButton: followButton,
          ),
          transition: Transition.cupertino,
          duration: Duration(milliseconds: 300),
        );
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Get.theme.dividerColor, width: 0.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 380.h),
            child: mediaType == 'video'
                ? InstagramVideoPlayer(
                    key: ValueKey(video),
                    url: video?.toString() ?? '',
                  )
                : CachedNetworkImage(
                    placeholder: (_, __) => Image.asset(Images.defaultImage),
                    imageUrl: image,
                    fit: BoxFit.contain,
                    memCacheHeight: 600,
                    errorWidget: (_, __, ___) =>
                        Image.asset(Images.defaultImage),
                    fadeInDuration: Duration.zero,
                  ),
            // WidgetZoom(
            //   heroAnimationTag: 'tag$image',
            //   zoomWidget:
            //
            //
            //   //   FadeInImage(
            //   //   placeholder: const AssetImage(Images.defaultImage),
            //   //   image: NetworkImage(image),
            //   //   width: double.infinity,
            //   //   fit: BoxFit.contain,
            //   //   imageErrorBuilder: (context, error, stackTrace) {
            //   //     return Center(
            //   //       child: Image.asset(
            //   //         Images.defaultImage,
            //   //         width: 150.w,
            //   //         height: 150.w,
            //   //       ),
            //   //     );
            //   //   },
            //   //   fadeInDuration: const Duration(milliseconds: 500),
            //   // ),
            // ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        CustomText(
          title: data['offer_name'] ?? '',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: Theme.of(Get.context!).brightness == Brightness.light
              ? primaryColor
              : lightRed,
          textAlign: TextAlign.start,
          maxLines: 2,
        ),
        // SizedBox(height: 8.h),
        _offerDetails(),
        SizedBox(height: 8.h),
        // Date Section
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_month_rounded,
              size: 16.r,
              // color: lightGrey,
            ),
            SizedBox(width: 6.w),
            Flexible(
              child: CustomText(
                title:
                    '${data['start_date'] ?? ''} to ${data['end_date'] ?? ''}',
                fontSize: 14.sp,
                color: primaryBlack,
                maxLines: 2,
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data['highlight_points'].map<Widget>((v) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: buildBulletPoint(text: v),
            );
          }).toList(),
        ),
        // _buildEngagementSection(),
        Divider(height: 12, color: lightGrey),
        _buildContentEngagement(),
      ],
    );
  }

  Widget _offerDetails() {
    final content = data['details'] ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: content,
          fontSize: 14.sp,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 14.sp, height: 1.5),
          maxLines: 2,
        ),

        // Read more button for long content
        if (content.length > 150)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: GestureDetector(
              onTap: () => expandContent(content),
              child: Text(
                'Read more',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContentEngagement() {
    return Column(
      children: [
        _buildEngagementHeader(),
        Divider(height: 12, color: lightGrey),
        _buildEngagementActions(),
      ],
    );
  }

  Widget _buildEngagementHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAnimatedIcon(icon: Icons.favorite, color: primaryColor),
            SizedBox(width: 6.w),
            Text(
              formatCount(
                int.parse(data['offer_likes_count']?.toString() ?? '0'),
              ),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ],
        ),
        CustomText(
          title: '${data['offer_comments_count']?.toString() ?? '0'} Comments',
          fontSize: 12.sp,
          color: Colors.grey,
        ),
      ],
    );
  }

  Widget _buildEngagementActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: onLike,
          child: EngagementAction(
            color: data['is_offer_liked'] == true ? Colors.red : primaryBlack,
            icon: data['is_offer_liked'] == true
                ? Icons.favorite
                : Icons.favorite_border,
            label: 'Like',
          ),
        ),
        GestureDetector(
          onTap: _handleComment,
          child: EngagementAction(
            hugeIcon: HugeIcons.strokeRoundedMessage02,
            label: 'Comment',
          ),
        ),
        GestureDetector(
          onTap: () {
            AppShare.share(
              type: ShareEntityType.offer,
              id: data['id']?.toString() ?? '',
              slug: data['business_slug']?.toString() ?? '',
            );
          },
          child: EngagementAction(
            hugeIcon: HugeIcons.strokeRoundedSent,
            label: 'Share',
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedIcon({required IconData icon, required Color color}) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Icon(icon, size: 18.sp, color: color),
    );
  }

  // Widget _buildEngagementSection() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       // Likes and Comments
  //       Row(
  //         children: [
  //           buildEngagementButton(
  //             icon: Icons.favorite_border,
  //             activeIcon: Icons.favorite,
  //             isActive: data['is_offer_liked'] == true,
  //             count: data['offer_likes_count']?.toString() ?? '0',
  //             onTap: onLike,
  //             activeColor: Colors.red,
  //           ),
  //
  //           SizedBox(width: 16.w),
  //
  //           buildEngagementButton(
  //             icon: HugeIcons.strokeRoundedMessage02,
  //             activeIcon: Icons.comment,
  //             isActive: false,
  //             count: data['offer_comments_count']?.toString() ?? '0',
  //             onTap: _handleComment,
  //             isComment: true,
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  void _handleComment() {
    if (!getIt<DemoService>().isDemo) {
      ToastUtils.showLoginToast();
      return;
    }
    Get.bottomSheet(
      CommentsBottomSheet(postId: data['id']?.toString() ?? '', isPost: false,isSingle: false,),
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.grey.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      ignoreSafeArea: false,
    );
    // Implement comment functionality
  }
}
