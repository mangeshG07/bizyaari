import 'dart:io';

import 'package:businessbuddy/utils/exported_path.dart';
import 'package:intl/intl.dart';

class AddOffer extends StatefulWidget {
  const AddOffer({super.key});

  @override
  State<AddOffer> createState() => _AddOfferState();
}

class _AddOfferState extends State<AddOffer> {
  final controller = getIt<LBOController>();

  @override
  void initState() {
    controller.clearOfferData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppbarPlain(title: "New Offer"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: controller.offerKey,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileImage(),
                Divider(height: 32.h),
                _buildLabel('Title'),
                buildTextField(
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  controller: controller.titleCtrl,
                  hintText: 'Enter title',
                  validator: (value) =>
                      value!.trim().isEmpty ? 'Please enter title' : null,
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateField(
                        'Start Date',
                        controller.startDateCtrl,
                        true,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildDateField(
                        'End Date',
                        controller.endDateCtrl,
                        false,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                _buildLabel('Description'),
                buildTextField(
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  controller: controller.descriptionCtrl,
                  hintText: 'Enter description',
                  maxLines: 3,
                  validator: (value) =>
                      value!.trim().isEmpty ? 'Please enter description' : null,
                ),
                SizedBox(height: 20.h),
                _buildHighlightSection(),
                SizedBox(height: 24.h),
                _buildAddOfferButton(),
              ],
            ),
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
            final file = controller.offerImage.value;
            final videoFile = controller.offerVideo.value;

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
                      controller.offerVideo.value = file;
                      controller.offerImage.value = null;
                    } else {
                      controller.offerImage.value = file;
                      controller.offerVideo.value = null;
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

  // Widget _buildProfileImage() {
  //   return Center(
  //     child: Stack(
  //       clipBehavior: Clip.none,
  //       children: [
  //         Container(
  //           width: Get.width * 0.7,
  //           height: Get.height * 0.3,
  //           decoration: BoxDecoration(
  //             border: Border.all(color: lightGrey, width: 0.5.w),
  //             borderRadius: BorderRadius.circular(12.r),
  //           ),
  //           child: Obx(() {
  //             final imageFile = controller.offerImage.value;
  //             final ImageProvider<Object> imageProvider = imageFile != null
  //                 ? FileImage(imageFile)
  //                 : const AssetImage(Images.defaultImage);
  //
  //             return ClipRRect(
  //               borderRadius: BorderRadius.circular(12.r),
  //               child: FadeInImage(
  //                 placeholder: const AssetImage(Images.logo),
  //                 image: imageProvider,
  //                 imageErrorBuilder: (context, error, stackTrace) {
  //                   return Image.asset(
  //                     Images.defaultImage,
  //                     fit: BoxFit.contain,
  //                   );
  //                 },
  //                 fit: BoxFit.cover,
  //                 placeholderFit: BoxFit.contain,
  //                 fadeInDuration: const Duration(milliseconds: 300),
  //               ),
  //             );
  //           }),
  //         ),
  //         Positioned(
  //           bottom: -10,
  //           right: -10,
  //           child: GestureDetector(
  //             onTap: () {
  //               CustomFilePicker.showPickerBottomSheet(
  //                 onFilePicked: (file) {
  //                   controller.offerImage.value = file;
  //                 },
  //               );
  //             },
  //             child: CircleAvatar(
  //               radius: 18.r,
  //               backgroundColor: primaryColor,
  //               child: Icon(Icons.edit, size: 20.sp, color: Colors.white),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildDateField(
    String label,
    TextEditingController dateController,
    bool isStartDate,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextFormField(
          controller: dateController,
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            focusedBorder: buildOutlineInputBorder(),
            enabledBorder: buildOutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            prefixIcon: Icon(
              Icons.calendar_today,
              color: textGrey,
              size: 20.sp,
            ),
            hintText: 'Select date',
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          onTap: () async {
            DateTime now = DateTime.now();

            /// If end date → minimum should be selected start date
            DateTime firstDate = now;
            if (!isStartDate && controller.startDateCtrl.text.isNotEmpty) {
              firstDate = DateTime.parse(controller.startDateCtrl.text);
            }

            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: firstDate,
              firstDate: firstDate,
              lastDate: DateTime(2101),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: primaryColor,
                      onPrimary: Colors.black,
                      onSurface: Colors.black,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              dateController.text = DateFormat('yyyy-MM-dd').format(picked);
            }
          },
        ),
      ],
    );
  }

  Widget _buildHighlightSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Highlight Points'),

        Obx(() {
          if (controller.points.isEmpty) {
            return Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: Text(
                "No highlights added yet.",
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.points.length,
            separatorBuilder: (_, __) => SizedBox(height: 6.h),
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: lightGrey),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        controller.points[index],
                        style: TextStyle(fontSize: 14.sp, color: primaryBlack),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.points.removeAt(index),
                      child: Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                        size: 20.sp,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller.highlightCtrl,
                decoration: InputDecoration(
                  hintText: 'Add highlight point',
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  focusedBorder: buildOutlineInputBorder(),
                  enabledBorder: buildOutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: () {
                if (controller.highlightCtrl.text.trim().isNotEmpty) {
                  controller.points.add(controller.highlightCtrl.text.trim());
                  controller.highlightCtrl.clear();
                }
              },
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.add, color: Colors.white, size: 20.sp),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddOfferButton() {
    return Obx(
      () => controller.isOfferLoading.isTrue
          ? LoadingWidget(color: primaryColor)
          : GestureDetector(
              onTap: () async {
                // 1️⃣ Validate text fields
                if (!controller.offerKey.currentState!.validate()) return;

                // 2️⃣ Validate media
                if (!_isMediaSelected()) {
                  ToastUtils.showWarningToast('Please select image or video');
                  return;
                }

                // 3️⃣ Validate video size
                final video = controller.offerVideo.value;
                if (video != null && !_isVideoSizeValid(video)) {
                  ToastUtils.showWarningToast(
                    'Video size should be less than 20MB',
                  );
                  return;
                }

                // 4️⃣ Submit
                await controller.addNewOffer();
              },

              // onTap: () async {
              //   if (controller.offerKey.currentState!.validate()) {
              //     await controller.addNewOffer();
              //   }
              // },
              child: Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
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
    return controller.offerImage.value != null ||
        controller.offerVideo.value != null;
  }

  bool _isVideoSizeValid(File video) {
    final sizeInMB = video.lengthSync() / (1024 * 1024);
    return sizeInMB <= 20;
  }

  Widget _buildLabel(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.0.w, bottom: 6.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: primaryBlack,
        ),
      ),
    );
  }
}
