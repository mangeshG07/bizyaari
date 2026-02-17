import 'package:businessbuddy/utils/exported_path.dart';

class GlobalSearch extends StatefulWidget {
  const GlobalSearch({super.key});

  @override
  State<GlobalSearch> createState() => _GlobalSearchState();
}

class _GlobalSearchState extends State<GlobalSearch> {
  final _controller = getIt<GlobalSearchController>();
  final _feedController = getIt<FeedsController>();
  final _navigationController = getIt<NavigationController>();

  @override
  void initState() {
    _controller.searchController.clear();
    _controller.clearAllLists();
    super.initState();
  }

  @override
  void dispose() {
    _controller.debouncer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppbarPlain(title: "Search"),
      body: SingleChildScrollView(
        child: Column(
          spacing: 16.h,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildSearchField(),
            ),
            Obx(() {
              if (_controller.isLoading.isTrue) {
                return _buildLoadingIndicator();
              }

              if (_controller.isAllListEmpty) {
                return _buildEmptyState();
              }

              return Column(
                children: [
                  _buildCategorySection(),
                  _buildBusinessSection(),
                  _buildRequirementsSection(),
                  _buildExpertSection(),
                  SizedBox(height: 20.h),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 40.w,
          height: 40.h,
          child: LoadingWidget(color: primaryColor),
        ),
        SizedBox(height: 16.h),
        Text(
          'Searching ...',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.only(top: 100.h),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 48.r, color: Colors.grey),
          SizedBox(height: 12.h),
          Text(
            "No results found",
            style: TextStyle(fontSize: 15.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextFormField(
      controller: _controller.searchController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        focusedBorder: buildOutlineInputBorder(),
        enabledBorder: buildOutlineInputBorder(),
        contentPadding: EdgeInsets.all(15),
        suffixIcon: Obx(
          () => _controller.searchText.value.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _controller.searchController.clear();
                    _controller.businessList.value = [];
                    _controller.categoryList.value = [];
                    _controller.requirementList.value = [];
                    _controller.expertList.value = [];
                    _controller.isLoading.value = false;
                  },
                  child: Container(
                    margin: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                )
              : Icon(Icons.search, color: mainTextGrey),
        ),
        prefixIconConstraints: BoxConstraints(maxWidth: Get.width * 0.1),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Image.asset(Images.appIcon, width: 30, height: 30),
        ),
        hintText: 'Search Offer, Interest, etc.',
        hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey.shade500),
      ),
      onChanged: _onSearchChanged,
    );
  }

  void _onSearchChanged(String text) {
    _controller.updateSearchText(text);
    if (text.trim().isEmpty) {
      _clearSearch();
      return;
    }

    _controller.debouncer.run(() {
      _controller.searchData();
    });
  }

  void _clearSearch() {
    _controller.searchController.clear();
    _controller.clearAllLists();
  }

  Widget _buildCategorySection() {
    return Obx(
      () => _controller.categoryList.isEmpty
          ? SizedBox()
          : SectionContainer(
              title: 'Categories',
              actionText: 'View More',
              onActionTap: _handleViewAllCategories,
              child: Obx(
                () => _controller.isLoading.isTrue
                    ? buildCategoryLoader()
                    : GridView.builder(
                        padding: EdgeInsets.only(
                          top: 8.h,
                          left: 8.w,
                          right: 8.w,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 0.h,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: _controller.categoryList.length,
                        itemBuilder: (context, index) {
                          final category = _controller.categoryList[index];
                          return GestureDetector(
                            onTap: () {
                              Get.back();
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
                          );
                        },
                      ),
              ),
            ),
    );
  }

  Widget _buildBusinessSection() {
    return Obx(
      () => _controller.businessList.isEmpty
          ? SizedBox()
          : SectionContainer(
              title: 'Results',
              actionText: 'View More',
              onActionTap: _handleViewAllFeeds,
              child: Obx(
                () => _controller.isLoading.isTrue
                    ? ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        itemCount: 6, // shimmer items
                        itemBuilder: (_, i) => CatItemCardShimmer(),
                      )
                    : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                        ).copyWith(top: 12.h),
                        itemCount: _controller.businessList.length,
                        itemBuilder: (_, i) {
                          final item = _controller.businessList[i];
                          return CatItemCard(
                            followersCount:
                                item['followers_count']?.toString() ?? '0',
                            isSearch: true,
                            offers: item['offers'] ?? [],
                            latitude: item['latitude'] ?? '',
                            isFollowed: item['is_followed'] ?? false,
                            isSelf: item['self_business'] ?? false,
                            longitude: item['longitude'] ?? '',
                            distance: item['distance']?.toString() ?? '',
                            name: item['name'] ?? '',
                            location: item['address'] ?? '',
                            category: item['category'] ?? '',
                            rating: item['total_rating']?.toString() ?? '0',
                            reviewCount:
                                item['reviews_count']?.toString() ?? '0',
                            offerText: '${item['offers_count']} Offers ',
                            phoneNumber: item['whatsapp_number'] ?? '',
                            imagePath: item['image'] ?? '',
                            onCall: () {
                              if (!getIt<DemoService>().isDemo) {
                                ToastUtils.showLoginToast();
                                return;
                              }
                              if (item['mobile_number'] != null) {
                                makePhoneCall(item['mobile_number']);
                              }
                            },
                            onTap: () {
                              Get.back();
                              _navigationController.openSubPage(
                                CategoryDetailPage(
                                  title: item['name'] ?? '',
                                  businessId: item['id']?.toString() ?? '',
                                ),
                              );
                            },
                            onFollow: () async {
                              if (!getIt<DemoService>().isDemo) {
                                ToastUtils.showLoginToast();
                                return;
                              }
                              if (item['is_followed'] == true) {
                                await _feedController.unfollowBusiness(
                                  item['follow_id'].toString(),
                                );
                              } else {
                                await _feedController.followBusiness(
                                  item['id'].toString(),
                                );
                              }

                              item['is_followed'] = !item['is_followed'];
                            },
                          );
                        },
                      ),
              ),
            ),
    );
  }

  Widget _buildRequirementsSection() {
    return Obx(
      () => _controller.requirementList.isEmpty
          ? SizedBox()
          : SectionContainer(
              title: 'Business Requirements',
              actionText: 'View More',
              onActionTap: _handleViewAllRequirements,
              child: Obx(
                () => _controller.isLoading.isTrue
                    ? ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(8),
                        itemCount: 6,
                        separatorBuilder: (_, __) => SizedBox(height: 10),
                        itemBuilder: (context, index) =>
                            const BusinessCardShimmer(),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        separatorBuilder: (context, index) =>
                            Divider(height: 1.h, color: lightGrey),
                        itemCount: _controller.requirementList.length,
                        itemBuilder: (context, index) {
                          final requirement =
                              _controller.requirementList[index];
                          return BusinessCard(
                            data: requirement,
                            isSearch: true,
                          );
                        },
                      ),
              ),
            ),
    );
  }

