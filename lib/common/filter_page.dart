import 'package:businessbuddy/utils/exported_path.dart';

class FeedSheet extends StatefulWidget {
  final String isFrom;

  const FeedSheet({super.key, required this.isFrom});

  @override
  State<FeedSheet> createState() => _FeedSheetState();
}

class _FeedSheetState extends State<FeedSheet> {
  final controller = getIt<SpecialOfferController>();
  final _explorerController = getIt<ExplorerController>();
  // final _debouncer = Debouncer(milliseconds: 500);
  // final RxBool _isSearchingLocation = false.obs;

  @override
  void initState() {
    super.initState();
    _explorerController.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 0.85.h,
      minChildSize: 0.5.h,
      builder: (_, scroll) {
        return SafeArea(child: _buildMainContent(scroll));
      },
    );
  }

  Widget _buildMainContent(ScrollController scroll) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDragHandle(),
          _buildTitle(),
          const SizedBox(height: 16),
          _buildFilterContent(scroll),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40.w,
        height: 5.h,
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: lightGrey,
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Filters",
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: primaryBlack,
      ),
    );
  }

  Widget _buildFilterContent(ScrollController scroll) {
    return Expanded(
      child: Obx(
        () => _explorerController.isLoading.isTrue
            ? LoadingWidget(color: primaryColor)
            : SingleChildScrollView(
                controller: scroll,
                child: Column(
                  spacing: 16.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// CATEGORY
                    dropList(
                      _explorerController.categories,
                      controller.selectedCategory.value,
                      (v) {
                        controller.selectedCategory.value = v;
                      },
                      'Category',
                      true,
                    ),

                    /// LOCATION
                    _buildLocationSearch(),

                    /// DATE RANGE
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8.0, bottom: 6),
                          child: buildLabel("Date Range"),
                        ),
                        Container(
                          decoration: box,
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            dense: true,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.red,
                                width: 0.2,
                              ), //
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            title: Obx(
                              () => Text(
                                controller.selectedDateRange.value ??
                                    "Select Date Range",
                                style: TextStyle(
                                  color: primaryBlack,
                                ),
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (controller.selectedDateRange.value != null)
                                  IconButton(
                                    icon: Icon(Icons.clear, size: 20),
                                    onPressed: controller.resetData,
                                    color: Colors.grey,
                                  ),
                                Icon(Icons.calendar_today, size: 20),
                              ],
                            ),
                            onTap: controller.pickCustomDateRange,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildLocationSearch() {
    return LocationSearchField(
      controller: controller.addressController,
      results: controller.addressList,
      onSearch: (query) => getPlaces(query),
      onSelected: (place) {
        controller.addressController.text = place['description'];
        controller.lat.value = place['lat'];
        controller.lng.value = place['lng'];

        // debugPrint('Selected: ${place['description']}');
      },
    );

    //   Column(
    //   children: [
    //     Padding(
    //       padding: EdgeInsets.only(left: 8.0),
    //       child: buildLabel("Location"),
    //     ),
    //     _buildSearchField(),
    //     Obx(
    //       () => _isSearchingLocation.value
    //           ? _buildLoadingIndicator()
    //           : controller.addressList.isNotEmpty
    //           ? _buildResultsList()
    //           : SizedBox(),
    //     ),
    //   ],
    // );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              controller.selectedCategory.value = null;
              controller.selectedLocation.value = null;
              controller.customStart = null;
              controller.customEnd = null;
              controller.selectedDateRange.value = null;
              controller.isApply.value = false;
              controller.addressController.clear();
              controller.addressList.value = [];
              // _isSearchingLocation.value = false;
              getIt<SpecialOfferController>().lat.value = '';
              getIt<SpecialOfferController>().lng.value = '';
              Get.back();
              // if (widget.isFrom == 'feed') {
              //   await getIt<FeedsController>().getFeeds();
              // } else {
              //   await controller.getSpecialOffer();
              // }
              widget.isFrom == 'feed'
                  ? await getIt<FeedsController>().getFeeds(
                      isRefresh: true,
                      showLoading: true,
                    )
                  : await controller.getSpecialOffer(isRefresh: true);
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.red),
            ),
            child: Text("Reset", style: TextStyle(color: Colors.red)),
          ),
        ),

        SizedBox(width: 12.w),

        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              Get.back();
              controller.isApply.value = true;
              widget.isFrom == 'feed'
                  ? await getIt<FeedsController>().getFeeds(isRefresh: true)
                  : await controller.getSpecialOffer(isRefresh: true);
            },
            style: ElevatedButton.styleFrom(
              surfaceTintColor: Colors.white,
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text("Apply", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  // CUSTOM UI COMPONENTS
  Widget dropList(
    List items,
    String? selected,
    Function(String) onSelect,
    String title,
    bool isDynamic,
  ) {
    return AppDropdownField(
      isDynamic: isDynamic,
      title: title,
      value: selected,
      items: items,
      hintText: 'Select your $title',
      validator: (value) => value == null ? 'Please select $title' : null,
      onChanged: (v) => onSelect(v!),
    );
  }

  BoxDecoration get box => BoxDecoration(
    color: Theme.of(context).scaffoldBackgroundColor,
    borderRadius: BorderRadius.circular(10.r),
    border: Border.all(color: Colors.grey, width: 0.2),
  );

  // Widget _buildSearchField() {
  //   return TextFormField(
  //     minLines: 1,
  //     maxLines: 3,
  //     keyboardType: TextInputType.text,
  //     controller: controller.addressController,
  //     style: TextStyle(color: Colors.black, fontSize: 16.sp),
  //     decoration: InputDecoration(
  //       filled: true,
  //       fillColor: Colors.white,
  //       suffixIcon: controller.addressController.text.isNotEmpty
  //           ? GestureDetector(
  //               onTap: () {
  //                 controller.addressController.clear();
  //                 controller.addressList.value = [];
  //                 _isSearchingLocation.value = false;
  //                 setState(() {});
  //               },
  //               child: Container(
  //                 margin: EdgeInsets.all(8.w),
  //                 decoration: BoxDecoration(
  //                   color: Colors.grey.shade200,
  //                   shape: BoxShape.circle,
  //                 ),
  //                 child: Icon(
  //                   Icons.close,
  //                   size: 18,
  //                   color: Colors.grey.shade600,
  //                 ),
  //               ),
  //             )
  //           : Icon(Icons.search, color: mainTextGrey),
  //
  //       // prefixIcon: Icon(Icons.search, color: primaryColor, size: 22),
  //       hintText: 'Enter your location...',
  //       hintStyle: TextStyle(color: mainTextGrey, fontSize: 14.sp),
  //       contentPadding: EdgeInsets.all(16.w),
  //       enabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12.r),
  //         borderSide: BorderSide(color: Colors.grey.shade300),
  //       ),
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12.r),
  //         borderSide: BorderSide(color: Colors.grey.shade300),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12.r),
  //         borderSide: BorderSide(color: primaryColor, width: 1.5),
  //       ),
  //     ),
  //     autovalidateMode: AutovalidateMode.onUserInteraction,
  //     validator: (value) =>
  //         value!.isEmpty ? 'Please search your location' : null,
  //     onChanged: (str) {
  //       if (str.trim().isEmpty) {
  //         controller.addressList.value = [];
  //         _isSearchingLocation.value = false;
  //         return;
  //       }
  //
  //       _isSearchingLocation.value = true;
  //       _debouncer.run(() {
  //         getPlaces(str.trim())
  //             .then((data) {
  //               WidgetsBinding.instance.addPostFrameCallback((_) {
  //                 controller.addressList.value = data;
  //                 _isSearchingLocation.value = false;
  //               });
  //             })
  //             .catchError((error) {
  //               WidgetsBinding.instance.addPostFrameCallback((_) {
  //                 _isSearchingLocation.value = false;
  //                 controller.addressList.value = [];
  //               });
  //             });
  //       });
  //     },
  //   );
  // }
  //
  // Widget _buildLoadingIndicator() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       SizedBox(
  //         width: 40.w,
  //         height: 40.h,
  //         child: LoadingWidget(color: primaryColor),
  //       ),
  //       SizedBox(height: 16.h),
  //       Text(
  //         'Searching locations...',
  //         style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
  //       ),
  //     ],
  //   );
  // }
  //
  // Widget _buildResultsList() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.grey.shade50,
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(20.r),
  //         topRight: Radius.circular(20.r),
  //       ),
  //     ),
  //     child: Column(
  //       children: [
  //         Padding(
  //           padding: EdgeInsets.all(16.w),
  //           child: Row(
  //             children: [
  //               Text(
  //                 'Search Results',
  //                 style: TextStyle(
  //                   fontSize: 14.sp,
  //                   fontWeight: FontWeight.w500,
  //                   color: Colors.grey.shade600,
  //                 ),
  //               ),
  //               SizedBox(width: 8.w),
  //               Container(
  //                 padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
  //                 decoration: BoxDecoration(
  //                   color: primaryColor.withValues(alpha: 0.1),
  //                   borderRadius: BorderRadius.circular(8.r),
  //                 ),
  //                 child: Text(
  //                   '${controller.addressList.length}',
  //                   style: TextStyle(
  //                     fontSize: 12.sp,
  //                     fontWeight: FontWeight.w600,
  //                     color: primaryColor,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         ListView.separated(
  //           shrinkWrap: true,
  //           physics: NeverScrollableScrollPhysics(),
  //           padding: EdgeInsets.only(bottom: 16.h),
  //           separatorBuilder: (_, index) => Divider(
  //             height: 1,
  //             indent: 56.w,
  //             endIndent: 16.w,
  //             color: Colors.grey.shade200,
  //           ),
  //           itemCount: controller.addressList.length,
  //           itemBuilder: (context, index) {
  //             return Material(
  //               color: Colors.transparent,
  //               child: InkWell(
  //                 onTap: () {
  //                   _onLocationSelected(controller.addressList[index]);
  //                 },
  //                 child: Container(
  //                   padding: EdgeInsets.symmetric(
  //                     horizontal: 16.w,
  //                     vertical: 12.h,
  //                   ),
  //                   child: Row(
  //                     children: [
  //                       Container(
  //                         width: 36.w,
  //                         height: 36.h,
  //                         decoration: BoxDecoration(
  //                           color: primaryColor.withValues(alpha: 0.1),
  //                           shape: BoxShape.circle,
  //                         ),
  //                         child: Icon(
  //                           Icons.place_outlined,
  //                           color: primaryColor,
  //                           size: 18,
  //                         ),
  //                       ),
  //                       SizedBox(width: 12.w),
  //                       Expanded(
  //                         child: CustomText(
  //                           title:
  //                               controller.addressList[index]['description'] ??
  //                               '',
  //                           fontSize: 14.sp,
  //                           fontWeight: FontWeight.w500,
  //                           color: Colors.black87,
  //                           maxLines: 10,
  //                           textAlign: TextAlign.start,
  //                           // overflow: TextOverflow.ellipsis,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _buildEmptyState() {
  //   return Container(
  //     padding: EdgeInsets.all(32.w),
  //     child: Column(
  //       children: [
  //         Icon(
  //           Icons.location_searching_rounded,
  //           size: 64,
  //           color: Colors.grey.shade300,
  //         ),
  //         SizedBox(height: 16.h),
  //         Text(
  //           controller.addressController.text.isNotEmpty
  //               ? 'No locations found'
  //               : 'Search for locations',
  //           style: TextStyle(
  //             fontSize: 16.sp,
  //             color: Colors.grey.shade500,
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //         SizedBox(height: 8.h),
  //         Text(
  //           controller.addressController.text.isNotEmpty
  //               ? 'Try a different search term'
  //               : 'Enter an address or place name to find locations',
  //           textAlign: TextAlign.center,
  //           style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade400),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // void _onLocationSelected(Map<String, dynamic> searchPlace) {
  //   controller.addressController.text = searchPlace['description'] ?? '';
  //   controller.lat.value = searchPlace['lat'] ?? '';
  //   controller.lng.value = searchPlace['lng'] ?? '';
  //
  //   // Uncomment and use these as needed
  //   // Get.find<HomeControllerC>().area.value = searchPlace['area'];
  //   // Get.find<HomeControllerC>().city.value = searchPlace['city'];
  //   // Get.find<HomeControllerC>().state.value = searchPlace['state'];
  //   // Get.find<HomeControllerC>().country.value = searchPlace['country'];
  //   // controller.lat.value = searchPlace['lat'];
  //   // controller.lng.value = searchPlace['lng'];
  //
  //   // debugPrint('Selected location: ${searchPlace['description']}');
  //   // debugPrint('Latitude: ${searchPlace['lat']}');
  //   // debugPrint('Longitude: ${searchPlace['lng']}');
  //
  //   controller.addressList.value = [];
  //   _isSearchingLocation.value = false;
  //   // Get.back();
  // }
}
