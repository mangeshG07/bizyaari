import 'dart:io';
import 'package:businessbuddy/utils/exported_path.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final controller = getIt<LBOController>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    controller.postImage.value = null;
    controller.postVideo.value = null;
    controller.postAbout.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppbarPlain(title: "New Post"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 12.h,
            children: [
              _buildProfileImage(),
              Divider(),
              buildTextField(
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                maxLines: 3,
                controller: controller.postAbout,
                hintText: 'About Details',
                validator: (value) =>
                    value!.trim().isEmpty ? 'Please enter about' : null,
              ),
              _buildAddPostButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Obx(() {
            final file = controller.postImage.value;
            final videoFile = controller.postVideo.value;

            if (videoFile != null && isVideo(videoFile)) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: SizedBox(
                  width: Get.width * 0.7.w,
                  height: Get.height * 0.3.h,
                  child: VideoPreview(
                    key: ValueKey(videoFile.path), // 🔥 THIS FIXES IT
                    file: videoFile,
                  ),
                ),
              );
            }

            final ImageProvider imageProvider = file != null
                ? FileImage(file)
                : const AssetImage(Images.defaultImage);

            return ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: FadeInImage(
                width: Get.width * 0.7.w,
                height: Get.height * 0.3.h,
                placeholder: const AssetImage(Images.defaultImage),
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            );
          }),

          // Obx(() {
          //   final imageFile = controller.postImage.value;
          //   final ImageProvider<Object> imageProvider = imageFile != null
          //       ? FileImage(imageFile)
          //       : const AssetImage(Images.defaultImage);
          //   return ClipRRect(
          //     borderRadius: BorderRadius.circular(12.r),
          //     child: FadeInImage(
          //       width: Get.width * 0.7.w,
          //       height: Get.height * 0.3.h,
          //       placeholder: const AssetImage(Images.logo),
          //       image: imageProvider,
          //       imageErrorBuilder: (context, error, stackTrace) {
          //         return Image.asset(
          //           Images.defaultImage,
          //           width: Get.width * 0.7.w,
          //           height: Get.height * 0.3.h,
          //           fit: BoxFit.cover,
          //         );
          //       },
          //       fit: BoxFit.cover,
          //       placeholderFit: BoxFit.contain,
          //       fadeInDuration: const Duration(milliseconds: 300),
          //     ),
          //   );
          // }),
          Positioned(
            bottom: 0,
            right: -10,
            child: GestureDetector(
              onTap: () {
                CustomFilePicker.showPickerBottomSheet(
                  showVideo: true,
                  onFilePicked: (file) {
                    if (isVideo(file)) {
                      controller.postVideo.value = file;
                      controller.postImage.value = null;
                    } else {
                      controller.postImage.value = file;
                      controller.postVideo.value = null;
                    }
                  },
                );
              },
              child: CircleAvatar(
                radius: 18.r,
                backgroundColor: primaryColor,
                child: Icon(Icons.edit, size: 20.sp, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPostButton() {
    return Obx(
      () => controller.isPostLoading.isTrue
          ? LoadingWidget(color: primaryColor)
          : GestureDetector(
              onTap: () async {
                // 1️⃣ Validate text fields
                if (!_formKey.currentState!.validate()) return;

                // 2️⃣ Validate media
                if (!_isMediaSelected()) {
                  ToastUtils.showWarningToast('Please select image or video');
                  return;
                }

                // 3️⃣ Validate video size
                final video = controller.postVideo.value;
                if (video != null && !_isVideoSizeValid(video)) {
                  ToastUtils.showWarningToast(
                    'Video size should be less than 20MB',
                  );
                  return;
                }

                // 4️⃣ Submit
                await controller.addNewPost();
              },
              child: Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: CustomText(
                  title: 'Post',
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }

  bool _isMediaSelected() {
    return controller.postImage.value != null ||
        controller.postVideo.value != null;
  }

  bool _isVideoSizeValid(File video) {
    final sizeInMB = video.lengthSync() / (1024 * 1024);
    return sizeInMB <= 20;
  }
}
