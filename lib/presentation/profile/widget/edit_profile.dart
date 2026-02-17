import 'package:businessbuddy/utils/exported_path.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final controller = getIt<ProfileController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<ExplorerController>().getCategories().then((v) {
        controller.setPreselected();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
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
        title: "Update Profile",
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        color: primaryBlack,
      ),
    );
  }

  Widget _buildProfileImage() {
    final image = controller.profileDetails['profile_image'] ?? '';
    return Center(
      child: GestureDetector(
        onTap: () {
          CustomFilePicker.showPickerBottomSheet(
            onFilePicked: (file) {
              controller.profileImage.value = file;
            },
          );
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Obx(() {
              final imageFile = controller.profileImage.value;

              final ImageProvider<Object> imageProvider = imageFile != null
                  ? FileImage(imageFile)
                  : NetworkImage(image);

              return CircleAvatar(
                radius: 51.r,
                backgroundColor: Colors.grey.shade200,
                child: CircleAvatar(
                  radius: 50.r,
                  backgroundColor: lightGrey,
                  child: ClipOval(
                    child: FadeInImage(
                      placeholder: const AssetImage(Images.defaultImage),
                      image: imageProvider,
                      fit: BoxFit.cover,
                      width: 120.r,
                      height: 120.r,
                      fadeInDuration: const Duration(milliseconds: 300),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          Images.defaultImage,
                          fit: BoxFit.cover,
                          width: 120.r,
                          height: 120.r,
                        );
                      },
                    ),
                  ),
                ),
              );
            }),
            Positioned(
              bottom: 8,
              right: -5,
              child: CircleAvatar(
                radius: 16.r,
                backgroundColor: primaryColor,
                child: Icon(Icons.edit, size: 16.sp, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        spacing: 12.h,
        children: [
          Row(
            spacing: 12.w,
            children: [
              _buildProfileImage(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildLabel('Your name'),
                    buildTextField(
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      controller: controller.nameCtrl,
                      hintText: 'Enter name',
                      keyboardType: TextInputType.name,
                      validator: (value) =>
                          value!.trim().isEmpty ? 'Please enter Name' : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildSpecialization(),
          _buildExperience(),
          _buildEducation(),
          _buildAbout(),
          SizedBox(height: 8.h),
          _buildSubmitButton(),
          _buildDeleteButton(),
        ],
      ),
    );
  }

  Widget _buildSpecialization() {
    // print('controller.specialization.value');
    // print(controller.specialization.value);
    return Obx(
      () => getIt<ExplorerController>().isLoading.isTrue
          ? LoadingWidget(color: primaryColor)
          : AppDropdownField(
              isDynamic: true,
              title: 'Specialization',
              value: controller.specialization.value,
              items: getIt<ExplorerController>().categories,
              hintText: 'Specialization',
              validator: (value) =>
                  value == null ? 'Please select specialization' : null,
              onChanged: (val) async {
                controller.specialization.value = val!;
              },
            ),
    );
  }

  Widget _buildExperience() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: buildLabel('Experience'),
        ),
        buildTextField(
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          controller: controller.experienceCtrl,
          hintText: 'Enter Experience',
          validator: (value) =>
              value!.trim().isEmpty ? 'Please enter Experience' : null,
        ),
      ],
    );
  }

  Widget _buildEducation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: buildLabel('Education'),
        ),
        buildTextField(
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          controller: controller.educationCtrl,
          hintText: 'Enter Education',
          validator: (value) =>
              value!.trim().isEmpty ? 'Please enter Education' : null,
        ),
      ],
    );
  }

  Widget _buildAbout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: buildLabel('About Me'),
        ),
        buildTextField(
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          controller: controller.aboutCtrl,
          hintText: 'Enter About',
          maxLines: 4,
          validator: (value) =>
              value!.trim().isEmpty ? 'Please enter About' : null,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
      () => controller.isLoading.isTrue
          ? LoadingWidget(color: primaryColor)
          : GestureDetector(
              onTap: () async {
                await controller.updateProfile();
              },
              child: Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(100.r),
                ),
                alignment: Alignment.center,
                child: CustomText(
                  title: 'Update Profile',
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: () {
        AllDialogs().showConfirmationDialog(
          'Delete Account',
          'This will permanently delete your account. Continue?',
          onConfirm: () async {
            await controller.deleteProfile();
            // perform delete
            Get.back();
            // Get.snackbar('Account Deleted', 'Your account has been removed');
          },
        );
      },
      child: Container(
        width: Get.width,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        alignment: Alignment.center,
        child: CustomText(
          title: 'Delete account',
          fontSize: 16.sp,
          color: textLightGrey,
        ),
      ),
    );
  }
}
