import 'package:businessbuddy/utils/exported_path.dart';

class BusinessPartner extends StatefulWidget {
  const BusinessPartner({super.key});

  @override
  State<BusinessPartner> createState() => _BusinessPartnerState();
}

class _BusinessPartnerState extends State<BusinessPartner>
    with SingleTickerProviderStateMixin {
  final navController = getIt<NavigationController>();
  final controller = getIt<PartnerDataController>();

  @override
  void initState() {
    super.initState();
    controller.resetFilter();
    controller.tabController = TabController(length: 2, vsync: this);
    controller.tabController.addListener(() {
      controller.tabIndex.value = controller.tabController.index;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
      loadAllData();
    });
  }

  Future<void> loadAllData() async {
    controller.isMainLoading.value = true;
    await Future.wait([
      controller.getBusinessRequired(isRefresh: true, isFirst: true),
      controller.getRequestedBusiness(isRefresh: true),
    ]);
    controller.isMainLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPartnerList(),
      floatingActionButton: Visibility(
        visible: getIt<DemoService>().isDemo,
        child: FloatingActionButton.small(
          backgroundColor: primaryColor,
          elevation: 0,
          foregroundColor: Colors.white,
          shape: CircleBorder(),
          onPressed: () {
            navController.openSubPage(AddRecruitment());
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildPartnerList() {
    return Obx(
      () => DefaultTabController(
        length: 2,
        initialIndex: controller.tabIndex.value,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Tab Bar ---
              Row(
                children: [
                  Expanded(
                    child: TabBar(
                      controller: controller.tabController,
                      onTap: (index) => controller.changeTab(index),
                      dividerColor: Colors.transparent,
                      indicatorColor: primaryColor,
                      labelColor: primaryColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                      unselectedLabelColor: Colors.grey,
                      labelStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: const [
                        Tab(text: 'Business Requirements', height: 35),
                        Tab(text: 'Requested', height: 35),
                      ],
                    ),
                  ),

                  /// ---- Filter Icon
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.grey.withValues(alpha: 0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        context: context,
                        builder: (_) => RecruitmentFilter(),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.grey.withValues(alpha: 0.08),
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedFilter,
                          size: 18.r,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(height: 0),
              // --- Tab Content ---
              Expanded(
                child: TabBarView(
                  controller: controller.tabController,
                  physics: const NeverScrollableScrollPhysics(), // prevents
                  children: [_buildRequirement(), _buildRequested()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequirement() {
    return Obx(() {
      /// 🔹 Initial Loading (Shimmer)
      if (controller.isMainLoading.isTrue) {
        return ListView.separated(
          padding: EdgeInsets.all(8.w),
          itemCount: 6,
          separatorBuilder: (_, __) => SizedBox(height: 10.h),
          itemBuilder: (_, index) => const BusinessCardShimmer(),
        );
      }

      /// Filter list → remove cards where owner is same user
      final filteredList = controller.requirementList.where((item) {
        return item['self'] == false;
      }).toList();

      /// 🔹 Empty State
      if (filteredList.isEmpty) {
        return _buildEmptyPartner();
      }

      /// 🔹 Feeds + Pagination
      return NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll is ScrollEndNotification &&
              scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 50 &&
              controller.hastBusinessMore &&
              !controller.isBusinessLoadMore.value &&
              !controller.isLoading.value) {
            controller.getBusinessRequired(showLoading: false);
          }
          return false;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// 🔹 Header

              /// 🔹 Category List
              AnimationLimiter(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  separatorBuilder: (_, __) =>
                      Divider(height: 5.h, color: lightGrey),
                  itemCount: filteredList.length,
                  itemBuilder: (_, index) =>
                      AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: BusinessCard(data: filteredList[index]),
                          ),
                        ),
                      ),
                ),
              ),

              /// 🔹 Pagination Loader
              Obx(
                () => controller.isBusinessLoadMore.value
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: LoadingWidget(color: primaryColor),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      );
    });

    // Obx(() {
    //   if (controller.isMainLoading.isTrue) {
    //     return ListView.separated(
    //       padding: EdgeInsets.all(8.w),
    //       itemCount: 6,
    //       separatorBuilder: (_, __) => SizedBox(height: 10.h),
    //       itemBuilder: (_, index) => const BusinessCardShimmer(),
    //     );
    //   }
    //
    //   /// Filter list → remove cards where owner is same user
    //   final filteredList = controller.requirementList.where((item) {
    //     return item['self'] == false;
    //   }).toList();
    //
    //   if (filteredList.isEmpty) {
    //     return _buildEmptyPartner(); // Clear & Perfect UI
    //   }
    //
    //   return AnimationLimiter(
    //     child: ListView.separated(
    //       padding: const EdgeInsets.all(8),
    //       separatorBuilder: (_, __) => Divider(height: 5.h, color: lightGrey),
    //       itemCount: filteredList.length,
    //       itemBuilder: (_, index) => AnimationConfiguration.staggeredList(
    //         position: index,
    //         duration: const Duration(milliseconds: 375),
    //         child: SlideAnimation(
    //           verticalOffset: 50.0,
    //           child: FadeInAnimation(
    //             child: BusinessCard(data: filteredList[index]),
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
    // });
  }

  // Widget _buildRequirement() {
  //   return Obx(
  //     () => controller.isMainLoading.isTrue
  //
  //         ? ListView.separated(
  //             padding: EdgeInsets.all(8),
  //             itemCount: 6,
  //             separatorBuilder: (_, __) => SizedBox(height: 10),
  //             itemBuilder: (context, index) => const BusinessCardShimmer(),
  //           )
  //         : controller.requirementList.isEmpty
  //         ? _buildEmptyPartner()
  //         : ListView.separated(
  //             separatorBuilder: (context, index) =>
  //                 Divider(height: 5, color: lightGrey),
  //             padding: const EdgeInsets.all(8),
  //             itemCount: controller.requirementList.length,
  //             itemBuilder: (context, index) {
  //               final data = controller.requirementList[index];
  //               return data['business_requirement_user_id'].toString() !=
  //                       data['user_id'].toString()
  //                   ? BusinessCard(data: data)
  //                   : SizedBox();
  //             },
  //           ),
  //   );
  // }

  Widget _buildRequested() {
    return Obx(() {
      /// 🔹 Initial Loading (Shimmer)
      if (controller.isMainLoading.isTrue) {
        return LoadingWidget(color: primaryColor);
      }

      /// 🔹 Empty State
      if (controller.requestedBusinessList.isEmpty) {
        return commonNoDataFound();
      }

      /// 🔹 Feeds + Pagination
      return NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll is ScrollEndNotification &&
              scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 50 &&
              controller.hasMore &&
              !controller.isLoadMore.value &&
              !controller.isLoading.value) {
            controller.getRequestedBusiness(showLoading: false);
          }
          return false;
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// 🔹 Feed List
              AnimationLimiter(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => SizedBox.shrink(),
                  padding: const EdgeInsets.all(8),
                  itemCount: controller.requestedBusinessList.length,
                  itemBuilder: (context, index) {
                    final data = controller.requestedBusinessList[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: BusinessCard(data: data, isRequested: true),
                        ),
                      ),
                    );
                    // return BusinessCard(data: data, isRequested: true);
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
      );
    });

    // Obx(
    //   () => controller.isMainLoading.isTrue
    //       ? LoadingWidget(color: primaryColor)
    //       : controller.requestedBusinessList.isEmpty
    //       ? commonNoDataFound()
    //       : AnimationLimiter(
    //           child: ListView.separated(
    //             separatorBuilder: (context, index) =>
    //                 Divider(height: 5, color: lightGrey),
    //             padding: const EdgeInsets.all(8),
    //             itemCount: controller.requestedBusinessList.length,
    //             itemBuilder: (context, index) {
    //               final data = controller.requestedBusinessList[index];
    //
    //               return AnimationConfiguration.staggeredList(
    //                 position: index,
    //                 duration: const Duration(milliseconds: 375),
    //                 child: SlideAnimation(
    //                   verticalOffset: 50.0,
    //                   child: FadeInAnimation(
    //                     child: BusinessCard(data: data, isRequested: true),
    //                   ),
    //                 ),
    //               );
    //               // return BusinessCard(data: data, isRequested: true);
    //             },
    //           ),
    //         ),
    // );
  }

  Widget _buildEmptyPartner() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Get.height * 0.1.h),
            Center(
              child: Image.asset(
                Images.emptyBusiness,
                width: Get.width * 0.5.w,
              ),
            ),
            SizedBox(height: 20.h),
            CustomText(
              title: 'Looking for business partner?',
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 20.h),
            // CustomButton(
            //   height: 60,
            //   width: Get.width.w,
            //   backgroundColor: primaryColor,
            //   isLoading: false.obs,
            //   onPressed: () {},
            //   text: 'See all open\nBusiness Requirements',
            // ),
            CustomButton(
              width: Get.width.w,
              backgroundColor: primaryColor,
              isLoading: false.obs,
              onPressed: () {
                if (!getIt<DemoService>().isDemo) {
                  ToastUtils.showLoginToast();
                  return;
                }
                navController.openSubPage(AddRecruitment());
              },
              text: 'Post Recruitment',
            ),
          ],
        ),
      ),
    );
  }
}
