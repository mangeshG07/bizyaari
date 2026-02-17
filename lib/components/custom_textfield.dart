import '../utils/exported_path.dart';

/// TextField
Widget buildTextField({
  required TextEditingController controller,
  required String? Function(String?) validator,
  required String hintText,
  Widget? prefixIcon,
  Widget? suffixIcon,
  bool? obscureText = false,
  bool? enabled = true,
  int? maxLines = 1,
  Color? fillColor = Colors.white,
  TextInputType? keyboardType = TextInputType.text,
  List<TextInputFormatter>? inputFormatters,
}) {
  return TextFormField(
    enabled: enabled,
    maxLines: maxLines,
    style: TextStyle(fontSize: 14.sp, color: primaryBlack),
    controller: controller,
    keyboardType: keyboardType,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: validator,
    obscureText: obscureText!,
    inputFormatters: inputFormatters,
    cursorColor: Theme.of(Get.context!).textTheme.titleSmall!.color,
    decoration: inputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      fillColor: fillColor,
    ),
  );
}

/// InputDecoration Helper
InputDecoration inputDecoration({
  required String hintText,
  Widget? suffixIcon,
  Widget? prefixIcon,
  Color? fillColor,
}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.all(15),
    filled: true,
    // fillColor: Theme.of(Get.context!).appBarTheme.backgroundColor,
    fillColor: fillColor,
    labelText: hintText,
    labelStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
    border: borderStyle(),
    enabledBorder: borderStyle(),
    focusedBorder: borderStyle(),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: const BorderSide(color: Colors.red),
    ),
    suffixIcon: suffixIcon,
    prefixIcon: prefixIcon,
  );
}

/// Label
///
Widget buildLabel(
  String text, {
  bool isRequired = false,
  Color color = Colors.black,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6.0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: textGrey,
          ),
          children: isRequired
              ? [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
                ]
              : [],
        ),
      ),
    ),
  );
}

// Widget buildLabel(String text) {
//   return Align(
//     alignment: Alignment.centerLeft,
//     child: Row(
//       children: [
//         CustomText(
//           title: text,
//           fontSize: 14.sp,
//           color: Colors.black,
//           fontWeight: FontWeight.bold,
//         ),
//         CustomText(title: " * ", fontSize: 14.sp, color: Colors.red),
//       ],
//     ),
//   );
// }

OutlineInputBorder borderStyle() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.r),
    borderSide: const BorderSide(color: Colors.grey, width: 0.2),
  );
}
