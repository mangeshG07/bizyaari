import 'package:businessbuddy/utils/exported_path.dart';
import 'package:sms_autofill/sms_autofill.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> with CodeAutoFill {
  final controller = getIt<OnboardingController>();

  @override
  void initState() {
    controller.startTimer();
    listenForCode();
    super.initState();
  }

  @override
  void codeUpdated() {
    controller.otpController.text = code!;
    // print('OTP Received: ${controller.otpController.text}');
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    // controller.otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(showBackButton: false, titleSpacing: 0),
      body: SafeArea(
        child: Stack(
          children: [
            /// Scrollable OTP content
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
              child: Form(
                key: controller.verifyKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: Get.height * 0.06),
                    _buildHeader(),
                    SizedBox(height: Get.height * 0.05),
                    _buildOTPField('Enter OTP'),
                    SizedBox(height: 12.r),
                    _buildResendOtp(),
                    SizedBox(height: 12.r),
                    _buildVerifyButton(),
                    SizedBox(height: Get.height * 0.12),
                  ],
                ),
              ),
            ),

            /// Fixed Change Number text at bottom
            Positioned(
              bottom: 20.h,
              left: 0,
              right: 0,
              child: Center(child: _buildChangeNumber()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResendOtp() {
    return Align(
      alignment: Alignment.topLeft,
      child: Obx(() {
        return controller.start.value > 0
            ? CustomText(
                title:
                    'Didn’t receive it? Resend OTP in (${controller.start.value}s)',
                color: textLightGrey,
                fontSize: 14.sp,
              )
            : GestureDetector(
                onTap: () {},
                child: CustomText(
                  title: 'Resend OTP',
                  color: primaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              );
      }),
    );
  }

  /// ---------------- HEADER ----------------
  Widget _buildHeader() {
    return Column(
      children: [
        CustomText(
          title: 'Enter Verification Code',
          textAlign: TextAlign.center,
          fontSize: 28.sp,
          color: textDarkGrey,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 12.h),
        CustomText(
          title:
              'We’ve sent a 6-digit OTP\non +91 ${controller.numberController.text}',
          textAlign: TextAlign.center,
          color: textLightGrey,
          fontSize: 14.sp,
          maxLines: 3,
        ),
      ],
    );
  }

  /// ---------------- OTP FIELD ----------------
  Widget _buildOTPField(String label) {
    final defaultPinTheme = PinTheme(
      width: 50.w,
      height: 50.h,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: Theme.of(context).textTheme.bodySmall!.color,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).textTheme.bodySmall!.color!,
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(label),
        SizedBox(height: 8.h),
        Center(
          child: Pinput(
            controller: controller.otpController,
            length: 6,

            keyboardType: TextInputType.number,
            validator: (value) =>
                value == null || value.isEmpty ? 'OTP is required' : null,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                border: Border.all(color: primaryColor, width: 2),
              ),
            ),
            submittedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                border: Border.all(color: primaryColor),
              ),
            ),
            onCompleted: (pin) => debugPrint('Entered OTP: $pin'),
          ),
        ),
      ],
    );
  }

  /// ---------------- VERIFY BUTTON ----------------
  Widget _buildVerifyButton() {
    return CustomButton(
      width: double.infinity,
      backgroundColor: primaryColor,
      text: 'Verify & Continue',
      isLoading: controller.isVerifyLoading,
      onPressed: () async {
        // if (controller.otpController.text.length == 6) {
        if (controller.verifyKey.currentState!.validate()) {
          await controller.verifyOtpApi();
        } else {
          // showCustomSnackBar('Please enter a valid 6-digit OTP');
        }
      },
    );
  }

  /// ---------------- CHANGE NUMBER ----------------
  Widget _buildChangeNumber() {
    return GestureDetector(
      onTap: () => AllDialogs().changeNumber(controller.numberController.text),
      child: Text(
        "Change Mobile Number",
        style: TextStyle(
          fontSize: 16.sp,
          color: primaryColor,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
          decorationColor: primaryColor,
        ),
      ),
    );
  }
}
