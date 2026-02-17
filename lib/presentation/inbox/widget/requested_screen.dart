import 'package:businessbuddy/utils/exported_path.dart';

class RequestedScreen extends StatefulWidget {
  const RequestedScreen({super.key});

  @override
  State<RequestedScreen> createState() => _RequestedScreenState();
}

class _RequestedScreenState extends State<RequestedScreen> {
  final controller = getIt<InboxController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
            Container(
              height: 40.h,
              margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: lightGrey, width: 0.5),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                indicatorColor: Colors.transparent,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelColor: Colors.grey[700],
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: 'Sent'),
                  Tab(text: 'Received'),
                ],
              ),
            ),

            // --- Tab Content ---
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(), // prevents
                children: [_buildSendList(), _buildReceivedList()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendList() {
    return Obx(() {
      /// 🔹 Initial Loading (Shimmer)
      if (getIt<PartnerDataController>().isLoading.isTrue) {
        return const ChatListShimmer();
      }

      /// 🔹 Empty State
      if (getIt<PartnerDataController>().requestedBusinessList.isEmpty) {
        return commonNoDataFound();
      }

      /// 🔹 Feeds + Pagination
      return NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll is ScrollEndNotification &&
              scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 50 &&
              getIt<PartnerDataController>().hasMore &&
              !getIt<PartnerDataController>().isLoadMore.value &&
              !getIt<PartnerDataController>().isLoading.value) {
            getIt<PartnerDataController>().getRequestedBusiness(
              showLoading: false,
            );
          }
          return false;
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// 🔹 Feed List
              AnimationLimiter(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) =>
                      Divider(height: 5, color: lightGrey),
                  padding: const EdgeInsets.all(8),
                  itemCount: getIt<PartnerDataController>()
                      .requestedBusinessList
                      .length,
                  itemBuilder: (context, index) {
                    final data = getIt<PartnerDataController>()
                        .requestedBusinessList[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: ListTile(
                            dense: true,
                            leading: CircleAvatar(
                              radius: 22.r,
                              backgroundColor: Colors.grey.shade300,
                              child: ClipOval(
                                child: FadeInImage(
                                  placeholder: const AssetImage(
                                    Images.defaultImage,
                                  ),
                                  image: NetworkImage(
                                    data['request_type'] == 'user_chat'
                                        ? data['recipient_user_profile_image'] ??
                                              ''
                                        : data['requirement_owner_profile_image'] ??
                                              '',
                                  ),
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                        return Image.asset(
                                          Images.defaultImage,
                                          width: 100.w,
                                          height: 100.h,
                                          fit: BoxFit.contain,
                                        );
                                      },
                                  width: 100.w,
                                  height: 100.h,
                                  fit: BoxFit.cover,
                                  placeholderFit: BoxFit.contain,
                                  fadeInDuration: const Duration(
                                    milliseconds: 300,
                                  ),
                                ),
                              ),
                              // backgroundImage: AssetImage(Images.hotelImg),
                            ),
                            title: CustomText(
                              title: data['request_type'] == 'user_chat'
                                  ? data['recipient_user_name'] ?? ''
                                  : data['requirement_owner_name'] ?? '',
                              fontSize: 14.sp,
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.bold,
                              color: primaryBlack,
                            ),
                            subtitle: data['request_type'] == 'user_chat'
                                ? SizedBox()
                                : CustomText(
                                    title: data['requirement_name'] ?? '',
                                    fontSize: 12.sp,
                                    maxLines: 2,
                                    textAlign: TextAlign.start,
                                    color: primaryBlack,
                                  ),
                            onTap: () {},
                            trailing:
                                data['requested'] == true &&
                                    data['accepted'] == false
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.w,
                                      vertical: 2.h,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: primaryColor),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: CustomText(
                                      title: 'Requested',
                                      fontSize: 12.sp,
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.w,
                                      vertical: 2.h,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.green),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: CustomText(
                                      title: 'Accepted',
                                      fontSize: 12.sp,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              /// 🔹 Pagination Loader
              Obx(
                () => getIt<PartnerDataController>().isLoadMore.value
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: LoadingWidget(color: primaryColor),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildReceivedList() {
    return Obx(() {
      /// 🔹 Initial Loading (Shimmer)
      if (controller.isLoading.isTrue) {
        return const ChatListShimmer();
      }

      /// 🔹 Empty State
      if (controller.receivedRequestList.isEmpty) {
        return commonNoDataFound();
      }

      /// 🔹 Feeds + Pagination
      return NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll is ScrollEndNotification &&
              scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 50 &&
              controller.hasRecMore &&
              !controller.isRecLoadMore.value &&
              !controller.isLoading.value) {
            controller.getReceiveBusinessRequest(showLoading: false);
          }
          return false;
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// 🔹 Feed List
              AnimationLimiter(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) =>
                      Divider(height: 5, color: lightGrey),
                  padding: const EdgeInsets.all(8),
                  itemCount: controller.receivedRequestList.length,
                  itemBuilder: (context, index) {
                    final data = controller.receivedRequestList[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: buildRequestCard(
                            name: data['request_type'] == 'user_chat'
                                ? data['sender_user_name'] ?? ''
                                : data['requesting_user_name'] ?? '',
                            title: data['request_type'] == 'user_chat'
                                ? null
                                : 'Requirement Title: ${data['requirement_name'] ?? ''}',
                            message: data['request_type'] == 'user_chat'
                                ? 'You’ve received a new chat request.'
                                : 'You’ve received a new collaboration request.',
                            date: data['requested_at'] ?? '',
                            buttonText: data['accepted'] == true
                                ? 'Accepted'
                                : 'Accept Request',

                            image: data['request_type'] == 'user_chat'
                                ? data['sender_user_profile_image'] ?? ''
                                : data['requesting_user_profile_image'] ?? '',
                            onPressed: () async {
                              if (data['accepted'] == false) {
                                await controller.acceptRequest(
                                  data['request_id']?.toString() ?? '',
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              /// 🔹 Pagination Loader
              Obx(
                () => controller.isRecLoadMore.value
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: LoadingWidget(color: primaryColor),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildRequestCard({
    required String name,
    String? title,
    required String message,
    required String date,
    required String image,
    required String buttonText,
    void Function()? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(10.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 22.r,
            backgroundColor: Colors.grey.shade300,
            child: ClipOval(
              child: FadeInImage(
                placeholder: const AssetImage(Images.defaultImage),
                image: NetworkImage(image),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    Images.defaultImage,
                    width: 100.w,
                    height: 100.h,
                    fit: BoxFit.contain,
                  );
                },
                width: 100.w,
                height: 100.h,
                fit: BoxFit.cover,
                placeholderFit: BoxFit.contain,
                fadeInDuration: const Duration(milliseconds: 300),
              ),
            ),

            // const Icon(Icons.person, color: Colors.white, size: 24),
          ),
          SizedBox(width: 10.w),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: primaryBlack,
                      ),
                    ),
                    Text(
                      date,
                      style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                    ),
                  ],
                ),
                if (title != null) ...[
                  SizedBox(height: 3.h),
                  Text(
                    title,
                    style: TextStyle(fontSize: 11.sp, color: primaryBlack),
                  ),
                ],
                SizedBox(height: 4.h),
                Text(
                  message,
                  style: TextStyle(fontSize: 11.sp, color: primaryBlack),
                ),
                SizedBox(height: 8.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton(
                    onPressed: onPressed,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: buttonText == 'Accepted'
                            ? Colors.green
                            : Colors.red,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 4.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        color: buttonText == 'Accepted'
                            ? Colors.green
                            : Colors.red,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
