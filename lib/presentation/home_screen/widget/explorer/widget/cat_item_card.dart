import 'package:businessbuddy/utils/exported_path.dart';

class CatItemCard extends StatelessWidget {
  final String name;
  final String location;
  final String category;
  final String rating;
  final String reviewCount;
  final String offerText;
  final String phoneNumber;
  final String distance;
  final String imagePath;
  final String latitude;
  final String longitude;
  final String followersCount;
  final bool isFollowed;
  final bool isSelf;
  final List offers;
  final VoidCallback? onCall;
  final VoidCallback? onFollow;
  final VoidCallback? onTap;
  final bool? isSearch;

  const CatItemCard({
    super.key,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.offers,
    required this.location,
    required this.category,
    required this.distance,
    required this.followersCount,
    required this.rating,
    required this.reviewCount,
    required this.offerText,
    required this.isFollowed,
    required this.isSelf,
    required this.phoneNumber,
    this.imagePath = Images.hotelImg,
    this.onCall,
    this.onFollow,
    this.onTap,
    this.isSearch = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Get.theme.dividerColor, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.08),
              blurRadius: 12.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          spacing: 12.h,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(),
                SizedBox(width: 4.w),
                _buildContent(),
              ],
            ),

            if (isSearch != true) _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 80.w,
        height: 80.h,
        decoration: BoxDecoration(
          // color: lightGrey,
          border: Border.all(color: lightGrey),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: FadeInImage(
          placeholder: const AssetImage(Images.defaultImage),
          image: NetworkImage(imagePath),
          width: 80.w,
          height: 80.h,
          imageErrorBuilder: (context, error, stackTrace) {
            return Container(
              width: 80.w,
              height: 80.h,
              padding: EdgeInsets.all(24.w),
              color: lightGrey,
              child: Image.asset(Images.defaultImage, fit: BoxFit.contain),
            );
          },
          fit: BoxFit.cover,
          placeholderFit: BoxFit.contain,
          fadeInDuration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: Column(
        spacing: 8.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildHeader(), _buildLocation()],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title: name,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: primaryBlack,
                textAlign: TextAlign.start,
                maxLines: 2,
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: CustomText(
                      title: category,
                      fontSize: 11.sp,
                      textAlign: TextAlign.start,
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isSearch != true) SizedBox(width: 8.w),
                  if (isSearch != true)
                    CustomText(
                      title: '·',
                      fontSize: 12.sp,
                      color: Colors.grey[400],
                    ),
                  if (isSearch != true) SizedBox(width: 8.w),
                  if (isSearch != true)
                    CustomText(
                      title: '$distance km',
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                ],
              ),
              if (followersCount != '0')
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 0, 0),
                  child: CustomText(
                    title: '$followersCount Followers',
                    fontSize: 13.sp,
                    textAlign: TextAlign.start,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
        _buildRating(),
        // Direction Icon
      ],
    );
  }

  Widget _buildRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 2.w,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.white, size: 14.sp),
                  SizedBox(width: 4.w),
                  CustomText(
                    title: rating,
                    fontSize: 12.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            // CustomText(
            //   title: 'By $reviewCount',
            //   fontSize: 10.sp,
            //   color: textLightGrey,
            // ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocation() {
    return Row(
      children: [
        Icon(Icons.location_on_outlined, color: textLightGrey, size: 14.sp),
        SizedBox(width: 4.w),
        Expanded(
          child: CustomText(
            title: location,
            textAlign: TextAlign.start,
            fontSize: 12.sp,
            color: textLightGrey,
            maxLines: 2,
          ),
        ),
        if (isSearch != true) _buildLocationIcon(),
      ],
    );
  }

  Widget _buildLocationIcon() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          if (!getIt<DemoService>().isDemo) {
            ToastUtils.showLoginToast();
            return;
          }
          openMap(double.parse(latitude), double.parse(longitude));
        },
        child: Container(
          width: 30.w,
          height: 30.h,
          decoration: BoxDecoration(
            color: Get.theme.dividerColor,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: lightGrey),
          ),
          child: Icon(
            Icons.location_on_outlined,
            size: 18.sp,
            color: Colors.red,
          ),
        ),
      ),
    );
    // Direction Icon

    // Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     Container(
    //       padding: EdgeInsets.symmetric(horizontal: 8.w),
    //       decoration: BoxDecoration(
    //         color: lightRed.withValues(alpha: 0.5),
    //         borderRadius: BorderRadius.circular(6.r),
    //         border: Border.all(color: lightRed.withValues(alpha: 0.3)),
    //       ),
    //       child: CustomText(
    //         title: category,
    //         fontSize: 12.sp,
    //         color: textLightGrey,
    //       ),
    //     ),
    //     GestureDetector(
    //       onTap: () {
    //         if (!getIt<DemoService>().isDemo) {
    //           ToastUtils.showLoginToast();
    //           return;
    //         }
    //         openMap(double.parse(latitude), double.parse(longitude));
    //       },
    //       child: HugeIcon(
    //         icon: HugeIcons.strokeRoundedLocation05,
    //         color: primaryColor,
    //         // size: 20.sp,
    //       ),
    //     ),
    //   ],
    // );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        /// Call
        if (!isSelf)
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: onCall,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedCall02,
                  size: 16.sp,
                  color: primaryBlack,
                ),
              ),
            ),
          ),

        if (!isSelf) SizedBox(width: 4.w),

        /// WhatsApp
        if (!isSelf && phoneNumber.isNotEmpty)
          GestureDetector(
            onTap: () {
              if (!getIt<DemoService>().isDemo) {
                ToastUtils.showLoginToast();
                return;
              }
              onWhatsApp(phoneNumber);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedWhatsapp,
                size: 16.sp,
                color: Colors.green,
              ),
            ),
          ),

        if (!isSelf) SizedBox(width: 4.w),

        /// Follow
        if (!isFollowed && !isSelf)
          Expanded(
            flex: 2,
            child: _buildActionButton(
              icon: HugeIcons.strokeRoundedUserAdd02,
              text: 'Follow',
              onPressed: onFollow,
              backgroundColor: Colors.transparent,
            ),
          ),

        if (!isFollowed && !isSelf) SizedBox(width: 4.w),

        /// Offer
        if (offerText != '0 Offers ')
          Expanded(
            flex: 3,
            child: _buildActionButton(
              icon: HugeIcons.strokeRoundedDiscount,
              text: offerText,
              onPressed: () => AllDialogs().offerDialog(offers),
              backgroundColor: primaryColor,
            ),
          ),
      ],
    );
  }

  // Widget _buildActionButtons() {
  //   return Row(
  //     children: [
  //       Visibility(
  //         visible: isSelf == false,
  //         child: Expanded(
  //           flex: 2,
  //           child: _buildActionButton(
  //             icon: HugeIcons.strokeRoundedCall02,
  //             text: 'Call',
  //             onPressed: onCall,
  //             backgroundColor: Colors.transparent,
  //           ),
  //         ),
  //       ),
  //       Visibility(
  //         visible: isSelf == false,
  //         child: Expanded(
  //           flex: 2,
  //           child: _buildActionButton(
  //             icon: HugeIcons.strokeRoundedCall02,
  //             text: 'Whatsapp',
  //             onPressed: onCall,
  //             backgroundColor: Colors.transparent,
  //           ),
  //         ),
  //       ),
  //       SizedBox(width: 8.w),
  //       if (!isFollowed && isSelf == false)
  //         Expanded(
  //           flex: 2,
  //           child: _buildActionButton(
  //             icon: HugeIcons.strokeRoundedUserAdd02,
  //             text: 'Follow',
  //             onPressed: onFollow,
  //             backgroundColor: Colors.transparent,
  //           ),
  //         ),
  //       SizedBox(width: 8.w),
  //       Expanded(
  //         flex: 3,
  //         child: _buildActionButton(
  //           icon: HugeIcons.strokeRoundedDiscount,
  //           text: offerText,
  //           onPressed: () => AllDialogs().offerDialog(offers),
  //           backgroundColor: primaryColor,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildActionButton({
    required var icon,
    required String text,
    required VoidCallback? onPressed,
    required Color backgroundColor,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HugeIcon(
              icon: icon,
              color: icon == HugeIcons.strokeRoundedCall02
                  ? primaryBlack
                  : backgroundColor == primaryColor
                  ? Colors.white
                  : primaryColor,
              size: 16.sp,
            ),
            SizedBox(width: 6.w),
            CustomText(
              title: text,
              fontSize: 12.sp,
              color: backgroundColor == primaryColor
                  ? Colors.white
                  : primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}

