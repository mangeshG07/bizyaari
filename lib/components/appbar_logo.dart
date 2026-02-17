import '../utils/exported_path.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final List<Widget>? actions;
  final double? titleSpacing;
  final bool? centerTitle;
  final Color backgroundColor;

  const CustomAppBar({
    super.key,
    this.showBackButton = true,
    this.centerTitle = false,
    this.actions,
    this.titleSpacing = 0,
    this.backgroundColor = Colors.white,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      titleSpacing: titleSpacing,
      centerTitle: centerTitle,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 16),
        child: Image.asset(Images.logo, width: Get.width * 0.4.w),
      ),
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      actions: actions,
      elevation: 0,
    );
  }
}
