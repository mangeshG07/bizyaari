import 'package:businessbuddy/utils/exported_path.dart';

class BlockUserList extends StatefulWidget {
  const BlockUserList({super.key});

  @override
  State<BlockUserList> createState() => _BlockUserListState();
}

class _BlockUserListState extends State<BlockUserList> {
  final controller = getIt<ProfileController>();

  @override
  void initState() {
    super.initState();
    controller.getBlockList(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Obx(() {
        /// 🔹 Initial Loading (Shimmer)
        if (controller.isBlockListLoading.isTrue) {
          return LoadingWidget(color: primaryColor);
        }

        /// 🔹 Empty State
        if (controller.blockList.isEmpty) {
          return Center(
            child: CustomText(title: 'No block user', fontSize: 14.sp,color: primaryBlack,),
          );
        }

        /// 🔹 Feeds + Pagination
        return NotificationListener<ScrollNotification>(
          onNotification: (scroll) {
            if (scroll is ScrollEndNotification &&
                scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 50 &&
                controller.hasBlockMore &&
                !controller.isBlockLoadMore.value &&
                !controller.isBlockLoading.value) {
              controller.getBlockList(showLoading: false);
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
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemCount: controller.blockList.length,
                    itemBuilder: (_, index) {
                      final block = controller.blockList[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50,
                          child: FadeInAnimation(
                            child: GestureDetector(
                              onTap: () async {
                                AllDialogs().showConfirmationDialog(
                                  'Unblock User',
                                  'Are you sure you want to unblock this user?',
                                  onConfirm: () async {
                                    Get.back();
                                    await controller
                                        .blockUser(
                                          block['id']?.toString() ?? '',
                                        )
                                        .then(
                                          (v) async => await controller
                                              .getBlockList(isRefresh: true),
                                        );
                                  },
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 16.w),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: Colors.grey.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withValues(
                                        alpha: 0.08,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10.w),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                        child: Image.network(
                                          block['image']?.toString() ?? '',
                                          width: 50.w,
                                          height: 50.h,
                                          fit: BoxFit.cover,
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
                                                  block['name']?.toString() ??
                                                  '',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              textAlign: TextAlign.start,
                                              color: primaryBlack,
                                            ),
                                            Text(
                                              block['email']?.toString() ?? '',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: textGrey,
                                              ),
                                            ),
                                            SizedBox(height: 6.h),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                  () => controller.isBlockLoadMore.value
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
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      foregroundColor: primaryBlack,
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
        title: "Blocked User",
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        color: primaryBlack,
      ),
    );
  }
}
