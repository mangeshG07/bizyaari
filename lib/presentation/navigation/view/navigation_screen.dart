import 'package:auto_size_text/auto_size_text.dart';
import 'package:businessbuddy/utils/exported_path.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final controller = getIt<NavigationController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
      () => PopScope(
        canPop: controller.pageStack.length <= 1,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            // 🔥 nested page back
            controller.goBack();
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Column(
              children: [
                CustomMainHeader2(),
                Expanded(child: Obx(() => controller.pageStack.last)),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor,
                border: Border(
                  top: BorderSide(color: primaryColor, width: 2),
                  bottom: BorderSide(color: primaryColor, width: 2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.brightness == Brightness.light
                        ? Colors.black.withValues(alpha: 0.07)
                        : Colors.white.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: ClipRRect(
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: navBackground,
                  selectedFontSize: 12,
                  unselectedFontSize: 11,
                  iconSize: 22,
                  selectedItemColor: controller.currentIndex.value == -1
                      ? Colors.grey
                      : primaryColor,
                  unselectedItemColor: textGrey,
                  showUnselectedLabels: true,
                  selectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  currentIndex: controller.currentIndex.value == -1
                      ? 0
                      : controller.currentIndex.value,
                  onTap: controller.updateBottomIndex,
                  items: [
                    _buildNavItem(
                      HugeIcons.strokeRoundedHome01,
                      'Home',
                      0,
                      controller.currentIndex.value == 0,
                    ),
                    _buildNavItem(
                      HugeIcons.strokeRoundedMessage02,
                      'Inbox',
                      1,
                      controller.currentIndex.value == 1,
                    ),
                    _buildNavItem(
                      HugeIcons.strokeRoundedUserMultiple02,
                      'Business Partner',
                      2,
                      controller.currentIndex.value == 2,
                    ),

                    _buildNavItem(
                      HugeIcons.strokeRoundedTag01,
                      'Special Offers',
                      3,
                      controller.currentIndex.value == 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    var icon,
    String label,
    int index,
    bool isSelected, {
    double? iconSize,
  }) {
    final controller = getIt<NavigationController>();

    Widget item = Column(
      children: [
        Container(
          decoration: BoxDecoration(
            // color: isSelected ? primaryColor : Colors.transparent,
            border: Border.all(
              color: isSelected ? primaryColor : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: const EdgeInsets.all(4),
          child: HugeIcon(
            size: Get.width * 0.06,
            icon: icon,
            color: isSelected ? primaryColor : primaryBlack,
          ),
        ),
        SizedBox(height: 2),
        AutoSizeText(
          label,
          style: TextStyle(fontSize: 12, height: 0.9),
          minFontSize: 10,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );

    /// 🔥 Wrap ONLY Business Partner
    if (index == 2) {
      return BottomNavigationBarItem(
        label: '',
        icon: AppShowCaseWidget(
          index: 0,
          totalSteps: 1,
          isLastFlow: true,
          globalKey: controller.businessPartnerKey,
          title: "Business Partner",
          description:
              "Connect with Local Investors, Search Business Partners Or Experts. Post your requirements or explore opportunities to start your Business or to grow your Business.",
          progressValue: 1,
          child: item,
        ),
      );
    }
    return BottomNavigationBarItem(
      icon: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? primaryColor : Colors.transparent,
              ),
              // color: isSelected ? primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: const EdgeInsets.all(4.0),
            child: HugeIcon(
              size: iconSize ?? Get.width * 0.06,
              icon: icon,
              color: isSelected ? primaryColor : primaryBlack,
            ),
          ),
          SizedBox(height: 2),
          AutoSizeText(
            label,
            style: TextStyle(fontSize: 14),
            minFontSize: 10,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      label: '',
    );
  }
}
