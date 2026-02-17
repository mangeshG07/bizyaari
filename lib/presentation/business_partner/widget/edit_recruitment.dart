import 'package:businessbuddy/utils/exported_path.dart';
import 'package:dropdown_search/dropdown_search.dart';

class EditRecruitment extends StatefulWidget {
  final dynamic recruitmentData;
  const EditRecruitment({super.key, required this.recruitmentData});

  @override
  State<EditRecruitment> createState() => _EditRecruitmentState();
}

class _EditRecruitmentState extends State<EditRecruitment> {
  final controller = getIt<PartnerDataController>();
  final navController = getIt<NavigationController>();
  final catController = getIt<ExplorerController>();

  @override
  void initState() {
    loadAllData();
    controller.preselectedRecruitment(widget.recruitmentData);
    super.initState();
  }

  Future<void> loadAllData() async {
    controller.isMainLoading.value = true;
    await Future.wait([controller.getWulf(), catController.getCategories()]);
    controller.isMainLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isMainLoading.isTrue
          ? LoadingWidget(color: primaryColor)
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Form(
                key: controller.partnerKey,
                child: Column(
                  spacing: 8.h,
                  children: [
                    _buildHeader(),
                    Divider(height: 5),
                    _buildTitle(),
                    _businessInterest(),
                    _buildLocation(),
                    _buildInvestmentType(),
                    _buildCapacity(),
                    Obx(() {
                      if (controller.invType.value == '2') {
                        return _buildCanInvest();
                      }
                      return SizedBox();
                    }),
                    _buildHistory(),
                    _buildNote(),
                    // Obx(
                    //   () => Center(
                    //     child: SwitchListTile(
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(12.r),
                    //         side: BorderSide(color: Colors.grey, width: 0.2),
                    //       ),
                    //       title: Text('Is this requirement completed?'),
                    //       value: controller.isCompleted.value,
                    //       onChanged: (newValue) {
                    //         controller.isCompleted.value = newValue;
                    //       },
                    //       activeThumbColor: primaryColor,
                    //       inactiveThumbColor: lightGrey,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 12.h),
                    _buildPostButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 8,
            children: [
              GestureDetector(
                onTap: () => navController.goBack(),
                child: const Icon(Icons.arrow_back),
              ),
              CustomText(
                title: 'Edit Post Recruitment',
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: primaryBlack,
              ),
            ],
          ),
          // Obx(
          //   () => Switch(
          //     activeTrackColor: primaryColor.withValues(alpha: 0.1),
          //     inactiveThumbColor: primaryColor,
          //     activeThumbColor: primaryColor,
          //     inactiveTrackColor: lightGrey,
          //     onChanged: (newValue) {
          //       controller.isCompleted.value = newValue;
          //     },
          //     value: controller.isCompleted.value,
          //     trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((
          //       states,
          //     ) {
          //       if (states.contains(WidgetState.selected)) {
          //         return primaryColor;
          //       }
          //       return Colors.grey;
          //     }),
          //     trackOutlineWidth: WidgetStateProperty.resolveWith<double?>((
          //       states,
          //     ) {
          //       if (states.contains(WidgetState.selected)) {
          //         return 0; // No border when switch is ON
          //       }
          //       return 0.5; // Border when OFF
          //     }),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Recruitment Title'),
        buildTextField(
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          controller: controller.recTitle,
          hintText: 'Enter your Recruitment Title',
          validator: (value) =>
              value!.trim().isEmpty ? 'Please enter Recruitment Title' : null,
        ),
      ],
    );
  }

  Widget _businessInterest() {
    return Column(
      children: [
        _buildLabel('Business Interest'),
        DropdownSearch<String>.multiSelection(
          selectedItems: controller.selectedBusiness,
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              filled: true,
              border: buildOutlineInputBorder(),
              enabledBorder: buildOutlineInputBorder(),
              focusedBorder: buildOutlineInputBorder(),
              contentPadding: const EdgeInsets.all(12),
              hintText: 'Business Interest',
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select Interest';
            }
            return null;
          },
          items: (filter, infiniteScrollProps) => catController.categories
              .map((item) => item['name'].toString())
              .toList(),
          popupProps: PopupPropsMultiSelection.menu(
            showSelectedItems: false,
            menuProps: MenuProps(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            constraints: const BoxConstraints(maxHeight: 300),
          ),
          onChanged: (List<String> selectedItems) {
            controller.selectedBusiness.value = selectedItems;
          },
        ),
      ],
    );
  }

  Widget _buildLocation() {
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
      },
    );
  }
  //   Column(
  //   crossAxisAlignment: CrossAxisAlignment.start,
  //   children: [
  //     _buildLabel('Location'),
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

  // Widget _buildLocation() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _buildLabel('Location'),
  //       buildTextField(
  //         controller: controller.location,
  //         hintText: 'Enter your Location',
  //         validator: (value) =>
  //             value!.trim().isEmpty ? 'Please enter Location' : null,
  //       ),
  //     ],
  //   );
  // }

  Widget _buildInvestmentType() {
    return AppDropdownField(
      isDynamic: true,
      title: 'What are u looking for',
      value: controller.invType.value,
      items: controller.wulfList,
      hintText: 'Select your Investment',
      validator: (value) => value == null ? 'Please select Investment' : null,
      onChanged: (val) async {
        controller.invType.value = val!;
        controller.invCapacity.value = null;
        await controller.getCapacity(val);
      },
    );
  }

  Widget _buildCanInvest() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('I can Invest'),
        buildTextField(
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          controller: controller.iCanInvest,
          hintText: 'Enter your i can Invest',
          validator: (value) =>
              value!.trim().isEmpty ? 'Please enter i can Invest' : null,
        ),
      ],
    );
  }

  Widget _buildCapacity() {
    return Obx(() {
      String title;

      switch (controller.invType.value) {
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
              value: controller.invCapacity.value,
              items: controller.capacityList,
              hintText: title,
              validator: (value) =>
                  value == null ? 'Please select $title' : null,
              onChanged: (val) {
                controller.invCapacity.value = val!;
              },
            );
    });
  }

  Widget _buildHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Investment History'),
        buildTextField(
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          controller: controller.invHistory,
          hintText: 'Enter Investment History ',
          validator: (value) =>
              value!.trim().isEmpty ? 'Please enter Investment History ' : null,
        ),
      ],
    );
  }

  Widget _buildNote() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Note'),
        buildTextField(
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          controller: controller.notes,
          hintText: 'Enter Note ',
          validator: (value) =>
              value!.trim().isEmpty ? 'Please enter Note' : null,
        ),
      ],
    );
  }

  Widget _buildPostButton() {
    return Obx(
      () => controller.isAddLoading.isTrue
          ? LoadingWidget(color: primaryColor)
          : GestureDetector(
              onTap: () async {
                if (controller.partnerKey.currentState!.validate()) {
                  await controller.editBusinessRequired(
                    widget.recruitmentData['id']?.toString() ?? '',
                  );
                }
              },
              child: Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                margin: EdgeInsets.only(bottom: 14.h),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
                child: CustomText(
                  title: 'Update',
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: buildLabel(label),
    );
  }

  List<String> getIdsByNames(List<String> names) {
    return names
        .map((name) {
          final item = catController.categories.firstWhere(
            (e) => e['name'] == name,
            orElse: () => null,
          );
          return item?['id'].toString() ?? '';
        })
        .where((id) => id.isNotEmpty)
        .toList();
  }
}
