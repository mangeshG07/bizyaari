import 'package:businessbuddy/utils/exported_path.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final String image;
  const CategoryCard({super.key, required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: Get.height * 0.08,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
          child: FadeInImage(
            placeholder: AssetImage(Images.defaultImage),
            image: NetworkImage(image),
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.asset(Images.defaultImage, fit: BoxFit.contain);
            },
            fit: BoxFit.contain,
            fadeInDuration: const Duration(milliseconds: 300),
          ),
        ),
        CustomText(
          title: name,
          fontSize: 14.sp,
          maxLines: 2,
          color: inverseColor,
          style: TextStyle(height: 1),
        ),
      ],
    );
  }
}
