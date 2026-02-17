import 'package:businessbuddy/utils/exported_path.dart';

class EditBusiness extends StatefulWidget {
  const EditBusiness({super.key});

  @override
  State<EditBusiness> createState() => _EditBusinessState();
}

class _EditBusinessState extends State<EditBusiness> {
  final navController = getIt<NavigationController>();
  final controller = getIt<LBOController>();
  final expController = getIt<ExplorerController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      expController.getCategories();
      final args = Get.arguments;
      if (args != null && args['data'] != null) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(
          args['data'],
        );

        controller.setBusinessDetails(data);
      }
    });
    getUserNumber();
    super.initState();
  }

  void getUserNumber() async {
    controller.numberCtrl.text =
        await LocalStorage.getString('mobile_no') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(child: _buildBody()),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Theme.of(context).brightness == Brightness.light
                ? [primaryColor.withValues(alpha: 0.5), Colors.white]
                : [primaryColor, Colors.black54],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      title: CustomText(
        title: "Edit Business",
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        color: primaryBlack,
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Form(
        key: controller.businessKey,
        child: Column(
          spacing: 8,
          children: [
            Row(
              spacing: 12.w,
              children: [
                _buildProfileImage(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildLabel('Business/Shop Name'),
                      buildTextField(
                        fillColor: Theme.of(
                          Get.context!,
                        ).scaffoldBackgroundColor,
                        controller: controller.shopName,
                        hintText: 'Enter Business/Shop Name',
                        keyboardType: TextInputType.name,
                        validator: (value) => value!.trim().isEmpty
                            ? 'Please enter Business/Shop Name'
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _buildLocation(),
            _buildNumber(),
            _buildWhatsapp(),
            _buildCategory(),

            _buildAbout(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: buildLabel('Attachments'),
                ),
                GestureDetector(
                  onTap: () {
                    CustomFilePicker.showPickerBottomSheet(
                      allowMultipleDocuments: true,
                      onFileMultiPicked: (files) {
                        controller.attachments.addAll(files);
                      },
                      onFilePicked: (file) {
                        controller.attachments.add(file);
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.add_circle_outline_outlined),
                  ),
                ),
              ],
            ),
            _buildImageGallery(),
            _buildSelectedFilesWrap(),

            // _buildUploadDocuments(),
            // _buildPostAndOffersSection(),
            Obx(
              () => controller.isAddBusinessLoading.isTrue
                  ? LoadingWidget(color: primaryColor)
                  : _buildActionButtons(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: controller.pickImage,
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            radius: 41.r,
            child: CircleAvatar(
              radius: 40.r,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Obx(() {
                  final image = controller.businessDetails['image'];
                  final imageFile = controller.profileImage.value;
                  final ImageProvider<Object> imageProvider = imageFile != null
                      ? FileImage(imageFile)
                      : NetworkImage(image);

                  return FadeInImage(
                    placeholder: const AssetImage(Images.defaultImage),
                    image: imageProvider,
                    width: 100.w,
                    height: 100.h,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        Images.defaultImage,
                        width: 100.w,
                        height: 100.h,
                        fit: BoxFit.contain,
                      );
                    },
                    fit: BoxFit.contain,
                    placeholderFit: BoxFit.contain,
                    fadeInDuration: const Duration(milliseconds: 300),
                  );
                }),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 14.r,
              backgroundColor: primaryColor,
              child: Icon(Icons.edit, size: 12.sp, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocation() {
    return LocationSearchField(
      label: 'Address',
      hintText: 'Address',
      controller: controller.addressController,
      results: controller.addressList,
      onSearch: (query) => getPlaces(query),
      onSelected: (place) {
        controller.addressController.text = place['description'];
        controller.lat.value = place['lat'];
        controller.lng.value = place['lng'];
      },
    );

    // Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     _buildLabel('Address'),
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
  //
  // Widget _buildLabel(String label) {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 8.0),
  //     child: buildLabel(label),
  //   );
  // }
  //
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
  //       hintText: 'Enter your address...',
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
  //         value!.isEmpty ? 'Please search your address' : null,
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
  //         'Searching address...',
  //         style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
  //       ),
  //     ],
  //   );
  // }

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

  // Widget _buildAddress() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(left: 8.0),
  //         child: buildLabel('Address'),
  //       ),
  //       buildTextField(
  //         controller: controller.address,
  //         hintText: 'Enter Address',
  //         validator: (value) =>
  //             value!.trim().isEmpty ? 'Please enter Address' : null,
  //       ),
  //     ],
  //   );
  // }

  Widget _buildNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: buildLabel('Mobile Number'),
        ),
        buildTextField(
          enabled: false,
          fillColor: Theme.of(Get.context!).scaffoldBackgroundColor,
          controller: controller.numberCtrl,
          hintText: 'Enter your mobile number',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter mobile number';
            }
            if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
              return 'Enter a valid mobile number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildWhatsapp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: buildLabel('Whatsapp Number'),
        ),
        buildTextField(
          fillColor: Theme.of(Get.context!).scaffoldBackgroundColor,
          // enabled: false,
          controller: controller.whatsappCtrl,
          hintText: 'Enter your Whatsapp number',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: (v) {
            return null;
          },
          // validator: (value) {
          //   if (value == null || value.isEmpty) {
          //     return 'Please enter Whatsapp number';
          //   }
          //   if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
          //     return 'Enter a valid Whatsapp number';
          //   }
          //   return null;
          // },
        ),
      ],
    );
  }

  Widget _buildCategory() {
    return Obx(
      () => expController.isLoading.isTrue
          ? LoadingWidget(color: primaryColor)
          : AppDropdownField(
              title: 'Category',
              isDynamic: true,
              value: controller.offering.value,
              items: expController.categories,
              hintText: 'Eg. Salon, Spa',
              validator: (value) =>
                  value == null ? 'Please select Category' : null,
              onChanged: (val) async {
                controller.offering.value = val!;
              },
            ),
    );
  }

  Widget _buildAbout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: buildLabel('About Business'),
        ),
        buildTextField(
          maxLines: 3,
          fillColor: Theme.of(Get.context!).scaffoldBackgroundColor,
          controller: controller.aboutCtrl,
          hintText: 'Enter about',
          validator: (value) =>
              value!.trim().isEmpty ? 'Please enter about' : null,
        ),
      ],
    );
  }

  Widget _buildImageGallery() {
    return Obx(() {
      if (controller.oldAttachments.isEmpty) return Container();
      return SizedBox(
        height: 80.h,
        child: ListView.separated(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          itemCount: controller.oldAttachments.length,
          separatorBuilder: (_, __) => SizedBox(width: 12.w),
          itemBuilder: (context, index) {
            final attach = controller.oldAttachments[index];
            return _buildGalleryImage(attach, index);
          },
        ),
      );
    });
  }

  Widget _buildGalleryImage(dynamic attach, int i) {
    return Container(
      width: 80.w,
      height: 80.h,
      decoration: BoxDecoration(
        border: Border.all(color: lightGrey),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: Get.width * 0.25.w,
            height: Get.width * 0.25.w,
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: WidgetZoom(
              heroAnimationTag: 'tag $attach',
              zoomWidget: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: FadeInImage(
                  placeholder: const AssetImage(Images.defaultImage),
                  image: NetworkImage(attach),
                  fit: BoxFit.contain,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Container(
                      padding: EdgeInsets.all(20.w),
                      child: Image.asset(
                        Images.defaultImage,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                  fadeInDuration: const Duration(milliseconds: 300),
                ),
              ),
            ),
          ),

          Positioned(
            top: -10,
            right: -10,
            child: InkWell(
              onTap: () {
                controller.oldAttachments.removeAt(i);
              },
              child: CircleAvatar(
                radius: 10.r,
                backgroundColor: Colors.red,
                child: Icon(Icons.close, size: 12.sp, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildUploadDocuments() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(12),
  //       color: Colors.white,
  //     ),
  //     child: GestureDetector(
  //       onTap: () {
  //         CustomFilePicker.showPickerBottomSheet(
  //           onFilePicked: (file) {
  //             controller.attachments.add(file);
  //           },
  //         );
  //       },
  //       child: DottedBorder(
  //         dashPattern: [10, 5],
  //         borderType: BorderType.RRect,
  //         radius: const Radius.circular(10),
  //         color: primaryGrey,
  //         strokeWidth: 1,
  //         padding: const EdgeInsets.all(16),
  //         child: Container(
  //           width: Get.width,
  //           padding: const EdgeInsets.all(8),
  //           decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
  //           margin: const EdgeInsets.all(16),
  //           child: Column(
  //             spacing: 8.h,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               HugeIcon(icon: HugeIcons.strokeRoundedAddCircle),
  //               Text(
  //                 'Upload Images'.tr,
  //                 style: TextStyle(decoration: TextDecoration.underline),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildSelectedFilesWrap() {
    return Obx(
      () => controller.attachments.isEmpty
          ? SizedBox()
          : SizedBox(
              height: 80.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.attachments.length,
                separatorBuilder: (_, __) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  final attach = controller.attachments[index];
                  final isImage =
                      attach.path.endsWith('.jpg') ||
                      attach.path.endsWith('.png');
                  return Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: Get.width * 0.25.w,
                          height: Get.width * 0.25.w,
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: isImage
                              ? Image.file(attach, fit: BoxFit.contain)
                              : Center(
                                  child: HugeIcon(
                                    icon: HugeIcons
                                        .strokeRoundedDocumentAttachment,
                                    size: 40.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                        Positioned(
                          top: -6,
                          right: -10,
                          child: InkWell(
                            onTap: () {
                              controller.attachments.removeAt(index);
                            },
                            child: CircleAvatar(
                              radius: 10.r,
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.close,
                                size: 12.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

      //     Wrap(
      //   spacing: 16,
      //   runSpacing: 8,
      //   children: controller.attachments.map((file) {
      //     final isImage =
      //         file.path.endsWith('.jpg') || file.path.endsWith('.png');
      //
      //     return Stack(
      //       clipBehavior: Clip.none,
      //       children: [
      //         Container(
      //           width: Get.width * 0.25.w,
      //           height: Get.width * 0.25.w,
      //           padding: EdgeInsets.all(6),
      //           decoration: BoxDecoration(
      //             border: Border.all(color: Colors.grey),
      //             borderRadius: BorderRadius.circular(10),
      //           ),
      //           child: isImage
      //               ? Image.file(file, fit: BoxFit.cover)
      //               : Center(
      //                   child: HugeIcon(
      //                     icon: HugeIcons.strokeRoundedDocumentAttachment,
      //                     size: 40.sp,
      //                     color: Colors.grey,
      //                   ),
      //                 ),
      //         ),
      //         Positioned(
      //           top: -10,
      //           right: -10,
      //           child: InkWell(
      //             onTap: () {
      //               controller.attachments.remove(file);
      //             },
      //             child: CircleAvatar(
      //               radius: 10.r,
      //               backgroundColor: Colors.red,
      //               child: Icon(Icons.close, size: 12.sp, color: Colors.white),
      //             ),
      //           ),
      //         ),
      //       ],
      //     );
      //   }).toList(),
      // ),
    );
  }

  // Widget _buildPostAndOffersSection() {
  //   return DefaultTabController(
  //     length: 2,
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(12.r),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.grey.withValues(alpha: 0.1),
  //             blurRadius: 8,
  //             offset: const Offset(0, 2),
  //           ),
  //         ],
  //       ),
  //       child: Column(
  //         children: [
  //           _buildTabBar(),
  //           Obx(() {
  //             return IndexedStack(
  //               index: controller.tabIndex.value,
  //               children: [
  //                 buildGridImages(
  //                   controller.businessDetails['posts'],
  //                   'post',
  //                   isEdit: true,
  //                 ),
  //                 buildGridImages(
  //                   controller.businessDetails['offers'],
  //                   'offer',
  //                   isEdit: true,
  //                 ),
  //               ],
  //             );
  //           }),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildTabBar() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.grey.shade50,
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(12.r),
  //         topRight: Radius.circular(12.r),
  //       ),
  //     ),
  //     child: TabBar(
  //       onTap: (i) {
  //         controller.tabIndex.value = i;
  //       },
  //       indicatorColor: primaryColor,
  //       labelColor: primaryColor,
  //       indicatorSize: TabBarIndicatorSize.tab,
  //       unselectedLabelColor: Colors.grey.shade600,
  //       indicatorWeight: 2.0,
  //       labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
  //       unselectedLabelStyle: TextStyle(
  //         fontSize: 14.sp,
  //         fontWeight: FontWeight.w500,
  //       ),
  //       tabs: const [
  //         Tab(text: 'Posts'),
  //         Tab(text: 'Offers'),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.close,
            text: 'Close',
            onPressed: () => Get.back(),
            backgroundColor: primaryColor,
            isPrimary: false,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildActionButton(
            icon: Icons.add,
            text: 'Update',
            onPressed: () async {
              if (controller.businessKey.currentState!.validate()) {
                await controller.editBusiness(
                  controller.businessDetails['id']?.toString() ?? '',
                );
              }
            },
            backgroundColor: Colors.transparent,
            isPrimary: true,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isPrimary ? primaryColor : Colors.transparent,
          border: Border.all(
            color: isPrimary ? primaryColor : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: CustomText(
          title: text,
          fontSize: 16.sp,
          color: isPrimary ? Colors.white : primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