  Widget _buildExpertSection() {
    return Obx(
      () => _controller.expertList.isEmpty
          ? SizedBox()
          : SectionContainer(
              title: 'Expert',
              isMore: false,
              actionText: 'View More',
              onActionTap: _handleViewAllRequirements,
              child: Obx(
                () => _controller.isLoading.isTrue
                    ? ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(8),
                        itemCount: 6,
                        separatorBuilder: (_, __) => SizedBox(height: 10),
                        itemBuilder: (context, index) =>
                            const BusinessCardShimmer(),
                      )
                    : Column(
                        children: _controller.expertList.map<Widget>((expert) {
                          return GestureDetector(
                            onTap: () async {
                              if (!getIt<DemoService>().isDemo) {
                                ToastUtils.showLoginToast();
                                return;
                              }

                              final userId =
                                  await LocalStorage.getString('user_id') ?? '';
                              if (userId == expert['user_id']?.toString()) {
                                Get.toNamed(
                                  Routes.profile,
                                  arguments: {'user_id': 'self'},
                                );
                              } else {
                                Get.toNamed(
                                  Routes.profile,
                                  arguments: {
                                    'user_id':
                                        expert['user_id']?.toString() ?? '',
                                    'is_search': true,
                                  },
                                );
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              padding: EdgeInsets.all(10.w),
                              decoration: _boxDecoration(),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: Image.network(
                                      expert['profile_image']?.toString() ?? '',
                                      width: 50.w,
                                      height: 50.h,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Image.asset(
                                        Images.defaultImage,
                                        width: 50.w,
                                        height: 50.h,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          title:
                                              expert['name']?.toString() ?? '',
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start,
                                          color: primaryBlack,
                                        ),
                                        Text(
                                          expert['specialization']
                                                  ?.toString() ??
                                              '',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: textLightGrey,
                                          ),
                                        ),
                                        if (expert['experience'] != null)
                                          Text(
                                            '${expert['experience']?.toString() ?? '0'} Years',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: textLightGrey,
                                            ),
                                          ),
                                        SizedBox(height: 6.h),
                                      ],
                                    ),
                                  ),
                                  // if (controller.isMe.isTrue)
                                  GestureDetector(
                                    // onTap: () => Get.toNamed(
                                    //   Routes.profile,
                                    //   arguments: {
                                    //     'user_id':
                                    //         expert['user_id']?.toString() ?? '',
                                    //   },
                                    // ),
                                    child: HugeIcon(
                                      icon: HugeIcons.strokeRoundedArrowRight01,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ),
    );
  }

  void _handleViewAllCategories() {
    Get.back();
    _navigationController.updateTopTab(0);
  }

  void _handleViewAllFeeds() {
    Get.back();
    _navigationController.updateTopTab(1);
  }

  void _handleViewAllRequirements() {
    Get.back();
    _navigationController.updateBottomIndex(2);
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade100,
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    );
  }
}

class SectionContainer extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onActionTap;
  final Widget child;
  final bool? isMore;

  const SectionContainer({
    super.key,
    required this.title,
    required this.actionText,
    required this.onActionTap,
    required this.child,
    this.isMore = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: buildHeadingWithButton(
            isMore: isMore!,
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
