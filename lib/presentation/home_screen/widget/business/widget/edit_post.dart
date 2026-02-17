import 'dart:io';

import 'package:businessbuddy/utils/exported_path.dart';

class EditPost extends StatefulWidget {
  const EditPost({super.key});

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final controller = getIt<LBOController>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    controller.postImage.value = null;
    controller.postVideo.value = null;
    controller.postAbout.text = Get.arguments['postData']['details'] ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppbarPlain(title: "Edit Post"),
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
                maxLines: 3,
                fillColor: Theme.of(context).scaffoldBackgroundColor,
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
            final postData = Get.arguments['postData'] ?? {};

            final String imageUrl = postData['image'] ?? '';
            final String videoUrl = postData['video'] ?? '';
            final String mediaType = postData['media_type'] ?? '';

            final File? pickedImage = controller.postImage.value;
            final File? pickedVideo = controller.postVideo.value;

            final double width = Get.width * 0.7;
            final double height = Get.height * 0.3;

            /// 1️⃣ Picked video (highest priority)
            if (pickedVideo != null && isVideo(pickedVideo)) {
              return _videoContainer(
                child: VideoPreview(
                  key: ValueKey(pickedVideo.path),
                  file: pickedVideo,
                ),
                width: width,
                height: height,
              );
            }

            /// 2️⃣ Picked image
            if (pickedImage != null) {
              return _imageContainer(
                imageProvider: FileImage(pickedImage),
                width: width,
                height: height,
              );
            }

            /// 3️⃣ API video
            if (mediaType == 'video' && videoUrl.isNotEmpty) {
              return _videoContainer(
                child: InstagramVideoPlayer(url: videoUrl),
                width: width,
                height: height,
              );
            }

            /// 4️⃣ API image
            if (imageUrl.isNotEmpty) {
              return _imageContainer(
                imageProvider: NetworkImage(imageUrl),
                width: width,
                height: height,
              );
            }

            /// 5️⃣ Fallback
            return _imageContainer(
              imageProvider: const AssetImage(Images.defaultImage),
              width: width,
              height: height,
            );
          }),

          // Obx(() {
          //   final image = Get.arguments['postData']['image'] ?? '';
          //   final video = Get.arguments['postData']['video'] ?? '';
          //   final type = Get.arguments['postData']['media_type'] ?? '';
          //   final imageFile = controller.postImage.value;
          //   final videoFile = controller.postVideo.value;
          //
          //   if (videoFile != null && isVideo(videoFile)) {
          //     return ClipRRect(
          //       borderRadius: BorderRadius.circular(12.r),
          //       child: SizedBox(
          //         width: Get.width * 0.7.w,
          //         height: Get.height * 0.3.h,
          //         child: VideoPreview(file: videoFile),
          //       ),
          //     );
          //   }
          //
          //   final ImageProvider<Object> imageProvider = imageFile != null
          //       ? FileImage(imageFile)
          //       : NetworkImage(image);
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
                if (!_formKey.currentState!.validate()) return;

                // if (!_isMediaSelected()) {
                //   ToastUtils.showWarningToast('Please select image or video');
                //   return;
                // }

                // 3️⃣ Validate video size
                final video = controller.postVideo.value;
                if (video != null && !_isVideoSizeValid(video)) {
                  ToastUtils.showWarningToast(
                    'Video size should be less than 20MB',
                  );
                  return;
                }

                await controller.editPost(
                  Get.arguments['postData']['id'].toString(),
                );
              },
              child: Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: CustomText(
                  title: 'Update Post',
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }

  // bool _isMediaSelected() {
  //   return controller.postImage.value != null ||
  //       controller.postVideo.value != null;
  // }

  bool _isVideoSizeValid(File video) {
    final sizeInMB = video.lengthSync() / (1024 * 1024);
    return sizeInMB <= 20;
  }

  Widget _imageContainer({
    required ImageProvider imageProvider,
    required double width,
    required double height,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: FadeInImage(
        width: width,
        height: height,
        placeholder: const AssetImage(Images.defaultImage),
        image: imageProvider,
        fit: BoxFit.cover,
        placeholderFit: BoxFit.contain,
        fadeInDuration: const Duration(milliseconds: 300),
        imageErrorBuilder: (_, __, ___) {
          return Image.asset(
            Images.defaultImage,
            width: width,
            height: height,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  Widget _videoContainer({
    required Widget child,
    required double width,
    required double height,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(width: width, height: height, child: child),
    );
  }
}
