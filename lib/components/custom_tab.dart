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
        'intro': 'Explore businesses & services here',
        'featureId': 'feature_explorer',
        'key': controller.exploreKey,
      },
      {
        'icon': HugeIcons.strokeRoundedMenuSquare,
        'label': 'Feeds',
        'intro': 'Check latest feeds & updates',
        'featureId': 'feature_feeds',
        'key': controller.feedsKey,
      },
      {
        'icon': HugeIcons.strokeRoundedUser03,
        'label': 'My Business',
        'intro': 'Manage your business profile here',
        'featureId': 'feature_my_business',
        'key': controller.myBusinessKey,
      },
    ];

    ShowcaseView.register(autoPlayDelay: const Duration(seconds: 3));

    controller.initShowcase();
    // ShowcaseView.register(
    //   autoPlayDelay: const Duration(seconds: 3),
    //
    //   // globalFloatingActionWidget: (showcaseContext) {
    //   //   return FloatingActionWidget(
    //   //     top: 100,
    //   //     right: 20,
    //   //     child: ElevatedButton(
    //   //       style: ElevatedButton.styleFrom(
    //   //         backgroundColor: Colors.red,
    //   //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    //   //       ),
    //   //       onPressed: () => ShowcaseView.get().dismiss(),
    //   //       child: const Text("Skip", style: TextStyle(color: Colors.white)),
    //   //     ),
    //   //   );
    //   // },
    //   // globalFloatingActionWidget: (showcaseContext) => FloatingActionWidget(
    //   //   left: 16,
    //   //   bottom: 16,
    //   //   child: Padding(
    //   //     padding: const EdgeInsets.all(Dimens.largePadding),
    //   //     child: ElevatedButton(
    //   //       onPressed: () => ShowcaseView.get().dismiss(),
    //   //       style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
    //   //       child: Row(
    //   //         spacing: Dimens.padding,
    //   //         children: [
    //   //           Icon(Icons.close, color: Colors.white),
    //   //           const Text('Close', style: TextStyle(color: Colors.white)),
    //   //         ],
    //   //       ),
    //   //     ),
    //   //   ),
    //   // ),
    //   // globalTooltipActions: [
    //   //   // TooltipActionButton(
    //   //   //   type: TooltipDefaultActionType.previous,
    //   //   //   textStyle: const TextStyle(color: Colors.white),
    //   //   //   backgroundColor: Colors.deepOrange,
    //   //   //   hideActionWidgetForShowcase: [exploreKey],
    //   //   // ),
    //   //   TooltipActionButton(
    //   //     type: TooltipDefaultActionType.previous,
    //   //     textStyle: const TextStyle(color: Colors.white),
    //   //     backgroundColor: Colors.deepOrange,
    //   //     hideActionWidgetForShowcase: [feedsKey],
    //   //   ),
    //   //   TooltipActionButton(
    //   //     type: TooltipDefaultActionType.next,
    //   //     textStyle: const TextStyle(color: Colors.white),
    //   //     backgroundColor: Colors.deepOrange,
    //   //     hideActionWidgetForShowcase: [myBusinessKey],
    //   //   ),
    //   // ],
    //   onStart: (index, key) {},
    //   onComplete: (index, key) {},
    //   onDismiss: (key) {},
    //   onFinish: () {},
    // );
    //
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) => ShowcaseView.get().startShowCase([
    //     exploreKey,
    //     feedsKey,
    //     myBusinessKey,
    //   ]),
    // );
  }

  @override
  void dispose() {
    ShowcaseView.get().unregister();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: Get.width,
        height: 35.h,
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.symmetric(horizontal: BorderSide(color: primaryColor)),
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
                              fontSize: 12.sp,
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
  });

  final GlobalKey globalKey;
  final String title;
  final String description;
  final double progressValue;
  final Widget child;
  final int index;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
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
              color: Theme.of(context).scaffoldBackgroundColor,
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
                          await LocalStorage.setBool('intro_done', true);
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
