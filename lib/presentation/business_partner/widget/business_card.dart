import 'package:businessbuddy/utils/exported_path.dart';

class BusinessCard extends StatefulWidget {
  final dynamic data;
  final bool isRequested;
  final bool isSearch;
  final VoidCallback? onDelete;

  const BusinessCard({
    super.key,
    this.data,
    this.isRequested = false,
    this.isSearch = false,
    this.onDelete,
  });

  @override
  State<BusinessCard> createState() => _BusinessCardState();
}

class _BusinessCardState extends State<BusinessCard> {
  final controller = getIt<PartnerDataController>();
  final navController = getIt<NavigationController>();

  @override
  Widget build(BuildContext context) {
    if (widget.data['request_type'] == 'user_chat') return SizedBox();
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          BusinessDetailBottomSheet(
            data: widget.data,
            isRequested: widget.isRequested,
          ),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 8.r,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Get.theme.dividerColor, width: 0.5.w),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLeftData(),

              if (widget.isSearch != true)
                VerticalDivider(
                  color: Get.theme.dividerColor,
                  thickness: 1,
                  width: 1,
                ),

              /// RIGHT SECTION
              if (widget.isSearch != true)
                Expanded(child: _buildRightSection()),
            ],
          ),
        ),
      ),
    );
  }

  // LEFT SECTION
  Widget _buildLeftData() {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          spacing: 8.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              title: widget.isRequested == true
                  ? widget.data['requirement_name'] ?? ''
                  : widget.data['name'] ?? '',
              fontSize: 16.sp,
              textAlign: TextAlign.start,
              color: primaryColor,
              fontWeight: FontWeight.w600,
              maxLines: 2,
            ),

            Divider(color: Get.theme.dividerColor, thickness: 1),
            if (widget.isRequested != true)
              _buildDetailRow(
                firstText: 'Business Interest: ',
                secondText: widget.data['category_names'].join(", "),
              ),

            _buildDetailRow(
              firstText: widget.data['what_you_look_for_id'].toString() == '3'
                  ? 'Experience: '
                  : 'Investment Capacity: ',
              secondText: widget.data['investment_capacity'] ?? '',
            ),

            _buildDetailRow(
              firstText: 'Location: ',
              secondText: widget.data['location'] ?? '',
            ),
            if (widget.data['note']?.toString().isNotEmpty == true)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildDetailRow(
                    firstText: 'Note: ',
                    secondText: widget.data['note'] ?? '',
                  ),
                  Expanded(child: _buildContentSection()),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    final content = widget.data['note'] ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomText(
          title: content,
          fontSize: 14.sp,
          color: inverseColor,
          textAlign: TextAlign.start,
          fontWeight: FontWeight.w600,
          style: TextStyle(
            fontSize: 14.sp,
            height: 1.5,
            color: inverseColor,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
        ),

        // Read more button for long content
        if (content.length > 150)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: GestureDetector(
              onTap: () => expandContent(content),
              child: Text(
                'Read more',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // RIGHT SECTION LOGIC
  Widget _buildRightSection() {
    if (widget.data['self'] == true && widget.data['is_approved'] == '0') {
      return _rightWrapper(
        child: _buildTextOnly("Business requirement approval pending."),
      );
    }
    if (widget.data['self'] == true) {
      return _rightWrapper(child: _buildSelf());
    }

    if (widget.data['requested'] == true &&
        widget.data['accepted'] == false &&
        widget.data['self'] == false) {
      return _rightWrapper(child: _buildTextOnly("Your request\nis pending"));
    }

    // if (widget.data['requested'] == true &&
    //     widget.data['accepted'] == false &&
    //     widget.isRequested == true) {
    //   return _rightWrapper(child: _buildTextOnly("Your request\nis pending"));
    // }

    if (widget.data['requested'] == false && widget.data['self'] == false) {
      return Obx(() {
        final isLoading =
            controller.businessLoadingMap[widget.data['id'].toString()] == true;

        return _rightWrapper(
          child: isLoading
              ? LoadingWidget(color: primaryColor)
              : GestureDetector(
                  onTap: () async {
                    if (!getIt<DemoService>().isDemo) {
                      ToastUtils.showLoginToast();
                      return;
                    }
                    await controller.sendBusinessRequest(
                      widget.data['id'].toString(),
                    );
                  },
                  child: _buildActionItem(
                    icon: Icons.send_rounded,
                    text: "Send\nRequest",
                  ),
                ),
        );
      });
    }

    if (widget.data['requested'] == true && widget.data['accepted'] == true) {
      return Obx(() {
        final isLoading =
            getIt<InboxController>().initiateLoadingMap[widget.data['id']
                .toString()] ==
            true;

        return _rightWrapper(
          child: isLoading
              ? LoadingWidget(color: primaryColor)
              : _buildApprovedSection(),
        );
      });
    }

    return const SizedBox();
  }

  Widget _buildSelf() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
      child: PopupMenuButton<String>(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Get.theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        elevation: 2,
        popUpAnimationStyle: AnimationStyle(curve: Curves.easeInOut),
        padding: EdgeInsets.zero,
        surfaceTintColor: Colors.white,
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).brightness == Brightness.light
                ? primaryColor.withValues(alpha: 0.1)
                : Colors.white70,
          ),
          child: Icon(Icons.more_vert, color: primaryColor),
        ),
        onSelected: (value) {
          _handleMenuSelection(value);
        },
        itemBuilder: (context) => [
          _buildMenuItem('edit', Icons.edit, 'Edit', primaryColor),
          _buildMenuItem('delete', Icons.delete, 'Delete', Colors.grey),
        ],
      ),
    );
  }

  /// Wrapper → Ensures all right widgets fit inside Expanded properly
  Widget _rightWrapper({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(12.r),
      alignment: Alignment.center,
      child: child,
    );
  }

  /// ACTION ITEMS
  Widget _buildActionItem({required IconData icon, required String text}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? primaryColor.withValues(alpha: 0.1)
                : Colors.white70,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20.r, color: primaryColor),
        ),
        Divider(color: Colors.grey.shade300, thickness: 1),
        CustomText(
          title: text,
          fontSize: 12.sp,
          maxLines: 2,
          color: textGrey,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
        ),

        // if (text == 'Edit') _buildReqStatus(),
      ],
    );
  }

  // Widget _buildReqStatus() {
  //   return Obx(
  //     () => Switch(
  //       activeTrackColor: primaryColor.withValues(alpha: 0.1),
  //       inactiveThumbColor: primaryColor,
  //       activeThumbColor: primaryColor,
  //       inactiveTrackColor: lightGrey,
  //       onChanged: (newValue) {
  //         controller.isCompleted.value = newValue;
  //       },
  //       value: controller.isCompleted.value,
  //       trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((states) {
  //         if (states.contains(WidgetState.selected)) {
  //           return primaryColor;
  //         }
  //         return Colors.grey;
  //       }),
  //       trackOutlineWidth: WidgetStateProperty.resolveWith<double?>((states) {
  //         if (states.contains(WidgetState.selected)) {
  //           return 0; // No border when switch is ON
  //         }
  //         return 0.5; // Border when OFF
  //       }),
  //     ),
  //   );
  // }

  /// PENDING
  Widget _buildTextOnly(String text) {
    return CustomText(
      title: text,
      fontSize: 12.sp,
      color: textGrey,
      fontWeight: FontWeight.w500,
      maxLines: 10,
      textAlign: TextAlign.center,
    );
  }

  /// APPROVED
  Widget _buildApprovedSection() {
    return GestureDetector(
      onTap: () async {
        if (widget.isRequested != true) {
          if (widget.data['chat_initiated'] == true) {
            navController.openSubPage(
              SingleChat(chatId: widget.data['chat_id']?.toString() ?? ''),
            );
          } else {
            await getIt<InboxController>().initiateChat(
              reqId: widget.data['id'].toString(),
              type: 'business_requirement',
              from: 'rec',
            );
          }
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            title: "Approved",
            fontSize: 12.sp,
            color: Colors.green,
            fontWeight: FontWeight.w600,
          ),
          if (widget.isRequested != true) SizedBox(height: 6.h),
          if (widget.isRequested != true) Divider(),
          if (widget.isRequested != true) SizedBox(height: 6.h),
          if (widget.isRequested != true)
            Container(
              width: 40.r,
              height: 40.r,
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? primaryColor.withValues(alpha: 0.1)
                    : Colors.white70,
                shape: BoxShape.circle,
              ),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedMessage02,
                color: primaryColor,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String firstText,
    required String secondText,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: RichText(
        text: TextSpan(
          text: firstText,
          style: TextStyle(
            fontSize: 13.sp,
            color: textSmall,
            fontWeight: FontWeight.w600,
          ),
          children: [
            if (firstText != 'Note: ')
              TextSpan(
                text: secondText,
                style: TextStyle(color: inverseColor),
              ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    String value,
    IconData icon,
    String text,
    Color color,
  ) {
    return PopupMenuItem<String>(
      value: value,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(color: textDarkGrey)),
        ],
      ),
    );
  }

  void _handleMenuSelection(String value) {
    // Handle different menu selections
    switch (value) {
      case 'edit':
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        getIt<NavigationController>().openSubPage(
          EditRecruitment(recruitmentData: widget.data),
        );
        break;
      case 'delete':
        widget.onDelete!();
        break;
    }
  }
}

// import 'package:businessbuddy/utils/exported_path.dart';
//
// class BusinessCard extends StatefulWidget {
//   final dynamic data;
//   final bool isRequested;
//
//   const BusinessCard({super.key, this.data, this.isRequested = false});
//
//   @override
//   State<BusinessCard> createState() => _BusinessCardState();
// }
//
// class _BusinessCardState extends State<BusinessCard> {
//   final controller = getIt<PartnerDataController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 8.h),
//       decoration: BoxDecoration(
//         color: const Color(0xffF4F4F4),
//         borderRadius: BorderRadius.circular(16.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withValues(alpha: 0.1),
//             blurRadius: 8.r,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         border: Border.all(
//           color: Colors.grey.withValues(alpha: 0.2),
//           width: 1.w,
//         ),
//       ),
//       child: IntrinsicHeight(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // LEFT SIDE
//             _buildLeftData(),
//
//             VerticalDivider(
//               color: Colors.grey.shade300,
//               thickness: 1,
//               width: 1,
//             ),
//
//             // RIGHT SIDE (Actions)
//             _buildRightSection(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// ---------------- LEFT SECTION ----------------
//   Widget _buildLeftData() {
//     return Expanded(
//       flex: 3,
//       child: Padding(
//         padding: EdgeInsets.all(16.r),
//         child: Column(
//           spacing: 8.h,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CustomText(
//               title: widget.isRequested == true
//                   ? widget.data['requirement_name'] ?? ''
//                   : widget.data['name'] ?? '',
//               fontSize: 16.sp,
//               textAlign: TextAlign.start,
//               color: primaryColor,
//               fontWeight: FontWeight.w600,
//               maxLines: 2,
//             ),
//
//             Divider(color: Colors.grey.shade300, thickness: 1),
//
//             _buildDetailRow(
//               firstText: 'Business Interest: ',
//               secondText: widget.data['category_names'].join(", "),
//             ),
//
//             _buildDetailRow(
//               firstText: widget.data['what_you_look_for_id'].toString() == '3'
//                   ? 'Experience: '
//                   : 'Investment Capacity: ',
//               secondText: widget.data['investment_capacity'] ?? '',
//             ),
//
//             _buildDetailRow(
//               firstText: 'Location: ',
//               secondText: widget.data['location'] ?? '',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// ---------------- RIGHT SECTION (Conditions) ----------------
//   Widget _buildRightSection() {
//     if (widget.data['self'] == true) {
//       return _buildActionItem(icon: Icons.edit, text: 'Edit');
//     }
//
//     if (widget.data['requested'] == true &&
//         widget.data['accepted'] == false &&
//         widget.data['self'] == false) {
//       return _buildTextOnly('Your request\nis pending');
//     }
//
//     if (widget.data['requested'] == false && widget.data['self'] == false) {
//       return Obx(() {
//         final isLoading =
//             controller.businessLoadingMap[widget.data['id'].toString()] == true;
//         return isLoading
//             ? LoadingWidget(color: primaryColor)
//             : GestureDetector(
//                 onTap: () async {
//                   await controller.sendBusinessRequest(
//                     widget.data['id'].toString(),
//                   );
//                 },
//                 child: _buildActionItem(
//                   icon: Icons.send_rounded,
//                   text: 'Send\nRequest',
//                 ),
//               );
//       });
//     }
//
//     if (widget.data['requested'] == true && widget.data['accepted'] == true) {
//       return _buildApprovedSection();
//     }
//
//     return const SizedBox();
//   }
//
//   /// ACTION ICON + TEXT (Send Request, Edit)
//   Widget _buildActionItem({required IconData icon, required String text}) {
//     return Expanded(
//       // flex: 1,
//       child: Padding(
//         padding: EdgeInsets.all(16.r),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 40.r,
//               height: 40.r,
//               decoration: BoxDecoration(
//                 color: primaryColor.withValues(alpha: 0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(icon, size: 20.r, color: primaryColor),
//             ),
//             Divider(color: Colors.grey.shade300, thickness: 1),
//             CustomText(
//               title: text,
//               fontSize: 12.sp,
//               maxLines: 2,
//               color: textGrey,
//               fontWeight: FontWeight.w500,
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// PENDING REQUEST TEXT ONLY
//   Widget _buildTextOnly(String text) {
//     return Expanded(
//       // flex: 1,
//       child: Center(
//         child: CustomText(
//           title: text,
//           fontSize: 12.sp,
//           maxLines: 4,
//           color: textGrey,
//           fontWeight: FontWeight.w500,
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
//
//   /// APPROVED SECTION
//   Widget _buildApprovedSection() {
//     return Expanded(
//       // flex: 1,
//       child: Padding(
//         padding: EdgeInsets.all(16.r),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CustomText(
//               title: 'Approved',
//               fontSize: 12.sp,
//               color: Colors.green,
//               fontWeight: FontWeight.w600,
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 6.h),
//             Divider(),
//             SizedBox(height: 6.h),
//             Container(
//               width: 40.r,
//               height: 40.r,
//               padding: EdgeInsets.all(8.r),
//               decoration: BoxDecoration(
//                 color: primaryColor.withValues(alpha: 0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: HugeIcon(
//                 icon: HugeIcons.strokeRoundedMessage02,
//                 color: primaryColor,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// RICH TEXT ROW
//   Widget _buildDetailRow({
//     required String firstText,
//     required String secondText,
//   }) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 6.h),
//       child: RichText(
//         text: TextSpan(
//           text: firstText,
//           style: TextStyle(
//             fontSize: 13.sp,
//             color: Colors.grey.shade700,
//             fontWeight: FontWeight.w600,
//           ),
//           children: [
//             TextSpan(
//               text: secondText,
//               style: TextStyle(
//                 color: Colors.black87,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // import 'package:businessbuddy/utils/exported_path.dart';
// //
// // class BusinessCard extends StatefulWidget {
// //   final String status;
// //   final dynamic data;
// //   const BusinessCard({super.key, required this.status, this.data});
// //
// //   @override
// //   State<BusinessCard> createState() => _BusinessCardState();
// // }
// //
// // class _BusinessCardState extends State<BusinessCard> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       margin: EdgeInsets.symmetric(vertical: 8.h),
// //       decoration: BoxDecoration(
// //         color: Color(0xffF4F4F4),
// //         borderRadius: BorderRadius.circular(16.r),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withValues(alpha: 0.1),
// //             blurRadius: 8.r,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //         border: Border.all(
// //           color: Colors.grey.withValues(alpha: 0.2),
// //           width: 1.w,
// //         ),
// //       ),
// //       child: IntrinsicHeight(
// //         child: Row(
// //           crossAxisAlignment: CrossAxisAlignment.stretch,
// //           children: [
// //             _buildLeftData(),
// //             // Action Section
// //             VerticalDivider(
// //               color: Colors.grey.shade300,
// //               thickness: 1,
// //               width: 1,
// //             ),
// //
// //             // _buildRightData(),
// //             if (widget.data['self'] == true) _buildIsMeCondition(),
// //
// //             if (widget.data['requested'] == true &&
// //                 widget.data['accepted'] == false && widget.data['self'] == false)
// //               _buildPendingRequested(),
// //             if (widget.data['requested'] == false &&
// //                 widget.data['self'] == false)
// //               _buildSendRequest(),
// //             if (widget.data['requested'] == true &&
// //                 widget.data['accepted'] == true &&
// //                 widget.data['self'] == false)
// //               _buildAcceptedRequest(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildLeftData() {
// //     return Expanded(
// //       flex: 3,
// //       child: Padding(
// //         padding: EdgeInsets.all(16.r),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           spacing: 8.h,
// //           children: [
// //             // Header Section
// //             Expanded(
// //               child: CustomText(
// //                 title: widget.data['name'] ?? '',
// //                 fontSize: 16.sp,
// //                 textAlign: TextAlign.start,
// //                 color: primaryColor,
// //                 fontWeight: FontWeight.w600,
// //                 maxLines: 2,
// //               ),
// //             ),
// //             Divider(color: Colors.grey.shade300, thickness: 1, height: 5.h),
// //
// //             // Business Details
// //             _buildDetailRow(
// //               firstText: 'Business Interest: ',
// //               secondText: widget.data['category_names'].join(", "),
// //             ),
// //
// //             widget.data['what_you_look_for_id'].toString() == '3'
// //                 ? _buildDetailRow(
// //                     firstText: 'Experience: ',
// //                     secondText: widget.data['investment_capacity'] ?? '',
// //                   )
// //                 : _buildDetailRow(
// //                     firstText: 'Investment Capacity: ',
// //                     secondText: widget.data['investment_capacity'] ?? '',
// //                   ),
// //
// //             _buildDetailRow(
// //               firstText: 'Location: ',
// //               secondText: widget.data['location'] ?? '',
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildSendRequest() {
// //     return Expanded(
// //       flex: 1,
// //       child: Padding(
// //         padding: EdgeInsets.all(16.r),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Container(
// //               width: 40.r,
// //               height: 40.r,
// //               decoration: BoxDecoration(
// //                 color: primaryColor.withValues(alpha: 0.1),
// //                 shape: BoxShape.circle,
// //               ),
// //               child: Icon(Icons.send_rounded, size: 20.r, color: primaryColor),
// //             ),
// //             SizedBox(height: 8.h),
// //             CustomText(
// //               title: 'Send\nRequest',
// //               fontSize: 12.sp,
// //               maxLines: 2,
// //               color: textGrey,
// //               fontWeight: FontWeight.w500,
// //               textAlign: TextAlign.center,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildIsMeCondition() {
// //     return Expanded(
// //       flex: 1,
// //       child: Padding(
// //         padding: EdgeInsets.all(16.r),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Container(
// //               width: 40.r,
// //               height: 40.r,
// //               decoration: BoxDecoration(
// //                 color: primaryColor.withValues(alpha: 0.1),
// //                 shape: BoxShape.circle,
// //               ),
// //               child: Icon(Icons.edit, size: 20.r, color: primaryColor),
// //             ),
// //             SizedBox(height: 8.h),
// //             CustomText(
// //               title: 'Edit',
// //               fontSize: 12.sp,
// //               maxLines: 2,
// //               color: textGrey,
// //               fontWeight: FontWeight.w500,
// //               textAlign: TextAlign.center,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildPendingRequested() {
// //     return Expanded(
// //       flex: 1,
// //       child: Padding(
// //         padding: EdgeInsets.all(16.r),
// //         child: Center(
// //           child: CustomText(
// //             title: 'Your request\nis pending',
// //             fontSize: 12.sp,
// //             maxLines: 4,
// //             color: textGrey,
// //             fontWeight: FontWeight.w500,
// //             textAlign: TextAlign.center,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildAcceptedRequest() {
// //     return Expanded(
// //       flex: 1,
// //       child: Padding(
// //         padding: EdgeInsets.all(16.r),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Center(
// //               child: CustomText(
// //                 title: 'Approved',
// //                 fontSize: 12.sp,
// //                 maxLines: 4,
// //                 color: Colors.green,
// //                 fontWeight: FontWeight.w500,
// //                 textAlign: TextAlign.center,
// //               ),
// //             ),
// //
// //             // Container(
// //             //   width: 40.r,
// //             //   height: 40.r,
// //             //   padding: EdgeInsets.all(8.r),
// //             //   decoration: BoxDecoration(
// //             //     color: primaryColor.withValues(alpha: 0.1),
// //             //     shape: BoxShape.circle,
// //             //   ),
// //             //   child: HugeIcon(
// //             //     icon: HugeIcons.strokeRoundedCall02,
// //             //     color: primaryColor,
// //             //   ),
// //             // ),
// //             // SizedBox(height: 8.h),
// //             Divider(),
// //             Container(
// //               width: 40.r,
// //               height: 40.r,
// //               padding: EdgeInsets.all(8.r),
// //               decoration: BoxDecoration(
// //                 color: primaryColor.withValues(alpha: 0.1),
// //                 shape: BoxShape.circle,
// //               ),
// //               child: HugeIcon(
// //                 icon: HugeIcons.strokeRoundedMessage02,
// //                 color: primaryColor,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildDetailRow({
// //     required String firstText,
// //     required String secondText,
// //   }) {
// //     return RichText(
// //       text: TextSpan(
// //         text: firstText,
// //         style: TextStyle(
// //           fontSize: 13.sp,
// //           color: Colors.grey.shade700,
// //           fontWeight: FontWeight.w600,
// //         ),
// //         children: [
// //           TextSpan(
// //             text: secondText,
// //             style: TextStyle(
// //               color: Colors.black87,
// //               fontWeight: FontWeight.w400,
// //               height: 1.4,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
