import 'package:businessbuddy/utils/exported_path.dart';
import 'package:sms_autofill/sms_autofill.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = getIt<OnboardingController>();

  @override
  void initState() {
    super.initState();
    _getHintNumber();
  }

  Future<void> _getHintNumber() async {
    try {
      String? number = await SmsAutoFill().hint;
      if (number != null && number.isNotEmpty) {
        controller.numberController.text = number;
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppbar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                child: Form(
                  key: controller.loginKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: Get.height * 0.05),
                      _buildWelcomeHeader(),
                      SizedBox(height: Get.height * 0.04),
                      _buildNumberField('Mobile Number'),
                      SizedBox(height: Get.height * 0.04),
                      _buildGetOtpButton(),
                      SizedBox(height: Get.height * 0.07),
                      _buildSignUpText(),
                      SizedBox(height: Get.height * 0.05),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: _buildPrivacySection(),
            ),
          ],
        ),
      ),
    );
  }

  CustomAppBar _buildAppbar() {
    return CustomAppBar(
      showBackButton: false,
      titleSpacing: null,
      actions: [
        InkWell(
          onTap: () async {
            await getIt<DemoService>().updateDemoStatus("demo");
            Get.offAllNamed(Routes.mainScreen);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: CustomText(
              title: 'Skip',
              fontSize: 13.sp,
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      children: [
        CustomText(
          title: 'Welcome to\nBizYaari',
          textAlign: TextAlign.center,
          fontSize: 28.sp,
          maxLines: 2,
          color: textDarkGrey,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 12.h),
        CustomText(
          title:
              'Enter your mobile number to continue.\nWe’ll send you a 6-digit verification code.',
          textAlign: TextAlign.center,
          color: textLightGrey,
          fontSize: 14.sp,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildNumberField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(label),
        SizedBox(height: 8.h),
        buildTextField(
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          controller: controller.numberController,
          hintText: 'Enter your mobile number',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter mobile number';
            }
            if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
              return 'Enter a valid mobile number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildGetOtpButton() {
    return CustomButton(
      width: double.infinity,
      backgroundColor: primaryColor,
      text: 'Get OTP',
      isLoading: controller.isLoading,
      onPressed: () async {
        if (controller.loginKey.currentState!.validate()) {
          await controller.sendOtpApi();
        }
      },
    );
  }

  Widget _buildPrivacySection() {
    return Column(
      children: [
        CustomText(
          title: "By continuing, you agree to our",
          fontSize: 14.sp,
          color: textGrey,
        ),
        SizedBox(height: 6.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLinkText(
              "Terms & Conditions",
              onTap: () {
                launchURL(AllUrl.termsCondition);
              },
            ),
            CustomText(title: " and  ", fontSize: 14.sp, color: textGrey),
            _buildLinkText(
              "Privacy Policy",
              onTap: () {
                launchURL(AllUrl.privacyPolicy);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLinkText(String text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          color: primaryColor,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
          decorationColor: primaryColor,
        ),
      ),
    );
  }

  Widget _buildSignUpText() {
    return RichText(
      text: TextSpan(
        text: "Don’t have an account yet? ",
        style: TextStyle(
          fontSize: 14.sp,
          color: textGrey,
          fontWeight: FontWeight.w500,
        ),
        children: [
          TextSpan(
            text: 'Sign up now',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.toNamed(Routes.register);
              },
          ),
        ],
      ),
    );
  }
}

// import 'package:businessbuddy/utils/exported_path.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final controller = getIt<OnboardingController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CustomAppBar(showBackButton: false, titleSpacing: null),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Form(
//             key: controller.loginKey,
//             child: Column(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(16.r),
//                   child: Column(
//                     spacing: 8.h,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(height: Get.height * 0.1.h),
//                       CustomText(
//                         title: 'Welcome to\nBusiness Buddy',
//                         textAlign: TextAlign.center,
//                         fontSize: 28.sp,
//                         maxLines: 2,
//                         color: textDarkGrey,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       CustomText(
//                         title:
//                             'Enter your mobile number to continue.\nWe’ll send you a 6-digit verification code.',
//                         textAlign: TextAlign.center,
//                         color: textLightGrey,
//                         fontSize: 14.sp,
//                         maxLines: 3,
//                       ),
//                       SizedBox(height: Get.height * 0.015),
//                       _buildNumberField('Mobile Number'),
//                       SizedBox(height: Get.height * 0.01),
//                       CustomButton(
//                         width: Get.width * 0.8.w,
//                         backgroundColor: primaryColor,
//                         text: 'Get OTP',
//                         isLoading: controller.isLoading,
//                         onPressed: () {
//                           Get.toNamed(Routes.verify);
//                         },
//                       ),
//                       SizedBox(height: Get.height * 0.01),
//                       _buildPrivacy(),
//                       SizedBox(height: Get.height * 0.02),
//                       _buildSignUpText(),
//                     ],
//                   ),
//                 ),
//                 // Container(
//                 //   height: Get.height,
//                 //   decoration: BoxDecoration(
//                 //     color: lightGrey,
//                 //     borderRadius: BorderRadius.circular(15.r),
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNumberField(String text) {
//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.only(left: 6.w, bottom: 6.h),
//           child: buildLabel(text),
//         ),
//         buildTextField(
//           inputFormatters: [
//             FilteringTextInputFormatter.digitsOnly,
//             LengthLimitingTextInputFormatter(10),
//           ],
//           keyboardType: TextInputType.number,
//           controller: controller.numberController,
//           validator: (value) => value!.isEmpty
//               ? 'Please enter mobile number'
//               : !value.contains(RegExp(r'^[6-9]\d{9}$'))
//               ? 'Enter valid mobile number'
//               : null,
//           hintText: 'Enter your mobile number',
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPrivacy() {
//     return Column(
//       children: [
//         CustomText(
//           title: "By generating OTP you accept our ",
//           fontSize: 14.sp,
//           fontWeight: FontWeight.w500,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             GestureDetector(
//               child: Text(
//                 "Terms & Conditions ",
//                 style: TextStyle(
//                   fontSize: Get.width * 0.04,
//                   color: primaryColor,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               onTap: () {},
//             ),
//             Text(
//               "and ",
//               style: TextStyle(
//                 fontSize: Get.width * 0.04,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             GestureDetector(
//               child: Text(
//                 "Privacy policy",
//                 style: TextStyle(
//                   fontSize: Get.width * 0.04,
//                   color: primaryColor,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               onTap: () {},
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSignUpText() {
//     return RichText(
//       text: TextSpan(
//         text: "Don't have an account yet?",
//         style: TextStyle(
//           fontSize: 14.sp,
//           fontWeight: FontWeight.bold,
//           color: textGrey,
//         ),
//         children: [
//           TextSpan(
//             text: ' Sign up now',
//             style: TextStyle(color: Colors.red),
//           ),
//         ],
//       ),
//     );
//   }
// }
