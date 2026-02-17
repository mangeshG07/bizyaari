import 'package:businessbuddy/utils/exported_path.dart';

class FeedShimmer extends StatelessWidget {
  const FeedShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Shimmer.fromColors(
        baseColor: lightGrey,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 120.w, height: 12.h, color: Colors.white),
                    SizedBox(height: 6.h),
                    Container(width: 80.w, height: 10.h, color: Colors.white),
                  ],
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Content line
            Container(
              width: double.infinity,
              height: 12.h,
              color: Colors.white,
            ),
            SizedBox(height: 6.h),
            Container(width: 200.w, height: 12.h, color: Colors.white),

            SizedBox(height: 12.h),

            // Image box
            Container(
              width: double.infinity,
              height: 200.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),

            SizedBox(height: 12.h),

            // Like + comment section
            Row(
              children: [
                Container(width: 60.w, height: 18.h, color: Colors.white),
                SizedBox(width: 12.w),
                Container(width: 60.w, height: 18.h, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
