import '../../../../../utils/exported_path.dart';

class CategoryDetailPage extends StatefulWidget {
  final String title;
  final String businessId;
  const CategoryDetailPage({
    super.key,
    required this.title,
    required this.businessId,
  });

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  final controller = getIt<ExplorerController>();
  final navController = getIt<NavigationController>();
  final feedsController = getIt<FeedsController>();

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    controller.getBusinessDetails(widget.businessId);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        const Divider(),
        Expanded(
          child: Obx(
            () => controller.isDetailsLoading.isTrue
                ? CategoryDetailShimmer()
                : controller.businessDetails.isEmpty
                ? commonNoDataFound()
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 20.h, top: 0.h),
                    child: _buildBody(),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Row(
        spacing: 8,
        children: [
          GestureDetector(
            onTap: () => navController.goBack(),
            child: const Icon(Icons.arrow_back),
          ),
          CustomText(
            title: widget.title,
            fontSize: 18.sp,
            color: primaryBlack,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSection(),
          SizedBox(height: 18.h),
          _buildHotelDetails(),
          SizedBox(height: 12.h),
          if (controller.businessDetails['self_business'] == false)
            _buildActionButtons(),
          Divider(),
          _buildAboutSection(),
          _buildPostAndOffers(),
          Divider(),
          _buildReviewsSection(),
        ],
      ),
    );
  }

  List<String> get allImages {
    final mainImage = controller.businessDetails['image'];
    final attachments = List<String>.from(
      controller.businessDetails['attachments'] ?? [],
    );

    return [
      if (mainImage != null && mainImage.toString().isNotEmpty) mainImage,
      ...attachments,
    ];
  }

  Widget _buildImageSection() {
    return Column(
      children: [
        _buildMainImageSlider(),
        SizedBox(height: 12.h),
        _buildImageGallery(),
      ],
    );
  }

  Widget _buildMainImageSlider() {
    final images = allImages;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: lightGrey),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: SizedBox(
              height: 180.h,
              width: double.infinity,
              child: PageView.builder(
                controller: _pageController,
                itemCount: images.length,
                onPageChanged: (index) {
                  controller.currentIndex.value = index;
                },
                itemBuilder: (_, index) {
                  return FadeInImage(
                    placeholder: const AssetImage(Images.defaultImage),
                    image: NetworkImage(images[index]),
                    width: double.infinity,
                    height: 180.h,
                    fit: BoxFit.cover,
                    imageErrorBuilder: (_, __, ___) {
                      return Image.asset(
                        Images.defaultImage,
                        fit: BoxFit.cover,
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Positioned(top: 10, right: 10, child: _buildCategoryChip()),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    final images = allImages;

    return SizedBox(
      height: 64.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: () {
              controller.currentIndex.value = index;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: _buildGalleryImage(images[index], index),
          );
        },
      ),
    );
  }

  Widget _buildGalleryImage(String image, int index) {
    return Obx(() {
      final isSelected = controller.currentIndex.value == index;
      return Container(
        width: 64.w,
        height: 64.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? primaryColor : lightGrey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: FadeInImage(
            placeholder: const AssetImage(Images.defaultImage),
            image: NetworkImage(image),
            fit: BoxFit.contain,
            imageErrorBuilder: (_, __, ___) {
              return Image.asset(Images.defaultImage, fit: BoxFit.cover);
            },
          ),
        ),
      );
    });
  }

  // Widget _buildMainImage() {
  //   final image = controller.businessDetails['image'] ?? '';
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(16.r),
  //       border: Border.all(color: Colors.grey.shade200, width: 1),
  //     ),
  //     child: Stack(
  //       children: [
  //         ClipRRect(
  //           borderRadius: BorderRadius.circular(16.r),
  //           child: FadeInImage(
  //             placeholder: const AssetImage(Images.defaultImage),
  //             image: NetworkImage(image),
  //             width: double.infinity,
  //             height: 180.h,
  //             imageErrorBuilder: (context, error, stackTrace) {
  //               return Container(
  //                 width: double.infinity,
  //                 height: 180.h,
  //                 padding: EdgeInsets.all(32.w),
  //                 child: Image.asset(Images.defaultImage, fit: BoxFit.cover),
  //               );
  //             },
  //             fit: BoxFit.cover,
  //             placeholderFit: BoxFit.contain,
  //             fadeInDuration: const Duration(milliseconds: 500),
  //           ),
  //         ),
  //         Positioned(top: 10, right: 10, child: _buildCategoryChip()),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildImageGallery() {
  //   final images = controller.businessDetails['attachments'];
  //   return SizedBox(
  //     height: 60.h,
  //     child: ListView.separated(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: images.length,
  //       separatorBuilder: (_, __) => SizedBox(width: 8.w),
  //       itemBuilder: (context, index) {
  //         final attach = images[index];
  //         return _buildGalleryImage(attach);
  //
  //         //   return GestureDetector(
  //         //     onTap: () {
  //         //       // Add image preview functionality
  //         //     },
  //         //     child: Container(
  //         //       width: 64.w,
  //         //       height: 64.h,
  //         //       decoration: BoxDecoration(
  //         //         borderRadius: BorderRadius.circular(12.r),
  //         //         border: Border.all(color: Colors.grey.shade200, width: 1),
  //         //         image: DecorationImage(
  //         //           image: NetworkImage(images[index]),
  //         //           fit: BoxFit.cover,
  //         //         ),
  //         //       ),
  //         //     ),
  //         //   );
  //       },
  //     ),
  //   );
  // }

  // Widget _buildGalleryImage(dynamic attach) {
  //   return Container(
  //     width: 64.w,
  //     height: 64.h,
  //     decoration: BoxDecoration(
  //       border: Border.all(color: Colors.grey.shade200),
  //       borderRadius: BorderRadius.circular(12.r),
  //     ),
  //     child: WidgetZoom(
  //       heroAnimationTag: 'tag $attach',
  //       zoomWidget: ClipRRect(
  //         borderRadius: BorderRadius.circular(12.r),
  //         child: FadeInImage(
  //           width: 64.w,
  //           height: 64.h,
  //           placeholder: const AssetImage(Images.defaultImage),
  //           image: NetworkImage(attach),
  //           fit: BoxFit.contain,
  //           imageErrorBuilder: (context, error, stackTrace) {
  //             return Container(
  //               padding: EdgeInsets.all(20.w),
  //               child: Image.asset(Images.defaultImage, fit: BoxFit.contain),
  //             );
  //           },
  //           fadeInDuration: const Duration(milliseconds: 300),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildHotelDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: widget.title,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: primaryBlack,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                  ),
                  SizedBox(height: 8.h),
                  _buildRatingSection(),
                  SizedBox(height: 8.h),
                  _buildFollowCount(),
                  SizedBox(height: 8.h),
                  _buildLocationSection(),
                  // SizedBox(height: 8.h),
                  // _buildCategoryChip(),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            _buildOfferCard(),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded, color: Colors.white, size: 14.sp),
              SizedBox(width: 4.w),
              CustomText(
                title:
                    controller.businessDetails['total_rating']?.toString() ??
                    '',
                fontSize: 12.sp,
                textAlign: TextAlign.start,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        CustomText(
          title:
              '(${controller.businessDetails['reviews_count']?.toString() ?? ''} reviews)',
          fontSize: 12.sp,
          color: Colors.grey.shade600,
        ),
      ],
    );
  }

