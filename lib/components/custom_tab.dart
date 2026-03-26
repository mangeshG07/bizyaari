import '../utils/exported_path.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({super.key});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  final controller = getIt<NavigationController>();

  @override
  void initState() {
    super.initState();

    controller.tabs = [
      {
        'icon': HugeIcons.strokeRoundedBriefcase08,
        'label': 'Explorer',
        'intro':
            'Find nearby Stores, Services & Businesses — from grocery and restaurants to salons and plumbers — all in one place.',
        'featureId': 'feature_explorer',
        'key': controller.exploreKey,
      },
      {
        'icon': HugeIcons.strokeRoundedMenuSquare,
        'label': 'Feeds',
        'intro':
            'Stay updated with the latest Posts, Offers & Business updates from nearby market. The Feeds section allows you to easily browse and filter content based on your Interests, Location or Business Category, helping you discover latest.',
        'featureId': 'feature_feeds',
        'key': controller.feedsKey,
      },
      {
        'icon': HugeIcons.strokeRoundedUser03,
        'label': 'My Business',
        'intro':
            'If you are a Business Owner - List and Manage your Business here. Create your Business Profile, add your Services or Products, and help nearby customers discover your Business. A step-by-step listing video is available in the Help section',
        'featureId': 'feature_my_business',
        'key': controller.myBusinessKey,
      },
    ];

    ShowcaseView.register(autoPlayDelay: const Duration(seconds: 3));

    // controller.initShowcase();
  }

  // @override
  // void dispose() {
  //   ShowcaseView.get().unregister();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: Get.width,
        height: 35.h,
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.symmetric(
            horizontal: BorderSide(color: primaryColor, width: 2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(controller.tabs.length, (index) {
            final isSelected =
                controller.topTabIndex.value == index &&
                controller.isTopTabSelected.value;

            return Expanded(
              child: GestureDetector(
                onTap: () => controller.updateTopTab(index),
                child: AppShowCaseWidget(
                  index: index,
                  totalSteps: controller.tabs.length,
                  globalKey: controller.tabs[index]['key'],
                  title: controller.tabs[index]['label'],
                  description: controller.tabs[index]['intro'],
                  progressValue: (index + 1) / controller.tabs.length,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? primaryColor
                          : Theme.of(context).scaffoldBackgroundColor,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HugeIcon(
                          icon: controller.tabs[index]['icon'],
                          color: isSelected ? Colors.white : textSmall,
                          size: 18.sp,
                        ),
                        SizedBox(width: 6.w),
                        Flexible(
                          child: Text(
                            controller.tabs[index]['label'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected ? Colors.white : textSmall,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class AppShowCaseWidget extends StatelessWidget {
  const AppShowCaseWidget({
    super.key,
    required this.globalKey,
    required this.title,
    required this.description,
    required this.progressValue,
    required this.child,
    required this.index,
    required this.totalSteps,
    this.isLastFlow = false,
  });

  final GlobalKey globalKey;
  final String title;
  final String description;
  final double progressValue;
  final Widget child;
  final int index;
  final int totalSteps;
  final bool isLastFlow;
  @override
  Widget build(BuildContext context) {
    final controller = getIt<NavigationController>();

    return Showcase.withWidget(
      key: globalKey,
      targetShapeBorder: const CircleBorder(),
      disableBarrierInteraction: true,
      targetPadding: EdgeInsets.all(30),
      overlayOpacity: 0.4,
      targetBorderRadius: BorderRadius.circular(50),
      container: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: context.widthPx,
            padding: const EdgeInsets.all(Dimens.largePadding),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimens.corners),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Dimens.padding,
              children: [
                /// 🔥 Top Row (Title + Close Button)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        ShowcaseView.get().dismiss();
                        await LocalStorage.setBool('intro_done', true);
                      },
                      child: const Icon(Icons.close, size: 22),
                    ),
                  ],
                ),
                Text(description),
                SizedBox(height: Dimens.largePadding),
                LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(Dimens.corners),
                  value: progressValue,
                  minHeight: 7,
                  color: primaryColor,
                  backgroundColor: primaryColor.withValues(alpha: 0.2),
                ),
                SizedBox.shrink(),

                /// 🔥 Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Previous
                    if (index != 0)
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryColor,
                          side: BorderSide(color: primaryColor),
                        ),
                        onPressed: () => ShowcaseView.get().previous(),
                        child: const Text("Previous"),
                      )
                    else
                      const SizedBox(width: 90),

                    /// Next / Finish
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                      ),
                      onPressed: () async {
                        if (index == totalSteps - 1) {
                          ShowcaseView.get().dismiss();

                          /// 🔥 If final onboarding → SAVE
                          if (isLastFlow) {
                            await LocalStorage.setBool('intro_done', true);
                          } else {
                            /// 🔥 Move to next showcase flow
                            await Future.delayed(
                              const Duration(milliseconds: 300),
                            );
                            controller.startBottomShowcase();
                          }
                        } else {
                          ShowcaseView.get().next();
                        }
                      },
                      child: Text(index == totalSteps - 1 ? "Finish" : "Next"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      child: child,
    );
  }
}
