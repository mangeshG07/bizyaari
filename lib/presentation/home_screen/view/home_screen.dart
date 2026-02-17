import 'package:businessbuddy/utils/exported_path.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _homeController = getIt<HomeController>();
  final _feedController = getIt<FeedsController>();
  final _navigationController = getIt<NavigationController>();

  // @override
  // void initState() {
  //   super.initState();
  //   _initializeData();
  // }
  //
  // Future<void> _initializeData() async {
  //   print('in 1 home screen');
  //    getIt<SearchNewController>().getLiveLocation();
  //   print('in 2 home screen');
  //   // await _homeController.requestLocationPermission();
  //   location();
  //   _homeController.getHomeApi();
  // }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();

      // 🚀 Load Home immediately
      // _homeController.isMainLoading.value = true;
      // _homeController.getHomeApi().then((_) {
      //   _homeController.isMainLoading.value = false;
      // });

      // 🔄 Background tasks
      // getIt<LocationController>().fetchInitialLocation();
      // getIt<SearchNewController>().getLiveLocation();
      getIt<UpdateController>().checkForUpdate();
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     checkInternetAndShowPopup();
  //     _initializeData();
  //     getIt<UpdateController>().checkForUpdate();
  //     // getIt<FirebaseTokenController>().updateToken();
  //   });
  // }

  // Future<void> _initializeData() async {
  //   _homeController.isMainLoading.value = true;
  //   // final locationController = getIt<LocationController>();
  //   // await locationController.fetchInitialLocation();
  //
  //   final searchController = getIt<SearchNewController>();
  //   searchController.getLiveLocation();
  //
  //   await _homeController.getHomeApi();
  //   _homeController.isMainLoading.value = false;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(
        () => _homeController.isAvailable.isTrue
            ? _serviceNotFound()
            : SingleChildScrollView(child: _buildHomeContent()),
      ),
    );
  }

  Widget _serviceNotFound() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// 🚫 Icon / Illustration
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withValues(alpha: 0.1),
              ),
              child: const Icon(
                Icons.location_off_rounded,
                size: 72,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),

            /// Title
            const CustomText(
              title: 'Service Not Available',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            /// Description
            const Text(
              'Sorry, we’re not providing services in your area at the moment.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Please try a different location or check back later.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            /// 🔁 Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.bottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.r),
                        topRight: Radius.circular(24.r),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    isScrollControlled: true,
                    SafeArea(
                      child: DraggableScrollableSheet(
                        expand: false,
                        initialChildSize: 0.85,
                        minChildSize: 0.5,
                        maxChildSize: 1.0,
                        builder: (_, controllerScroll) {
                          return SearchLocation();
                        },
                      ),
                    ),
                    enableDrag: true,
                    isDismissible: true,
                  );
                  // OR:open location picker
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Change Location',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return Column(
      spacing: 16.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSlider(),
        _buildCategorySection(),
        _buildRequirementsSection(),
        _buildFeedsSection(),
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
            margin: const EdgeInsets.fromLTRB(8, 0, 8, 20),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: GestureDetector(
              onTap: _handleViewAllFeeds,
              child: CustomText(
                title: 'View All Feeds',
                fontSize: 12.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlider() {
    return Obx(
      () => _homeController.isMainLoading.isTrue
          ? _buildSliderLoader()
          : _homeController.sliderList.isEmpty
          ? const SizedBox.shrink()
          : AnimationLimiter(
              child: AnimationConfiguration.staggeredList(
                position: 0,
                duration: const Duration(milliseconds: 500),
                child: SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: CustomCarouselSlider(
                      height: 0.2.h,
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      radius: 16.r,
                      imageList: _homeController.sliderList,
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildCategorySection() {
    return Obx(
      () => _homeController.isMainLoading.isTrue
          ? buildCategoryLoader()
          : Container(
              padding: const EdgeInsets.only(top: 12),
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Get.theme.cardColor,
                border: Border.all(color: Get.theme.dividerColor, width: 0.5),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: SectionContainer(
                title: 'Categories',
                actionText: 'View More',
                onActionTap: _handleViewAllCategories,
                child: AnimationLimiter(
                  child: GridView.builder(
                    padding: EdgeInsets.only(top: 8.h, left: 8.w, right: 8.w),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 0.h,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: _homeController.categoryList.length,
                    itemBuilder: (context, index) {
                      final category = _homeController.categoryList[index];
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        columnCount: 4,
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: GestureDetector(
                              onTap: () {
                                _navigationController.openSubPage(
                                  CategoryList(
                                    categoryId: category['id'].toString(),
                                    categoryName: category['name'].toString(),
                                  ),
                                );
                              },
                              child: CategoryCard(
                                image: category['image'].toString(),
                                name: category['name'].toString(),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildFeedsSection() {
    return Obx(
      () => _homeController.isMainLoading.isTrue
          ? ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              itemCount: 5,
              // shimmer count
              itemBuilder: (_, i) => const FeedShimmer(),
            )
          : SectionContainer(
              title: 'Feeds',
              actionText: 'View More',
              onActionTap: _handleViewAllFeeds,
              child: AnimationLimiter(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  itemCount: _homeController.feedsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final feedItem = _homeController.feedsList[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: _buildFeedItem(feedItem, index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  Widget _buildFeedItem(Map<String, dynamic> item, index) {
    if (item['type'] == 'offer') {
      return OfferCard(
        data: item,
        onRefresh: () async =>
            await _homeController.getHomeApi(showLoading: false),
        onLike: () => handleOfferLike(
          item,
          () => _homeController.getHomeApi(showLoading: false),
        ),
        followButton: _followButton(index),
      );
    }

    return FeedCard(
      data: item,
      onRefresh: () async =>
          await _homeController.getHomeApi(showLoading: false),
      onLike: () async => await handleFeedLike(
        item,
        () async => await _homeController.getHomeApi(showLoading: false),
      ),
      // onFollow: () => _handleFeedFollow(item),
      followButton: _followButton(index),
    );
  }

  Widget _followButton(index) {
    return Obx(() {
      final data = _homeController.feedsList[index];

      if (data['self_business'] == true) return SizedBox();

      final isFollowing = data['is_followed'] == true;

      final key = isFollowing
          ? data['follow_id'].toString()
          : data['business_id'].toString();

      final isLoading =
          key.isNotEmpty && _feedController.followingLoadingMap[key] == true;
      return isLoading
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
                      color: isFollowing ? Colors.grey.shade600 : Colors.white,
                    ),
                    CustomText(
                      title: isFollowing ? 'Following' : 'Follow',
                      fontSize: 12.sp,
                      color: isFollowing ? Colors.grey.shade700 : Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            );
    });
  }

  int findFeedIndex(dynamic item) {
    return _homeController.feedsList.indexWhere((e) {
      if (item['type'] == 'offer') {
        return e['id'].toString() == item['id'].toString();
      } else {
        return e['post_id'].toString() == item['post_id'].toString();
      }
    });
  }

  void _onFollow(dynamic item) async {
    if (getIt<DemoService>().isDemo == false) {
      ToastUtils.showLoginToast();
      return;
    }

    final index = findFeedIndex(item);
    if (index == -1) return;

    final isFollowed = _homeController.feedsList[index]['is_followed'] == true;
    if (isFollowed) {
      await _feedController.unfollowBusiness(item['follow_id'].toString());
      _updateFollowStatusForBusiness(
        businessId: item['business_id'].toString(),
        isFollowed: !isFollowed,
      );
    } else {
      await _feedController.followBusiness(item['business_id'].toString());
      _updateFollowStatusForBusiness(
        businessId: item['business_id'].toString(),
        isFollowed: !isFollowed,
      );
    }
  }

  void _updateFollowStatusForBusiness({
    required String businessId,
    required bool isFollowed,
  }) async {
    for (var item in _homeController.feedsList) {
      if (item['business_id'].toString() == businessId) {
        item['is_followed'] = isFollowed;
      }
    }
    _homeController.feedsList.refresh();
    await _homeController.getHomeApi(showLoading: false);
  }

  Widget _buildRequirementsSection() {
    return Obx(
      () => _homeController.isMainLoading.isTrue
          ? ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) => const BusinessCardShimmer(),
            )
          : SectionContainer(
              title: 'Business Requirements',
              actionText: 'View More',
              onActionTap: _handleViewAllRequirements,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                separatorBuilder: (context, index) =>
                    Divider(height: 1.h, color: lightGrey),
                itemCount: _homeController.requirementList.length,
                itemBuilder: (context, index) {
                  final requirement = _homeController.requirementList[index];
                  return BusinessCard(data: requirement);
                },
              ),
            ),
    );
  }

  Widget _buildSliderLoader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: Get.height * 0.2.h,
      width: Get.width,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1,
            aspectRatio: 1,
            autoPlay: true,
            enlargeCenterPage: true,
            pauseAutoPlayOnTouch: true,
          ),
          items: List.generate(6, (index) {
            return GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    color: Colors.grey[300], // Shimmer effect
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // Future<void> _handleFeedFollow(Map<String, dynamic> item) async {
  //   if (_feedController.isFollowProcessing.value) return;
  //
  //   if (!isUserAuthenticated()) {
  //     ToastUtils.showLoginToast();
  //     return;
  //   }
  //
  //   await _feedController.isFollowProcessing.runWithLoader(() async {
  //     await _toggleFeedFollow(item);
  //   });
  // }

  // Future<void> _toggleFeedFollow(Map<String, dynamic> item) async {
  //   final bool wasFollowed = item['is_followed'] ?? false;
  //
  //   try {
  //     if (wasFollowed) {
  //       await _feedController.unfollowBusiness(item['follow_id'].toString());
  //     } else {
  //       await _feedController.followBusiness(item['business_id'].toString());
  //     }
  //
  //     item['is_followed'] = !wasFollowed;
  //     await _homeController.getHomeApi(showLoading: false);
  //   } catch (e) {
  //     handleError('Follow error: $e');
  //     // Consider showing an error toast to the user
  //   }
  // }

  // Future<void> _handleOfferLike(Map<String, dynamic> item) async {
  //   if (_feedController.isLikeProcessing.value) return;
  //
  //   if (!_isUserAuthenticated()) {
  //     ToastUtils.showLoginToast();
  //     return;
  //   }
  //
  //   await _feedController.isLikeProcessing.runWithLoader(() async {
  //     await toggleOfferLike(
  //       item,
  //       () => _homeController.getHomeApi(showLoading: false),
  //     );
  //   });
  // }

  // bool _isUserAuthenticated() {
  //   return getIt<DemoService>().isDemo;
  // }

  void _handleViewAllCategories() {
    _navigationController.updateTopTab(0);
  }

  void _handleViewAllFeeds() {
    _navigationController.updateTopTab(1);
  }

  void _handleViewAllRequirements() {
    _navigationController.updateBottomIndex(2);
  }
}

// Helper widget for consistent section styling
class SectionContainer extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onActionTap;
  final Widget child;

  const SectionContainer({
    super.key,
    required this.title,
    required this.actionText,
    required this.onActionTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: buildHeadingWithButton(
            title: title,
            rightText: actionText,
            onTap: onActionTap,
          ),
        ),
        child,
      ],
    );
  }
}

// Extension for cleaner loading state management
extension LoadingExtension on RxBool {
  Future<void> runWithLoader(Future<void> Function() action) async {
    value = true;
    try {
      await action();
    } finally {
      value = false;
    }
  }
}

// return Obx(() {
//   // If CatList or any subpage is open
//   if (controller.isSubPageOpen.value) {
//     return controller.homeContent;
//   }
//
//   // Otherwise show normal home with tabs
//   return topTabPages[controller.topTabIndex.value];
// });
