import 'package:businessbuddy/utils/exported_path.dart';

class BusinessCardShimmer extends StatelessWidget {
  const BusinessCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: lightGrey,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Shimmer.fromColors(
        baseColor: lightGrey,
        highlightColor: Colors.grey.shade100,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // LEFT SECTION
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    spacing: 12.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerBox(width: double.infinity, height: 18.h),
                      _shimmerBox(width: double.infinity, height: 1.h),

                      _shimmerBox(width: 150.w, height: 14.h),
                      _shimmerBox(width: 120.w, height: 14.h),
                      _shimmerBox(width: 180.w, height: 14.h),
                    ],
                  ),
                ),
              ),

              VerticalDivider(color: Colors.grey.shade300, thickness: 1),

              // RIGHT SECTION
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _shimmerCircle(40.r),
                      SizedBox(height: 8.h),
                      _shimmerBox(width: 50.w, height: 12.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmerBox({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
    );
  }

  Widget _shimmerCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}
