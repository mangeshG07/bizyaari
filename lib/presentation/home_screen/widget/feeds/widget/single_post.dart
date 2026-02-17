import 'package:businessbuddy/utils/exported_path.dart';

class InstagramPostView extends StatefulWidget {
  final String postId;
  final String isFrom;
  final dynamic followButton;
  final void Function() refresh;

  const InstagramPostView({
    super.key,
    required this.postId,
    this.followButton,
    required this.isFrom,
    required this.refresh,
  });

  @override
  State<InstagramPostView> createState() => _InstagramPostViewState();
}

class _InstagramPostViewState extends State<InstagramPostView> {
  final controller = getIt<LBOController>();
  final navController = getIt<NavigationController>();

  @override
  void initState() {
    controller.getSinglePost(widget.postId.toString());
    getIt<GlobalVideoMuteController>().makeViewTrue();
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final box = _captionKey.currentContext?.findRenderObject() as RenderBox?;
  //     if (box != null) {
  //       setState(() {
  //         _captionHeight = box.size.height;
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) => _handleBack(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: primaryBlack,
          elevation: 0,
          leading: BackButton(onPressed: () => _handleBack()),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: Theme.of(context).brightness == Brightness.light
                    ? [primaryColor.withValues(alpha: 0.5), Colors.white]
                    : [primaryColor, Colors.black54],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          centerTitle: true,
          title: CustomText(
            title: 'Post',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: primaryBlack,
          ),
        ),
        body: Obx(
          () => controller.isSinglePostLoading.isTrue
              // ? LoadingWidget(color: primaryColor)
              ? OfferDetailShimmer()
              : Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildPostHeader(),
                          SizedBox(
                            height: Get.height * 0.7.h,
                            child: _buildPostMediaWithIcons(),
                          ),
                          _buildCaptionSection(),
                        ],
                      ),
                    ),
                    _buildFloatingRightIcons(),
                  ],
                ),
        ),
      ),
    );
  }

  void _handleBack() {
    if (Get.isBottomSheetOpen ?? false) {
      Navigator.of(context).pop(); // close only bottomsheet
      return;
    }

    if (widget.isFrom == 'deep') {
      Get.offAllNamed(Routes.mainScreen);
      return;
    }

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    // if (widget.isFrom == 'deep') {
    //   Get.offAllNamed(Routes.mainScreen);
    // } else {
    //   Get.back();
    // }
  }

  Widget _buildPostHeader() {
    final image = controller.singlePost['business_profile_image'] ?? '';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: lightGrey, width: 0.5)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _openBusinessDetails,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: lightGrey,
              child: ClipOval(
                child: CachedNetworkImage(
                  placeholder: (_, __) => Image.asset(Images.defaultImage),
                  imageUrl: image,
                  width: double.infinity,
                  height: 100.w,
                  fit: BoxFit.cover,
                  errorWidget: (context, error, stackTrace) {
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
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: _openBusinessDetails,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: controller.singlePost['business_name'] ?? '',
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                    color: primaryBlack,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      CustomText(
                        title: controller.singlePost['category'] ?? '',
                        fontSize: 10.sp,
                        textAlign: TextAlign.start,
                        color: textLightGrey,
                        maxLines: 1,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Container(
                          width: 3.r,
                          height: 3.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: textLightGrey,
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
          widget.followButton ?? SizedBox(),
        ],
      ),
    );
  }

  Widget _buildTimeDisplay() {
    final createdAt = controller.singlePost['created_at'] ?? '';
    if (createdAt == null || createdAt.toString().isEmpty) {
      return SizedBox();
    }

    return CustomText(
      title: getTimeAgo(createdAt),
      fontSize: 10.sp,
      textAlign: TextAlign.start,
      color: textLightGrey,
      maxLines: 1,
    );
  }

  Widget _buildPostMediaWithIcons() {
    final image = controller.singlePost['image'] ?? '';
    final video = controller.singlePost['video'] ?? '';
    final mediaType = controller.singlePost['media_type'] ?? '';

    return Container(
      color: Colors.black,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      width: double.infinity,
      child: mediaType == 'video'
          ? InstagramVideoPlayer(
              isSingleView: true,
              key: ValueKey(video),
              url: video?.toString() ?? '',
            )
          : CachedNetworkImage(
              placeholder: (_, __) => Image.asset(Images.defaultImage),
              imageUrl: image,
              fit: BoxFit.contain,
              memCacheHeight: 600,
              errorWidget: (_, __, ___) => Image.asset(Images.defaultImage),
              fadeInDuration: Duration.zero,
            ),
    );
  }

  Widget _buildFloatingRightIcons() {
    // final screenHeight = MediaQuery.of(context).size.height;
    //
    // /// Minimum spacing from caption
    // final minBottomSpacing = 60 + 24;

    // /// Clamp position to avoid overlap
    // final bottomPosition = (screenHeight * 0.18).clamp(
    //   minBottomSpacing,
    //   screenHeight * 0.45,
    // );
    return Positioned(
      right: 16,
      bottom: 60,
      child: Column(
        children: [
          _buildLikeButton(),
          const SizedBox(height: 10),
          _buildRightIcon(
            icon: HugeIcons.strokeRoundedMessage02,
            color: Colors.white,
            count: controller.singlePost['comments_count']?.toString() ?? '0',
            onTap: _handleComment,
          ),
          const SizedBox(height: 10),
          _buildRightIcon(
            icon: HugeIcons.strokeRoundedSent,
            color: Colors.white,
            count: '0',
            onTap: _handleShare,
            isShare: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLikeButton() {
    return Obx(() {
      final postId = controller.singlePost['id'].toString();
      final isLiked = controller.singlePost['is_liked'] == true;
      final likeCount = controller.singlePost['likes_count']?.toString() ?? '0';
      final isLoading = getIt<FeedsController>().isPostLikeLoading(postId);

      return AbsorbPointer(
        absorbing: isLoading,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isLoading ? 0.5 : 1,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeOutBack,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, anim) {
              return ScaleTransition(scale: anim, child: child);
            },
            child: _buildRightIcon(
              key: ValueKey(isLiked),
              // 🔥 REQUIRED
              isLike: true,
              icon: isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.white,
              count: likeCount,
              onTap: () async {
                await handleFeedLike(
                  isSingle: true,
                  controller.singlePost,
                  () async => await controller
                      .getSinglePost(postId, showLoading: false)
                      .then((v) {
                        widget.refresh.call();
                      }),
                );
              },
            ),
          ),
        ),
      );
    });
  }

  void _handleComment() {
    if (!getIt<DemoService>().isDemo) {
      ToastUtils.showLoginToast();
      return;
    }
    Get.bottomSheet(
      CommentsBottomSheet(
        isSingle: true,
        postId: controller.singlePost['id']?.toString() ?? '',
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

  void _handleShare() {
    AppShare.share(
      type: ShareEntityType.post,
      id: widget.postId.toString(),
      slug: controller.singlePost['business_slug']?.toString() ?? '',
    );
  }

  Widget _buildRightIcon({
    Key? key,
    required dynamic icon,
    required Color color,
    required String count,
    required VoidCallback onTap,
    bool isLike = false,
    bool isShare = false,
  }) {
    return InkWell(
      key: key,
      borderRadius: BorderRadius.circular(30.r),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              shape: BoxShape.circle,
            ),
            child: isLike
                ? Icon(icon, color: color, size: 20.r)
                : HugeIcon(icon: icon, color: color, size: 20.r),
          ),
          if (!isShare) const SizedBox(height: 4),
          if (!isShare)
            Text(
              count,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCaptionSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: lightGrey)),
      ),
      child: _buildCaption(),
    );
  }

  Widget _buildCaption() {
    final content = controller.singlePost['details'] ?? '';
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 13.5.sp, color: primaryBlack, height: 1.4),
        children: [
          TextSpan(
            text: '${controller.singlePost['business_name']} ',
            style: TextStyle(
              color: primaryBlack,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          TextSpan(
            text: content,
            style: TextStyle(color: primaryBlack, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  void _openBusinessDetails() {
    Get.back();
    navController.openSubPage(
      CategoryDetailPage(
        title: controller.singlePost['business_name'] ?? '',
        businessId: controller.singlePost['business_id']?.toString() ?? '',
      ),
    );
  }
}
