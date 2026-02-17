import 'package:businessbuddy/utils/exported_path.dart';

class BusinessDetailBottomSheet extends StatelessWidget {
  final dynamic data;
  final bool isRequested;
  const BusinessDetailBottomSheet({
    super.key,
    required this.data,
    this.isRequested = false,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          constraints: BoxConstraints(maxHeight: Get.height * 0.75),
          decoration: BoxDecoration(
            color: Get.theme.cardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            children: [
              /// Drag Handle
              SizedBox(height: 12.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 16.h),

              /// Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Business Name
                      CustomText(
                        title: isRequested == true
                            ? data['requirement_name'] ?? ''
                            : data['name'] ?? '',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,maxLines: 10,
                        textAlign: TextAlign.start,
                      ),

                      SizedBox(height: 12.h),
                      Divider(),

                      _detailTile(
                        title: "Business Interest",
                        value: data['category_names']?.join(', ') ?? '',
                      ),

                      _detailTile(
                        title: data['what_you_look_for_id'].toString() == '3'
                            ? "Experience"
                            : "Investment Capacity",
                        value: data['investment_capacity'] ?? '',
                      ),

                      _detailTile(
                        title: "Location",
                        value: data['location'] ?? '',
                      ),

                      if ((data['history'] ?? '').toString().isNotEmpty)
                        _detailTile(title: "History", value: data['history']),

                      if ((data['note'] ?? '').toString().isNotEmpty)
                        _detailTile(title: "Note", value: data['note']),

                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _detailTile({required String title, required String value}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              color: textSmall,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(fontSize: 14.sp, color: inverseColor, height: 1.5),
          ),
        ],
      ),
    );
  }
}
