import 'package:businessbuddy/utils/exported_path.dart';

class RecruitmentFilter extends StatefulWidget {
  const RecruitmentFilter({super.key});

  @override
  State<RecruitmentFilter> createState() => _RecruitmentFilterState();
}

class _RecruitmentFilterState extends State<RecruitmentFilter> {
  final controller = getIt<PartnerDataController>();

  @override
  void initState() {
    loadAllData();
    super.initState();
  }

  Future<void> loadAllData() async {
    controller.isFilterLoading.value = true;
    await Future.wait([
      controller.getWulf(),
      getIt<ExplorerController>().getCategories(),
    ]);
    controller.isFilterLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.85,
      minChildSize: 0.50,
      builder: (_, scroll) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                Text(
                  "Filters",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 15),

                Expanded(
                  child: Obx(
                    () => controller.isFilterLoading.isTrue
                        ? LoadingWidget(color: primaryColor)
                        : Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: SingleChildScrollView(
                              controller: scroll,
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              child: Column(
                                spacing: 16.h,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// CATEGORY
                                  dropList(
                                    getIt<ExplorerController>().categories,
                                    controller.selectedCategory.value,
                                    (v) {
                                      controller.selectedCategory.value = v;
                                    },
                                    "Category",
                                    true,
                                  ),

                                  /// LOOKING FOR
                                  dropList(
                                    controller.wulfList,
                                    controller.lookingFor.value,
                                    (v) async {
                                      controller.lookingFor.value = v;
                                      controller.selectedExp.value = null;
                                      await controller.getCapacity(v);
                                    },
                                    "Looking For",
                                    true,
                                  ),

                                  _buildCapacity(),

                                  /// LOCATION
                                  _buildLocationSearch(),

                                  /// SORT ORDER
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Sort Order", style: title),
                                      Row(
                                        children: [
                                          radioTile("Ascending"),
                                          radioTile("Descending"),
                                        ],
                                      ),
                                    ],
                                  ),

                                  // SizedBox(height: 35),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),

                /// BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                          controller.resetFilter();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red),
                        ),
                        child: Text(
                          "Reset",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          controller.changeTab(0);
                          await controller.getBusinessRequired(isRefresh: true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          "Apply",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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

  Widget radioTile(String text) {
    return Row(
      children: [
        Radio(
          value: text,
          groupValue: controller.sort.value,

          onChanged: (v) => controller.sort.value = v.toString(),
          activeColor: primaryColor,
        ),
        Text(text),
      ],
    );
  }

  Widget _buildCapacity() {
    return Obx(() {
      String title;

      switch (controller.lookingFor.value) {
        case '1':
          title = 'Investment Capacity(Lacks)';
          break;
        case '2':
          title = 'Investment Requirement(Lacks)';
          break;
        case '3':
          title = 'Experience(Years)';
          break;
        default:
          title = 'Investment Capacity(Lacks)';
      }

      return controller.isLoading.isTrue
          ? LoadingWidget(color: primaryColor)
          : AppDropdownField(
              isDynamic: true,
              title: title,
              // value: controller.invCapacity.value,
              items: controller.capacityList,
              hintText: title,
              validator: (value) =>
                  value == null ? 'Please select $title' : null,
              onChanged: (val) {
                controller.selectedExp.value = val!;
              },
            );
    });
  }

  Widget _buildLocationSearch() {
    return LocationSearchField(
      label: 'Location',
      hintText: 'Location',
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
    //       padding: const EdgeInsets.only(left: 8.0),
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
  //   //
  //   // debugPrint('Selected location: ${searchPlace['description']}');
  //   // debugPrint('Latitude: ${searchPlace['lat']}');
  //   // debugPrint('Longitude: ${searchPlace['lng']}');
  //
  //   controller.addressList.value = [];
  //   _isSearchingLocation.value = false;
  //   // Get.back();
  // }

  TextStyle get title => TextStyle(fontSize: 15, fontWeight: FontWeight.w600);
}
