import 'dart:io';
import 'package:businessbuddy/utils/exported_path.dart';
import 'package:flutter/cupertino.dart';

class ReviewDialog extends StatefulWidget {
  final String productName;
  final String imageUrl;
  final Function(double, String)? onSubmit;

  const ReviewDialog({
    super.key,
    required this.productName,
    required this.imageUrl,
    this.onSubmit,
  });

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  final controller = getIt<ExplorerController>();

  @override
  void initState() {
    controller.rating.value = 0;
    controller.isSubmitting.value = false;
    controller.reviewController.clear();
    super.initState();
  }

  void _submitReview() {
    if (controller.rating.value == 0) {
      _showRatingRequiredDialog();
      return;
    }

    // Call the onSubmit callback if provided
    widget.onSubmit?.call(
      controller.rating.value,
      controller.reviewController.text.trim(),
    );
  }

  void _showRatingRequiredDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Rating Required'),
          content: const Text('Please select a rating before submitting.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } else {
      Get.dialog(
        AlertDialog(
          surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
          backgroundColor: Get.theme.cardColor,
          title: const Text('Rating Required'),
          content: const Text('Please select a rating before submitting.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildProductHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Image
        Container(
          margin: const EdgeInsets.only(right: 12),
          height: 60.h,
          width: 60.w,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: FadeInImage(
              image: NetworkImage(widget.imageUrl),
              placeholder: const NetworkImage(Images.defaultImage),
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.network(Images.defaultImage, fit: BoxFit.cover);
              },
              fit: BoxFit.cover,
              placeholderFit: BoxFit.contain,
            ),
          ),
        ),

        // Product Name and Info
        Expanded(
          child: CustomText(
            title: widget.productName,
            color: primaryBlack,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            maxLines: 2,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: 'How would you rate this product?',
          fontSize: 14.sp,
          textAlign: TextAlign.start,
          color: primaryBlack,
        ),
        const SizedBox(height: 8),
        Obx(
          () => Center(
            child: RatingBar.builder(
              itemSize: 32,
              initialRating: controller.rating.value,
              minRating: 1,
              direction: Axis.horizontal,
              itemCount: 5,
              unratedColor: lightGrey,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, _) =>
                  const Icon(Icons.star_rounded, color: Colors.amber),
              onRatingUpdate: (rating) {
                controller.rating.value = rating;
              },
            ),
          ),
        ),
        const SizedBox(height: 8),

        Obx(() {
          if (controller.rating.value > 0) {
            return Center(
              child: Text(
                controller.rating.value == 1
                    ? 'Poor'
                    : controller.rating.value == 2
                    ? 'Fair'
                    : controller.rating.value == 3
                    ? 'Good'
                    : controller.rating.value == 4
                    ? 'Very Good'
                    : 'Excellent',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          /// ⭐ must return something
          return SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildReviewInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Share your experience (optional)',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            style: TextStyle(fontSize: 14.sp),
            controller: controller.reviewController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Tell us about your experience with this product...',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12),
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                surfaceTintColor: Colors.white,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: controller.isSubmitting.value
                  ? null
                  : () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: controller.isSubmitting.value ? null : _submitReview,
              style: ElevatedButton.styleFrom(
                surfaceTintColor: Colors.white,
                padding: EdgeInsets.zero,
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: controller.isSubmitting.value
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Submit Review',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Platform.isIOS;

    if (isIOS) {
      return CupertinoAlertDialog(
        title: const Text('Write a Review'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            _buildProductHeader(),
            const SizedBox(height: 20),
            _buildRatingSection(),
            const SizedBox(height: 20),
            _buildReviewInput(),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: controller.isSubmitting.value
                ? null
                : () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            onPressed: controller.isSubmitting.value ? null : _submitReview,
            child: controller.isSubmitting.value
                ? const CupertinoActivityIndicator()
                : const Text('Submit'),
          ),
        ],
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 20.h,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.reviews_outlined, color: primaryColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Write a Review',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),

            // Product Header
            _buildProductHeader(),

            // Rating Section
            _buildRatingSection(),

            // Review Input
            _buildReviewInput(),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }
}
