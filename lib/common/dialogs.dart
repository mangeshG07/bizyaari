import 'dart:io';
import 'package:businessbuddy/utils/exported_path.dart';
import 'package:flutter/cupertino.dart';

class AllDialogs {
  void noInternetDialog() {
    Get.dialog(
      PopScope(
        canPop: false,
        child: AlertDialog(
          surfaceTintColor: Theme.of(Get.context!).scaffoldBackgroundColor,
          backgroundColor: Theme.of(Get.context!).cardColor,
          title: const Text(
            'No Internet Connection',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(Images.noInternet, width: Get.height * 0.25.w),
              const SizedBox(height: 12),
              Text(
                'Please check your internet connection.',
                style: TextStyle(color: inverseColor),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                final isConnected =
                    await InternetConnectionChecker.instance.hasConnection;
                if (isConnected) {
                  if (Get.isDialogOpen ?? false) Get.back();
                  // await checkMaintenance();
                } else {
                  Get.offAllNamed(Routes.splash);
                }
              },
              child: Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  void changeNumber(String number) {
    if (Platform.isIOS) {
      // iOS style dialog
      showCupertinoDialog(
        context: Get.context!,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text('Change Number'),
          content: Text('Are you sure you want to change\n+91 $number'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(ctx),
              isDestructiveAction: true,
              child: const Text('No'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                getIt<OnboardingController>().numberController.clear();
                Get.offAllNamed(Routes.login);
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    } else {
      // Android style dialog
      Get.dialog(
        AlertDialog(
          surfaceTintColor: Theme.of(Get.context!).scaffoldBackgroundColor,
          backgroundColor: Theme.of(Get.context!).scaffoldBackgroundColor,
          content: Text('Are you sure you want to change\n+91 $number'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('No', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                getIt<OnboardingController>().numberController.clear();
                Get.offAllNamed(Routes.login);
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    }
  }

  void offerDialog(dynamic offers) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        surfaceTintColor: Colors.white,
        backgroundColor: Theme.of(Get.context!).scaffoldBackgroundColor,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: Get.height * 0.7.h),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with close icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      title: 'Latest Local Offers Just for You!',
                      fontSize: 18.sp,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(Icons.close, color: Colors.grey, size: 20.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Divider(color: Get.theme.dividerColor),
                // Offers list

                // Offers list
                offers.isEmpty
                    ? Center(
                        child: CustomText(
                          title: 'No offers available',
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                      )
                    : Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(top: 8.h),
                          itemCount: offers.length,
                          separatorBuilder: (_, __) => SizedBox(height: 10.h),
                          itemBuilder: (context, index) {
                            final offer = offers[index];
                            return _buildOfferTile(offer);
                          },
                        ),
                      ),
                // SizedBox(height: 8.h),
                //
                // _buildOfferTile(),
                // SizedBox(height: 12.h),
                // _buildOfferTile(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showConfirmationDialog(
    String title,
    String message, {
    required VoidCallback onConfirm,
  }) {
    Get.dialog(
      Dialog(
        surfaceTintColor: Theme.of(Get.context!).scaffoldBackgroundColor,
        backgroundColor: Theme.of(Get.context!).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 50.sp,
                color: Colors.redAccent,
              ),
              SizedBox(height: 10.h),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                  color: primaryBlack,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: textGrey),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(Get.context!).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onPressed: onConfirm,
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfferTile(dynamic offer) {
    return OfferTile(
      point: offer['highlight_points'] ?? [],
      imageUrl: offer['image'] ?? '',
      restaurantName: offer['business_name'] ?? '',
      offerTitle: offer['details'] ?? '',
      dateRange: '${offer['start_date'] ?? ''} to ${offer['end_date'] ?? ''}  ',
    );
  }
}

class OfferTile extends StatelessWidget {
  final String imageUrl;
  final String restaurantName;
  final String offerTitle;
  final String dateRange;
  final List point;

  const OfferTile({
    super.key,
    required this.imageUrl,
    required this.restaurantName,
    required this.offerTitle,
    required this.dateRange,
    required this.point,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          WidgetZoom(
            heroAnimationTag: 'Tag $imageUrl',
            zoomWidget: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedNetworkImage(
                placeholder: (_, __) => Image.asset(Images.defaultImage),
                imageUrl: imageUrl,
                height: 60.h,
                width: 60.h,
                fit: BoxFit.contain,
                memCacheHeight: 600,
                errorWidget: (_, __, ___) => Image.asset(Images.defaultImage),
                fadeInDuration: Duration.zero,
              ),

              // Image.network(
              //   imageUrl,
              //   height: 60.h,
              //   width: 60.h,
              //   fit: BoxFit.contain,
              // ),
            ),
          ),
          SizedBox(width: 10.w),

          // Text Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurantName,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: primaryBlack,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  offerTitle,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade700,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14.sp,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      dateRange,
                      style: TextStyle(fontSize: 11.sp, color: primaryBlack),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: point.map((v) {
                    return buildBulletPoint(text: v);
                  }).toList(),
                ),

                // _buildBulletPoint(text: 'No minimum order'),
                // _buildBulletPoint(text: 'Extra cheese free on weekend orders'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildBulletPoint({required String text}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // Bullet point
      Container(
        margin: EdgeInsets.only(right: 8.w),
        width: 8.r,
        height: 8.r,
        decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
      ),
      // Text
      Expanded(
        child: CustomText(
          title: text,
          maxLines: 4,
          fontSize: 12.sp,
          color: textLightGrey,
          textAlign: TextAlign.start,
        ),
      ),
    ],
  );
}
