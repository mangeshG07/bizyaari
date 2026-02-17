import 'package:businessbuddy/utils/exported_path.dart';

class CatItemCardShimmer extends StatelessWidget {
  const CatItemCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: lightGrey,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // IMAGE shimmer
              ShimmerBox(width: 80.w, height: 80.h, radius: 12.r),
              SizedBox(width: 8.w),

              // Right side section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(width: double.infinity, height: 16.h),
                    SizedBox(height: 6.h),
                    ShimmerBox(width: 120.w, height: 14.h),
                    SizedBox(height: 6.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerBox(width: 100.w, height: 14.h),
                        ShimmerBox(width: 24.w, height: 24.h, radius: 6.r),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Buttons shimmer row
          Row(
            children: [
              Expanded(
                child: ShimmerBox(height: 36.h, radius: 8.r),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: ShimmerBox(height: 36.h, radius: 8.r),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: ShimmerBox(height: 36.h, radius: 8.r),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const ShimmerBox({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.radius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: lightGrey,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: lightGrey,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
