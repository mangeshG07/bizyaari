import 'package:businessbuddy/utils/exported_path.dart';

class FeedCard extends StatelessWidget {
  final dynamic data;
  final dynamic followButton;
  final Future<void> Function() onLike;
  final void Function()? onRefresh;

  FeedCard({
    super.key,
    this.data,
    required this.onLike,
    this.followButton,
    this.onRefresh,
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
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
        ).copyWith(top: 12.h, bottom: 4.h),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(),
            _buildContentSection(),
            // Image Section
            _buildImageSection(),
            _buildContentEngagement(),
            // _buildEngagementSection(),
            // _buildTimeDisplay(),

            // Content Section
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final image = data['business_profile_image'] ?? '';
    return Row(
      children: [
        GestureDetector(
          child: CircleAvatar(
            radius: 20.r,
            backgroundColor: Colors.grey.shade100,
            child: ClipOval(
              child: FadeInImage(
                placeholder: const AssetImage(Images.defaultImage),
                image: NetworkImage(image),
                width: double.infinity,
                height: 100.w,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Image.asset(
                      Images.defaultImage,
                      width: 100.w,
                      height: 100.w,
                    ),
                  );
                },
                fadeInDuration: const Duration(milliseconds: 500),
              ),
            ),
            // backgroundImage: AssetImage(Images.hotelImg),
          ),
        ),
        SizedBox(width: 8.w),
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
              spacing: 4.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: data['business_name'] ?? '',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.start,
                  color: primaryBlack,
                  maxLines: 1,
                  style: TextStyle(
                    height: 1,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: primaryBlack,
                  ),
                ),
                Row(
                  children: [
                    CustomText(
                      title: data['category'] ?? '',
                      fontSize: 10.sp,
                      textAlign: TextAlign.start,
                      color: textSmall,
                      maxLines: 1,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Container(
                        width: 3.r,
                        height: 3.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: textSmall,
                        ),
                      ),
                    ),
                    _buildTimeDisplay(),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8.w),
        followButton ?? SizedBox(),
      ],
    );
  }

  Widget _buildImageSection() {
    final image = data['image'] ?? '';
    final video = data['video'] ?? '';
    final mediaType = data['media_type'] ?? '';
    final heroTag = 'post_${data['post_id']}';

    return GestureDetector(
      onTap: () {
        Get.to(
          () => InstagramPostView(
            isFrom: '',
            refresh: onRefresh!,
            followButton: followButton,
            postId: data['post_id']?.toString() ?? '',
          ),
          transition: Transition.cupertino,
          duration: Duration(milliseconds: 300),
        );
      },
      child: Hero(
        tag: heroTag,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Get.theme.dividerColor, width: 0.5),
          ),

          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 380.h),
              child: mediaType == 'video'
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: InstagramVideoPlayer(
                        // isSingleView: true,
                        key: ValueKey(video),
                        url: video?.toString() ?? '',
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: CachedNetworkImage(
                        placeholder: (_, __) =>
                            Image.asset(Images.defaultImage),
                        imageUrl: image,
                        fit: BoxFit.contain,
                        memCacheHeight: 600,
                        errorWidget: (_, __, ___) =>
                            Image.asset(Images.defaultImage),
                        fadeInDuration: Duration.zero,
                      ),
                    ),
            ),
          ),
        ),
      ),

      // Stack(
      //   alignment: Alignment.center,
      //   children: [
      //
      //     AnimatedOpacity(
      //       duration: const Duration(milliseconds: 200),
      //       opacity: _homeController.isLikeAnimating.value ? 1 : 0,
      //       child: LikeAnimation(
      //         isAnimating: _homeController.isLikeAnimating.value,
      //         duration: const Duration(milliseconds: 400),
      //         onEnd: () {
      //           _homeController.isLikeAnimating.value = false;
      //         },
      //         child: Icon(
      //           data['is_liked'] == true ? Icons.favorite : Icons.favorite,
      //           color: data['is_liked'] == true ? lightGrey : Colors.red,
      //           size: 40.r,
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
    //   Obx(
    //   () => GestureDetector(
    //     onDoubleTap: () async {
    //       _homeController.isLikeAnimating.value = true;
    //       onLike();
    //     },
    //     child: ClipRRect(
    //       borderRadius: BorderRadius.circular(12.r),
    //       child: ConstrainedBox(
    //         constraints: BoxConstraints(maxHeight: 380.h),
    //         child: InstagramVideoPlayer(
    //           url: 'https://youtu.be/sEID7kTP_hE?si=AOx4r_nIOAkWL19P',
    //         ),
    //         // FadeInImage(
    //         //   placeholder: const AssetImage(Images.defaultImage),
    //         //   image: NetworkImage(image),
    //         //   width: Get.width,
    //         //   fit: BoxFit.contain,
    //         //   imageErrorBuilder: (context, error, stackTrace) {
    //         //     return Center(
    //         //       child: Image.asset(
    //         //         Images.defaultImage,
    //         //         width: 150.w,
    //         //         height: 150.h,
    //         //       ),
    //         //     );
    //         //   },
    //         //   fadeInDuration: const Duration(milliseconds: 500),
    //         // ),
    //
    //         // Image.network(
    //         //   image,
    //         //   fit: BoxFit.contain,
    //         //   width: Get.width,
    //         // ),
    //       ),
    //     ),
    //     // Stack(
    //     //   alignment: Alignment.center,
    //     //   children: [
    //     //
    //     //     AnimatedOpacity(
    //     //       duration: const Duration(milliseconds: 200),
    //     //       opacity: _homeController.isLikeAnimating.value ? 1 : 0,
    //     //       child: LikeAnimation(
    //     //         isAnimating: _homeController.isLikeAnimating.value,
    //     //         duration: const Duration(milliseconds: 400),
    //     //         onEnd: () {
    //     //           _homeController.isLikeAnimating.value = false;
    //     //         },
    //     //         child: Icon(
    //     //           data['is_liked'] == true ? Icons.favorite : Icons.favorite,
    //     //           color: data['is_liked'] == true ? lightGrey : Colors.red,
    //     //           size: 40.r,
    //     //         ),
    //     //       ),
    //     //     ),
    //     //   ],
    //     // ),
    //   ),
    // );
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
            _buildAnimatedIcon(icon: Icons.favorite, color: Colors.red),
            SizedBox(width: 6.w),
            Text(
              formatCount(int.parse(data['likes_count']?.toString() ?? '0')),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ],
        ),
        CustomText(
          title: '${data['comments_count']?.toString() ?? '0'} Comments',
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
        Obx(() {
          final postId = data['post_id'].toString();
          final isLoading = getIt<FeedsController>().isPostLikeLoading(postId);
          return AbsorbPointer(
            absorbing: isLoading,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isLoading ? 0.4 : 1,
              child: GestureDetector(
                onTap: onLike,
                child: EngagementAction(
                  color: data['is_liked'] == true ? Colors.red : primaryBlack,
                  icon: data['is_liked'] == true
                      ? Icons.favorite
                      : Icons.favorite_border,
                  label: 'Like',
                ),
              ),
            ),
          );
        }),
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
              slug: data['business_slug']?.toString() ?? '',
              type: ShareEntityType.post,
              id: data['post_id']?.toString() ?? '',
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

  Widget _buildContentSection() {
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

  void _handleComment() {
    if (!getIt<DemoService>().isDemo) {
      ToastUtils.showLoginToast();
      return;
    }
    Get.bottomSheet(
      CommentsBottomSheet(
        postId: data['post_id']?.toString() ?? '',
        isSingle: false,
      ),
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

class EngagementAction extends StatelessWidget {
  final IconData? icon;
  final dynamic hugeIcon;
  final String label;
  final Color color;

  const EngagementAction({
    super.key,
    this.icon,
    this.hugeIcon,
    this.color = Colors.black,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: icon != null
              ? Icon(icon, size: 18.sp, color: color)
              : HugeIcon(icon: hugeIcon, size: 18.sp, color: primaryBlack),
        ),
        SizedBox(height: 0.h),
        CustomText(title: label, fontSize: 12.sp, color: primaryBlack),
      ],
    );
  }
}

// class FeedCard extends StatelessWidget {
//   const FeedCard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         children: [
//           ListTile(
//             // tileColor: Colors.amber,
//             contentPadding: EdgeInsets.all(4.w),
//             leading: CircleAvatar(backgroundImage: AssetImage(Images.hotelImg)),
//             title: CustomText(
//               title: 'Deepminds Infotech Pvt. Ltd.',
//               fontSize: 16.sp,
//               maxLines: 2,
//               textAlign: TextAlign.start,
//               fontWeight: FontWeight.bold,
//             ),
//             subtitle: CustomText(
//               title: 'Information technology',
//               fontSize: 12.sp,
//               maxLines: 2,
//               textAlign: TextAlign.start,
//             ),
//             trailing: GestureDetector(
//               onTap: () {},
//               child: Container(
//                 padding: EdgeInsets.all(8.w),
//                 decoration: BoxDecoration(
//                   color: primaryColor,
//                   borderRadius: BorderRadius.circular(8.r),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Icon(
//                       Icons.person_add_outlined,
//                       color: Colors.white,
//                       size: 18.sp,
//                     ),
//                     SizedBox(width: 8.w),
//                     CustomText(
//                       title: 'Follow',
//                       fontSize: 14.sp,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           AspectRatio(
//             aspectRatio: 1,
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(28.r),
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               child: ClipRRect(
//                 clipBehavior: Clip.none,
//                 borderRadius: BorderRadius.circular(28.r),
//                 child: FadeInImage(
//                   placeholder: const AssetImage(Images.logo),
//                   image: AssetImage(Images.feedImg),
//                   width: double.infinity,
//                   height: 180.h,
//                   imageErrorBuilder: (context, error, stackTrace) {
//                     return Container(
//                       width: double.infinity,
//                       height: 180.h,
//                       padding: EdgeInsets.all(32.w),
//                       child: Image.asset(
//                         Images.logo,
//                         fit: BoxFit.contain,
//                         // color: Colors.grey.shade400,
//                       ),
//                     );
//                   },
//                   fit: BoxFit.cover,
//                   placeholderFit: BoxFit.contain,
//                   fadeInDuration: const Duration(milliseconds: 500),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   spacing: 8.w,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         HugeIcon(
//                           icon: HugeIcons.strokeRoundedFavourite,
//                           color: Colors.black,
//                           size: 18.sp,
//                         ),
//                         SizedBox(width: 8.w),
//                         CustomText(
//                           title: '10k',
//                           fontSize: 14.sp,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         HugeIcon(
//                           icon: HugeIcons.strokeRoundedMessage02,
//                           color: Colors.black,
//                           size: 18.sp,
//                         ),
//                         SizedBox(width: 8.w),
//                         CustomText(
//                           title: '500',
//                           fontSize: 14.sp,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Container(
//                   padding: EdgeInsets.all(4.w),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8.r),
//                     border: Border.all(color: primaryColor),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       HugeIcon(
//                         icon: HugeIcons.strokeRoundedDiscount,
//                         color: primaryColor,
//                         size: 20.sp,
//                       ),
//                       SizedBox(width: 4.h),
//                       CustomText(
//                         title: 'See Offers',
//                         fontSize: 10.sp,
//                         color: primaryColor,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           CustomText(
//             title: 'Boost Your Local Business with Business Buddy!',
//             fontSize: 14.sp,
//             textAlign: TextAlign.start,
//             maxLines: 2,
//             fontWeight: FontWeight.w500,
//           ),
//
//           CustomText(
//             title:
//                 'Share offers, promote products, and connect directly with nearby customers — all in one app.',
//             fontSize: 12.sp,
//             maxLines: 20,
//             textAlign: TextAlign.start,
//           ),
//         ],
//       ),
//     );
//   }
// }
