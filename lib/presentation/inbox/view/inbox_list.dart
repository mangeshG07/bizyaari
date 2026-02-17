import 'package:businessbuddy/utils/exported_path.dart';

class InboxList extends StatefulWidget {
  const InboxList({super.key});

  @override
  State<InboxList> createState() => _InboxListState();
}

class _InboxListState extends State<InboxList> {
  final controller = getIt<InboxController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
      controller.getAllChat(isRefresh: true);
      controller.getReceiveBusinessRequest(isRefresh: true);
      getIt<PartnerDataController>().getRequestedBusiness(isRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: lightGrey, width: 0.5),
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- Tab Bar ---
                  TabBar(
                    indicatorColor: primaryColor,
                    labelColor: primaryColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    tabs: [
                      Tab(text: 'Chat', height: 35),
                      Tab(text: 'Request', height: 35),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Use CustomScrollView for ChatScreen
                ChatScreen(),
                RequestedScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
