import 'dart:io';
import 'package:businessbuddy/utils/exported_path.dart';

Widget buildReviewTile({
  required String userName,
  required String review,
  required int rating,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CircleAvatar(
        radius: 20.r,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: AssetImage(Images.hotelImg),
      ),
      SizedBox(width: 12.w),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              title: userName,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            SizedBox(height: 4.h),
            CustomText(
              title: review,
              textAlign: TextAlign.start,
              fontSize: 13.sp,
              color: Colors.grey.shade700,
              maxLines: 20,
            ),
            buildStarRating(rating),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    ],
  );
}

Widget buildStarRating(int rating) {
  return Row(
    children: List.generate(5, (index) {
      return Icon(
        Icons.star_rounded,
        color: index < rating ? Colors.amber : Colors.grey.shade300,
        size: 16.sp,
      );
    }),
  );
}

Widget buildGridImages(dynamic data, String type, {bool isEdit = false}) {
  if (data.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Images.noData,
            width: 120.w,
            height: 120.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 20),
          Text(
            "No data found",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  return GridView.builder(
    padding: EdgeInsets.only(top: 8.h),
    itemCount: data.length,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      mainAxisSpacing: 8.w,
      crossAxisSpacing: 8.w,
      childAspectRatio: 1,
    ),
    itemBuilder: (context, index) {
      final image = data[index];
      final isExpired = image['is_expired'] ?? false;
      final isApproved = image['approved'] == "1";
      return GestureDetector(
        onTap: () {
          showPostBottomSheet(
            image['id'].toString(),
            type,
            data,
            index,
            isEdit,
          );
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (image['media_type'] == 'video')
              FutureBuilder<Uint8List?>(
                future: getVideoThumbnail(image['video']),
                builder: (context, snapshot) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: lightGrey, width: 1.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: snapshot.hasData
                            ? Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.memory(
                                    snapshot.data!,
                                    fit: BoxFit.contain,
                                  ),
                                  Center(
                                    child: Icon(
                                      Icons.play_circle_fill,
                                      color: Colors.white,
                                      size: 25.r,
                                    ),
                                  ),
                                ],
                              )
                            : Image.asset(
                                Images.defaultImage,
                                fit: BoxFit.cover,
                                key: ValueKey('placeholder'),
                              ),
                      ),

                      // Center(
                      //   child: HugeIcon(
                      //     icon: HugeIcons.strokeRoundedVideoReplay,
                      //     color: Colors.grey.shade400,
                      //     size: 40.r,
                      //   ),
                      // ),
                    ),
                  );
                },
              )
            else
              Container(
                width: double.infinity,
                height: double.infinity,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: lightGrey, width: 1.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: FadeInImage.assetNetwork(
                    placeholder: Images.defaultImage,
                    image: image['image'] ?? '',
                    fit: BoxFit.contain,
                    imageErrorBuilder: (_, __, ___) =>
                        Image.asset(Images.defaultImage, fit: BoxFit.cover),
                  ),
                ),
              ),
            // Overlay for unapproved images
            if (isExpired)
              Container(
                width: double.infinity,
                height: double.infinity,

                decoration: BoxDecoration(
                  color: Colors.black54,
                  border: Border.all(color: Colors.red.shade400, width: 1.5),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timer_off_rounded,
                        color: Colors.white,
                        size: 24.r,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Offer Expired",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            if (!isApproved)
              Container(
                width: double.infinity,
                height: double.infinity,

                decoration: BoxDecoration(
                  color: Colors.black54,
                  border: Border.all(color: Colors.red.shade400, width: 1.5),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.pending_actions,
                        color: Colors.white,
                        size: 24.r,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Pending\nApproval",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            if (isEdit)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 6.h, right: 6.w),
                  child: GestureDetector(
                    onTap: () {
                      if (type == 'post') {
                        Get.toNamed(
                          Routes.editPost,
                          arguments: {'postData': image},
                        );
                      } else {
                        Get.toNamed(
                          Routes.editOffer,
                          arguments: {'offerData': image},
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.edit, color: Colors.white, size: 12.r),
                    ),
                  ),
                ),
              ),
            //
            // Positioned(
            //     top: 4,
            //     right: 10,
            //     child: GestureDetector(
            //       onTap: () {
            //         if (type == 'post') {
            //           Get.toNamed(
            //             Routes.editPost,
            //             arguments: {'postData': image},
            //           );
            //         } else {
            //           Get.toNamed(
            //             Routes.editOffer,
            //             arguments: {'offerData': image},
            //           );
            //         }
            //       },
            //       child: Container(
            //         padding: EdgeInsets.all(4.w),
            //         decoration: BoxDecoration(
            //           color: Colors.grey,
            //           shape: BoxShape.circle,
            //         ),
            //         child: Icon(Icons.edit, color: Colors.white, size: 12.r),
            //       ),
            //     ),
            //   ),
          ],
        ),
      );
    },
  );
}

