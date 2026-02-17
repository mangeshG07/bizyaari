import 'package:businessbuddy/utils/exported_path.dart';

class OfferDetailShimmer extends StatelessWidget {
  const OfferDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerShimmer(),
          _mediaShimmer(context),
          _detailsShimmer(),
          _highlightsShimmer(),
          _dateShimmer(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _shimmerBox({
    double height = 12,
    double width = double.infinity,
    BorderRadius? radius,
  }) {
    return Shimmer.fromColors(
      baseColor: lightGrey,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _headerShimmer() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _shimmerBox(
            height: 40,
            width: 40,
            radius: BorderRadius.circular(20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(height: 14, width: 160),
                const SizedBox(height: 6),
                _shimmerBox(height: 10, width: 120),
              ],
            ),
          ),
          _shimmerBox(height: 28, width: 70, radius: BorderRadius.circular(6)),
        ],
      ),
    );
  }

  // ---------------- MEDIA ----------------
  Widget _mediaShimmer(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: double.infinity,
      color: Colors.white,
      child: Shimmer.fromColors(
        baseColor: lightGrey,
        highlightColor: Colors.grey.shade100,
        child: Container(color: Colors.grey),
      ),
    );
  }

  // ---------------- DETAILS ----------------
  Widget _detailsShimmer() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerBox(height: 16, width: 220),
          const SizedBox(height: 8),
          _shimmerBox(height: 12),
          const SizedBox(height: 6),
          _shimmerBox(height: 12, width: 260),
        ],
      ),
    );
  }

  // ---------------- HIGHLIGHTS ----------------
  Widget _highlightsShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerBox(height: 14, width: 120),
          const SizedBox(height: 8),
          ...List.generate(
            3,
                (_) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _shimmerBox(height: 10),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- DATE ----------------
  Widget _dateShimmer() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: _shimmerBox(
        height: 60,
        radius: BorderRadius.circular(12),
      ),
    );
  }
}
