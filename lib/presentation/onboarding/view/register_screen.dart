import 'package:businessbuddy/utils/exported_path.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final controller = getIt<OnboardingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(
        showBackButton: false,
        centerTitle: true,
        titleSpacing: null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                child: Form(
                  key: controller.registerKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // SizedBox(height: Get.height * 0.03),
                      _buildWelcomeHeader(),
                      SizedBox(height: Get.height * 0.01),
                      _buildProfileImage(),
                      SizedBox(height: Get.height * 0.02),
                      _buildNameField('Full Name'),
                      SizedBox(height: Get.height * 0.02),
                      _buildNumberField('Mobile Number'),
                      SizedBox(height: Get.height * 0.02),
                      _buildEmailField('Email Address'),
                      SizedBox(height: Get.height * 0.04),
                      _buildRegisterButton(),
                      SizedBox(height: Get.height * 0.03),
                      _buildSignUpText(),
                      SizedBox(height: Get.height * 0.05),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: _buildPrivacySection(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      children: [
        CustomText(
          title: 'Create Your Account',
          textAlign: TextAlign.center,
          fontSize: 28.sp,
          maxLines: 2,
          color: textDarkGrey,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 12.h),
        CustomText(
          title:
              'Join BizYaari and start connecting\nwith local businesses and customers near you.',
          textAlign: TextAlign.center,
          color: textLightGrey,
          fontSize: 14.sp,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: controller.pickImage,
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            radius: 51.r,
            child: CircleAvatar(
              radius: 50.r,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Obx(() {
                  final imageFile = controller.profileImage.value;
                  final ImageProvider<Object> imageProvider = imageFile != null
                      ? FileImage(imageFile)
                      : const AssetImage(Images.defaultImage);

                  return FadeInImage(
                    placeholder: const AssetImage(Images.defaultImage),
                    image: imageProvider,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        Images.defaultImage,
                        width: 100.w,
                        height: 100.h,
                        fit: BoxFit.contain,
                      );
                    },
                    fit: BoxFit.cover,
                    width: 100.w,
                    height: 100.h,
                    placeholderFit: BoxFit.contain,
                    fadeInDuration: const Duration(milliseconds: 300),
                  );
                }),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 16.r,
              backgroundColor: primaryColor,
              child: Icon(Icons.edit, size: 16.sp, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(label),
        buildTextField(
          fillColor: Theme.of(Get.context!).scaffoldBackgroundColor,
          controller: controller.nameController,
          hintText: 'Enter your full name',
          keyboardType: TextInputType.name,
          validator: (value) =>
              value!.trim().isEmpty ? 'Please enter name' : null,
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
          fillColor: Theme.of(Get.context!).scaffoldBackgroundColor,
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

  Widget _buildEmailField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(label),
        // SizedBox(height: 8.h),
        buildTextField(
          fillColor: Theme.of(Get.context!).scaffoldBackgroundColor,
          controller: controller.emailController,
          hintText: 'Enter your email address',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email address';
            } else if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+$",
            ).hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return CustomButton(
      width: double.infinity,
      backgroundColor: primaryColor,
      text: 'Sign Up / Register',
      isLoading: controller.isRegLoading,
      onPressed: () async {
        if (controller.registerKey.currentState!.validate()) {
          await controller.registerApi();
        }
      },
    );
  }

  Widget _buildPrivacySection() {
    return Column(
      children: [
        CustomText(
          title: "By signing up, you agree to our",
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
        text: "Already have an account? ",
        style: TextStyle(
          fontSize: 14.sp,
          color: textGrey,
          fontWeight: FontWeight.w500,
        ),
        children: [
          TextSpan(
            text: 'Login',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.offAllNamed(Routes.login),
          ),
        ],
      ),
    );
  }
}
