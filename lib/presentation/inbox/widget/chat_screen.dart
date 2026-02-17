import 'package:businessbuddy/utils/exported_path.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final navController = getIt<NavigationController>();
  final controller = getIt<InboxController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      /// 🔹 Initial Loading (Shimmer)
      if (controller.isChatLoading.isTrue) {
        return const ChatListShimmer();
      }

      /// 🔹 Empty State
      if (controller.allChats.isEmpty) {
        return _buildEmptyState();
      }

      /// 🔹 Feeds + Pagination
      return NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll is ScrollEndNotification &&
              scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 50 &&
              controller.hasMore &&
              !controller.isLoadMore.value &&
              !controller.isChatLoading.value) {
            controller.getAllChat(showLoading: false);
          }
          return false;
        },
        child: _buildChatList(),
      );
    });

    //   Obx(
    //   () => controller.isChatLoading.isTrue
    //       ? const ChatListShimmer()
    //       : controller.allChats.isEmpty
    //       ? _buildEmptyState()
    //       : _buildChatList(),
    //
    //   // ? SingleChildScrollView(
    //   //     child: Column(
    //   //       children: [
    //   //         SizedBox(
    //   //           height: Get.height * 0.25,
    //   //         ), // ✅ Push content to center
    //   //         commonNoDataFound(),
    //   //       ],
    //   //     ),
    //   //   )
    //   // : AnimationLimiter(
    //   //     child: ListView.separated(
    //   //       physics: const AlwaysScrollableScrollPhysics(),
    //   //       padding: EdgeInsets.zero,
    //   //       separatorBuilder: (context, index) =>
    //   //           Divider(height: 5, color: lightGrey),
    //   //       itemCount: controller.allChats.length,
    //   //       itemBuilder: (context, index) {
    //   //         final chat = controller.allChats[index];
    //   //         return AnimationConfiguration.staggeredList(
    //   //           position: index,
    //   //           duration: const Duration(milliseconds: 375),
    //   //           child: SlideAnimation(
    //   //             verticalOffset: 50.0,
    //   //             child: FadeInAnimation(child: _chatTile(chat)),
    //   //           ),
    //   //         );
    //   //       },
    //   //     ),
    //   //   ),
    // );
  }

  Widget _buildEmptyState() {
    return CustomScrollView(
      physics: NeverScrollableScrollPhysics(),
      slivers: [SliverFillRemaining(child: commonNoDataFound())],
    );
  }

  Widget _buildChatList() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.zero,
          sliver: SliverList.separated(
            itemCount: controller.allChats.length,
            itemBuilder: (BuildContext context, int index) {
              final chat = controller.allChats[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(child: _chatTile(chat)),
                ),
              );
            },
            separatorBuilder: (_, _) => Divider(color: lightGrey, height: 1),
          ),
        ),
        Obx(
          () => controller.isLoadMore.value
              ? SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  sliver: SliverToBoxAdapter(
                    child: LoadingWidget(color: primaryColor),
                  ),
                )
              : SliverToBoxAdapter(child: const SizedBox()),
        ),
      ],
    );
  }

  Widget _chatTile(chat) {
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        child: ClipOval(
          child: CachedNetworkImage(
            width: 44,
            height: 44,
            fit: BoxFit.cover,
            imageUrl: chat['chat_type'] == 'user_to_user'
                ? (chat['other_user_profile_image'] ?? '')
                : chat['self_business_requirement'] == true
                ? (chat['user_profile_image'] ?? '')
                : (chat['business_requirement_user_profile_image'] ?? ''),
            placeholder: (_, __) => Image.asset(Images.defaultImage),
            errorWidget: (_, __, ___) => Image.asset(Images.defaultImage),
          ),
        ),
      ),
      title: CustomText(
        title: chat['chat_type'] == 'user_to_user'
            ? chat['other_user_name'] ?? ''
            : chat['business_requirement_name'] ?? '',
        fontSize: 14.sp,
        textAlign: TextAlign.start,
        fontWeight: FontWeight.bold,
        color: primaryBlack,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          chat['chat_type'] == 'user_to_user'
              ? CustomText(
                  title: chat['latest_message'] == null
                      ? 'No messages yet'
                      : chat['latest_message'] ?? '',
                  fontSize: 12.sp,
                  textAlign: TextAlign.start,
                  color: primaryBlack,
                  // maxLines: 1,
                )
              : CustomText(
                  title: chat['self_business_requirement'] == true
                      ? chat['user_name'] ?? ''
                      : chat['business_requirement_user_name'] ?? '',
                  fontSize: 12.sp,
                  textAlign: TextAlign.start,
                  color: primaryBlack,
                  // maxLines: 1,
                ),
          if (chat['is_blocked'] == true)
            CustomText(
              title: chat['blocked_by_me'] == false
                  ? 'You have been blocked by user'
                  : 'You Blocked this user',
              fontSize: 14.sp,
              textAlign: TextAlign.start,
              color: primaryColor,
            ),
        ],
      ),
      onTap: () {
        if (chat['is_blocked'] != true) {
          navController.openSubPage(
            SingleChat(
              chatId: chat['business_requirement_chat_id']?.toString() ?? '',
            ),
          );
        }
      },
    );
  }
}

class ChatListShimmer extends StatelessWidget {
  const ChatListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: 8,
      separatorBuilder: (_, __) => Divider(height: 5, color: lightGrey),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
          child: Row(
            children: [
              Shimmer.fromColors(
                baseColor: lightGrey,
                highlightColor: Colors.grey.shade100,
                child: CircleAvatar(radius: 24.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: lightGrey,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 14.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Shimmer.fromColors(
                      baseColor: lightGrey,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 12.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
