import '../../../utils/exported_path.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      allowImplicitScrolling: true,
      infiniteAutoScroll: true,
      autoScrollDuration: 3000,
      curve: Curves.fastLinearToSlowEaseIn,
      globalBackgroundColor: Colors.white,
      bodyPadding: EdgeInsets.only(top: Get.height * 0.25.h),
      globalHeader: Padding(
        padding: EdgeInsets.only(top: 50.h),
        child: SafeArea(
          child: Center(
            child: Image.asset(Images.logo, width: Get.width * 0.6.w),
          ),
        ),
      ),

      pages: [
        _buildPage(
          title: "Welcome to\nBizYaari",
          body:
              "Discover nearby stores, deals, and essential services — right around you.",
          image: Images.intro_1,
        ),
        _buildPage(
          title: "Find Great\nLocal Offers",
          body:
              "Get the best discounts and special deals from your trusted neighborhood shops.",
          image: Images.intro_2,
        ),
        _buildPage(
          title: "Post Your\nNeeds Instantly",
          body:
              "Looking for a service or product? Share your requirement and let businesses come to you.",
          image: Images.intro_3,
        ),
      ],

      onDone: () async {
        await LocalStorage.setBool('isOnboarded', true);
        Get.offAllNamed(Routes.login);
      },
      onSkip: () async {
        await LocalStorage.setBool('isOnboarded', true);
        Get.offAllNamed(Routes.login);
      },

      showSkipButton: true,
      skip: const Text("Skip", style: TextStyle(color: primaryColor)),
      next: const Icon(Icons.arrow_forward, color: Colors.grey),
      done: const Text(
        "Done",
        style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
      ),
      dotsDecorator: getDotDecoration(),
    );
  }

  PageViewModel _buildPage({
    required String title,
    required String body,
    required String image,
  }) {
    return PageViewModel(
      titleWidget: CustomText(
        title: title,
        textAlign: TextAlign.center,
        fontSize: 24.sp,
        maxLines: 2,
        fontWeight: FontWeight.bold,
      ),
      bodyWidget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomText(
          title: body,
          textAlign: TextAlign.center,
          color: inverseColor,
          fontSize: 16.sp,
          maxLines: 3,
          style: const TextStyle(height: 1.5),
        ),
      ),
      image: Center(child: Image.asset(image, width: Get.width * 0.7.w)),
      decoration: const PageDecoration(pageColor: Colors.white),
    );
  }

  DotsDecorator getDotDecoration() => DotsDecorator(
    color: Colors.grey,
    activeColor: primaryColor,
    size: const Size(10, 10),
    activeSize: const Size(22, 10),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
    ),
  );
}
