import 'package:businessbuddy/utils/exported_path.dart';

class TutorialVideoPopup extends StatelessWidget {
  final String title;
  final String videoUrl;

  const TutorialVideoPopup({
    super.key,
    required this.title,
    required this.videoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22.r),
        side: BorderSide(color: Colors.grey),
      ),
      child: Container(
        height: Get.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(22.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22.r),
            child: InstagramVideoPlayer(
              url: videoUrl,
              isSingleView: true, // 👈 important
            ),
          ),
        ),
      ),
    );
  }
}