Future<Uint8List?> getVideoThumbnail(String url) async {
  return await VideoThumbnail.thumbnailData(
    video: url,
    imageFormat: ImageFormat.JPEG,
    maxWidth: 300,
    quality: 75,
  );
}

bool isVideo(File file) {
  final ext = file.path.toLowerCase();
  return ext.endsWith('.mp4') ||
      ext.endsWith('.mov') ||
      ext.endsWith('.avi') ||
      ext.endsWith('.mkv');
}

void showPostBottomSheet(
  String postId,
  String type,
  dynamic data,
  int initialIndex,
  bool isEdit,
) async {
  final controller = getIt<LBOController>();

  // Store the data and current index in the controller
  controller.currentPostsList.value = data;
  controller.currentIndex.value = initialIndex;
  controller.currentType.value = type;

  // Load initial item
  if (type == 'post') {
    await controller.getSinglePost(postId);
    _showPost(controller, isEdit: isEdit);
  } else {
    await controller.getSingleOffer(postId);
    _showOffer(controller, isEdit: isEdit);
  }
}

Future<dynamic> _showPost(LBOController controller, {bool isEdit = false}) {
  return Get.bottomSheet(
    ConstrainedBox(
      constraints: BoxConstraints(maxHeight: Get.height * 0.85.h),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(Get.context!).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black54.withValues(alpha: 0.15),
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: lightGrey,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),

              // Navigation Header with indicators
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Previous Button
                    Opacity(
                      opacity: controller.currentIndex > 0 ? 1.0 : 0.3,
                      child: GestureDetector(
                        onTap: controller.currentIndex > 0
                            ? () {
                                controller.goToPreviousItem();
                              }
                            : null,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: lightGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.arrow_back_ios, size: 16.r),
                              SizedBox(width: 4.w),
                              Text(
                                'Previous',
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Page Indicator
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${controller.currentIndex.value + 1} / ${controller.currentPostsList.length}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Next Button
                    Opacity(
                      opacity:
                          controller.currentIndex.value <
                              controller.currentPostsList.length - 1
                          ? 1.0
                          : 0.3,
                      child: GestureDetector(
                        onTap:
                            controller.currentIndex.value <
                                controller.currentPostsList.length - 1
                            ? () {
                                controller.goToNextItem();
                              }
                            : null,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: lightGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text('Next', style: TextStyle(fontSize: 12.sp)),
                              SizedBox(width: 4.w),
                              Icon(Icons.arrow_forward_ios, size: 16.r),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8.h),

              Expanded(
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity! < -100) {
                      controller.goToNextItem();
                    } else if (details.primaryVelocity! > 100) {
                      controller.goToPreviousItem();
                    }
                  },
                  child: Obx(
                    () => SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image with enhanced styling
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    Get.context!,
                                  ).scaffoldBackgroundColor,
                                  border: Border.all(
                                    width: 0.5,
                                    color: lightGrey,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.r),
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child:
                                        controller.singlePost['media_type'] ==
                                            'video'
                                        ? InstagramVideoPlayer(
                                            isSingleView: true,
                                            url:
                                                controller.singlePost['video']
                                                    ?.toString() ??
                                                '',
                                          )
                                        : FadeInImage(
                                            placeholder: AssetImage(
                                              Images.defaultImage,
                                            ),
                                            image: NetworkImage(
                                              controller.singlePost['image']
                                                      ?.toString() ??
                                                  '',
                                            ),
                                            imageErrorBuilder:
                                                (context, error, stackTrace) {
                                                  return Image.asset(
                                                    Images.defaultImage,
                                                    fit: BoxFit.contain,
                                                  );
                                                },
                                            fit: BoxFit.contain,
                                            placeholderFit: BoxFit.contain,
                                            fadeInDuration: Duration(
                                              milliseconds: 300,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              // ✏️ Edit Icon
                              if (isEdit)
                                Positioned(
                                  bottom: 10.h,
                                  right: 10.w,
                                  child: GestureDetector(
                                    onTap: () {
                                      // Get.back();
                                      Get.toNamed(
                                        Routes.editPost,
                                        arguments: {
                                          'postData': controller.singlePost,
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8.w),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          Get.context!,
                                        ).dividerColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: lightGrey,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.edit,
                                        color: primaryColor,
                                        size: 18.r,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          SizedBox(height: 16.h),

                          // Date and Likes row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Date
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 14.r,
                                    color: textGrey,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    controller.singlePost['created_at']
                                            ?.toString() ??
                                        "",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: textGrey,
                                    ),
                                  ),
                                ],
                              ),

                              // Likes and Comments count
                              Row(
                                children: [
                                  // Likes count
                                  _buildLikeIconData(controller),

                                  SizedBox(width: 8.w),

                                  // Comment count
                                  _buildComment(controller),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: 16.h),

                          // Content section
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                Get.context!,
                              ).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: lightGrey, width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Section title
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(6.w),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.description_outlined,
                                        size: 16.r,
                                        color: Colors.blue.shade700,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Post Details',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: primaryBlack,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 12.h),

                                // Details text
                                Text(
                                  controller.singlePost['details']
                                          ?.toString() ??
                                      "",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    height: 1.6,
                                    color: textLightGrey,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.red.shade200,
    enableDrag: true,
  );
}

Widget _buildComment(LBOController controller) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
    decoration: BoxDecoration(
      color: lightGrey,
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: textLightGrey),
    ),
    child: Row(
      children: [
        Icon(Icons.comment_outlined, size: 16.r, color: primaryBlack),
        SizedBox(width: 6.w),
        Text(
          controller.singlePost['comments_count']?.toString() ?? '0',
          style: TextStyle(
            fontSize: 14.sp,
            color: primaryBlack,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget _buildLikeIconData(LBOController controller) {
  return GestureDetector(
    onTap: () async {
      if (getIt<FeedsController>().isLikeProcessing.isTrue) {
        return; // <<< stops multiple taps
      }
      getIt<FeedsController>().isLikeProcessing.value = true;

      if (!getIt<DemoService>().isDemo) {
        ToastUtils.showLoginToast();
        getIt<FeedsController>().isLikeProcessing.value = false;
        return;
      }
      try {
        bool wasLiked = controller.singlePost['is_liked'];
        int likeCount =
            int.tryParse(controller.singlePost['likes_count'].toString()) ?? 0;

        if (wasLiked) {
          await getIt<FeedsController>().unLikeBusiness(
            controller.singlePost['liked_id'].toString(),
          );
          controller.singlePost['likes_count'] = (likeCount - 1).clamp(
            0,
            999999,
          );
        } else {
          await getIt<FeedsController>().likeBusiness(
            controller.singlePost['business_id'].toString(),
            controller.singlePost['id'].toString(),
          );
          controller.singlePost['likes_count'] = likeCount + 1;
        }

        // Toggle locally
        controller.singlePost['is_liked'] = !wasLiked;
        await controller.getSinglePost(
          controller.singlePost['id'].toString(),
          showLoading: false,
        );
      } catch (e) {
        // print("follow error: $e");
      } finally {
        getIt<FeedsController>().isLikeProcessing.value = false;
      }
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: lightGrey,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: textLightGrey),
      ),
      child: Row(
        children: [
          Obx(() {
            bool isLoading = false;
            if (controller.singlePost['is_liked'] == true) {
              isLoading =
                  getIt<FeedsController>().likeLoadingMap[controller
                      .singlePost['liked_id']
                      .toString()] ==
                  true;
            } else {
              isLoading =
                  getIt<FeedsController>().likeLoadingMap[controller
                      .singlePost['business_id']
                      .toString()] ==
                  true;
            }

            return isLoading
                ? LoadingWidget(color: primaryColor, size: 20.r)
                : controller.singlePost['is_liked'] == true
                ? Icon(Icons.favorite, color: Colors.red, size: 18.sp)
                : HugeIcon(
                    icon: HugeIcons.strokeRoundedFavourite,
                    color: primaryBlack,
                    size: 18.sp,
                  );
          }),
          SizedBox(width: 6.w),
          Text(
            controller.singlePost['likes_count']?.toString() ?? '0',
            style: TextStyle(
              fontSize: 14.sp,
              color: primaryBlack,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}

Future<dynamic> _showOffer(LBOController controller, {bool isEdit = false}) {
  return Get.bottomSheet(
    ConstrainedBox(
      key: ValueKey(controller.singleOffer['id']?.toString() ?? ''),
      constraints: BoxConstraints(maxHeight: Get.height * 0.75.h),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(Get.context!).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with drag indicator
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: lightGrey,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Previous Button
                      Opacity(
                        opacity: controller.currentIndex.value > 0 ? 1.0 : 0.5,
                        child: GestureDetector(
                          onTap: controller.currentIndex.value > 0
                              ? () {
                                  controller.goToPreviousItem();
                                }
                              : null,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: lightGrey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.arrow_back_ios, size: 16.r),
                                SizedBox(width: 4.w),
                                Text(
                                  'Previous',
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Page Indicator
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${controller.currentIndex.value + 1} / ${controller.currentPostsList.length}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      // Next Button
                      Opacity(
                        opacity:
                            controller.currentIndex.value <
                                controller.currentPostsList.length - 1
                            ? 1.0
                            : 0.5,
                        child: GestureDetector(
                          onTap:
                              controller.currentIndex.value <
                                  controller.currentPostsList.length - 1
                              ? () {
                                  controller.goToNextItem();
                                }
                              : null,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: lightGrey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text('Next', style: TextStyle(fontSize: 12.sp)),
                                SizedBox(width: 4.w),
                                Icon(Icons.arrow_forward_ios, size: 16.r),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity! < -100) {
                        controller.goToNextItem();
                      } else if (details.primaryVelocity! > 100) {
                        controller.goToPreviousItem();
                      }
                    },
                    child: Obx(
                      () => SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image with better styling
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      Get.context!,
                                    ).scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(16.r),
                                    border: Border.all(
                                      width: 0.5,
                                      color: lightGrey,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child:
                                          controller
                                                  .singleOffer['media_type'] ==
                                              'video'
                                          ? InstagramVideoPlayer(
                                              isSingleView: true,
                                              key: ValueKey(
                                                controller.singleOffer['video']
                                                        ?.toString() ??
                                                    '',
                                              ),
                                              url:
                                                  controller
                                                      .singleOffer['video']
                                                      ?.toString() ??
                                                  '',
                                            )
                                          : FadeInImage(
                                              placeholder: const AssetImage(
                                                Images.defaultImage,
                                              ),
                                              image: NetworkImage(
                                                controller.singleOffer['image']
                                                    .toString(),
                                              ),
                                              imageErrorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Image.asset(
                                                      Images.defaultImage,
                                                      fit: BoxFit.contain,
                                                    );
                                                  },
                                              fit: BoxFit.contain,
                                              placeholderFit: BoxFit.contain,
                                              fadeInDuration: const Duration(
                                                milliseconds: 300,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                                if (isEdit)
                                  Positioned(
                                    bottom: 10.h,
                                    right: 10.w,
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.toNamed(
                                          Routes.editOffer,
                                          arguments: {
                                            'offerData': controller.singleOffer,
                                          },
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8.w),
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            Get.context!,
                                          ).dividerColor,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: lightGrey,
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.edit,
                                          color: primaryColor,
                                          size: 18.r,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Business Name
                            Text(
                              controller.singleOffer['business_name']
                                  .toString(),
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: primaryBlack,
                              ),
                            ),

                            SizedBox(height: 12),
                            CustomText(
                              title: controller.singleOffer['offer_name']
                                  .toString(),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: textLightGrey,
                              textAlign: TextAlign.start,
                            ),

                            // Details
                            if (controller.singleOffer['details'] != null &&
                                controller.singleOffer['details']
                                    .toString()
                                    .isNotEmpty)
                              CustomText(
                                title: controller.singleOffer['details']
                                    .toString(),
                                fontSize: 13.sp,
                                maxLines: 10,
                                textAlign: TextAlign.start,
                                color: textLightGrey,
                              ),

                            const SizedBox(height: 16),

                            // Date Range
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.blue.shade100,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 16,
                                    color: Colors.blue.shade700,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '${controller.singleOffer['start_date'] ?? ''} to ${controller.singleOffer['end_date'] ?? ''}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue.shade800,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Highlights Section
                            if (controller.singleOffer['highlight_points'] !=
                                null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Highlights',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: primaryBlack,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: controller
                                        .singleOffer['highlight_points']
                                        .map<Widget>(
                                          (v) => buildHighlightPoint(v),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ),

                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 14.r,
                                  color: textLightGrey,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  controller.singleOffer['created_at']
                                          ?.toString() ??
                                      "",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: textLightGrey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

// Future<dynamic> _showPost(LBOController controller) {
//   return Get.bottomSheet(
//     ConstrainedBox(
//       constraints: BoxConstraints(maxHeight: Get.height * 0.75.h),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//           boxShadow: [
//             BoxShadow(
//               blurRadius: 20,
//               color: Colors.black.withValues(alpha: 0.15),
//               offset: Offset(0, -2),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Drag handle
//             Container(
//               padding: EdgeInsets.symmetric(vertical: 16),
//               child: Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade400,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//             ),
//
//             Expanded(
//               child: SingleChildScrollView(
//                 physics: BouncingScrollPhysics(),
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Image with enhanced styling
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(width: 0.5, color: Colors.grey),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(16),
//                         child: AspectRatio(
//                           aspectRatio: 1,
//                           child: FadeInImage(
//                             placeholder: const AssetImage(Images.defaultImage),
//                             image: NetworkImage(
//                               controller.singlePost['image'] ?? '',
//                             ),
//                             imageErrorBuilder: (context, error, stackTrace) {
//                               return Image.asset(
//                                 Images.defaultImage,
//                                 fit: BoxFit.contain,
//                               );
//                             },
//                             fit: BoxFit.contain,
//                             placeholderFit: BoxFit.contain,
//                             fadeInDuration: const Duration(milliseconds: 300),
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     SizedBox(height: 10),
//                     // Date and Likes row
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // Date
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.calendar_today_outlined,
//                               size: 14.r,
//                               color: Colors.grey.shade600,
//                             ),
//                             SizedBox(width: 6),
//                             Text(
//                               controller.singlePost['created_at']?.toString() ??
//                                   "",
//                               style: TextStyle(
//                                 fontSize: 12.sp,
//                                 color: Colors.grey.shade700,
//                               ),
//                             ),
//                           ],
//                         ),
//                         // Likes count
//                         Row(
//                           spacing: 8,
//                           children: [
//                             Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 8.w,
//                                 vertical: 6.h,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade50,
//                                 borderRadius: BorderRadius.circular(8.r),
//                               ),
//                               child: Row(
//                                 children: [
//                                   HugeIcon(
//                                     icon: HugeIcons.strokeRoundedFavourite,
//                                     size: 16.r,
//                                   ),
//                                   SizedBox(width: 6),
//                                   Text(
//                                     controller.singlePost['likes_count']
//                                             ?.toString() ??
//                                         '0',
//                                     style: TextStyle(
//                                       fontSize: 14.sp,
//                                       color: Colors.grey.shade700,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//
//                             // Comment count
//                             Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 8.w,
//                                 vertical: 6.h,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade50,
//                                 borderRadius: BorderRadius.circular(8.r),
//                               ),
//                               child: Row(
//                                 children: [
//                                   HugeIcon(
//                                     icon: HugeIcons.strokeRoundedMessage02,
//                                     size: 16.r,
//                                   ),
//                                   SizedBox(width: 6),
//                                   Text(
//                                     controller.singlePost['likes_count']
//                                             ?.toString() ??
//                                         '0',
//                                     style: TextStyle(
//                                       fontSize: 14.sp,
//                                       color: Colors.grey.shade700,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 12.h),
//                     // Content section
//                     Container(
//                       padding: EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade50,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: Colors.grey.shade200,
//                           width: 1,
//                         ),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Section title
//                           Row(
//                             children: [
//                               Container(
//                                 padding: EdgeInsets.all(6),
//                                 decoration: BoxDecoration(
//                                   color: Colors.blue.shade50,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Icon(
//                                   Icons.description_outlined,
//                                   size: 16,
//                                   color: Colors.blue.shade700,
//                                 ),
//                               ),
//                               SizedBox(width: 8),
//                               Text(
//                                 'Post Details',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                             ],
//                           ),
//
//                           SizedBox(height: 12),
//
//                           // Details text
//                           Text(
//                             controller.singlePost['details']?.toString() ?? "",
//                             style: TextStyle(
//                               fontSize: 15.sp,
//                               height: 1.6,
//                               color: Colors.grey.shade700,
//                               letterSpacing: 0.2,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//   );
// }

Widget buildHighlightPoint(String text) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 6, right: 12),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, height: 1.4, color: textLightGrey),
          ),
        ),
      ],
    ),
  );
}

void showError(dynamic e) {
  // ToastUtils.showToast(
  //   title: 'Something went wrong',
  //   // description: e.toString(),
  //   type: ToastificationType.error,
  //   icon: Icons.error,
  // );
  // debugPrint("Error: $e");
}

void checkLogin({required bool status, required String message}) async {
  if (status == false && message == "Invalid App Security Key" ||
      message == "Invalid Request") {
    Get.snackbar(
      'Logged Out',
      "Your account is logged in on another device. You have been logged out.",
      colorText: Colors.black,
      icon: const Icon(Icons.add_alert),
    );
    Get.offAllNamed(Routes.login);
    LocalStorage.clear();
  }
}

Widget buildHeadingWithButton({
  required String title,
  required String rightText,
  required var onTap,
  bool isMore = true,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      CustomText(
        title: title,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: textSmall,
      ),
      if (isMore)
        Container(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: GestureDetector(
            onTap: onTap,
            child: CustomText(
              title: rightText,
              fontSize: 12.sp,
              color: Colors.white,
            ),
          ),
        ),
    ],
  );
}

String getTimeAgo(dynamic createdAt) {
  try {
    DateTime postTime;

    // Handle different date formats
    if (createdAt is String) {
      // Handle "Nov 18, 2025 11:14 AM" format
      if (createdAt.contains(',')) {
        postTime = _parseCustomDateFormat(createdAt);
      } else {
        // Try parsing ISO format as fallback
        postTime = DateTime.parse(createdAt);
      }
    } else if (createdAt is DateTime) {
      postTime = createdAt;
    } else if (createdAt is int) {
      // Handle timestamp (assuming milliseconds)
      postTime = DateTime.fromMillisecondsSinceEpoch(createdAt);
    } else {
      return '';
    }

    final now = DateTime.now();
    final difference = now.difference(postTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '${years}y ago';
    }
  } catch (e) {
    // Return empty string if date parsing fails
    return '';
  }
}

DateTime _parseCustomDateFormat(String dateString) {
  try {
    // Parse format: "Nov 18, 2025 11:14 AM"
    final parts = dateString.split(' ');
    if (parts.length >= 4) {
      final month = _getMonthNumber(parts[0]);
      final day = int.parse(parts[1].replaceAll(',', ''));
      final year = int.parse(parts[2]);

      // Parse time and AM/PM
      final timeParts = parts[3].split(':');
      var hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      // Handle AM/PM if present
      if (parts.length > 4) {
        final period = parts[4].toUpperCase();
        if (period == 'PM' && hour < 12) {
          hour += 12;
        } else if (period == 'AM' && hour == 12) {
          hour = 0;
        }
      }

      return DateTime(year, month, day, hour, minute);
    }
    throw FormatException('Invalid date format');
  } catch (e) {
    throw FormatException('Unable to parse date: $dateString');
  }
}

int _getMonthNumber(String monthAbbreviation) {
  const months = {
    'Jan': 1,
    'Feb': 2,
    'Mar': 3,
    'Apr': 4,
    'May': 5,
    'Jun': 6,
    'Jul': 7,
    'Aug': 8,
    'Sep': 9,
    'Oct': 10,
    'Nov': 11,
    'Dec': 12,
  };

  final monthKey = monthAbbreviation.substring(0, 3);
  return months[monthKey] ?? 1;
}

// Helper widget
Widget buildDotSeparator() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 4.w),
    child: Container(
      width: 4.r,
      height: 4.r,
      decoration: BoxDecoration(
        color: Colors.grey.shade500,
        shape: BoxShape.circle,
      ),
    ),
  );
}

Widget commonNoDataFound({bool isHome = false}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          Images.noData,
          width: 120.w,
          height: 120.h,
          fit: BoxFit.contain,
        ),
        SizedBox(height: 20),
        Text(
          "No data found",
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (isHome)
          GestureDetector(
            onTap: () async {
              getIt<SpecialOfferController>().resetData();
              await getIt<FeedsController>().getFeeds();
            },
            child: Container(
              width: Get.width * 0.5.w,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: CustomText(
                title: 'Reset Filter',
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    ),
  );
}

void expandContent(dynamic data) {
  // Implement content expansion
  Get.dialog(
    AlertDialog(
      surfaceTintColor: Theme.of(Get.context!).scaffoldBackgroundColor,
      backgroundColor: Theme.of(Get.context!).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      content: SingleChildScrollView(
        child: CustomText(
          title: data ?? '',
          fontSize: 14.sp,
          maxLines: 30,
          color: inverseColor,
          textAlign: TextAlign.start,
        ),
      ),
      actionsPadding: EdgeInsets.zero,
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Close', style: TextStyle(color: primaryColor)),
        ),
      ],
    ),
  );
}

Widget buildEngagementButton({
  required dynamic icon,
  required IconData activeIcon,
  required bool isActive,
  required String count,
  required VoidCallback onTap,
  Color? activeColor,
  bool isComment = false,
}) {
  final color = isActive ? (activeColor ?? primaryColor) : Colors.grey.shade600;

  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isActive ? color.withValues(alpha: 0.1) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: isComment
                ? HugeIcon(icon: icon, color: Colors.grey.shade700, size: 18.sp)
                : Icon(
                    isActive ? activeIcon : icon,
                    key: ValueKey(isActive),
                    size: 18.sp,
                    color: color,
                  ),
          ),
          if (count.isNotEmpty) ...[
            SizedBox(width: 6.w),
            Text(
              formatCount(int.tryParse(count) ?? 0),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

String formatCount(int count) {
  if (count >= 1000000) {
    return '${(count / 1000000).toStringAsFixed(1)}M';
  } else if (count >= 1000) {
    return '${(count / 1000).toStringAsFixed(1)}K';
  }
  return count.toString();
}
