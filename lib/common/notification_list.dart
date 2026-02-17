import '../utils/exported_path.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  final controller = getIt<NotificationController>();

  @override
  void initState() {
    controller.getNotificationInitial(isRefresh: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppbarPlain(title: "Notifications"),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return _buildShimmerLoader();
        }

        if (controller.notificationData.isEmpty) {
          return _buildEmptyState();
        }
        return NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification &&
                scrollNotification.metrics.pixels ==
                    scrollNotification.metrics.maxScrollExtent) {
              controller.getNotificationLoadMore();
            }
            return true;
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                spacing: 10,
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.notificationData.length,
                    itemBuilder: (context, index) {
                      final notification = controller.notificationData[index];
                      return NotificationTile(
                        notification: notification,
                        onTap: () async {
                          final action = notification['action'];
                          final data = notification['data'] ?? {};

                          /// 🔹 Close notification panel / bottom sheet if open
                          if (Get.isOverlaysOpen) {
                            Get.back();
                          }
                          if (notification['title'] == 'Request Accepted') {
                            Get.back();
                            getIt<NavigationController>().updateBottomIndex(2);
                            return;
                          }
                          if (notification['type'] == 'business_follow') {
                            Get.toNamed(
                              Routes.profile,
                              arguments: {
                                'is_search': false,
                                'user_id':
                                    data['follower_id']?.toString() ?? '',
                              },
                            );
                          }
                          if (notification['type'] == 'chat_message') {
                            _openChat(data);
                          }
                          switch (action) {
                            case 'message':
                              _openChat(data);
                              break;

                            case 'post':
                              _openPost(data);
                              break;

                            case 'offer':
                              _openOffer(data);
                              break;

                            default:
                              debugPrint(
                                'Unknown notification action: $action',
                              );
                          }

                          /// 🔹 Mark notification as read
                          await controller.readNotification(
                            notification['id'].toString(),
                          );
                        },

                        // onTap: () async {
                        //   if (notification['data']['action'] == 'message') {
                        //     Get.back();
                        //     getIt<NavigationController>().openSubPage(
                        //       SingleChat(
                        //         chatId:
                        //             notification['data']['chat_id']
                        //                 ?.toString() ??
                        //             '',
                        //       ),
                        //     );
                        //   }
                        //   await controller.readNotification(
                        //     notification['id'].toString(),
                        //   );
                        //   // Get.toNamed(
                        //   //   Routes.newsDetails,
                        //   //   arguments: {
                        //   //     'newsId': notification['news_id'].toString(),
                        //   //   },
                        //   // );
                        // },
                      );
                    },
                  ),
                  controller.notificationData.isEmpty
                      ? const SizedBox()
                      : buildLoader(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void _openChat(Map data) {
    final chatId = data['chat_id']?.toString();
    if (chatId == null || chatId.isEmpty) return;

    Get.back();
    getIt<NavigationController>().openSubPage(SingleChat(chatId: chatId));
  }

  void _openPost(Map data) {
    final postId = data['post_id']?.toString();
    if (postId == null || postId.isEmpty) return;

    Get.to(
      () => InstagramPostView(
        isFrom: '',
        refresh: () {},
        followButton: const SizedBox(),
        postId: postId,
      ),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _openOffer(Map data) {
    final offerId = data['offer_id']?.toString();
    if (offerId == null || offerId.isEmpty) return;

    Get.to(
      () => InstagramOfferView(
        isFrom: '',
        refresh: () async {},
        followButton: const SizedBox(),
        offerId: offerId,
      ),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget buildLoader() {
    if (controller.isMoreLoading.value) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: LoadingWidget(color: primaryColor),
      );
    } else if (!controller.hasNextPage.value) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: Text('No more data')),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(Images.noNotification, width: Get.width * 0.35.w),
          SizedBox(height: 16.sp),
          CustomText(
            title: 'No Notifications!',
            textAlign: TextAlign.center,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: primaryBlack,
            style: TextStyle(),
          ),
          SizedBox(height: 8.sp),
          CustomText(
            title: 'You don\'t have any notifications yet.',
            textAlign: TextAlign.center,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: primaryBlack,
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: lightGrey,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          height: Get.height * 0.1,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final dynamic notification;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRead = notification['is_read'].toString() == '1';
    return Card(
      surfaceTintColor: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: isRead ? Get.theme.cardColor : lightRed,
      child: ListTile(
        title: CustomText(
          title: notification['title'] ?? '',
          fontSize: 14.sp,
          textAlign: TextAlign.start,
          maxLines: 2,
          color: isRead ? primaryBlack : Colors.black,
          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              title: notification['message'] ?? '',
              fontSize: 12.sp,
              color: Colors.grey,
              textAlign: TextAlign.start,
              maxLines: 2,
            ),
            SizedBox(height: 4),
            Text(
              notification['created_at'] ?? '',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: isRead
            ? null
            : Icon(Icons.circle, color: primaryColor, size: 12),
        onTap: onTap,
      ),
    );
  }
}
