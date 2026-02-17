import '../utils/exported_path.dart';

class CustomCarouselSlider extends StatelessWidget {
  final List imageList;
  final double radius;
  final EdgeInsetsGeometry? margin;
  final double height;

  CustomCarouselSlider({
    super.key,
    required this.imageList,
    required this.radius,
    required this.margin,
    required this.height,
  });

  final ValueNotifier<int> _selectedSlider = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: Get.height * height,
            viewportFraction: 1,
            autoPlay: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.2,
            autoPlayInterval: const Duration(seconds: 3),
            onPageChanged: (int page, _) {
              _selectedSlider.value = page;
            },
          ),
          items: imageList.map((imagePath) {
            return Container(
              margin:
                  margin ?? EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: CachedNetworkImage(
                  imageUrl: imagePath['image'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) =>
                      Image.asset(Images.defaultSlider),
                  errorWidget: (context, url, error) =>
                      Image.asset(Images.defaultSlider),
                ),

                // Image.network(
                //   imagePath['image'],
                //   fit: BoxFit.cover,
                //   width: double.infinity,
                // ),
              ),
            );
          }).toList(),
        ),

        Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: ValueListenableBuilder<int>(
            valueListenable: _selectedSlider,
            builder: (context, value, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(imageList.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: value == index ? 10 : 8,
                    height: value == index ? 10 : 8,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: value == index ? primaryColor : Colors.grey,
                    ),
                  );
                }),
              );
            },
          ),
        ),

        // Positioned(
        //   bottom: 18,
        //   right: 0,
        //   left: 0,
        //   child: ValueListenableBuilder(
        //     valueListenable: _selectedSlider,
        //     builder: (context, value, _) {
        //       List<Widget> list = [];
        //       for (int i = 0; i < imageList.length; i++) {
        //         list.add(
        //           Container(
        //             width: 8,
        //             height: 8,
        //             margin: const EdgeInsets.symmetric(horizontal: 4),
        //             decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(10),
        //               color:
        //                   value == i ? AppColors.buttonColor : AppColors.grey,
        //             ),
        //           ),
        //         );
        //       }
        //       return Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: list,
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}
