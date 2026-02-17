import 'package:businessbuddy/utils/exported_path.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  final controller = getIt<SearchNewController>();
  final _debouncer = Debouncer(milliseconds: 500);
  final RxBool _isLoading = false.obs;

  @override
  void initState() {
    controller.addressList.clear();
    super.initState();
  }

  @override
  void dispose() {
    _debouncer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Draggable handle
            _buildHandle(),

            // Header
            _buildHeader(),

            // Search field
            _buildSearchField(),

            // Current location button
            _buildCurrentLocation(context),

            SizedBox(height: 16.h),

            // Results section
            Obx(
              () => _isLoading.value
                  ? _buildLoadingIndicator()
                  : controller.addressList.isNotEmpty
                  ? _buildResultsList()
                  : _buildEmptyState(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
      width: 40.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined, color: primaryColor, size: 24),
          SizedBox(width: 8.w),
          Text(
            'Search Location',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: primaryBlack,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 16.h),
      child: TextFormField(
        minLines: 1,
        maxLines: 1,
        keyboardType: TextInputType.text,
        controller: controller.addressController,
        style: TextStyle(fontSize: 16.sp),
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          suffixIcon: controller.addressController.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    controller.addressController.clear();
                    controller.addressList.value = [];
                    _isLoading.value = false;
                    setState(() {});
                  },
                  child: Container(
                    margin: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                )
              : Icon(Icons.search, color: mainTextGrey),
          hintText: 'Enter your location...',
          hintStyle: TextStyle(color: mainTextGrey, fontSize: 14.sp),
          contentPadding: EdgeInsets.all(16.w),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: primaryColor, width: 1.5),
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) =>
            value!.isEmpty ? 'Please search your location' : null,
        onChanged: (str) {
          if (str.trim().isEmpty) {
            controller.addressList.value = [];
            _isLoading.value = false;
            return;
          }

          _isLoading.value = true;
          _debouncer.run(() {
            getPlaces(str.trim())
                .then((data) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    controller.addressList.value = data;
                    _isLoading.value = false;
                  });
                })
                .catchError((error) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _isLoading.value = false;
                    controller.addressList.value = [];
                  });
                });
          });
        },
      ),
    );
  }

  Widget _buildCurrentLocation(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showCurrentLocationLoader();
            controller.getLiveLocation();
            Navigator.of(context).pop();
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? primaryColor.withValues(alpha: 0.1)
                  : Get.theme.cardColor,
              border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.my_location_rounded,
                    color: primaryColor,
                    size: 20,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Use Current Location',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? primaryColor
                          : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 40.w,
          height: 40.h,
          child: LoadingWidget(color: primaryColor),
        ),
        SizedBox(height: 16.h),
        Text(
          'Searching locations...',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildResultsList() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Text(
                  'Search Results',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: textGrey,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '${controller.addressList.length}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 16.h),
            separatorBuilder: (_, index) => Divider(
              height: 1,
              indent: 56.w,
              endIndent: 16.w,
              color: Colors.grey.shade200,
            ),
            itemCount: controller.addressList.length,
            itemBuilder: (context, index) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _onLocationSelected(controller.addressList[index]);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36.w,
                          height: 36.h,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                ? primaryColor.withValues(alpha: 0.1)
                                : Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.place_outlined,
                            color: primaryColor,
                            size: 18,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: CustomText(
                            title:
                                controller.addressList[index]['description'] ??
                                '',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: primaryBlack,
                            maxLines: 10,
                            textAlign: TextAlign.start,
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(32.w),
      child: Column(
        children: [
          Icon(
            Icons.location_searching_rounded,
            size: 64,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 16.h),
          Text(
            controller.addressController.text.isNotEmpty
                ? 'No locations found'
                : 'Search for locations',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            controller.addressController.text.isNotEmpty
                ? 'Try a different search term'
                : 'Enter an address or place name to find locations',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  void _onLocationSelected(Map<String, dynamic> searchPlace) async {
    controller.addressController.text = searchPlace['description'] ?? '';
    controller.address.value = searchPlace['description'] ?? '';
    getIt<LocationController>().updateLocation(
      lat: double.parse(searchPlace['lat']),
      lng: double.parse(searchPlace['lng']),
    );
    controller.addressList.value = [];
    _isLoading.value = false;
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }

    Get.back();
    await getIt<HomeController>().getHomeApi();
  }

  void _showCurrentLocationLoader() {
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 40.w,
              height: 40.h,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Getting your current location...',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );

    // Auto close after 3 seconds if still open
    Future.delayed(Duration(seconds: 3), () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }
}

// Updated Debouncer class with cancel method
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void cancel() {
    _timer?.cancel();
  }
}

// class SearchLocation extends StatefulWidget {
//   const SearchLocation({super.key});
//
//   @override
//   State<SearchLocation> createState() => _SearchLocationState();
// }
//
// class _SearchLocationState extends State<SearchLocation> {
//   final controller = getIt<SearchNewController>();
//
//   @override
//   void initState() {
//     controller.addressList.clear();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           margin: const EdgeInsets.only(top: 8, bottom: 8),
//           width: 40.w,
//           height: 4.h,
//           decoration: BoxDecoration(
//             color: Colors.grey.shade300,
//             borderRadius: BorderRadius.circular(2.r),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: TextFormField(
//             minLines: 1,
//             maxLines: 3,
//             keyboardType: TextInputType.multiline,
//             controller: controller.addressController,
//             style: const TextStyle(color: Colors.black),
//             decoration: InputDecoration(
//               suffixIcon: controller.address.isNotEmpty
//                   ? GestureDetector(
//                       onTap: () {
//                         controller.addressController.clear();
//                       },
//                       child: const Icon(Icons.close, size: 20),
//                     )
//                   : const Icon(Icons.search),
//               prefixIcon: Icon(Icons.search, color: mainTextGrey),
//               labelText: 'Search for your location',
//               labelStyle: TextStyle(color: mainTextGrey),
//               contentPadding: const EdgeInsets.all(15),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//                 borderSide: BorderSide(color: lightGrey),
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//                 borderSide: BorderSide(color: lightGrey),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//                 borderSide: BorderSide(color: lightGrey),
//               ),
//             ),
//             autovalidateMode: AutovalidateMode.onUserInteraction,
//             validator: (value) =>
//                 value!.isEmpty ? 'Please search your location' : null,
//             onChanged: (str) {
//               getPlaces(controller.addressController.text.trim()).then((data) {
//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   controller.addressList.value = data;
//                 });
//               });
//             },
//           ),
//         ),
//
//         GestureDetector(
//           onTap: () {
//             controller.getLiveLocation();
//             Navigator.of(context).pop(); // Close after selection
//           },
//           child: Container(
//             margin: const EdgeInsets.symmetric(horizontal: 15),
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               border: Border.all(color: lightGrey),
//               borderRadius: BorderRadius.circular(8.r),
//             ),
//             child: Center(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.my_location_outlined,
//                     color: primaryColor,
//                     size: 20,
//                   ),
//                   const SizedBox(width: 10),
//                   Text(
//                     'Use current location',
//                     style: TextStyle(color: primaryColor),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         const Divider(),
//         Obx(
//           () => controller.addressList.isNotEmpty
//               ? ListView.separated(
//                   shrinkWrap: true,
//                   separatorBuilder: (_, index) =>
//                       const Divider(endIndent: 20, indent: 20),
//                   itemCount: controller.addressList.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       leading: const Icon(Icons.location_on_outlined),
//                       title: Text(
//                         controller.addressList[index]['description'] ?? '',
//                       ),
//                       onTap: () {
//                         final searchPlace = controller.addressList[index];
//                         controller.addressController.text =
//                             searchPlace['description'];
//                         controller.address.value = searchPlace['description'];
//                         // Get.find<HomeControllerC>().area.value =
//                         //     searchPlace['area'];
//                         // Get.find<HomeControllerC>().city.value =
//                         //     searchPlace['city'];
//                         // Get.find<HomeControllerC>().state.value =
//                         //     searchPlace['state'];
//                         // Get.find<HomeControllerC>().country.value =
//                         //     searchPlace['country'];
//                         // controller.lat.value = searchPlace['lat'];
//                         // controller.lng.value = searchPlace['lng'];
//
//                         print('searchPlace');
//                         print(searchPlace['description']);
//                         print(searchPlace['lat']);
//                         print(searchPlace['lng']);
//                         controller.addressList.value = [];
//                         Get.back();
//                       },
//                     );
//                   },
//                 )
//               : const SizedBox(),
//         ),
//       ],
//     );
//   }
// }
