import 'dart:io';
import 'package:businessbuddy/utils/exported_path.dart';
import 'package:file_picker/file_picker.dart';

class CustomFilePicker {
  static Future<File?> pickCamera() async {
    final XFile? photo = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    return photo != null ? File(photo.path) : null;
  }

  static Future<File?> pickGallery() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    return image != null ? File(image.path) : null;
  }

  static Future<File?> pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  static Future<File?> pickVideoFromCamera() async {
    final XFile? video = await ImagePicker().pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(seconds: 15), // 🎯 Camera level limit
    );
    return video != null ? File(video.path) : null;
  }

  static Future<File?> pickVideoFromGallery() async {
    final XFile? video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    if (video == null) return null;

    return await _validateVideoDuration(File(video.path));
  }

  static Future<List<File>?> pickDocumentMulti({
    bool allowMultiple = false,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
      type: FileType.image, // ✅ only images
    );

    if (result != null) {
      return result.paths
          .whereType<String>()
          .map((path) => File(path))
          .toList();
    }
    return null;
  }

  static Future<void> showPickerBottomSheet({
    required Function(File file) onFilePicked,
    Function(List<File> files)? onFileMultiPicked,
    bool showVideo = false,
    bool allowMultipleDocuments = false,
  }) async {
    Get.bottomSheet(
      backgroundColor: Theme.of(Get.context!).scaffoldBackgroundColor,
      SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _item(HugeIcons.strokeRoundedCamera02, 'Camera Image', () async {
                Get.back();
                File? file = await pickCamera();
                if (file != null) onFilePicked(file);
              }),
              _divider(),
              _item(HugeIcons.strokeRoundedImage02, 'Gallery Image', () async {
                Get.back();
                File? file = await pickGallery();
                if (file != null) onFilePicked(file);
              }),

              if (showVideo) _divider(),
              if (showVideo)
                _item(HugeIcons.strokeRoundedVideo02, 'Camera Video', () async {
                  Get.back();
                  final file = await pickVideoFromCamera();
                  if (file != null) onFilePicked(file);
                }),
              if (showVideo) _divider(),
              if (showVideo)
                _item(
                  HugeIcons.strokeRoundedVideo02,
                  'Gallery Video',
                  () async {
                    Get.back();
                    final file = await pickVideoFromGallery();
                    if (file != null) onFilePicked(file);
                  },
                ),
              if (allowMultipleDocuments) _divider(),
              if (allowMultipleDocuments)
                _item(HugeIcons.strokeRoundedAlbum02, 'Multi Images', () async {
                  List<File>? files = await pickDocumentMulti(
                    allowMultiple: allowMultipleDocuments,
                  );
                  if (files != null && files.isNotEmpty) {
                    onFileMultiPicked!(files);
                  }
                }),
              // ListTile(
              //   leading: HugeIcon(icon: HugeIcons.strokeRoundedCamera02),
              //   title: CustomText(
              //     title: 'Camera',
              //     textAlign: TextAlign.start,
              //     fontSize: 14.sp,
              //   ),
              //   onTap: () async {
              //     Get.back();
              //     File? file = await pickCamera();
              //     if (file != null) onFilePicked(file);
              //   },
              // ),
              // Divider(height: 5, thickness: 0.5),
              // ListTile(
              //   leading: HugeIcon(icon: HugeIcons.strokeRoundedImage02),
              //   title: CustomText(
              //     title: 'Gallery',
              //     textAlign: TextAlign.start,
              //     fontSize: 14.sp,
              //   ),
              //   onTap: () async {
              //     Get.back();
              //     File? file = await pickGallery();
              //     if (file != null) onFilePicked(file);
              //   },
              // ),
              // Divider(height: 5, thickness: 0.5),

              /// Video Camera
              // ListTile(
              //   leading: HugeIcon(icon: HugeIcons.strokeRoundedVideo02),
              //   title: CustomText(
              //     title: 'Video (Camera)',
              //     textAlign: TextAlign.start,
              //     fontSize: 14.sp,
              //   ),
              //   onTap: () async {
              //     Get.back();
              //     final file = await pickVideoFromCamera();
              //     if (file != null) onFilePicked(file);
              //   },
              // ),

              // const Divider(),

              /// Video Gallery
              // ListTile(
              //   leading: HugeIcon(icon: HugeIcons.strokeRoundedVideo01),
              //   title: CustomText(
              //     title: 'Video (Gallery)',
              //     fontSize: 14.sp,
              //     textAlign: TextAlign.start,
              //   ),
              //   onTap: () async {
              //     Get.back();
              //     final file = await pickVideoFromGallery();
              //     if (file != null) onFilePicked(file);
              //   },
              // ),
              // ListTile(
              //   leading: HugeIcon(
              //     icon: HugeIcons.strokeRoundedDocumentValidation,
              //   ),
              //   title: CustomText(
              //     title: 'Document',
              //     textAlign: TextAlign.start,
              //     fontSize: 14.sp,
              //   ),
              //   onTap: () async {
              //     Get.back();
              //     File? file = await pickDocument();
              //     if (file != null) onFilePicked(file);
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _item(dynamic icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: HugeIcon(icon: icon),
      title: CustomText(
        title: title,
        fontSize: 14.sp,
        textAlign: TextAlign.start,
        color: primaryBlack,
      ),
      onTap: onTap,
    );
  }

  static Widget _divider() {
    return Divider(height: 5, thickness: 0.5);
  }

  static Future<File?> _validateVideoDuration(File file) async {
    final controller = VideoPlayerController.file(file);

    await controller.initialize();
    final duration = controller.value.duration;
    await controller.dispose();

    if (duration.inSeconds > 15) {
      ToastUtils.showWarningToast('Video must be 15 seconds or less');
      return null;
    }

    return file;
  }
}
