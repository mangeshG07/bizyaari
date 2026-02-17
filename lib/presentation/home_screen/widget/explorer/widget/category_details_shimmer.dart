import 'package:businessbuddy/utils/exported_path.dart';

class CategoryDetailShimmer extends StatelessWidget {
  const CategoryDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerBox(height: 180.h, radius: 16), // Main Image
          SizedBox(height: 12.h),

          // Gallery
          SizedBox(
            height: 60.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (_, __) =>
                  _shimmerBox(width: 64.w, height: 64.h, radius: 12),
            ),
          ),

          SizedBox(height: 18.h),

          _shimmerBox(height: 18.h, width: 180.w),
          SizedBox(height: 8.h),
          _shimmerBox(height: 14.h, width: 120.w),
          SizedBox(height: 8.h),
          _shimmerBox(height: 14.h, width: 200.w),

          SizedBox(height: 16.h),

          // Buttons
          Row(
            children: [
              Expanded(child: _shimmerBox(height: 42.h, radius: 10)),
              SizedBox(width: 12.w),
              Expanded(child: _shimmerBox(height: 42.h, radius: 10)),
            ],
          ),

          SizedBox(height: 24.h),

          _shimmerBox(height: 16.h, width: 100.w),
          SizedBox(height: 10.h),
          _shimmerBox(height: 12.h),
          SizedBox(height: 6.h),
          _shimmerBox(height: 12.h),
          SizedBox(height: 6.h),
          _shimmerBox(height: 12.h, width: 240.w),

          SizedBox(height: 24.h),

          // Tabs
          Row(
            children: [
              Expanded(child: _shimmerBox(height: 36.h)),
              SizedBox(width: 12.w),
              Expanded(child: _shimmerBox(height: 36.h)),
            ],
          ),

          SizedBox(height: 16.h),

          // Grid shimmer
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.w,
            ),
            itemBuilder: (_, __) => _shimmerBox(height: 140.h),
          ),

          SizedBox(height: 24.h),

          _shimmerBox(height: 16.h, width: 140.w),

          SizedBox(height: 16.h),

          // Reviews
          ...List.generate(2, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Row(
                children: [
                  _shimmerCircle(44),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerBox(height: 14.h, width: 120.w),
                        SizedBox(height: 6.h),
                        _shimmerBox(height: 12.h),
                        SizedBox(height: 6.h),
                        _shimmerBox(height: 12.h, width: 200.w),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _shimmerBox({double height = 12, double? width, double radius = 8}) {
    return Shimmer.fromColors(
      baseColor: lightGrey,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius.r),
        ),
      ),
    );
  }

  Widget _shimmerCircle(double size) {
    return Shimmer.fromColors(
      baseColor: lightGrey,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: size.w,
        height: size.w,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }
}
