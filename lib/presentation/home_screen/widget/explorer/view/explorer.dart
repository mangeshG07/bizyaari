import 'package:businessbuddy/utils/exported_path.dart';

class Explorer extends StatefulWidget {
  const Explorer({super.key});

  @override
  State<Explorer> createState() => _ExplorerState();
}

class _ExplorerState extends State<Explorer> {
  final controller = getIt<ExplorerController>();
  final navController = getIt<NavigationController>();

  @override
  void initState() {
    controller.getCategories(isRefresh: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      /// 🔹 Initial Loading (Shimmer)
      if (controller.isLoading.isTrue) {
        return buildCategoryLoader();
      }

      /// 🔹 Empty State
      if (controller.categories.isEmpty) {
        return commonNoDataFound(isHome: true);
      }

      /// 🔹 Feeds + Pagination
      return NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll is ScrollEndNotification &&
              scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 50 &&
              controller.hasMore &&
              !controller.isLoadMore.value &&
              !controller.isLoading.value) {
            controller.getCategories(showLoading: false);
          }
          return false;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// 🔹 Header
              Align(
                alignment: Alignment.topLeft,
                child: CustomText(
                  title: 'Category',
                  fontSize: 18.sp,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.bold,
                  color: textSmall,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: CustomText(
                  title: 'Find nearby stores, services & offers with one tap.',
                  fontSize: 14.sp,
                  color: textLightGrey,
                  textAlign: TextAlign.start,
                ),
              ),

              /// 🔹 Category List
              AnimationLimiter(
                child: GridView.builder(
                  padding: EdgeInsets.only(
                    top: 8.h,
                  ).copyWith(right: 8.w, left: 8.w),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 8.h,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final cat = controller.categories[index];
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      columnCount: 4,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () {
                              navController.openSubPage(
                                CategoryList(
                                  categoryId: cat['id'].toString(),
                                  categoryName: cat['name'].toString(),
                                ),
                              );
                            },
                            child: CategoryCard(
                              image: cat['image'].toString(),
                              name: cat['name'].toString(),
                            ),
                          ),
                        ),
                      ),
                    );
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

    //   Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: Column(
    //     children: [
    //       Align(
    //         alignment: Alignment.topLeft,
    //         child: CustomText(
    //           title: 'Category',
    //           fontSize: 18.sp,
    //           textAlign: TextAlign.start,
    //           fontWeight: FontWeight.bold,
    //         ),
    //       ),
    //       Align(
    //         alignment: Alignment.topLeft,
    //         child: CustomText(
    //           title: 'Find nearby stores, services & offers with one tap.',
    //           fontSize: 14.sp,
    //           color: textLightGrey,
    //           textAlign: TextAlign.start,
    //         ),
    //       ),
    //
    //       Expanded(
    //         child: Obx(
    //           () => controller.isLoading.isTrue
    //               ? buildCategoryLoader()
    //               : controller.categories.isEmpty
    //               ? Center(
    //                   child: CustomText(
    //                     title: 'No Category Found',
    //                     fontSize: 20.sp,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 )
    //               : AnimationLimiter(
    //                   child: GridView.builder(
    //                     padding: EdgeInsets.only(
    //                       top: 8.h,
    //                     ).copyWith(right: 8.w, left: 8.w),
    //                     shrinkWrap: true,
    //                     physics: const NeverScrollableScrollPhysics(),
    //                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //                       crossAxisCount: 4,
    //                       crossAxisSpacing: 12.w,
    //                       mainAxisSpacing: 8.h,
    //                       childAspectRatio: 0.8,
    //                     ),
    //                     itemCount: controller.categories.length,
    //                     itemBuilder: (context, index) {
    //                       final cat = controller.categories[index];
    //                       return AnimationConfiguration.staggeredGrid(
    //                         position: index,
    //                         duration: const Duration(milliseconds: 375),
    //                         columnCount: 4,
    //                         child: SlideAnimation(
    //                           verticalOffset: 50.0,
    //                           child: FadeInAnimation(
    //                             child: GestureDetector(
    //                               onTap: () {
    //                                 navController.openSubPage(
    //                                   CategoryList(
    //                                     categoryId: cat['id'].toString(),
    //                                     categoryName: cat['name'].toString(),
    //                                   ),
    //                                 );
    //                               },
    //                               child: CategoryCard(
    //                                 image: cat['image'].toString(),
    //                                 name: cat['name'].toString(),
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                       );
    //                     },
    //                   ),
    //                 ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}

Widget buildCategoryLoader() {
  return GridView.builder(
    padding: EdgeInsets.only(top: 8.h).copyWith(right: 8.w, left: 8.w),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 8.h,
      childAspectRatio: 0.7,
    ),
    itemCount: 8, // Show 8 shimmer items
    itemBuilder: (context, index) {
      return Shimmer.fromColors(
        baseColor: lightGrey,
        highlightColor: Colors.grey.shade100,
        child: Column(
          children: [
            // Image placeholder
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(height: 8.h),
            // Text placeholder
            Container(
              width: 60.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 4.h),
            // Secondary text placeholder
            Container(
              width: 40.w,
              height: 10.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ],
        ),
      );
    },
  );
}
