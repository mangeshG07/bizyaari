import 'package:businessbuddy/utils/exported_path.dart';

class LboScreen extends StatefulWidget {
  const LboScreen({super.key});

  @override
  State<LboScreen> createState() => _LboScreenState();
}

class _LboScreenState extends State<LboScreen> {
  final navController = getIt<NavigationController>();
  final controller = getIt<LBOController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getMyBusinesses();
      controller.selectedBusiness.value = 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(
        () => Padding(
          padding: EdgeInsets.all(12.w),
          child: controller.isBusinessLoading.isTrue
              ? _buildBusinessShimmer()
              : controller.businessList.isEmpty
              ? _buildEmptyLBO()
              : _buildBusinessList(),
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: Obx(() {
        final isDemo = getIt<DemoService>().isDemo;
        final hasBusiness = controller.businessList.isNotEmpty;
        final isApproved = controller.isBusinessApproved.value == '1';

        if (!isDemo) return const SizedBox();
        if (!hasBusiness) return const SizedBox();
        if (!isApproved) return const SizedBox();

        return _buildExpandableFab();
      }),
    );
  }

  // ---------------- FAB -----------------
  Widget _buildExpandableFab() {
    return ExpandableFab(
      distance: 70,
      type: ExpandableFabType.up,
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        fabSize: ExpandableFabSize.small,
        child: const Icon(Icons.add, color: Colors.white, size: 24),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        elevation: 0,
      ),
      closeButtonBuilder: RotateFloatingActionButtonBuilder(
        fabSize: ExpandableFabSize.small,
        child: const Icon(Icons.close, color: Colors.white, size: 20),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
      ),
      children: [
        _buildFabChild(
          icon: Icons.post_add,
          text: 'Post',
          color: primaryBlack,
          onPressed: () => Get.toNamed(Routes.addPost),
          textColor: lightGrey,
        ),
        _buildFabChild(
          icon: Icons.local_offer,
          text: 'Offer',
          color: Colors.red,
          textColor: Colors.white,
          onPressed: () => Get.toNamed(Routes.addOffer),
        ),
      ],
    );
  }

  // Helper method to create consistent FAB children
  Widget _buildFabChild({
    required IconData icon,
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: FloatingActionButton.extended(
        heroTag: null,
        elevation: 0,
        highlightElevation: 0,
        backgroundColor: color,
        foregroundColor: Colors.white,
        onPressed: onPressed,
        icon: Icon(icon, size: 20, color: textColor),
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.r),
        ),
      ),
    );
  }

  // ---------------- MAIN CONTENT -----------------
  Widget _buildBusinessList() {
    return SingleChildScrollView(
      child: Obx(
        () => AnimationLimiter(
          child: Column(
            spacing: 12.h,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 500),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                _buildAddBusinessButton(),
                _buildBusinessListBody(),
                if (controller.isBusinessApproved.value == '0')
                  _pendingBusiness(),
                if (controller.isBusinessApproved.value == '1')
                  _buildPostAndOffers(),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddBusinessButton() {
    return GestureDetector(
      onTap: () {
        if (!getIt<DemoService>().isDemo) {
          ToastUtils.showLoginToast();
          return;
        }
        navController.openSubPage(const AddBusiness());
      },

      child: Container(
        width: Get.width,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: CustomText(
          title: 'Add Business',
          fontSize: 16.sp,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBusinessListBody() {
    return SizedBox(
      height: 60.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.businessList.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          return Obx(() {
            final isSelected = controller.selectedBusiness.value == index;
            final business = controller.businessList[index];

            return GestureDetector(
              onTap: () {
                controller.selectedBusiness.value = index;
                controller.selectedBusinessId.value = business['id'].toString();
                controller.postList.value = business['posts'] ?? [];
                controller.offerList.value = business['offers'] ?? [];
                controller.isBusinessApproved.value =
                    business['is_business_approved'];
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: Get.width * 0.7.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: isSelected ? primaryColor : lightGrey,
                    width: isSelected ? 1.8 : 1,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: GestureDetector(
                  onTap: () {
                    if (controller.isBusinessApproved.value == '1') {
                      Get.toNamed(
                        Routes.businessDetails,
                        arguments: {'businessId': business['id'].toString()},
                      );
                    }
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22.r,
                        backgroundColor: Colors.grey.shade100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.r),
                          child: FadeInImage(
                            placeholder: const AssetImage(Images.defaultImage),
                            image: NetworkImage(business['image'] ?? ''),
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                Images.defaultImage,
                                fit: BoxFit.contain,
                              );
                            },
                            width: 100.w,
                            height: 100.h,
                            fit: BoxFit.cover,
                            placeholderFit: BoxFit.contain,
                            fadeInDuration: const Duration(milliseconds: 300),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              title: business['name'] ?? '',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              maxLines: 1,
                              color: primaryBlack,
                            ),
                            SizedBox(height: 4.h),
                            CustomText(
                              title: business['category'] ?? '',
                              fontSize: 12.sp,
                              color: textGrey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildPostAndOffers() {
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(color: lightGrey, width: 0.5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- Tab Bar ---
            TabBar(
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
                Tab(text: 'Special Offer'),
              ],
            ),

            // --- Tab Content ---
            Container(
              padding: EdgeInsets.all(10.w),
              height: Get.height * 0.45.h,
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(), // prevents
                children: [
                  buildGridImages(controller.postList, 'post', isEdit: true),
                  buildGridImages(controller.offerList, 'offer', isEdit: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyLBO() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SizedBox(height: Get.height * 0.1.h),
            Center(
              child: Image.asset(Images.noBusiness, width: Get.width * 0.5.w),
            ),
            SizedBox(height: 20.h),
            CustomText(
              title: 'No Business Added Yet!',
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: primaryBlack,
            ),
            SizedBox(height: 10.h),
            CustomText(
              title:
                  'Start by adding your business to showcase your brand, attract investors, and connect with potential partners.',
              fontSize: 14.sp,
              maxLines: 5,
              color: primaryBlack,
            ),
            SizedBox(height: 20.h),
            CustomButton(
              width: Get.width.w,
              backgroundColor: primaryColor,
              isLoading: false.obs,
              onPressed: () {
                if (!getIt<DemoService>().isDemo) {
                  ToastUtils.showLoginToast();
                  return;
                }
                navController.openSubPage(AddBusiness());
              },
              text: 'Add Business',
            ),
          ],
        ),
      ),
    );
  }

  Widget _pendingBusiness() {
    return Card(
      color: Get.theme.cardColor,
      surfaceTintColor: Get.theme.cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.light
                      ? primaryColor.withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedLoading01,
                size: 12,
                color: Theme.of(context).brightness == Brightness.light
                    ? primaryColor.withValues(alpha: 0.5)
                    : primaryColor,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              "Approval Pending",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: primaryBlack,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              "Your business is currently under review. We'll notify you once the verification process is complete.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, height: 1.5, color: textSmall),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- MAIN CONTENT SHIMMER-----------------
  Widget _buildBusinessShimmer() {
    return SingleChildScrollView(
      child: Column(
        spacing: 12.h,
        children: [
          _shimmerAddBusinessButton(),
          _shimmerBusinessList(),
          _shimmerTabsSection(),
        ],
      ),
    );
  }

  Widget _shimmerAddBusinessButton() {
    return Shimmer.fromColors(
      baseColor: lightGrey,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: Get.width,
        height: 42.h,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  Widget _shimmerBusinessList() {
    return SizedBox(
      height: 60.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, i) {
          return Shimmer.fromColors(
            baseColor: lightGrey,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: Get.width * 0.7.w,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44.r,
                    height: 44.r,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 12.h,
                          width: 120.w,
                          color: Colors.white,
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          height: 10.h,
                          width: 80.w,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _shimmerTabsSection() {
    return Shimmer.fromColors(
      baseColor: lightGrey,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: Get.width,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            // Tab bar shimmer
            Row(
              children: [
                Container(height: 26.h, width: 80.w, color: Colors.white),
                SizedBox(width: 12.w),
                Container(height: 26.h, width: 120.w, color: Colors.white),
              ],
            ),

            SizedBox(height: 16.h),

            // Grid shimmer
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: List.generate(
                6,
                (i) => Container(
                  // margin: EdgeInsets.all(8.w),
                  width: (Get.width / 3) - 24.w,
                  height: 90.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