  Widget _buildFollowCount() {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            spacing: 8.w,
            mainAxisSize: MainAxisSize.min,
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedUserAdd02,
                size: 16.sp,
                color: Colors.grey,
              ),
              CustomText(
                title:
                    '${controller.businessDetails['followers_count']} Followers',
                fontSize: 12.sp,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildLocationSection() {
  //   final details = controller.businessDetails;
  //
  //   final address = (details['address'] ?? '').toString();
  //   final distance = (details['distance'] ?? '').toString();
  //   final lat = double.tryParse(details['latitude']?.toString() ?? '');
  //   final lng = double.tryParse(details['longitude']?.toString() ?? '');
  //
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Expanded(
  //         child: Row(
  //           children: [
  //             Icon(
  //               Icons.location_on_outlined,
  //               color: Colors.grey.shade600,
  //               size: 16.sp,
  //             ),
  //             SizedBox(width: 6.w),
  //             Expanded(
  //               child: CustomText(
  //                 title:
  //                     '${controller.businessDetails['address'] ?? ''} | ${controller.businessDetails['distance']?.toString() ?? ''} km',
  //                 fontSize: 14.sp,
  //                 textAlign: TextAlign.start,
  //                 color: Colors.grey.shade700,
  //                 maxLines: 1,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       GestureDetector(
  //         onTap: () {
  //           openMap(
  //             double.parse(controller.businessDetails['latitude']),
  //             double.parse(controller.businessDetails['longitude']),
  //           );
  //         },
  //         child: HugeIcon(
  //           icon: HugeIcons.strokeRoundedLocation05,
  //           color: primaryColor,
  //           // size: 20.sp,
  //         ),
  //       ),
  //     ],
  //   );
  // }
  Widget _buildLocationSection() {
    final details = controller.businessDetails;

    final address = (details['address'] ?? '').toString();
    final distance = (details['distance'] ?? '').toString();
    final lat = double.tryParse(details['latitude']?.toString() ?? '');
    final lng = double.tryParse(details['longitude']?.toString() ?? '');

    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// LEFT SIDE: Address + Distance
        Expanded(
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: textLightGrey,
                size: 16.sp,
              ),
              SizedBox(width: 6.w),

              Flexible(
                child: CustomText(
                  title: '$address | $distance km',
                  fontSize: 14.sp,
                  color: textLightGrey,
                  textAlign: TextAlign.start,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),

        /// PUSHES ICON TO THE RIGHT SIDE
        // Spacer(),
        SizedBox(width: 12.w),

        /// RIGHT SIDE ICON
        GestureDetector(
          onTap: () {
            if (!getIt<DemoService>().isDemo) {
              ToastUtils.showLoginToast();
              return;
            }
            if (lat != null && lng != null) {
              openMap(lat, lng);
            } else {
              Get.snackbar(
                "Location Error",
                "Unable to open map. Invalid coordinates.",
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedLocation05,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip() {
    final category = controller.businessDetails['category'];
    if (category == null) return SizedBox();
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: CustomText(
            title: controller.businessDetails['category'] ?? '',
            fontSize: 12.sp,
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildOfferCard() {
    final offerCount =
        controller.businessDetails['offers_count']?.toString() ?? '';
    final offer = controller.businessDetails['offers'] ?? [];
    if (offer.isEmpty) return SizedBox();
    return GestureDetector(
      onTap: () {
        AllDialogs().offerDialog(offer);
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Theme.of(Get.context!).brightness == Brightness.light
                    ? primaryColor.withValues(alpha: 0.2)
                    : Colors.white,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 4.h),
                HugeIcon(
                  icon: HugeIcons.strokeRoundedDiscount,
                  color: Theme.of(Get.context!).brightness == Brightness.light
                      ? primaryColor
                      : Colors.white,
                  size: 20.sp,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  title: 'See Offer',
                  fontSize: 10.sp,
                  color: Theme.of(Get.context!).brightness == Brightness.light
                      ? primaryColor
                      : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          Positioned(
            top: -15,
            child: Wrap(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(Get.context!).brightness == Brightness.light
                        ? lightGrey
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    spacing: 2.w,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedDiscount,
                        size: 16.sp,
                        color: primaryColor,
                      ),
                      CustomText(
                        title: '$offerCount Offers',
                        fontSize: 12.sp,
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final whatsapp = controller.businessDetails['whatsapp_number'] ?? '';
    return Row(
      spacing: 12.w,
      children: [
        if (whatsapp != null && whatsapp.toString().trim().isNotEmpty)
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                if (!getIt<DemoService>().isDemo) {
                  ToastUtils.showLoginToast();
                  return;
                }
                onWhatsApp(whatsapp.toString());
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedWhatsapp,
                  size: 16.sp,
                  color: Colors.green,
                ),
              ),
            ),
          ),
        Expanded(
          flex: 2,
          child: _buildActionButton(
            icon: Icons.call_outlined,
            text: '',
            onPressed: () => _handleCall(),
            backgroundColor: primaryColor,
            isPrimary: false,
          ),
        ),
        Expanded(
          flex: 3,
          child: Obx(() {
            return controller.isFollowLoading.value
                ? LoadingWidget(color: primaryColor)
                : _buildActionButton(
                    icon: controller.businessDetails['is_followed'] == true
                        ? Icons.person_remove_alt_1_outlined
                        : Icons.person_add_outlined,
                    text: controller.businessDetails['is_followed'] == true
                        ? 'Following'
                        : 'Follow',
                    onPressed: () => _handleFollow(),
                    backgroundColor: Colors.transparent,
                    isPrimary: true,
                  );
          }),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isPrimary == false ? Colors.transparent : primaryColor,
          border: Border.all(
            color: text == ''
                ? Theme.of(context).brightness == Brightness.light
                      ? primaryColor
                      : Colors.white
                : primaryColor,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: !isPrimary ? primaryColor : Colors.white,
              size: 18.sp,
            ),
            // SizedBox(width: 8.w),
            CustomText(
              title: text,
              fontSize: 13.sp,
              color: !isPrimary ? Colors.black : Colors.white,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: 'About',
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: primaryBlack,
        ),
        CustomText(
          title: controller.businessDetails['about_business'] ?? '',
          fontSize: 14.sp,
          maxLines: 20,
          textAlign: TextAlign.start,
          color: textGrey,
        ),
        SizedBox(height: 16.h),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildPostAndOffers() {
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- Tab Bar ---
            TabBar(
              onTap: (i) {
                controller.tabIndex.value = i;
              },
              indicatorColor: primaryColor,
              labelColor: primaryColor,
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Post'),
                Tab(text: 'Offer'),
              ],
            ),
            Obx(() {
              return IndexedStack(
                index: controller.tabIndex.value,
                children: [
                  buildGridImages(controller.businessDetails['posts'], 'post'),
                  buildGridImages(
                    controller.businessDetails['offers'],
                    'offer',
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSection() {
    final reviewList = controller.businessDetails['reviews'] ?? [];
    return ExpansionTile(
      trailing: SizedBox(
        width: 60.w, // Fixed width to prevent layout issues
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Expansion arrow
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey.shade600,
              size: 22.w,
            ),
            SizedBox(width: 12.w),
            if (controller.businessDetails['self_business'] != true)
              GestureDetector(
                onTap: () => _addReview(),
                child: Icon(
                  Icons.add_circle_outline,
                  color: primaryColor,
                  size: 22.w,
                ),
              ),
          ],
        ),
      ),
      title: CustomText(
        title: 'Reviews & Ratings',
        fontSize: 16.sp,
        textAlign: TextAlign.start,
        fontWeight: FontWeight.w600,
        color: primaryBlack,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      collapsedShape: const RoundedRectangleBorder(
        // Remove collapsed border shape
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      tilePadding: EdgeInsets.symmetric(horizontal: 0),
      childrenPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      children: [
        ...reviewList.map((item) {
          return Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: _buildReviewTile(
              userName: item['user_name'] ?? "",
              review: item['review'] ?? "",
              rating: item['rating'] ?? '0',
              imageUrl: item['user_profile_image'] ?? "",
              date: item['created_at'] ?? "",
            ),
          );
        }).toList(),
        SizedBox(height: 8.h),
        // _buildViewAllReviews(),
      ],
    );
  }

  Widget _buildReviewTile({
    required String userName,
    required String review,
    required String rating,
    required String date,
    String? imageUrl,
  }) {
    return Row(
      spacing: 12.w,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 22.r,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100.r),
            child: FadeInImage(
              placeholder: const AssetImage(Images.defaultImage),
              image: NetworkImage(imageUrl!),
              fit: BoxFit.cover,
              width: 100,
              height: 100,
              imageErrorBuilder: (context, error, stackTrace) {
                return Container(
                  padding: EdgeInsets.all(20.w),
                  child: Image.asset(Images.defaultImage, fit: BoxFit.contain),
                );
              },
              fadeInDuration: const Duration(milliseconds: 300),
            ),
          ),
        ),
        // Content
        Expanded(
          child: Column(
            spacing: 4.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title: userName,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                textAlign: TextAlign.start,
                maxLines: 2,
                color: primaryBlack,
              ),

              // Rating
              // buildStarRating(int.parse(rating)),
              Row(
                children: [
                  Icon(Icons.star, size: 16.r, color: Colors.orange),
                  SizedBox(width: 4),
                  Text(rating.toString(), style: TextStyle(fontSize: 13.sp)),
                ],
              ),
              CustomText(
                title: review,
                fontSize: 13.sp,
                color: primaryBlack,
                textAlign: TextAlign.start,
                maxLines: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleCall() {
    if (!getIt<DemoService>().isDemo) {
      ToastUtils.showLoginToast();
      return;
    }
    makePhoneCall(controller.businessDetails['mobile_number'] ?? '');
  }

  void _handleFollow() async {
    final isFollowed = controller.businessDetails['is_followed'] ?? false;
    final item = controller.businessDetails;
    if (!getIt<DemoService>().isDemo) {
      ToastUtils.showLoginToast();
      return;
    }
    controller.isFollowLoading.value = true;
    if (isFollowed == true) {
      await feedsController.unfollowBusiness(item['follow_id'].toString());
    } else {
      await feedsController.followBusiness(item['id'].toString());
    }

    item['is_followed'] = !item['is_followed'];
    await controller.getBusinessDetails(widget.businessId, showLoading: false);

    controller.isFollowLoading.value = false;
  }

  void _addReview() {
    if (!getIt<DemoService>().isDemo) {
      ToastUtils.showLoginToast();
      return;
    }
    Get.dialog(
      ReviewDialog(
        productName: widget.title,
        imageUrl: controller.businessDetails['image'] ?? "",
        onSubmit: (rating, review) async {
          await controller.addReview(
            controller.businessDetails['id'].toString(),
          );
        },
      ),
    );
    // Implement add review functionality
  }
}

// class CategoryDetailPage extends StatefulWidget {
//   final String title;
//   final String businessId;
//   const CategoryDetailPage({
//     super.key,
//     required this.title,
//     required this.businessId,
//   });
//
//   @override
//   State<CategoryDetailPage> createState() => _CategoryDetailPageState();
// }
//
// class _CategoryDetailPageState extends State<CategoryDetailPage> {
//   final controller = getIt<ExplorerController>();
//   final navController = getIt<NavigationController>();
//   final feedsController = getIt<FeedsController>();
//
//   @override
//   void initState() {
//     controller.getBusinessDetails(widget.businessId);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       body: Column(
//         children: [
//           _buildHeader(),
//           const Divider(height: 0),
//           Expanded(
//             child: Obx(
//                   () => controller.isDetailsLoading.isTrue
//                   ? LoadingWidget(color: primaryColor)
//                   : controller.businessDetails.isEmpty
//                   ? _buildEmptyState()
//                   : _buildContent(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//       child: Row(
//         children: [
//           _buildBackButton(),
//           SizedBox(width: 12.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustomText(
//                   title: widget.title,
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black87,
//                   maxLines: 1,
//                   // overflow: TextOverflow.ellipsis,
//                 ),
//                 SizedBox(height: 2.h),
//                 _buildHeaderSubtitle(),
//               ],
//             ),
//           ),
//           SizedBox(width: 12.w),
//           _buildHeaderActions(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBackButton() {
//     return GestureDetector(
//       onTap: () => navController.goBack(),
//       child: Container(
//         width: 40.w,
//         height: 40.w,
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           shape: BoxShape.circle,
//         ),
//         child: Icon(
//           Icons.arrow_back_ios_rounded,
//           size: 18.sp,
//           color: Colors.grey.shade700,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeaderSubtitle() {
//     final details = controller.businessDetails;
//     if (details.isEmpty) return SizedBox();
//
//     return Row(
//       children: [
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
//           decoration: BoxDecoration(
//             color: primaryColor.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(4.r),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(Icons.star, size: 12.sp, color: primaryColor),
//               SizedBox(width: 4.w),
//               CustomText(
//                 title: details['total_rating']?.toStringAsFixed(1) ?? '0.0',
//                 fontSize: 11.sp,
//                 fontWeight: FontWeight.w600,
//                 color: primaryColor,
//               ),
//             ],
//           ),
//         ),
//         SizedBox(width: 8.w),
//         CustomText(
//           title: '(${details['reviews_count'] ?? 0} reviews)',
//           fontSize: 12.sp,
//           color: Colors.grey.shade600,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildHeaderActions() {
//     final details = controller.businessDetails;
//     if (details['self_business'] == true) return SizedBox();
//
//     return Row(
//       children: [
//         _buildActionIcon(
//           icon: Icons.share_outlined,
//           onTap: _shareBusiness,
//         ),
//         SizedBox(width: 12.w),
//         _buildActionIcon(
//           icon: Icons.bookmark_border,
//           onTap: _saveBusiness,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionIcon({required IconData icon, required VoidCallback onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 40.w,
//         height: 40.w,
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           shape: BoxShape.circle,
//         ),
//         child: Icon(icon, size: 20.sp, color: Colors.grey.shade700),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.search_off_rounded,
//             size: 64.sp,
//             color: Colors.grey.shade400,
//           ),
//           SizedBox(height: 16.h),
//           CustomText(
//             title: 'No Business Found',
//             fontSize: 18.sp,
//             fontWeight: FontWeight.w600,
//             color: Colors.grey.shade600,
//           ),
//           SizedBox(height: 8.h),
//           CustomText(
//             title: 'Could not load business details',
//             fontSize: 14.sp,
//             color: Colors.grey.shade500,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildContent() {
//     return RefreshIndicator(
//       onRefresh: () async {
//         await controller.getBusinessDetails(widget.businessId);
//       },
//       child: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         child: Column(
//           children: [
//             _buildHeroSection(),
//             SizedBox(height: 20.h),
//             _buildHeroContent(),
//             _buildMainContent(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeroSection() {
//     final image = controller.businessDetails['image'];
//     return Stack(
//       children: [
//         Container(
//           height: 240.h,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.black.withOpacity(0.3),
//                 Colors.transparent,
//               ],
//             ),
//           ),
//           child: ClipRect(
//             child: FadeInImage(
//               placeholder: AssetImage(Images.defaultImage),
//               image: NetworkImage(image),
//               fit: BoxFit.cover,
//               width: double.infinity,
//               height: 240.h,
//               imageErrorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   color: Colors.grey.shade200,
//                   child: Center(
//                     child: Icon(
//                       Icons.business_rounded,
//                       size: 64.sp,
//                       color: Colors.grey.shade400,
//                     ),
//                   ),
//                 );
//               },
//               fadeInDuration: const Duration(milliseconds: 300),
//             ),
//           ),
//         ),
//         // Positioned(
//         //   bottom: 16.h,
//         //   left: 16.w,
//         //   right: 16.w,
//         //   child:
//         // ),
//       ],
//     );
//   }
//
//   Widget _buildHeroContent() {
//     // final details = controller.businessDetails;
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 16,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomText(
//                       title: widget.title,
//                       fontSize: 20.sp,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.black87,textAlign: TextAlign.start,
//                       maxLines: 2,
//                     ),
//                     SizedBox(height: 8.h),
//                     _buildCategoryTag(),
//                   ],
//                 ),
//               ),
//               SizedBox(width: 12.w),
//               _buildHeroStats(),
//             ],
//           ),
//           SizedBox(height: 12.h),
//           _buildLocationRow(),
//           SizedBox(height: 16.h),
//           _buildActionButtons(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCategoryTag() {
//     final category = controller.businessDetails['category'];
//     if (category == null || category.isEmpty) return SizedBox();
//
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
//       decoration: BoxDecoration(
//         color: primaryColor.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20.r),
//       ),
//       child: CustomText(
//         title: category,
//         fontSize: 12.sp,
//         color: primaryColor,
//         fontWeight: FontWeight.w600,
//       ),
//     );
//   }
//
//   Widget _buildHeroStats() {
//     final details = controller.businessDetails;
//     return Column(
//       children: [
//         _buildStatItem(
//           icon: HugeIcons.strokeRoundedUserAdd02,
//           value: details['followers_count']?.toString() ?? '0',
//           label: 'Followers',
//         ),
//         SizedBox(height: 8.h),
//         _buildStatItem(
//           icon: HugeIcons.strokeRoundedDiscount,
//           value: details['offers_count']?.toString() ?? '0',
//           label: 'Offers',
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatItem({required dynamic icon, required String value, required String label}) {
//     return Column(
//       children: [
//         Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             HugeIcon(
//               icon: icon,
//               size: 14.sp,
//               color: primaryColor,
//             ),
//             SizedBox(width: 4.w),
//             CustomText(
//               title: value,
//               fontSize: 14.sp,
//               fontWeight: FontWeight.w700,
//               color: Colors.black87,
//             ),
//           ],
//         ),
//         SizedBox(height: 2.h),
//         CustomText(
//           title: label,
//           fontSize: 10.sp,
//           color: Colors.grey.shade600,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildLocationRow() {
//     final details = controller.businessDetails;
//     final address = details['address'] ?? '';
//     final distance = details['distance']?.toString() ?? '';
//
//     return Row(
//       children: [
//         Icon(
//           Icons.location_on_outlined,
//           size: 18.sp,
//           color: primaryColor,
//         ),
//         SizedBox(width: 8.w),
//         Expanded(
//           child: CustomText(
//             title: address,
//             fontSize: 14.sp,textAlign: TextAlign.start,
//             color: Colors.grey.shade700,
//             maxLines: 2,
//           ),
//         ),
//         SizedBox(width: 12.w),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//           decoration: BoxDecoration(
//             color: Colors.grey.shade100,
//             borderRadius: BorderRadius.circular(8.r),
//           ),
//           child: CustomText(
//             title: '$distance km away',
//             fontSize: 12.sp,
//             color: Colors.grey.shade600,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionButtons() {
//     final details = controller.businessDetails;
//     if (details['self_business'] == true) return SizedBox();
//
//     return Row(
//       children: [
//         Expanded(
//           child: _buildPrimaryButton(
//             icon: Icons.call_outlined,
//             text: 'Call Now',
//             onPressed: _handleCall,
//           ),
//         ),
//         SizedBox(width: 12.w),
//         Expanded(
//           child: Obx(() {
//             return controller.isFollowLoading.value
//                 ? LoadingWidget(color: primaryColor, size: 20.sp)
//                 : _buildOutlineButton(
//               icon: details['is_followed'] == true
//                   ? Icons.person_remove_alt_1_outlined
//                   : Icons.person_add_outlined,
//               text: details['is_followed'] == true
//                   ? 'Following'
//                   : 'Follow',
//               onPressed: _handleFollow,
//               isFollowing: details['is_followed'] == true,
//             );
//           }),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPrimaryButton({
//     required IconData icon,
//     required String text,
//     required VoidCallback onPressed,
//   }) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: primaryColor,
//         foregroundColor: Colors.white,
//         padding: EdgeInsets.symmetric(vertical: 12.h),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         elevation: 0,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 18.sp),
//           SizedBox(width: 8.w),
//           CustomText(
//             title: text,
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildOutlineButton({
//     required IconData icon,
//     required String text,
//     required VoidCallback onPressed,
//     required bool isFollowing,
//   }) {
//     return OutlinedButton(
//       onPressed: onPressed,
//       style: OutlinedButton.styleFrom(
//         foregroundColor: isFollowing ? Colors.grey.shade700 : primaryColor,
//         side: BorderSide(
//           color: isFollowing ? Colors.grey.shade400 : primaryColor,
//         ),
//         padding: EdgeInsets.symmetric(vertical: 12.h),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         backgroundColor: isFollowing ? Colors.grey.shade100 : Colors.transparent,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 18.sp),
//           SizedBox(width: 8.w),
//           CustomText(
//             title: text,
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMainContent() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
//       ),
//       padding: EdgeInsets.all(16.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildImageGallery(),
//           SizedBox(height: 24.h),
//           _buildAboutSection(),
//           SizedBox(height: 24.h),
//           _buildTabsSection(),
//           SizedBox(height: 24.h),
//           _buildReviewsSection(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildImageGallery() {
//     final images = controller.businessDetails['attachments'] ?? [];
//     if (images.isEmpty) return SizedBox();
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             CustomText(
//               title: 'Gallery',
//               fontSize: 18.sp,
//               fontWeight: FontWeight.w700,
//               color: Colors.black87,
//             ),
//             CustomText(
//               title: '${images.length} photos',
//               fontSize: 14.sp,
//               color: Colors.grey.shade600,
//             ),
//           ],
//         ),
//         SizedBox(height: 12.h),
//         SizedBox(
//           height: 100.h,
//           child: ListView.separated(
//             scrollDirection: Axis.horizontal,
//             itemCount: images.length,
//             separatorBuilder: (_, __) => SizedBox(width: 12.w),
//             itemBuilder: (context, index) {
//               return _buildGalleryImage(images[index]);
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildGalleryImage(dynamic imageUrl) {
//     return GestureDetector(
//       onTap: () {
//         // Open full screen gallery
//       },
//       child: Hero(
//         tag: 'image_$imageUrl',
//         child: Container(
//           width: 100.w,
//           height: 100.h,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12.r),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 8,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(12.r),
//             child: FadeInImage(
//               placeholder: AssetImage(Images.defaultImage),
//               image: NetworkImage(imageUrl),
//               fit: BoxFit.cover,
//               imageErrorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   color: Colors.grey.shade200,
//                   child: Icon(
//                     Icons.photo_library_outlined,
//                     size: 32.sp,
//                     color: Colors.grey.shade400,
//                   ),
//                 );
//               },
//               fadeInDuration: const Duration(milliseconds: 200),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAboutSection() {
//     final about = controller.businessDetails['about_business'];
//     if (about == null || about.isEmpty) return SizedBox();
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CustomText(
//           title: 'About',
//           fontSize: 18.sp,
//           fontWeight: FontWeight.w700,
//           color: Colors.black87,
//         ),
//         SizedBox(height: 12.h),
//         Container(
//           padding: EdgeInsets.all(16.w),
//           decoration: BoxDecoration(
//             color: Colors.grey.shade50,
//             borderRadius: BorderRadius.circular(12.r),
//             border: Border.all(color: Colors.grey.shade200),
//           ),
//           child: CustomText(
//             title: about,
//             fontSize: 14.sp,
//             color: Colors.grey.shade700,
//             // lineHeight: 1.6,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTabsSection() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16.r),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         children: [
//           _buildTabBar(),
//           SizedBox(height: 16.h),
//           Obx(() => _buildTabContent()),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTabBar() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: _buildTabButton(
//               label: 'Posts',
//               isActive: controller.tabIndex.value == 0,
//               onTap: () => controller.tabIndex.value = 0,
//             ),
//           ),
//           Expanded(
//             child: _buildTabButton(
//               label: 'Offers',
//               isActive: controller.tabIndex.value == 1,
//               onTap: () => controller.tabIndex.value = 1,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTabButton({
//     required String label,
//     required bool isActive,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 16.h),
//         decoration: BoxDecoration(
//           color: isActive ? Colors.white : Colors.transparent,
//           borderRadius: BorderRadius.vertical(
//             top: Radius.circular(16.r),
//           ),
//           boxShadow: isActive
//               ? [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             ),
//           ]
//               : null,
//         ),
//         child: Center(
//           child: CustomText(
//             title: label,
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w600,
//             color: isActive ? primaryColor : Colors.grey.shade600,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTabContent() {
//     final tabIndex = controller.tabIndex.value;
//     final data = tabIndex == 0
//         ? controller.businessDetails['posts']
//         : controller.businessDetails['offers'];
//     final emptyMessage = tabIndex == 0 ? 'No posts yet' : 'No offers available';
//     final emptyIcon = tabIndex == 0 ? Icons.newspaper_outlined : Icons.local_offer_outlined;
//
//     if (data == null || data.isEmpty) {
//       return Container(
//         padding: EdgeInsets.symmetric(vertical: 40.h),
//         child: Column(
//           children: [
//             Icon(
//               emptyIcon,
//               size: 48.sp,
//               color: Colors.grey.shade400,
//             ),
//             SizedBox(height: 16.h),
//             CustomText(
//               title: emptyMessage,
//               fontSize: 16.sp,
//               color: Colors.grey.shade600,
//             ),
//           ],
//         ),
//       );
//     }
//
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w),
//       child: GridView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 12.w,
//           mainAxisSpacing: 12.h,
//           childAspectRatio: 0.8,
//         ),
//         itemCount: data.length,
//         itemBuilder: (context, index) {
//           return _buildContentCard(
//             data[index],
//             isOffer: tabIndex == 1,
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildContentCard(dynamic item, {required bool isOffer}) {
//     return GestureDetector(
//       onTap: () {
//         // Open post/offer detail
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12.r),
//           border: Border.all(color: Colors.grey.shade200),
//           color: Colors.white,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: ClipRRect(
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
//                 child: FadeInImage(
//                   placeholder: AssetImage(Images.defaultImage),
//                   image: NetworkImage(item['image'] ?? ''),
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.all(8.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CustomText(
//                     title: item['title'] ?? '',
//                     fontSize: 12.sp,
//                     fontWeight: FontWeight.w600,
//                     maxLines: 1,
//                     // overflow: TextOverflow.ellipsis,
//                   ),
//                   if (isOffer && item['discount'] != null)
//                     Padding(
//                       padding: EdgeInsets.only(top: 4.h),
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 6.w,
//                           vertical: 2.h,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.red.shade50,
//                           borderRadius: BorderRadius.circular(4.r),
//                         ),
//                         child: CustomText(
//                           title: '${item['discount']}% OFF',
//                           fontSize: 10.sp,
//                           color: Colors.red,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildReviewsSection() {
//     final reviews = controller.businessDetails['reviews'] ?? [];
//     final totalRating = controller.businessDetails['total_rating'].toString() ?? 0;
//     final reviewCount = controller.businessDetails['reviews_count'] ?? 0;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             CustomText(
//               title: 'Reviews',
//               fontSize: 18.sp,
//               fontWeight: FontWeight.w700,
//               color: Colors.black87,
//             ),
//             GestureDetector(
//               onTap: _addReview,
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//                 decoration: BoxDecoration(
//                   color: primaryColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(20.r),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.add, size: 16.sp, color: primaryColor),
//                     SizedBox(width: 4.w),
//                     CustomText(
//                       title: 'Add Review',
//                       fontSize: 12.sp,
//                       color: primaryColor,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 16.h),
//         _buildRatingOverview(totalRating.toString(), reviewCount),
//         SizedBox(height: 20.h),
//         if (reviews.isNotEmpty)
//           ...reviews.map((review) => _buildReviewItem(review)).toList(),
//         if (reviews.isEmpty)
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 40.h),
//             child: Column(
//               children: [
//                 Icon(
//                   Icons.reviews_outlined,
//                   size: 48.sp,
//                   color: Colors.grey.shade400,
//                 ),
//                 SizedBox(height: 16.h),
//                 CustomText(
//                   title: 'No reviews yet',
//                   fontSize: 16.sp,
//                   color: Colors.grey.shade600,
//                 ),
//                 SizedBox(height: 8.h),
//                 CustomText(
//                   title: 'Be the first to review this business',
//                   fontSize: 14.sp,
//                   color: Colors.grey.shade500,
//                 ),
//               ],
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildRatingOverview(String rating, int count) {
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Row(
//         children: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 padding: EdgeInsets.all(8.w),
//                 decoration: BoxDecoration(
//                   color: primaryColor,
//                   shape: BoxShape.circle,
//                 ),
//                 child: CustomText(
//                   title: rating,
//                   fontSize: 24.sp,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(height: 8.h),
//               Row(
//                 children: List.generate(5, (index) {
//                   return Icon(
//                     Icons.star,
//                     size: 16.sp,
//                     color:
//                     // index < rating
//                     //     ? Colors.orange
//                     //     :
//                     Colors.grey.shade400,
//                   );
//                 }),
//               ),
//             ],
//           ),
//           SizedBox(width: 20.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustomText(
//                   title: '$count Reviews',
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 SizedBox(height: 8.h),
//                 CustomText(
//                   title: 'Based on customer feedback',
//                   fontSize: 13.sp,
//                   color: Colors.grey.shade600,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildReviewItem(Map<String, dynamic> review) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 16.h),
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CircleAvatar(
//                 radius: 20.r,
//                 backgroundImage: NetworkImage(
//                   review['user_profile_image'] ?? '',
//                 ),
//                 onBackgroundImageError: (_, __) {},
//                 child: Icon(Icons.person, color: Colors.grey.shade400),
//               ),
//               SizedBox(width: 12.w),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         CustomText(
//                           title: review['user_name'] ?? 'Anonymous',
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w600,
//                         ),
//                         CustomText(
//                           title: _formatDate(review['created_at'] ?? ''),
//                           fontSize: 12.sp,
//                           color: Colors.grey.shade500,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 4.h),
//                     Row(
//                       children: List.generate(5, (index) {
//                         final rating = double.tryParse(
//                             review['rating']?.toString() ?? '0') ??
//                             0;
//                         return Icon(
//                           Icons.star,
//                           size: 14.sp,
//                           color: index < rating.floor()
//                               ? Colors.orange
//                               : Colors.grey.shade400,
//                         );
//                       }),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 12.h),
//           CustomText(
//             title: review['review'] ?? '',
//             fontSize: 14.sp,
//             color: Colors.grey.shade700,
//             // lineHeight: 1.5,
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _formatDate(String dateString) {
//     try {
//       final date = DateTime.parse(dateString);
//       final now = DateTime.now();
//       final difference = now.difference(date);
//
//       if (difference.inDays > 30) {
//         return '${difference.inDays ~/ 30} months ago';
//       } else if (difference.inDays > 0) {
//         return '${difference.inDays} days ago';
//       } else if (difference.inHours > 0) {
//         return '${difference.inHours} hours ago';
//       } else {
//         return 'Just now';
//       }
//     } catch (e) {
//       return dateString;
//     }
//   }
//
//   void _shareBusiness() {
//     // Implement share functionality
//   }
//
//   void _saveBusiness() {
//     // Implement save business functionality
//   }
//
//   // Keep existing methods for handling actions
//   void _handleCall() {
//     if (!getIt<DemoService>().isDemo) {
//       ToastUtils.showLoginToast();
//       return;
//     }
//     makePhoneCall(controller.businessDetails['mobile_number'] ?? '');
//   }
//
//   void _handleFollow() async {
//     final details = controller.businessDetails;
//     if (!getIt<DemoService>().isDemo) {
//       ToastUtils.showLoginToast();
//       return;
//     }
//     controller.isFollowLoading.value = true;
//
//     if (details['is_followed'] == true) {
//       await feedsController.unfollowBusiness(details['follow_id'].toString());
//     } else {
//       await feedsController.followBusiness(details['id'].toString());
//     }
//
//     await controller.getBusinessDetails(widget.businessId, showLoading: false);
//     controller.isFollowLoading.value = false;
//   }
//
//   void _addReview() {
//     if (!getIt<DemoService>().isDemo) {
//       ToastUtils.showLoginToast();
//       return;
//     }
//     Get.dialog(
//       ReviewDialog(
//         productName: widget.title,
//         imageUrl: controller.businessDetails['image'] ?? "",
//         onSubmit: (rating, review) async {
//           await controller.addReview(
//             controller.businessDetails['id'].toString(),
//           );
//         },
//       ),
//     );
//   }
// }

//
// import '../utils/exported_path.dart';
//
// class CategoryDetailPage extends StatelessWidget {
//   final String title;
//   CategoryDetailPage({super.key, required this.title});
//   final List<String> imageList = [
//     Images.hotelImg,
//     Images.hotelImg,
//     Images.hotelImg,
//     Images.hotelImg,
//   ];
//   @override
//   Widget build(BuildContext context) {
//     final navController = getIt<NavigationController>();
//
//     return SingleChildScrollView(
//       child: Column(children: [_buildHeader(navController), _buildBody()]),
//     );
//   }
//
//   Widget _buildHeader(NavigationController navController) {
//     return Container(
//       color: Colors.white,
//       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//       child: Row(
//         spacing: 8.h,
//         children: [
//           GestureDetector(
//             onTap: () => navController.goBack(),
//             child: const Icon(Icons.arrow_back),
//           ),
//           CustomText(
//             title: title,
//             fontSize: 18.sp,
//             fontWeight: FontWeight.bold,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBody() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 12.h),
//       child: Column(
//         spacing: 8.h,
//         children: [
//           _buildImage(),
//           _buildImageList(),
//           _buildHotelDetails(),
//           _buildActionButtons(),
//           _buildAbout(),
//           _buildReview(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildImage() {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(12.r),
//       child: FadeInImage(
//         placeholder: const AssetImage(Images.logo),
//         image: AssetImage(Images.hotelImgLarge),
//         width: Get.width.w,
//         height: 180.h,
//         imageErrorBuilder: (context, error, stackTrace) {
//           return Container(
//             width: Get.width.w,
//             height: 180.h,
//             padding: EdgeInsets.all(24.w),
//             color: lightGrey,
//             child: Image.asset(Images.logo, fit: BoxFit.contain),
//           );
//         },
//         fit: BoxFit.cover,
//         placeholderFit: BoxFit.contain,
//         fadeInDuration: const Duration(milliseconds: 300),
//       ),
//     );
//   }
//
//   Widget _buildImageList() {
//     return SizedBox(
//       height: 55.h,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemCount: imageList.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 8),
//         itemBuilder: (context, index) {
//           return Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.grey.shade300),
//               image: DecorationImage(
//                 image: AssetImage(imageList[index]),
//                 fit: BoxFit.contain,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildHotelDetails() {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 8.h),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             spacing: 8.h,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomText(
//                 title: title,
//                 fontSize: 16.sp,
//                 textAlign: TextAlign.start,
//                 maxLines: 2,
//                 style: TextStyle(
//                   height: 1,
//                   fontSize: 16.sp,
//                   color: Colors.black,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 4.w,
//                       vertical: 2.h,
//                     ),
//                     decoration: BoxDecoration(
//                       color: primaryColor,
//                       borderRadius: BorderRadius.circular(8.r),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(Icons.star, color: Colors.white, size: 14.sp),
//                         SizedBox(width: 4.w),
//                         CustomText(
//                           title: '4.9',
//                           fontSize: 14.sp,
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(width: 8.h),
//                   CustomText(
//                     title: 'By 500',
//                     fontSize: 14.sp,
//                     color: textLightGrey,
//                   ),
//                 ],
//               ),
//               _buildLocation(),
//               _buildCategory(),
//             ],
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 20.w),
//             decoration: BoxDecoration(
//               // color: lightRed.withValues(alpha: 0.5),
//               borderRadius: BorderRadius.circular(6.r),
//               border: Border.all(width: 0.5, color: primaryColor),
//             ),
//             child: Column(
//               children: [
//                 HugeIcon(
//                   icon: HugeIcons.strokeRoundedDiscount,
//                   color: primaryBlueColor,
//                   size: 16.sp,
//                 ),
//                 CustomText(
//                   title: 'See offer',
//                   fontSize: 12.sp,
//                   color: primaryColor,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLocation() {
//     return Row(
//       children: [
//         Icon(Icons.location_on_outlined, color: textLightGrey, size: 14.sp),
//         SizedBox(width: 4.w),
//         CustomText(
//           title: 'Kandivali West, Mumbai',
//           textAlign: TextAlign.start,
//           fontSize: 12.sp,
//           color: textLightGrey,
//           maxLines: 1,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCategory() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8.w),
//       decoration: BoxDecoration(
//         color: lightRed.withValues(alpha: 0.5),
//         borderRadius: BorderRadius.circular(6.r),
//         border: Border.all(color: lightRed.withValues(alpha: 0.3)),
//       ),
//       child: CustomText(
//         title: 'Restaurant',
//         fontSize: 12.sp,
//         color: textLightGrey,
//       ),
//     );
//   }
//
//   Widget _buildActionButtons() {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildActionButton(
//             icon: Icons.call_outlined,
//             text: 'Call',
//             onPressed: () {},
//             backgroundColor: primaryColor,
//           ),
//         ),
//         SizedBox(width: 8.w),
//         Expanded(
//           child: _buildActionButton(
//             icon: Icons.person_add_outlined,
//             text: 'Follow',
//             onPressed: () {},
//             backgroundColor: primaryColor,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionButton({
//     required IconData icon,
//     required String text,
//     required VoidCallback? onPressed,
//     required Color backgroundColor,
//   }) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//         decoration: BoxDecoration(
//           // color: backgroundColor,
//           border: Border.all(color: Colors.red),
//           borderRadius: BorderRadius.circular(8.r),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, color: primaryColor, size: 16.sp),
//             SizedBox(width: 6.w),
//             CustomText(
//               title: text,
//               fontSize: 12.sp,
//               color: primaryColor,
//               fontWeight: FontWeight.w600,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAbout() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Divider(),
//         CustomText(
//           title: 'About',
//           fontSize: 18.sp,
//           fontWeight: FontWeight.bold,
//         ),
//         CustomText(
//           title:
//               'Chinese, Punjabi, Mughlai, Sea Food, North Indian, Malwani, Maharashtrian',
//           fontSize: 14.sp,
//           maxLines: 30,
//           textAlign: TextAlign.start,
//         ),
//         Divider(),
//       ],
//     );
//   }
//
//   Widget _buildReview() {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             CustomText(
//               title: 'Reviews & Ratings',
//               fontSize: 18.sp,
//               fontWeight: FontWeight.bold,
//             ),
//             CustomText(
//               title: 'Add Review',
//               fontSize: 18.sp,
//               color: primaryColor,
//               fontWeight: FontWeight.bold,
//             ),
//           ],
//         ),
//         ListTile(
//           leading: CircleAvatar(backgroundImage: AssetImage(Images.hotelImg)),
//           title: CustomText(
//             title: 'Mandar',
//             fontSize: 14.sp,
//             maxLines: 2,
//             textAlign: TextAlign.start,
//             fontWeight: FontWeight.bold,
//           ),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomText(
//                 title:
//                     'At Hotel Jyoti Family Restaurant, I was delighted by the rich flavors and aromatic dishes. Each bite of their signature biryani was a culinary delight, bursting with spices.',
//                 fontSize: 12.sp,
//                 textAlign: TextAlign.start,
//                 maxLines: 20,
//               ),
//               Row(
//                 children: [
//                   Icon(Icons.star, color: Colors.amberAccent, size: 14.w),
//                   Icon(Icons.star, color: Colors.amberAccent, size: 14.w),
//                   Icon(Icons.star, color: Colors.amberAccent, size: 14.w),
//                   Icon(Icons.star, color: Colors.amberAccent, size: 14.w),
//                   Icon(Icons.star, color: Colors.amberAccent, size: 14.w),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         Divider(),
//         ListTile(
//           leading: CircleAvatar(backgroundImage: AssetImage(Images.hotelImg)),
//           title: CustomText(
//             title: 'DANISH',
//             fontSize: 14.sp,
//             maxLines: 2,
//             textAlign: TextAlign.start,
//             fontWeight: FontWeight.bold,
//           ),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomText(
//                 title:
//                     'At Hotel Jyoti Family Restaurant, I was delighted by the rich flavors and aromatic dishes. Each bite of their signature biryani was a culinary delight, bursting with spices.',
//                 fontSize: 12.sp,
//                 textAlign: TextAlign.start,
//                 maxLines: 20,
//               ),
//               Row(
//                 children: [
//                   Icon(Icons.star, color: Colors.amberAccent, size: 14.w),
//                   Icon(Icons.star, color: Colors.amberAccent, size: 14.w),
//                   Icon(Icons.star, color: Colors.amberAccent, size: 14.w),
//                   Icon(Icons.star, color: Colors.amberAccent, size: 14.w),
//                   Icon(Icons.star, color: Colors.amberAccent, size: 14.w),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
