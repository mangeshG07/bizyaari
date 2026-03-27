import 'exported_path.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class DisclaimerDialog extends StatelessWidget {
  DisclaimerDialog({super.key, required this.data});
  final String data;
  final RxBool isChecked = false.obs;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        constraints: BoxConstraints(maxHeight: Get.height * 0.8),
        backgroundColor: Theme.of(context).cardColor,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedAlert01,
                    color: Colors.red,
                  ),

                  const SizedBox(width: 12),
                  const Text(
                    'Disclaimer',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              /// ✅ Only content scrolls
              Flexible(
                child: SingleChildScrollView(
                  child: HtmlWidget(
                    data,
                    textStyle: TextStyle(fontSize: 14.sp, height: 1.5),
                  ),
                ),
              ),

              /// ✅ Checkbox
              Obx(
                () => Row(
                  children: [
                    Checkbox(
                      activeColor: primaryColor,
                      side: BorderSide(
                        color: Theme.of(context).textTheme.bodyMedium!.color!,
                      ),
                      value: isChecked.value,
                      onChanged: (value) {
                        isChecked.value = value ?? false;
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'I have read and agree to the disclaimer',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => getIt<PartnerDataController>().isDisLoading.value
                    ? LoadingWidget(color: primaryColor)
                    : Obx(
                        () => CustomButton(
                          backgroundColor: primaryColor,
                          width: double.infinity,
                          text: 'I Agree',
                          isLoading:
                              getIt<PartnerDataController>().isDisLoading,
                          onPressed: isChecked.value
                              ? () async {
                                  await getIt<PartnerDataController>()
                                      .acceptDisclaimer(data,context);
                                }
                              : null,
                        ),

                        // Center(
                        //   child: ElevatedButton(
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: primaryColor,
                        //       foregroundColor: Colors.white,
                        //     ),
                        //     onPressed: isChecked.value
                        //         ? () async {
                        //             await getIt<PartnerDataController>()
                        //                 .acceptDisclaimer(data);
                        //           }
                        //         : null, // disables button
                        //     child: const Text('I Agree'),
                        //   ),
                        // ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
