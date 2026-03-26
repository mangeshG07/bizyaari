import 'package:businessbuddy/utils/exported_path.dart';

class AlertBottomsheet extends StatelessWidget {
  final dynamic data;
  const AlertBottomsheet({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 32.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle for better UX
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 20.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Header with icon and close button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  // color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Image.asset(Images.alertIcon, height: 40.h, width: 40.w),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: 22.sp,
                  color: Colors.grey.shade400,
                ),
                onPressed: () => Get.back(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Main caution title
          CustomText(
            title: data['heading1'] ?? '',
            fontSize: 24.sp,
            maxLines: 3,
            color: textGrey,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.start,
          ),

          SizedBox(height: 24.h),

          // Section header
          Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              title: data['heading2'] ?? '',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.start,
              color: primaryColor,
            ),
          ),

          SizedBox(height: 12.h),

          // Bullet points container with background
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color:  lightGrey,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: data['points'].map<Widget>((v) {
                return _buildBulletPoint(text: v, icon: Icons.check);
              }).toList(),

              // [
              //   _buildBulletPoint(
              //     text: 'Meet, Evaluate, & then Decide',
              //     icon: Icons.people_outline,
              //   ),
              //   SizedBox(height: 12.h),
              //   _buildBulletPoint(
              //     text: 'Verify your potential Business Partner',
              //     icon: Icons.verified_outlined,
              //   ),
              //   SizedBox(height: 12.h),
              //   _buildBulletPoint(
              //     text: 'Do a background check before committing',
              //     icon: Icons.shield_outlined,
              //   ),
              // ],
            ),
          ),

          SizedBox(height: 16.h),

          // Action button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: CustomText(
                title: 'Okay Understood',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildBulletPoint({required String text, IconData? icon}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Icon bullet point
      Container(
        margin: EdgeInsets.only(top: 2.h),
        child: icon != null
            ? Icon(icon, size: 18.sp, color: primaryColor)
            : Container(
                margin: EdgeInsets.only(right: 8.w),
                width: 6.r,
                height: 6.r,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
      ),
      SizedBox(width: 12.w),

      // Text
      Expanded(
        child: CustomText(
          title: text,
          maxLines: 4,
          fontSize: 14.sp,
          color: textLightGrey,
          textAlign: TextAlign.start,
        ),
      ),
    ],
  );
}
