import '../utils/exported_path.dart';

class CustomMainHeader2 extends StatelessWidget {
  final bool showBackButton;
  final VoidCallback? onBackTap;

  const CustomMainHeader2({
    super.key,
    this.showBackButton = true,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: Get.width,
          padding: EdgeInsets.symmetric(horizontal: 8.w).copyWith(top: 16.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: Theme.of(context).brightness == Brightness.light
                  // ? [primaryColor.withValues(alpha: 0.5), Colors.white]
                  ? [primaryColor, Colors.white]
                  : [primaryColor, Colors.black54],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 Location Label
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: _openLocationSheet,
                            child: SizedBox(
                              width: Get.width * 0.8.w,
                              child: Column(
                                // spacing: 8,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    spacing: 4.w,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: primaryBlack,
                                        size: 14.sp,
                                      ),
                                      CustomText(
                                        title: 'Location',
                                        fontSize: 13.sp,
                                        color: primaryBlack,
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: CustomText(
                                          title: getIt<SearchNewController>()
                                              .address
                                              .value,
                                          fontSize: 13.sp,
                                          color: primaryBlack,
                                          fontWeight: FontWeight.bold,
                                          maxLines: 1,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: primaryBlack,
                                        size: 14.sp,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        _buildNotificationIcon(),
                        SizedBox(width: 5.w),
                        _buildProfileIcon(),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 4.h),

                /// 🔹 Top Row: Logo + Icons
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.globalSearch),
                  child: SizedBox(
                    // height: 35.h,
                    child: TextFormField(
                      onTap: () => Get.toNamed(Routes.globalSearch),
                      enabled: false,

                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        focusedBorder: buildOutlineInputBorder(),
                        enabledBorder: buildOutlineInputBorder(),
                        disabledBorder: buildOutlineInputBorder(),
                        // 👇 MAKE FIELD SMALL HEIGHT
                        contentPadding: const EdgeInsets.all(15),
                        isDense: true,
                        visualDensity: VisualDensity(
                          horizontal: -2,
                          vertical: -2,
                        ),
                        suffixIcon: Icon(Icons.search, color: Colors.grey),
                        prefixIconConstraints: BoxConstraints(
                          maxWidth: Get.width * 0.1,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Image.asset(
                            Images.appIcon,
                            width: 18,
                            height: 18,
                          ),
                        ),
                        hintText: 'Search Offer, Interest, etc.',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        CustomTabBar(),
      ],
    );
  }

  void _openLocationSheet() {
    Get.bottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      SafeArea(
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 1.0,
          builder: (_, controllerScroll) {
            return SearchLocation();
          },
        ),
      ),
      enableDrag: true,
      isDismissible: true,
    );
  }

  OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.grey,
        width: 0.2,
      ), // Replace with AppColors.primaryColor
      borderRadius: BorderRadius.circular(100.r),
    );
  }

  Widget _buildNotificationIcon() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.notificationList),
      // onTap: () {
      //   Get.toNamed(
      //     Routes.chat,
      //     parameters: {
      //       'userId': '101',
      //       'roomId': 'room_1',
      //     },
      //   );
      //
      // },
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Get.theme.cardColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: textSmall,
              size: 18.sp,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Obx(() {
              if (getIt<HomeController>().showNotificationDot.isFalse)
                return SizedBox();
              return Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Get.theme.cardColor, width: 1.5),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileIcon() {
    return GestureDetector(
      onTap: () {
        if (!getIt<DemoService>().isDemo) {
          ToastUtils.showLoginToast();
          return;
        }
        Get.toNamed(
          Routes.profile,
          arguments: {'user_id': 'self', 'is_search': false},
        );
      },
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(Icons.person_outline, color: primaryColor, size: 18.sp),
      ),
    );
  }
}

