import 'package:businessbuddy/utils/exported_path.dart';

class SingleChat extends StatefulWidget {
  const SingleChat({super.key, required this.chatId});
  final String chatId;
  @override
  State<SingleChat> createState() => _SingleChatState();
}

class _SingleChatState extends State<SingleChat> {
  final navController = getIt<NavigationController>();
  final controller = getIt<InboxController>();

  @override
  void initState() {
    controller.getSingleChat(widget.chatId, isRefresh: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(
        () => controller.isSingleLoading.isTrue
            ? LoadingWidget(color: primaryColor)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Local back + title
                  _buildHeader(),
                  Divider(color: lightGrey),
                  // Chat messages
                  _buildAllChat(),

                  // Text field at bottom
                  _buildTextField(),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        spacing: 8.w,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ✅ BACK BUTTON CENTERED
          InkWell(
            onTap: () => navController.goBack(),
            borderRadius: BorderRadius.circular(50),
            child: Padding(
              padding: EdgeInsets.all(6.w),
              child: Icon(Icons.arrow_back, size: 22.sp),
            ),
          ),

          // ✅ PROFILE TILE CENTERED
          Expanded(
            child: GestureDetector(
              onTap: () => Get.toNamed(
                Routes.profile,
                arguments: {
                  'is_search': false,
                  'user_id':
                      controller.singleChat['other_user_id']?.toString() ?? '',
                },
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center, // ✅ IMPORTANT
                children: [
                  // ✅ PROFILE IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100.r),
                    child: FadeInImage(
                      placeholder: const AssetImage(Images.defaultImage),
                      image:
                          (controller.singleChat['other_user_profile'] ?? '')
                              .toString()
                              .isNotEmpty
                          ? NetworkImage(
                              controller.singleChat['other_user_profile'],
                            )
                          : const AssetImage(Images.defaultImage)
                                as ImageProvider,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          Images.defaultImage,
                          fit: BoxFit.cover,
                          width: 36.w,
                          height: 36.h,
                        );
                      },
                      fit: BoxFit.cover,
                      width: 36.w,
                      height: 36.h,
                      fadeInDuration: const Duration(milliseconds: 300),
                    ),
                  ),

                  SizedBox(width: 10.w),

                  // ✅ NAME + SUBTITLE CENTERED
                  Expanded(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // ✅ VERTICAL CENTER
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          title: controller.singleChat['other_user'] ?? '',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          color: primaryBlack,
                        ),
                        SizedBox(height: 2.h),
                        CustomText(
                          title:
                              controller
                                  .singleChat['business_requirement_name'] ??
                              '',
                          fontSize: 12.sp,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          color: primaryBlack,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildHeader() {
  //   return Container(
  //     height: 40.h, // ✅ Proper AppBar height
  //     color: Colors.white,
  //     padding: EdgeInsets.symmetric(horizontal: 8.w),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.center, // ✅ CENTER ALIGN
  //       spacing: 8,
  //       children: [
  //         GestureDetector(
  //           onTap: () => navController.goBack(),
  //           child: const Icon(Icons.arrow_back),
  //         ),
  //         Expanded(
  //           child: ListTile(
  //             dense: true,
  //             onTap: () => Get.toNamed(
  //               Routes.profile,
  //               arguments: {
  //                 'user_id':
  //                     controller.singleChat['other_user_id']?.toString() ?? '',
  //               },
  //             ),
  //             visualDensity: VisualDensity(vertical: -4),
  //             contentPadding: EdgeInsets.zero,
  //             minVerticalPadding: 0,
  //             minLeadingWidth: 0,
  //             horizontalTitleGap: 8,
  //             leading: ClipRRect(
  //               borderRadius: BorderRadius.circular(100),
  //               child: FadeInImage(
  //                 placeholder: AssetImage(Images.defaultImage),
  //                 image:
  //                     (controller.singleChat['other_user_profile'] ?? '')
  //                         .isNotEmpty
  //                     ? NetworkImage(
  //                         controller.singleChat['other_user_profile'],
  //                       )
  //                     : const AssetImage(Images.defaultImage) as ImageProvider,
  //                 imageErrorBuilder: (context, error, stackTrace) {
  //                   return Image.asset(
  //                     Images.defaultImage,
  //                     fit: BoxFit.contain,
  //                     width: 30.w,
  //                     height: 30.h,
  //                   );
  //                 },
  //                 fit: BoxFit.cover,
  //                 width: 30.w,
  //                 height: 30.h,
  //                 placeholderFit: BoxFit.cover,
  //                 fadeInDuration: Duration(milliseconds: 300),
  //               ),
  //             ),
  //             title: CustomText(
  //               textAlign: TextAlign.start,
  //               title: controller.singleChat['other_user'] ?? '',
  //               fontSize: 14.sp,
  //               fontWeight: FontWeight.w600,
  //             ),
  //             subtitle: CustomText(
  //               textAlign: TextAlign.start,
  //               title: controller.singleChat['business_requirement_name'] ?? '',
  //               fontSize: 12.sp,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: lightGrey, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 0),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(25.r),
                border: Border.all(color: lightGrey, width: 1.5),
              ),
              child: TextField(
                controller: controller.msgController,
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (value) async {
                  if (value.trim().isNotEmpty) {
                    await controller.sendMsg(widget.chatId);
                  }
                },
              ),
            ),
          ),

          Obx(
            () => controller.isSendLoading.isTrue
                ? LoadingWidget(color: primaryColor, size: 20.r)
                : IconButton(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedSent,
                      color: primaryColor,
                    ),
                    onPressed: () async {
                      if (controller.msgController.text.isNotEmpty) {
                        await controller.sendMsg(widget.chatId);
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Widget _buildAllChat() {
  //   final chatList = controller.singleChat['messages'] ?? [];
  //   return Expanded(
  //     child: ListView.builder(
  //       reverse: true,
  //       padding: const EdgeInsets.all(12),
  //       itemCount: chatList.length,
  //       itemBuilder: (context, index) {
  //         final message = chatList[index];
  //         final isMe = message['self'] == true;
  //
  //         return Align(
  //           alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
  //           child: ConstrainedBox(
  //             constraints: BoxConstraints(maxWidth: Get.width * 0.75.w),
  //             child: IntrinsicWidth(
  //               child: Card(
  //                 elevation: 0,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(8.r),
  //                 ),
  //                 color: !isMe
  //                     ? primaryColor.withValues(alpha: 0.05)
  //                     : Colors.grey.shade200,
  //                 surfaceTintColor: Colors.white,
  //                 child: Padding(
  //                   padding: const EdgeInsets.symmetric(
  //                     horizontal: 14,
  //                     vertical: 10,
  //                   ),
  //                   child: Column(
  //                     children: [
  //                       // if (chat['document'] == 'yes') _buildFileAttachment(),
  //                       Align(
  //                         alignment: isMe
  //                             ? Alignment.centerRight
  //                             : Alignment.centerLeft,
  //                         child: CustomText(
  //                           title: message['message'].toString(),
  //                           fontSize: 13.sp,
  //                           maxLines: 10,
  //                           color: Colors.black87,
  //                           textAlign: TextAlign.start,
  //                         ),
  //                       ),
  //                       Align(
  //                         alignment: Alignment.centerRight,
  //                         child: CustomText(
  //                           title: message['created_at'],
  //                           textAlign: TextAlign.start,
  //                           // DateFormat(
  //                           //   'hh mm a',
  //                           // ).format(DateTime.parse(message['created_at'])),
  //                           fontSize: 10,
  //                           color: Colors.grey,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _buildAllChat() {
    return Expanded(
      child: RefreshIndicator(
        backgroundColor: primaryBlack,
        strokeWidth: 1,
        color: primaryColor,
        onRefresh: () async {
          await controller.getSingleChat(widget.chatId, isRefresh: true);
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            // 🔥 reverse list → load more when reaching TOP
            if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent &&
                controller.hasSingleMore &&
                !controller.isSingleLoadMore.value) {
              controller.getSingleChat(widget.chatId, showLoading: false);
            }
            return false;
          },
          child: Obx(
            () => ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(12),
              itemCount:
                  controller.allMessages.length +
                  (controller.isSingleLoadMore.value ? 1 : 0),
              itemBuilder: (context, index) {
                // 🔄 loader at top
                if (index == controller.allMessages.length) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Center(child: LoadingWidget(color: primaryColor)),
                  );
                }

                final message = controller.allMessages[index];
                final isMe = message['self'] == true;

                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: Get.width * 0.75),
                    child: IntrinsicWidth(
                      child: Card(
                        elevation: 0,
                        color: isMe
                            ? lightGrey
                            : Theme.of(context).brightness == Brightness.light
                            ? primaryColor.withValues(alpha: 0.05)
                            : Get.theme.cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Align(
                                alignment: isMe
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: CustomText(
                                  title: message['message'] ?? '',
                                  fontSize: 13.sp,
                                  color: primaryBlack,
                                ),
                              ),
                              SizedBox(height: 4),
                              CustomText(
                                title: message['created_at'] ?? '',
                                fontSize: 10.sp,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