extension NumberFormatting on int {
  String formatCount() {
    if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}k';
    }
    return toString();
  }
}

//
//
// class CatItemCard extends StatelessWidget {
//   final String name;
//   final String location;
//   final String category;
//   final String rating;
//   final String reviewCount;
//   final String offerText;
//   final String phoneNumber;
//   final String distance;
//   final String imagePath;
//   final String latitude;
//   final String longitude;
//   final bool isFollowed;
//   final bool isSelf;
//   final List offers;
//   final VoidCallback? onCall;
//   final VoidCallback? onFollow;
//   final VoidCallback? onTap;
//
//   const CatItemCard({
//     super.key,
//     required this.name,
//     required this.latitude,
//     required this.longitude,
//     required this.offers,
//     required this.location,
//     required this.category,
//     required this.distance,
//     required this.rating,
//     required this.reviewCount,
//     required this.offerText,
//     required this.isFollowed,
//     required this.isSelf,
//     required this.phoneNumber,
//     this.imagePath = Images.hotelImg,
//     this.onCall,
//     this.onFollow,
//     this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.only(bottom: 12.h),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16.r),
//           border: Border.all(color: Colors.grey[200]!, width: 1.5),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 8.r,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             // Image with overlay
//             _buildImageSection(),
//
//             // Content
//             Padding(
//               padding: EdgeInsets.all(8.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Header
//                   _buildHeader(),
//                   SizedBox(height: 8.h),
//
//                   // Location & Category
//                   _buildLocationInfo(),
//                   SizedBox(height: 12.h),
//
//                   // Action Buttons
//                   _buildActionButtons(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImageSection() {
//     return Stack(
//       children: [
//         // Main Image
//         ClipRRect(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(16.r),
//             topRight: Radius.circular(16.r),
//           ),
//           child: Container(
//             height: 120.h,
//             width: double.infinity,
//             child: FadeInImage(
//               placeholder: const AssetImage(Images.defaultImage),
//               image: NetworkImage(imagePath),
//               fit: BoxFit.cover,
//               placeholderFit: BoxFit.cover,
//               fadeInDuration: const Duration(milliseconds: 300),
//               imageErrorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   color: Colors.grey[100],
//                   child: Center(
//                     child: Icon(
//                       Icons.business_rounded,
//                       size: 40.sp,
//                       color: Colors.grey[300],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//
//         // Rating Chip
//         Positioned(
//           top: 10.w,
//           right: 10.w,
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20.r),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 4.r,
//                 ),
//               ],
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.star_rounded, color: Colors.amber[600], size: 14.sp),
//                 SizedBox(width: 4.w),
//                 CustomText(
//                   title: rating,
//                   fontSize: 13.sp,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildHeader() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomText(
//                 title: name,
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.black,
//                 maxLines: 2,
//               ),
//               SizedBox(height: 2.h),
//               Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 8.w,
//                       vertical: 2.h,
//                     ),
//                     decoration: BoxDecoration(
//                       color: primaryColor.withOpacity(0.08),
//                       borderRadius: BorderRadius.circular(6.r),
//                     ),
//                     child: CustomText(
//                       title: category,
//                       fontSize: 11.sp,
//                       color: primaryColor,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   SizedBox(width: 8.w),
//                   CustomText(
//                     title: '·',
//                     fontSize: 12.sp,
//                     color: Colors.grey[400],
//                   ),
//                   SizedBox(width: 8.w),
//                   CustomText(
//                     title: '$distance km',
//                     fontSize: 12.sp,
//                     color: Colors.grey[600],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         // Direction Icon
//         GestureDetector(
//           onTap: () {
//             if (!getIt<DemoService>().isDemo) {
//               ToastUtils.showLoginToast();
//               return;
//             }
//             openMap(double.parse(latitude), double.parse(longitude));
//           },
//           child: Container(
//             width: 36.w,
//             height: 36.h,
//             decoration: BoxDecoration(
//               color: Colors.grey[50],
//               borderRadius: BorderRadius.circular(10.r),
//               border: Border.all(color: Colors.grey[200]!),
//             ),
//             child: Icon(
//               Icons.navigation_rounded,
//               size: 18.sp,
//               color: Colors.grey[700],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildLocationInfo() {
//     return Row(
//       children: [
//         Icon(Icons.location_on_outlined, size: 16.sp, color: Colors.grey[500]),
//         SizedBox(width: 6.w),
//         Expanded(
//           child: CustomText(
//             title: location,
//             textAlign: TextAlign.start,
//             fontSize: 13.sp,
//             color: Colors.grey[700],
//             maxLines: 1,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionButtons() {
//     return Row(
//       children: [
//         // Call Button (if not self)
//         if (!isSelf)
//           Expanded(
//             child: _buildMinimalButton(
//               icon: Icons.call_outlined,
//               label: 'Call',
//               onPressed: onCall,
//               color: Colors.green[600]!,
//             ),
//           ),
//         if (!isSelf) SizedBox(width: 8.w),
//
//         // Follow/Following Button (if not self)
//         if (!isSelf)
//           Expanded(
//             child: _buildMinimalButton(
//               icon: isFollowed
//                   ? Icons.check_circle_outline
//                   : Icons.person_add_outlined,
//               label: isFollowed ? 'Following' : 'Follow',
//               onPressed: onFollow,
//               color: isFollowed ? Colors.grey[600]! : Colors.blue[600]!,
//               isActive: isFollowed,
//             ),
//           ),
//         if (!isSelf) SizedBox(width: 4.w),
//
//         // Offer Button (Always visible)
//         Expanded(
//           flex: 2,
//           child: Container(
//             height: 38.h,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [primaryColor, primaryColor.withOpacity(0.9)],
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//               ),
//               borderRadius: BorderRadius.circular(10.r),
//             ),
//             child: Material(
//               color: Colors.transparent,
//               borderRadius: BorderRadius.circular(10.r),
//               child: InkWell(
//                 onTap: () => AllDialogs().offerDialog(offers),
//                 borderRadius: BorderRadius.circular(10.r),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.local_offer_outlined,
//                       size: 16.sp,
//                       color: Colors.white,
//                     ),
//                     SizedBox(width: 6.w),
//                     Flexible(
//                       child: CustomText(
//                         title: offerText,
//                         fontSize: 13.sp,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                         maxLines: 1,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildMinimalButton({
//     required IconData icon,
//     required String label,
//     required VoidCallback? onPressed,
//     required Color color,
//     bool isActive = false,
//   }) {
//     return Container(
//       height: 38.h,
//       decoration: BoxDecoration(
//         color: isActive ? color.withOpacity(0.1) : Colors.transparent,
//         borderRadius: BorderRadius.circular(10.r),
//         border: Border.all(
//           color: isActive ? color.withOpacity(0.3) : Colors.grey[300]!,
//           width: 1.5,
//         ),
//       ),
//       child: Material(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(10.r),
//         child: InkWell(
//           onTap: onPressed,
//           borderRadius: BorderRadius.circular(10.r),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 16.sp, color: color),
//               SizedBox(width: 6.w),
//               CustomText(
//                 title: label,
//                 fontSize: 13.sp,
//                 color: color,
//                 fontWeight: FontWeight.w600,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Extension for formatting review counts
// extension NumberFormatting on int {
//   String formatCount() {
//     if (this >= 1000) {
//       return '${(this / 1000).toStringAsFixed(1)}k';
//     }
//     return toString();
//   }
// }
