import '../utils/exported_path.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class PolicyData extends StatefulWidget {
  final String slug;

  const PolicyData({super.key, required this.slug});

  @override
  State<PolicyData> createState() => _PolicyDataState();
}

class _PolicyDataState extends State<PolicyData> {
  final controller = getIt<ProfileController>();

  @override
  void initState() {
    controller.legalPageDetailsApi(widget.slug);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.detailsLoading.isTrue
          ? Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: LoadingWidget(color: primaryColor),
            )
          : Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppbarPlain(
                title: controller.legalPageDetails['name'] ?? '',
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: HtmlWidget(
                  controller.legalPageDetails['description'] ?? '-',
                  textStyle: TextStyle(fontSize: 14.sp, height: 1.6),
                ),
              ),

              // WebViewWidget(controller: _controller),
            ),
    );
  }
}
