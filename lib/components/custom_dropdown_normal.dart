import '../utils/exported_path.dart';

class AppDropdownField extends StatelessWidget {
  final String? value;
  final List items;
  final String title;
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final bool isExpanded;
  final bool isRequired;
  final String? errorText;
  final bool? isDynamic;
  final bool? isWithColor;

  const AppDropdownField({
    super.key,
    required this.items,
    required this.title,
    required this.hintText,
    this.value,
    this.validator,
    this.onChanged,
    this.isExpanded = true,
    this.isRequired = false,
    this.errorText,
    this.isWithColor = false,
    this.isDynamic = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 6),
          child: buildLabel(title, isRequired: isRequired),
        ),
        ButtonTheme(
          alignedDropdown: true,
          buttonColor: Colors.grey[700],
          splashColor: Colors.transparent,
          materialTapTargetSize: MaterialTapTargetSize.padded,
          child: DropdownButtonFormField(
            borderRadius: BorderRadius.circular(12.r),
            initialValue: value,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 12.h,
              ),
              isDense: true,
              filled: true,
              fillColor: Theme.of(Get.context!).scaffoldBackgroundColor,
              focusedBorder: buildOutlineInputBorder(),
              enabledBorder: buildOutlineInputBorder(),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Colors.red),
              ),
              disabledBorder: buildOutlineInputBorder(),
              border: buildOutlineInputBorder(),
              hintText: hintText,
              errorStyle: TextStyle(fontSize: 12.sp),
              errorMaxLines: 1,
            ),
            validator: validator,
            dropdownColor: lightGrey,
            hint: Text(
              hintText,
              style: TextStyle(fontSize: 14.sp, color: primaryGrey),
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            isExpanded: isExpanded,
            elevation: 4,
            items: isDynamic!
                ? items.map((value) {
                    return DropdownMenuItem(
                      value: value['id'].toString(),
                      child: isWithColor == true
                          ? Row(
                              spacing: 8,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 4,
                                  backgroundColor: Color(
                                    int.parse(value['color_code']),
                                  ),
                                ),
                                CustomText(
                                  textAlign: TextAlign.start,
                                  title: value['name'],
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                ),
                              ],
                            )
                          : CustomText(
                              textAlign: TextAlign.start,
                              title: value['name'],
                              color: primaryBlack,
                              fontSize: 14.sp,
                            ),
                    );
                  }).toList()
                : items.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: CustomText(
                        title: value,
                        fontSize: 14.sp,
                        color: Colors.black,
                      ),
                    );
                  }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

OutlineInputBorder buildOutlineInputBorder() {
  return OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.grey,
      width: 0.2,
    ), // Replace with AppColors.primaryColor
    borderRadius: BorderRadius.circular(10.r),
  );
}
