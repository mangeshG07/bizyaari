import 'package:businessbuddy/utils/exported_path.dart';

class BusinessDetails extends StatefulWidget {
  const BusinessDetails({super.key});

  @override
  State<BusinessDetails> createState() => _BusinessDetailsState();
}

class _BusinessDetailsState extends State<BusinessDetails> {
  final controller = getIt<LBOController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
      controller.getMyBusinessDetails(Get.arguments['businessId']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: true,
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
      title: CustomText(
        title: "Business Details",
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        color: primaryBlack,
      ),
    );
  }

  Widget _buildBody() {
    return Obx(
      () => controller.isDetailsLoading.isTrue
          ? LoadingWidget(color: primaryColor)
          : controller.businessDetails.isEmpty
          ? commonNoDataFound()
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(),
                  SizedBox(height: 16.h),
                  Divider(color: lightGrey),
                  _buildImageGallery(),
                  if (controller.businessDetails['attachments'].length != 0)
                    SizedBox(height: 16.h),
                  if (controller.businessDetails['attachments'].length != 0)
                    Divider(color: lightGrey),
                  _buildAboutSection(),
                  // SizedBox(height: 24.h),
                  _buildContactSection(),
                  // const Divider(),
                  _buildPostAndOffersSection(),
                  Divider(color: lightGrey),
                  _buildReviewsSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBusinessImage(),
        SizedBox(width: 12.w),
        Expanded(child: _buildBusinessInfo()),
      ],
    );
  }

  Widget _buildBusinessImage() {
    final image = controller.businessDetails['image'] ?? '';
    return Container(
      width: 80.w,
      height: 80.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: FadeInImage(
          placeholder: const AssetImage(Images.defaultImage),
          image: NetworkImage(image),
          fit: BoxFit.cover,
          imageErrorBuilder: (context, error, stackTrace) {
            return Container(
              color: lightGrey,
              padding: EdgeInsets.all(20.w),
              child: Image.asset(Images.defaultImage, fit: BoxFit.contain),
            );
          },
          fadeInDuration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }

  Widget _buildBusinessInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomText(
                textAlign: TextAlign.start,
                title: controller.businessDetails['name'] ?? '',
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: primaryBlack,
                maxLines: 2,
              ),
            ),
            SizedBox(width: 8.w),
            _buildEditButton(),
          ],
        ),
        SizedBox(height: 8.h),
        _buildCategoryAndFollowers(),
      ],
    );
  }

  Widget _buildEditButton() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
      child: PopupMenuButton<String>(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Get.theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        elevation: 2,
        popUpAnimationStyle: AnimationStyle(curve: Curves.easeInOut),
        padding: EdgeInsets.zero,
        surfaceTintColor: Colors.white,
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).brightness == Brightness.light
                ? primaryColor.withValues(alpha: 0.1)
                : Colors.white70,
          ),
          child: Icon(Icons.more_vert, color: primaryColor),
        ),
        onSelected: (value) {
          _handleMenuSelection(value);
        },
        itemBuilder: (context) => [
          _buildMenuItem('edit', Icons.edit, 'Edit', primaryColor),
          _buildMenuItem('delete', Icons.delete, 'Delete', Colors.grey),
        ],
      ),
    );

    //   GestureDetector(
    //   onTap: () => Get.toNamed(Routes.editBusiness, arguments: {'data': {}}),
    //   child: Container(
    //     padding: EdgeInsets.all(6.w),
    //     decoration: BoxDecoration(
    //       color: Theme.of(context).brightness == Brightness.light
    //           ? primaryColor.withValues(alpha: 0.1)
    //           : Colors.white,
    //       borderRadius: BorderRadius.circular(8.r),
    //     ),
    //     child: Icon(Icons.edit_outlined, size: 18.w, color: primaryColor),
    //   ),
    // );
  }

  PopupMenuItem<String> _buildMenuItem(
    String value,
    IconData icon,
    String text,
    Color color,
  ) {
    return PopupMenuItem<String>(
      value: value,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(color: textDarkGrey)),
        ],
      ),
    );
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'edit':
        // Get.back();
        Get.toNamed(
          Routes.editBusiness,
          arguments: {'data': controller.businessDetails},
        );
        break;
      case 'delete':
        AllDialogs().showConfirmationDialog(
          'Delete Business',
          'Are you sure you want to delete this Business?',
          onConfirm: () async {
            Get.back();
            await controller.deleteBusiness(
              controller.businessDetails['id']?.toString() ?? '',
            );
          },
        );
        break;
    }
  }

  Widget _buildCategoryAndFollowers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: controller.businessDetails['category'] ?? '',
          fontSize: 14.sp,
          color: textLightGrey,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: 4.h),
        GestureDetector(
          onTap: () => Get.toNamed(
            Routes.followersList,
            arguments: {
              'business_id': Get.arguments['businessId']?.toString() ?? '',
            },
          ),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      controller.businessDetails['followers']?.toString() ??
                      '0',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' Followers',
                  style: TextStyle(fontSize: 12.sp, color: textLightGrey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageGallery() {
    final images = controller.businessDetails['attachments'];
    if (images.length == 0) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: 'Gallery',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: primaryBlack,
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 80.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final attach = images[index];
              return _buildGalleryImage(attach);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGalleryImage(dynamic attach) {
    return Container(
      width: 80.w,
      height: 80.h,
      decoration: BoxDecoration(
        border: Border.all(color: lightGrey),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: WidgetZoom(
        heroAnimationTag: 'tag $attach',
        zoomWidget: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: FadeInImage(
            placeholder: const AssetImage(Images.defaultImage),
            image: NetworkImage(attach),
            fit: BoxFit.contain,
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
        SizedBox(height: 8.h),
        CustomText(
          title: controller.businessDetails['about_business'] ?? '',
          fontSize: 14.sp,
          maxLines: 10,
          textAlign: TextAlign.start,
          color: textSmall,
        ),
        Divider(color: lightGrey),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // spacing: 12.h,
      children: [
        CustomText(
          title: 'Contact Information',
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: primaryBlack,
        ),
        _buildContactItem(
          icon: Icons.phone_outlined,
          title: 'Mobile Number',
          value: controller.businessDetails['mobile_number'] ?? '',
          onTap: () =>
              _makePhoneCall(controller.businessDetails['mobile_number'] ?? ''),
        ),
        _buildWhatsapp(),
        _buildContactItem(
          icon: Icons.location_on_outlined,
          title: 'Address',
          value: controller.businessDetails['address'] ?? '',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildWhatsapp() {
    final whatsapp = controller.businessDetails['whatsapp_number']
        ?.toString()
        .trim();

    if (whatsapp != null && whatsapp.isNotEmpty) {
      return _buildContactItem(
        icon: Icons.business_center_outlined,
        title: 'Whatsapp Number',
        value: controller.businessDetails['whatsapp_number']?.toString() ?? '-',
        onTap: () {},
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20.w, color: primaryColor),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: title,
                    fontSize: 14.sp,
                    color: textSmall,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    maxLines: 3,
                    textAlign: TextAlign.start,
                    title: value,
                    fontSize: 14.sp,
                    color: primaryBlack,
                    // lineHeight: 1.4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              title: 'Reviews & Ratings',
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: primaryBlack,
            ),
            _buildRatingSummary(),
          ],
        ),
        SizedBox(height: 16.h),
        _buildReviewList(),
      ],
    );
  }

  Widget _buildRatingSummary() {
    return GestureDetector(
      onTap: _viewAllReviews,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            CustomText(
              title: '${controller.businessDetails['total_rating']}',
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            SizedBox(width: 4.w),
            Icon(Icons.star, color: Colors.amber, size: 16.w),
            SizedBox(width: 4.w),
            CustomText(
              title: '(${controller.businessDetails['reviews_count']})',
              fontSize: 12.sp,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewList() {
    final reviewList = controller.businessDetails['reviews'] ?? [];
    if (reviewList.isEmpty) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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

        // Center(
        //   child: TextButton(
        //     onPressed: _viewAllReviews,
        //     child: CustomText(
        //       title: 'View All Reviews',
        //       fontSize: 14,
        //       color: primaryColor,
        //       fontWeight: FontWeight.w600,
        //     ),
        //   ),
        // ),
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
              width: 100.w,
              height: 100.h,
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
                textAlign: TextAlign.start,
                maxLines: 20,
                color: primaryBlack,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPostAndOffersSection() {
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildTabBar(),
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

            // IndexedStack(
            //   index: controller.tabIndex.value,
            //     children: [
            //   child: TabBarView(
            //     children: [
            //       buildGridImages(controller.businessDetails['posts'], 'post'),
            //       buildGridImages(
            //         controller.businessDetails['offers'],
            //         'offer',
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: lightGrey, width: 0.5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: TabBar(
        onTap: (i) {
          controller.tabIndex.value = i;
        },
        indicatorColor: primaryColor,
        labelColor: primaryColor,
        indicatorSize: TabBarIndicatorSize.tab,
        unselectedLabelColor: Colors.grey.shade600,
        indicatorWeight: 2.0,
        labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'Posts'),
          Tab(text: 'Offers'),
        ],
      ),
    );
  }

  // Widget _buildPostsGrid() {
  //   return GridView.builder(
  //     padding: EdgeInsets.all(12.w),
  //     physics: const NeverScrollableScrollPhysics(),
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 3,
  //       crossAxisSpacing: 8.w,
  //       mainAxisSpacing: 8.h,
  //     ),
  //     itemCount: 9,
  //     itemBuilder: (context, index) {
  //       return _buildGridItem(Images.hotelImg);
  //     },
  //   );
  // }

  // Widget _buildOffersGrid() {
  //   return GridView.builder(
  //     padding: EdgeInsets.all(12.w),
  //     physics: const NeverScrollableScrollPhysics(),
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 2,
  //       crossAxisSpacing: 12.w,
  //       mainAxisSpacing: 12.h,
  //     ),
  //     itemCount: 4,
  //     itemBuilder: (context, index) {
  //       return _buildOfferItem();
  //     },
  //   );
  // }

  // Widget _buildGridItem(String imagePath) {
  //   return ClipRRect(
  //     borderRadius: BorderRadius.circular(8.r),
  //     child: Image.asset(imagePath, fit: BoxFit.cover),
  //   );
  // }
  //
  // Widget _buildOfferItem() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(12.r),
  //       color: primaryColor.withValues(alpha: 0.1),
  //       border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
  //     ),
  //     padding: EdgeInsets.all(12.w),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Icon(Icons.local_offer_outlined, color: primaryColor, size: 24.w),
  //         SizedBox(height: 8.h),
  //         CustomText(
  //           title: 'Special Offer',
  //           fontSize: 14.sp,
  //           fontWeight: FontWeight.w600,
  //           color: primaryColor,
  //           textAlign: TextAlign.center,
  //         ),
  //         SizedBox(height: 4.h),
  //         CustomText(
  //           title: '20% OFF',
  //           fontSize: 12.sp,
  //           color: Colors.grey.shade700,
  //           textAlign: TextAlign.center,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _makePhoneCall(String phoneNumber) {
    // Implement phone call functionality
    // print('Make phone call to: $phoneNumber');
  }

  void _viewAllReviews() {
    // Navigate to all reviews screen
    // print('View all reviews tapped');
  }
}

// import 'package:businessbuddy/utils/exported_path.dart';
//
// class BusinessDetails extends StatefulWidget {
//   const BusinessDetails({super.key});
//
//   @override
//   State<BusinessDetails> createState() => _BusinessDetailsState();
// }
//
// class _BusinessDetailsState extends State<BusinessDetails> {
//   final List<String> imageList = [
//     Images.hotelImg,
//     Images.hotelImg,
//     Images.hotelImg,
//     Images.hotelImg,
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: _buildAppBar(),
//       floatingActionButton: FloatingActionButton.small(
//         backgroundColor: primaryColor,
//         foregroundColor: Colors.white,
//         shape: CircleBorder(),
//         onPressed: () {},
//         child: Icon(Icons.add),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(12.w),
//         child: Column(
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildImage(),
//                 SizedBox(width: 4.w),
//                 _buildContent(),
//               ],
//             ),
//             Divider(),
//             _buildImageGallery(),
//             Divider(),
//             _buildAboutSection(),
//             _buildContactSection(),
//             _buildReviewsSection(),
//             _buildPostAndOffers(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       surfaceTintColor: Colors.white,
//       backgroundColor: Colors.white,
//       elevation: 0,
//       centerTitle: true,
//       flexibleSpace: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//
//               Colors.white.withValues(alpha: 0.5),
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//       ),
//       title: CustomText(
//         title: "Business Details",
//         fontSize: 22.sp,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//   }
//
//   Widget _buildImage() {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(12.r),
//       child: Container(
//         width: 80.w,
//         height: 80.h,
//         decoration: BoxDecoration(
//           color: lightGrey,
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         child: FadeInImage(
//           placeholder: const AssetImage(Images.logo),
//           image: AssetImage(Images.hotelImg),
//           width: 80.w,
//           height: 80.h,
//           imageErrorBuilder: (context, error, stackTrace) {
//             return Container(
//               width: 80.w,
//               height: 80.h,
//               padding: EdgeInsets.all(24.w),
//               color: lightGrey,
//               child: Image.asset(Images.logo, fit: BoxFit.contain),
//             );
//           },
//           fit: BoxFit.cover,
//           placeholderFit: BoxFit.contain,
//           fadeInDuration: const Duration(milliseconds: 300),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildContent() {
//     return Expanded(
//       child: Column(
//         spacing: 8.h,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [_buildHeader(), _buildCategory()],
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           child: CustomText(
//             title: 'Hotel Jyoti Family Restaurant',
//             fontSize: 16.sp,
//             textAlign: TextAlign.start,
//             maxLines: 2,
//             style: TextStyle(
//               height: 1.2,
//               fontSize: 16.sp,
//               color: textDarkGrey,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ),
//         SizedBox(width: 8.w),
//         HugeIcon(icon: HugeIcons.strokeRoundedPencilEdit02),
//       ],
//     );
//   }
//
//   Widget _buildCategory() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CustomText(
//           title: 'Restaurant',
//           textAlign: TextAlign.start,
//           fontSize: 12.sp,
//           color: textLightGrey,
//           maxLines: 1,
//         ),
//         CustomText(
//           title: '10K',
//           textAlign: TextAlign.start,
//           fontSize: 14.sp,
//           color: textLightGrey,
//           fontWeight: FontWeight.bold,
//           maxLines: 1,
//         ),
//         CustomText(
//           title: 'followers',
//           textAlign: TextAlign.start,
//           fontSize: 12.sp,
//           color: textLightGrey,
//           maxLines: 1,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildImageGallery() {
//     return SizedBox(
//       height: 60.h,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemCount: imageList.length,
//         separatorBuilder: (_, __) => SizedBox(width: 8.w),
//         itemBuilder: (context, index) {
//           return GestureDetector(
//             onTap: () {
//               // Add image preview functionality
//             },
//             child: Container(
//               width: 64.w,
//               height: 64.h,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12.r),
//                 border: Border.all(color: Colors.grey.shade200, width: 1),
//                 image: DecorationImage(
//                   image: AssetImage(imageList[index]),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildAboutSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CustomText(
//           title: 'About',
//           fontSize: 18.sp,
//           fontWeight: FontWeight.w700,
//           color: Colors.black87,
//         ),
//         CustomText(
//           title:
//               'Chinese, Punjabi, Mughlai, Sea Food, North Indian, Malwani, Maharashtrian',
//           fontSize: 14.sp,
//           maxLines: 20,
//           textAlign: TextAlign.start,
//           color: Colors.grey.shade700,
//         ),
//         SizedBox(height: 16.h),
//         const Divider(height: 1),
//       ],
//     );
//   }
//
//   Widget _buildContactSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CustomText(
//           title: 'Contact Information',
//           fontSize: 18.sp,
//           fontWeight: FontWeight.w700,
//           color: Colors.black87,
//         ),
//         CustomText(
//           title: 'Mobile Number',
//           fontSize: 14.sp,
//           maxLines: 20,
//           textAlign: TextAlign.start,
//           color: Colors.grey.shade700,
//         ),
//         CustomText(
//           title: '+91 XXXXXXXXXX',
//           fontSize: 14.sp,
//           maxLines: 20,
//           textAlign: TextAlign.start,
//           color: Colors.grey.shade700,
//         ),
//         SizedBox(height: 16.h),
//         CustomText(
//           title: 'Address',
//           fontSize: 14.sp,
//           maxLines: 20,
//           textAlign: TextAlign.start,
//           color: Colors.grey.shade700,
//         ),
//         CustomText(
//           title:
//
//           fontSize: 14.sp,
//           maxLines: 20,
//           textAlign: TextAlign.start,
//           color: Colors.grey.shade700,
//         ),
//         const Divider(height: 1),
//       ],
//     );
//   }
//
//   Widget _buildReviewsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             CustomText(
//               title: 'Reviews & Ratings',
//               fontSize: 18.sp,
//               fontWeight: FontWeight.w700,
//               color: Colors.black87,
//             ),
//             Row(
//               children: [
//                 CustomText(
//                   title: '4.9',
//                   fontSize: 12.sp,
//                   color: Colors.black87,
//                 ),
//                 buildStarRating(5),
//                 CustomText(
//                   title: '50 reviews',
//                   fontSize: 12.sp,
//                   color: Colors.black87,
//                 ),
//               ],
//             ),
//           ],
//         ),
//         buildReviewTile(
//           userName: 'Mandar',
//           review:
//               'At Hotel Jyoti Family Restaurant, I was delighted by the rich flavors and aromatic dishes. Each bite of their signature biryani was a culinary delight, bursting with spices.',
//           rating: 5,
//         ),
//         SizedBox(height: 16.h),
//         const Divider(height: 1),
//         SizedBox(height: 16.h),
//         buildReviewTile(
//           userName: 'Danish',
//           review:
//               'At Hotel Jyoti Family Restaurant, I was delighted by the rich flavors and aromatic dishes. Each bite of their signature biryani was a culinary delight, bursting with spices.',
//           rating: 5,
//         ),
//         const Divider(height: 1),
//       ],
//     );
//   }
//
//   Widget _buildPostAndOffers() {
//     return DefaultTabController(
//       length: 2,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // --- Tab Bar ---
//             TabBar(
//               indicatorColor: primaryColor,
//               labelColor: primaryColor,
//               indicatorSize: TabBarIndicatorSize.tab,
//               unselectedLabelColor: Colors.grey,
//               labelStyle: TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w600,
//               ),
//               tabs: const [
//                 Tab(text: 'Post'),
//                 Tab(text: 'Offer'),
//               ],
//             ),
//
//             // --- Tab Content ---
//             SizedBox(
//               height: Get.height * 0.45.h,
//               child: TabBarView(
//                 physics: const NeverScrollableScrollPhysics(), // prevents
//                 children: [buildGridImages(9), buildGridImages(6)],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
