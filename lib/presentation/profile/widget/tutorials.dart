import 'package:businessbuddy/presentation/profile/widget/video_popup.dart';
import 'package:businessbuddy/utils/exported_path.dart';

class TutorialsList extends StatefulWidget {
  const TutorialsList({super.key});

  @override
  State<TutorialsList> createState() => _TutorialsListState();
}

class _TutorialsListState extends State<TutorialsList> {
  final controller = getIt<TutorialsController>();

  @override
  void initState() {
    controller.getTutorials(isRefresh: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Obx(() {
        /// 🔹 Initial Loading (Shimmer)
        if (controller.isLoading.isTrue) {
          return LoadingWidget(color: primaryColor);
        }

        /// 🔹 Empty State
        if (controller.tutorialList.isEmpty) {
          return Center(
            child: CustomText(
              title: 'No video found',
              fontSize: 14.sp,
              color: primaryBlack,
            ),
          );
        }

        /// 🔹 Feeds + Pagination
        return NotificationListener<ScrollNotification>(
          onNotification: (scroll) {
            if (scroll is ScrollEndNotification &&
                scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 50 &&
                controller.hasMore &&
                !controller.isLoadMore.value &&
                !controller.isLoading.value) {
              controller.getTutorials(showLoading: false);
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
                    itemCount: controller.tutorialList.length,
                    itemBuilder: (_, index) {
                      final tutor = controller.tutorialList[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50,
                          child: FadeInAnimation(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14.r),
                              onTap: () {
                                Get.dialog(
                                  TutorialVideoPopup(
                                    title: tutor['name'] ?? '',
                                    videoUrl: tutor['youtube_url'] ?? '',
                                  ),
                                  // isScrollControlled: true,
                                  // backgroundColor: Colors.transparent,
                                );
                              },

                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 16.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.r),
                                  color: Theme.of(
                                    context,
                                  ).scaffoldBackgroundColor,
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                    width: 0.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.08,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.w),
                                  child: Row(
                                    children: [
                                      /// 🎥 Video Thumbnail / Icon
                                      Container(
                                        height: 60.h,
                                        width: 60.h,
                                        decoration: BoxDecoration(
                                          color: Colors.red.withValues(
                                            alpha: 0.9,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.play_arrow_rounded,
                                          color: Colors.white,
                                          size: 34,
                                        ),
                                      ),

                                      SizedBox(width: 12.w),

                                      /// 📄 Title + Subtitle
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              title: tutor['name'] ?? '',
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w600,
                                              color: primaryBlack,
                                              maxLines: 1,
                                            ),
                                            SizedBox(height: 4.h),
                                            CustomText(
                                              title: "Watch short tutorial",
                                              fontSize: 12.sp,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                      ),

                                      /// ➡ Arrow
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 16.r,
                                        color: Colors.grey,
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
        title: "How To Use ?",
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        color: primaryBlack,
      ),
    );
  }
}
