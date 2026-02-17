import 'package:businessbuddy/utils/exported_path.dart';

class InstagramOfferView extends StatefulWidget {
  final String offerId;
  final String isFrom;
  final dynamic followButton;
  final Future<void> Function() refresh;

  const InstagramOfferView({
    super.key,
    required this.offerId,
    required this.isFrom,
    this.followButton,
    required this.refresh,
  });

  @override
  State<InstagramOfferView> createState() => _InstagramOfferViewState();
}

class _InstagramOfferViewState extends State<InstagramOfferView> {
  final controller = getIt<LBOController>();
  final navController = getIt<NavigationController>();
  bool _showAllPoints = false;

  @override
  void initState() {
    super.initState();
    getIt<GlobalVideoMuteController>().makeViewTrue();
    controller.getSingleOffer(widget.offerId.toString());
  }

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
            title: 'Special Offer',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: primaryBlack,
          ),
        ),

        // AppbarPlain(title: 'Special Offer', showBackButton: false),
        body: Obx(
          () => controller.isSingleOfferLoading.isTrue
              ? OfferDetailShimmer()
              : Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Offer Header
                          _buildOfferHeader(),
                          // Offer Image with Right-side Icons
                          SizedBox(
                            height: Get.height * 0.7.h,
                            child: _buildOfferImageWithIcons(),
                          ),
                          // Offer Details
                          _buildOfferDetails(),
                          // Highlight Points
                          _buildHighlightPoints(),
                          // Date Range
                          _buildDateRange(),

                          SizedBox(height: 20),
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

  Widget _buildOfferHeader() {
    final String image = controller.singleOffer['business_profile_image'] ?? '';

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
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: GestureDetector(
              onTap: _openBusinessDetails,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: controller.singleOffer['business_name'] ?? '',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                    color: primaryBlack,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Flexible(
                        child: CustomText(
                          title: controller.singleOffer['category'] ?? '',
                          fontSize: 10.sp,
                          textAlign: TextAlign.start,
                          color: textSmall,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 4),
                      _dot(),
                      const SizedBox(width: 4),
                      _buildTimeDisplay(),
                      const SizedBox(width: 4),
                      _dot(),
                      const SizedBox(width: 4),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 90.w),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.red.shade100),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.local_offer,
                                color: Colors.red,
                                size: 12.r,
                              ),
                              SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  'Special Offer',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12),

          // Follow button
          widget.followButton ?? SizedBox(),
        ],
      ),
    );
  }

  Widget _dot() => Container(
    width: 3,
    height: 3,
    decoration: BoxDecoration(shape: BoxShape.circle, color: textLightGrey),
  );

  Widget _buildTimeDisplay() {
    final createdAt = controller.singleOffer['created_at'] ?? '';
    if (createdAt.toString().isEmpty) return SizedBox();

    return CustomText(
      title: getTimeAgo(createdAt),
      fontSize: 10.sp,
      textAlign: TextAlign.start,
      color: textSmall,
      maxLines: 1,
    );
  }

  Widget _buildOfferImageWithIcons() {
    final image = controller.singleOffer['image'] ?? '';
    final video = controller.singleOffer['video'] ?? '';
    final mediaType = controller.singleOffer['media_type'] ?? '';

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
    return Positioned(
      right: 16,
      bottom: Get.height * 0.2,
      child: Column(
        children: [
          _buildLikeButton(),
          const SizedBox(height: 10),
          _buildRightIcon(
            icon: HugeIcons.strokeRoundedMessage02,
            color: Colors.white,
            count: controller.singleOffer['comments_count']?.toString() ?? '0',
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
    final offer = controller.singleOffer;
    final String offerId = offer['id']?.toString() ?? '';

    final bool isLiked = offer['is_offer_liked'] == true;
    final String likeCount = offer['offer_likes_count']?.toString() ?? '0';
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, anim) {
        return ScaleTransition(scale: anim, child: child);
      },
      child: _buildRightIcon(
        key: ValueKey(isLiked), // 🔥 REQUIRED
        isLike: true,
        icon: isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : Colors.white,
        count: likeCount.toString(),
        onTap: () async {
          if (offerId.isEmpty) return;

          await handleOfferLike(offer, () async {
            await controller.getSingleOffer(offerId, showLoading: false);

            // 🔥 FORCE feed refresh
            await widget.refresh();
          });
        },
      ),
    );
  }

  void _handleShare() {
    AppShare.share(
      type: ShareEntityType.offer,
      id: widget.offerId.toString(),
      slug: controller.singleOffer['business_slug']?.toString() ?? '',
    );
  }

  void _handleComment() {
    if (!getIt<DemoService>().isDemo) {
      ToastUtils.showLoginToast();
      return;
    }
    Get.bottomSheet(
      CommentsBottomSheet(
        postId: controller.singleOffer['id']?.toString() ?? '',
        isPost: false,
        isSingle: true,
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
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.35),
              shape: BoxShape.circle,
            ),
            child: isLike
                ? Icon(icon, color: color, size: 18.r)
                : HugeIcon(icon: icon, color: color, size: 18.r),
          ),
          if (!isShare) const SizedBox(height: 4),
          if (!isShare)
            Text(
              count,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOfferDetails() {
    final offerName = controller.singleOffer['offer_name'] ?? '';
    final details = controller.singleOffer['details'] ?? '';

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Offer Title
          CustomText(
            title: offerName,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: primaryColor,
            textAlign: TextAlign.start,
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          // Offer Description
          CustomText(
            title: details,
            fontSize: 14.sp,
            textAlign: TextAlign.start,
            // color: ,
            style: TextStyle(fontSize: 14.sp, height: 1.5),
            maxLines: 2,
          ),
          if (details.length > 150)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: GestureDetector(
                onTap: () => expandContent(details),
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
      ),
    );
  }

  Widget _buildHighlightPoints() {
    final List<dynamic> points =
        controller.singleOffer['highlight_points'] ?? [];
    final int maxVisiblePoints = 3;

    if (points.isEmpty) return SizedBox();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Highlights:',
            style: TextStyle(
              color: primaryBlack,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: (_showAllPoints ? points : points.take(maxVisiblePoints))
                .map<Widget>((point) {
                  return buildBulletPoint(text: point.toString());
                })
                .toList(),
          ),
          if (points.length > maxVisiblePoints && !_showAllPoints)
            GestureDetector(
              onTap: () {
                setState(() => _showAllPoints = true);
              },
              child: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Show more highlights',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDateRange() {
    final startDate = controller.singleOffer['start_date'] ?? '';
    final endDate = controller.singleOffer['end_date'] ?? '';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: lightGrey),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: primaryColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Valid Until',
                    style: TextStyle(color: textSmall, fontSize: 12.sp),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$startDate - $endDate',
                    style: TextStyle(
                      color: primaryBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openBusinessDetails() {
    Get.back();
    navController.openSubPage(
      CategoryDetailPage(
        title: controller.singleOffer['business_name'] ?? '',
        businessId: controller.singleOffer['business_id']?.toString() ?? '',
      ),
    );
  }
}