// import '../utils/exported_path.dart';
//
// class CustomMainHeader2 extends StatelessWidget {
//   final bool showBackButton;
//   final VoidCallback? onBackTap;
//   final TextEditingController searchController;
//
//   const CustomMainHeader2({
//     super.key,
//     this.showBackButton = true,
//     this.onBackTap,
//     required this.searchController,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           width: Get.width,
//           padding: EdgeInsets.symmetric(
//             horizontal: 8.w,
//           ).copyWith(top: 12.h, bottom: 8.h),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [primaryColor.withValues(alpha: 0.5), Colors.white],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//           child: SafeArea(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// 🔹 Top Bar with Logo and Icons
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Logo
//                     Container(
//                       padding: EdgeInsets.all(6.w),
//                       margin: EdgeInsets.only(right: 2.w),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                       child: Image.asset(
//                         Images.appIcon,
//                         width: 20.w,
//                         height: 20.w,
//                       ),
//                     ),
//
//                     Expanded(
//                       flex: 2,
//                       child: Obx(
//                         () => GestureDetector(
//                           onTap: _openLocationSheet,
//                           child: Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 12.w,
//                               vertical: 10.h,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(20.r),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withValues(alpha: 0.05),
//                                   blurRadius: 8,
//                                   offset: Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Icons.location_on,
//                                   color: primaryColor,
//                                   size: 16.sp,
//                                 ),
//                                 SizedBox(width: 6.w),
//                                 Expanded(
//                                   child: CustomText(
//                                     title: getIt<SearchNewController>()
//                                         .address
//                                         .value,
//                                     fontSize: 13.sp,
//                                     color: Colors.black,
//                                     textAlign: TextAlign.start,
//                                     maxLines: 1,
//                                   ),
//                                 ),
//                                 Icon(
//                                   Icons.keyboard_arrow_down,
//                                   color: Colors.grey.shade600,
//                                   size: 18.sp,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 5.w),
//                     // Action Icons
//                     _buildLocationIcon(),
//                     SizedBox(width: 5.w),
//                     _buildNotificationIcon(),
//                     SizedBox(width: 5.w),
//                     _buildProfileIcon(),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         CustomTabBar(),
//       ],
//     );
//   }
//
//   void _openLocationSheet() {
//     Get.bottomSheet(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(24.r),
//           topRight: Radius.circular(24.r),
//         ),
//       ),
//       backgroundColor: Colors.white,
//       isScrollControlled: true,
//       SafeArea(
//         child: DraggableScrollableSheet(
//           expand: false,
//           initialChildSize: 0.85,
//           minChildSize: 0.5,
//           maxChildSize: 1.0,
//           builder: (_, controllerScroll) {
//             return Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(24.r),
//                   topRight: Radius.circular(24.r),
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   // Drag handle
//                   Container(
//                     margin: EdgeInsets.symmetric(vertical: 12.h),
//                     width: 40.w,
//                     height: 4.h,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(2.r),
//                     ),
//                   ),
//                   Expanded(child: SearchLocation()),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//       enableDrag: true,
//       isDismissible: true,
//     );
//   }
//
//   Widget _buildNotificationIcon() {
//     return GestureDetector(
//       onTap: () => Get.toNamed(Routes.notificationList),
//       child: Stack(
//         children: [
//           Container(
//             padding: EdgeInsets.all(8.w),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.05),
//                   blurRadius: 10,
//                   offset: Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Icon(
//               Icons.notifications_outlined,
//               color: Colors.grey.shade700,
//               size: 18.sp,
//             ),
//           ),
//           Positioned(
//             right: 0,
//             top: 0,
//             child: Container(
//               width: 8.w,
//               height: 8.w,
//               decoration: BoxDecoration(
//                 color: Colors.red,
//                 shape: BoxShape.circle,
//                 border: Border.all(color: Colors.white, width: 1.5),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProfileIcon() {
//     return GestureDetector(
//       onTap: () {
//         if (!getIt<DemoService>().isDemo) {
//           ToastUtils.showLoginToast();
//           return;
//         }
//         Get.toNamed(Routes.profile, arguments: {'user_id': 'self'});
//       },
//       child: Container(
//         padding: EdgeInsets.all(2.w),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.05),
//               blurRadius: 10,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Container(
//           padding: EdgeInsets.all(6.w),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             shape: BoxShape.circle,
//           ),
//           child: Icon(Icons.person_outline, color: primaryColor, size: 18.sp),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLocationIcon() {
//     return GestureDetector(
//       onTap: () => Get.toNamed(Routes.globalSearch),
//       child: Container(
//         padding: EdgeInsets.all(8.w),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.05),
//               blurRadius: 10,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Icon(Icons.search, color: Colors.grey.shade700, size: 18.sp),
//       ),
//     );
//   }
// }
