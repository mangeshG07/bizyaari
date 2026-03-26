import 'dart:ui';
import '../../../common/dark_light.dart';
import '../../../common/policy_data.dart';
import '../../../utils/exported_path.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final controller = getIt<ProfileController>();
  final navController = getIt<NavigationController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      checkInternetAndShowPopup();
      controller.helpAndSupport();
      await _checkProfileType();
    });
  }

  Future<void> _checkProfileType() async {
    final userId = Get.arguments['user_id'] ?? 'self';

    if (userId == 'self') {
      controller.isMe.value = true;
      await controller.getProfile();
      await controller.legalPageListApi();
    } else {
      controller.isMe.value = false;
      await controller.getUserProfile(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return LoadingWidget(color: primaryColor);
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [_buildProfileHeader(), _buildProfileContent()],
          ),
        );
      }),
    );
  }

  // ✅---------------- APP BAR ----------------✅
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      foregroundColor: primaryBlack,
      elevation: 0,
      titleSpacing: 0,
      centerTitle: false,
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
      title: Obx(
        () => CustomText(
          title: controller.isMe.isTrue ? "My Account" : 'Profile',
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: primaryBlack,
        ),
      ),
      actions: [
        Obx(() => controller.isMe.isTrue ? _ownerActions() : _visitorActions()),

        // Obx(() {
        //   if (controller.isMe.isFalse) return SizedBox();
        //   return IconButton(
        //     onPressed: () => getIt<ThemeController>().toggleTheme(),
        //     icon: HugeIcon(
        //       icon: Theme.of(context).brightness == Brightness.light
        //           ? HugeIcons.strokeRoundedSun01
        //           : HugeIcons.strokeRoundedMoon02,
        //       color: primaryBlack,
        //     ),
        //   );
        // }),
        // Obx(() {
        //   if (controller.isMe.isFalse) return SizedBox();
        //   return IconButton(
        //     onPressed: () => Get.toNamed(Routes.editProfile),
        //     icon: HugeIcon(
        //       icon: HugeIcons.strokeRoundedPencilEdit02,
        //       color: primaryBlack,
        //     ),
        //   );
        // }),
        // Obx(() {
        //   if (controller.isMe.isFalse) {
        //     return IconButton(
        //       onPressed: () {},
        //       icon: HugeIcon(
        //         icon: HugeIcons.strokeRoundedBubbleChat,
        //         color: primaryBlack,
        //       ),
        //     );
        //   }
        //
        //   return SizedBox();
        // }),
        // Obx(() {
        //   if (controller.isMe.isFalse) {
        //     return Container(
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(12.r),
        //       ),
        //       child: PopupMenuButton<String>(
        //         color: Theme.of(context).brightness == Brightness.light
        //             ? Colors.white
        //             : Get.theme.cardColor,
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(16.r),
        //         ),
        //         elevation: 2,
        //         popUpAnimationStyle: AnimationStyle(curve: Curves.easeInOut),
        //         padding: EdgeInsets.zero,
        //         surfaceTintColor: Colors.white,
        //         icon: Container(
        //           padding: const EdgeInsets.all(8),
        //           margin: const EdgeInsets.only(right: 8),
        //           decoration: BoxDecoration(
        //             shape: BoxShape.circle,
        //             color: Colors.white70,
        //           ),
        //           child: Icon(Icons.more_vert, color: primaryColor),
        //         ),
        //         onSelected: (value) {
        //           _handleMenuSelection(value);
        //         },
        //         itemBuilder: (context) => [
        //           _buildMenuItem(
        //             'block',
        //             controller.isBlocked.isTrue
        //                 ? Icons.u_turn_left_rounded
        //                 : Icons.block,
        //             controller.isBlocked.isTrue ? 'Unblock User' : 'Block User',
        //             primaryColor,
        //           ),
        //         ],
        //       ),
        //     );
        //   }
        //   return SizedBox();
        // }),
      ],
    );
  }

  Widget _ownerActions() {
    return Row(
      children: [
        // IconButton(
        //   onPressed: () => getIt<ThemeController>().toggleTheme(),
        //   icon: HugeIcon(
        //     icon: Theme.of(context).brightness == Brightness.light
        //         ? HugeIcons.strokeRoundedSun01
        //         : HugeIcons.strokeRoundedMoon02,
        //     color: primaryBlack,
        //   ),
        // ),
        const ThemeToggleButton(
          showLabel: true,
          labelPosition: LabelPosition.left,
        ),
        IconButton(
          onPressed: () => Get.toNamed(Routes.editProfile),
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedPencilEdit02,
            color: primaryBlack,
          ),
        ),
      ],
    );
  }

  Widget _visitorActions() {
    return Row(
      children: [
        Obx(() {
          return controller.isBlocked.isFalse
              ? IconButton(
                  onPressed: () async => _handleChatAction(),
                  icon: _buildChatIcon(),
                )
              : SizedBox();
        }),

        // IconButton(
        //   onPressed: () async {
        //     controller.profileDetails['chat_initiated'] == true
        //         ? {
        //             Get.back(),
        //             getIt<NavigationController>().openSubPage(
        //               SingleChat(
        //                 chatId:
        //                     controller.profileDetails['chat_id']?.toString() ??
        //                     '',
        //               ),
        //             ),
        //           }
        //         : controller.profileDetails['request_sent'] == true
        //         ? controller.profileDetails['is_request_accepted'] == true
        //               ? await getIt<InboxController>().initiateChat(
        //                   from: 'profile',
        //                   otherUserId: controller
        //                       .profileDetails['other_user_id']
        //                       .toString(),
        //                   type: 'user_to_user',
        //                 )
        //               : null
        //         : await controller.sendChatReq(
        //             controller.profileDetails['id']?.toString() ?? '',
        //           );
        //   },
        //   icon: controller.profileDetails['chat_initiated'] == true
        //       ? HugeIcon(
        //           icon: HugeIcons.strokeRoundedBubbleChat,
        //           color: primaryBlack,
        //         )
        //       : controller.profileDetails['request_sent'] == true
        //       ? controller.profileDetails['is_request_accepted'] == true
        //             ? HugeIcon(
        //                 icon: HugeIcons.strokeRoundedBubbleChat,
        //                 color: primaryBlack,
        //               )
        //             : HugeIcon(
        //                 icon: HugeIcons.strokeRoundedLoading01,
        //                 color: primaryBlack,
        //               )
        //       : Image.asset(Images.sendReq),
        // ),
        Container(
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
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white70,
              ),
              child: Icon(Icons.more_vert, color: primaryColor),
            ),
            onSelected: (value) {
              _handleMenuSelection(value);
            },
            itemBuilder: (context) => [
              _buildMenuItem(
                'block',
                controller.isBlocked.isTrue
                    ? Icons.u_turn_left_rounded
                    : Icons.block,
                controller.isBlocked.isTrue ? 'Unblock User' : 'Block User',
                primaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleChatAction() async {
    final details = controller.profileDetails;

    final chatInitiated = details['chat_initiated'] == true;
    final requestSent = details['request_sent'] == true;
    final requestAccepted = details['is_request_accepted'] == true;
    final args = Get.arguments as Map<String, dynamic>?; // 👈 SAFE
    final isSearch = args?['is_search'] == true;
    if (chatInitiated) {
      if (Navigator.of(context).canPop() == true) {
        Navigator.of(context).pop();
      }

      if (isSearch && Navigator.of(context).canPop() == true) {
        Navigator.of(context).pop();
      }
      getIt<NavigationController>().openSubPage(
        SingleChat(chatId: details['chat_id']?.toString() ?? ''),
      );
      return;
    }

    if (requestSent) {
      if (!requestAccepted) return;

      await getIt<InboxController>().initiateChat(
        from: 'profile',
        otherUserId: details['other_user_id']?.toString() ?? '',
        type: 'user_to_user',
      );
      return;
    }

    await controller.sendChatReq(details['id']?.toString() ?? '');
  }

  Widget _buildChatIcon() {
    final details = controller.profileDetails;

    final chatInitiated = details['chat_initiated'] == true;
    final requestSent = details['request_sent'] == true;
    final requestAccepted = details['is_request_accepted'] == true;

    if (chatInitiated || (requestSent && requestAccepted)) {
      return HugeIcon(
        icon: HugeIcons.strokeRoundedBubbleChat,
        color: primaryBlack,
      );
    }

    if (requestSent && !requestAccepted) {
      return HugeIcon(
        icon: HugeIcons.strokeRoundedLoading01,
        color: primaryBlack,
      );
    }

    return HugeIcon(
      icon: HugeIcons.strokeRoundedUserAdd01,
      color: primaryBlack,
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
      child: Obx(
        () => Row(
          children: [
            Icon(
              controller.isBlocked.isTrue
                  ? Icons.u_turn_left_rounded
                  : Icons.block,
              color: color,
            ),
            const SizedBox(width: 12),
            Text(
              controller.isBlocked.isTrue ? 'Unblock User' : 'Block User',
              style: TextStyle(color: textDarkGrey),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'block':
        AllDialogs().showConfirmationDialog(
          controller.profileDetails['is_block'] == true
              ? 'Unblock User'
              : 'Block user',

          controller.profileDetails['is_block'] == true
              ? 'Are you sure you want to unblock this user?'
              : 'Are you sure you want to block this user?',
          onConfirm: () async {
            Get.back();
            await controller.blockUser(
              controller.profileDetails['id']?.toString() ?? '',
            );
          },
        );
        break;
    }
  }

  // ✅---------------- PROFILE HEADER ----------------✅
  Widget _buildProfileHeader() {
    final image = controller.profileDetails['profile_image'] ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        children: [
          // Profile Image
          _profileImage(image),
          const SizedBox(height: 16),
          CustomText(
            title: controller.profileDetails['name'] ?? '',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.start,
            color: primaryBlack,
          ),
          const SizedBox(height: 8),
          // Category
          _specializationChip(),
          const SizedBox(height: 8),
          // Name
          _followingCount(),
        ],
      ),
    );
  }

  Widget _profileImage(image) {
    return Container(
      width: 110.w,
      height: 110.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blueGrey.shade300, width: 2),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: image,
          fit: BoxFit.cover,
          placeholder: (_, __) => Image.asset(Images.defaultImage),
          errorWidget: (_, __, ___) => Image.asset(Images.defaultImage),
        ),
      ),
    );
  }

  Widget _specializationChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? primaryColor.withValues(alpha: 0.2)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
      ),
      child: CustomText(
        title: controller.profileDetails['specialization'] ?? '-',
        color: primaryColor,
        fontWeight: FontWeight.w500,
        fontSize: 14.sp,
      ),
    );
  }

  Widget _followingCount() {
    return GestureDetector(
      onTap: () {
        if (controller.isBlocked.isFalse) {
          Get.toNamed(
            Routes.followingList,
            arguments: {
              'user_id': controller.profileDetails['id']?.toString() ?? '',
            },
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            title:
                controller.profileDetails['followed_businesses_count']
                    ?.toString() ??
                '0',
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: primaryBlack,
          ),
          SizedBox(width: 6.w),
          CustomText(
            title: 'Following',
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
            color: primaryBlack,
          ),
          SizedBox(width: 4.w),
          Icon(Icons.arrow_forward_ios, size: 14.r, color: primaryBlack),
        ],
      ),
    );
  }

  // ✅---------------- PROFILE DETAILS ----------------✅
  Widget _buildProfileContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        spacing: 8.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: lightGrey, height: 1),
          if (controller.profileDetails['about'] != null) ...[
            _Section(
              title: 'About Me',
              child: Text(
                controller.profileDetails['about'],
                textAlign: TextAlign.justify,
              ),
            ),
            // _buildSectionTitle('About Me'),
            // _buildAboutMeSection(),
          ],
          _Section(
            title: 'Professional Details',
            child: Column(
              spacing: 8.h,
              children: [
                _InfoRow(
                  'Specialization',
                  controller.profileDetails['specialization'],
                ),
                _InfoRow('Experience', controller.profileDetails['experience']),
                _InfoRow('Education', controller.profileDetails['education']),
              ],
            ),
          ),

          // _buildSectionTitle('Professional Details'),
          //
          // _buildCategorySection(),
          if (controller.isMe.isTrue)
            _Section(
              title: 'Contact Information',
              child: Column(
                spacing: 12.h,
                children: [
                  _ContactRow(
                    HugeIcons.strokeRoundedMail01,
                    controller.profileDetails['email_id'],
                  ),
                  _ContactRow(
                    HugeIcons.strokeRoundedCall02,
                    controller.profileDetails['mobile_number'],
                  ),
                ],
              ),
            ),

          // if (controller.isMe.isTrue) ...[
          //   _buildSectionTitle('Contact Information'),
          //   _buildContactSection(),
          // ],
          _businessCard(),
          _businessRequirement(),
          if (controller.isMe.isTrue) ...[
            _buildLogoutButton(),
            _buildDivider(),
            _SimpleTile(
              title: 'How to use?',
              onTap: () => Get.toNamed(Routes.tutorials),
            ),
            _buildDivider(),
            _SimpleTile(
              title: 'Blocked User',
              onTap: () => Get.toNamed(Routes.blockUserList),
            ),
            _buildDivider(),
            _SimpleTile(
              title: 'Help & Support',
              onTap: () => Get.toNamed(Routes.helpAndSupport),
            ),
            _buildDivider(),
            if (controller.legalPageList.isNotEmpty)
              ...controller.legalPageList.map(
                (v) => Column(
                  children: [
                    _SimpleTile(
                      title: v['name'] ?? '',
                      onTap: () =>
                          Get.to(() => PolicyData(slug: v['slug'] ?? '')),
                    ),
                    _buildDivider(),
                  ],
                ),
              ),
          ],
          // if (controller.isMe.isTrue &&
          //     controller.legalPageList.isNotEmpty) ...[
          //   _buildDivider(),
          //   Column(
          //     children: List.generate(controller.legalPageList.length, (index) {
          //       final v = controller.legalPageList[index];
          //       return Column(
          //         children: [
          //           ListTile(
          //             visualDensity: VisualDensity(vertical: -4),
          //             dense: true,
          //             onTap: () {
          //               Get.to(() => PolicyData(slug: v['slug'] ?? ''));
          //             },
          //             title: CustomText(
          //               title: v['name'] ?? '',
          //               fontSize: 16.sp,
          //               textAlign: TextAlign.start,
          //               fontWeight: FontWeight.bold,
          //               color: primaryBlack,
          //             ),
          //             trailing: Icon(
          //               Icons.arrow_forward_ios_rounded,
          //               size: 16.r,
          //               color: Colors.grey,
          //             ),
          //           ),
          //           if (index != controller.legalPageList.length - 1)
          //             _buildDivider(),
          //         ],
          //       );
          //     }),
          //   ),
          // ],
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.shade300,
      indent: Get.width * 0.04,
      endIndent: Get.width * 0.04,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: primaryBlack,
        letterSpacing: -0.5,
      ),
    );
  }
  //
  // Widget _buildAboutMeSection() {
  //   final about = controller.profileDetails['about'] ?? '';
  //   // if (about == null) return SizedBox();
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(20),
  //     decoration: _boxDecoration(),
  //     child: CustomText(
  //       title: about,
  //       maxLines: 10,
  //       fontSize: 15.sp,
  //       color: primaryBlack,
  //       textAlign: TextAlign.justify,
  //     ),
  //   );
  // }
  //
  // Widget _buildCategorySection() {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(20),
  //     decoration: _boxDecoration(),
  //     child: Column(
  //       children: [
  //         _buildCategoryItem(
  //           'Specialization',
  //           controller.profileDetails['specialization'] ?? '-',
  //         ),
  //         const SizedBox(height: 12),
  //         _buildCategoryItem(
  //           'Experience',
  //           controller.profileDetails['experience'] ?? '-',
  //         ),
  //         const SizedBox(height: 12),
  //         _buildCategoryItem(
  //           'Education',
  //           controller.profileDetails['education'] ?? '-',
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildCategoryItem(String title, String value) {
  //   return Row(
  //     children: [
  //       Expanded(flex: 2, child: Text(title, style: _labelStyle())),
  //       Expanded(flex: 3, child: Text(value, style: _valueStyle())),
  //     ],
  //   );
  // }

  // Widget _buildContactSection() {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(20),
  //     decoration: _boxDecoration(),
  //     child: Column(
  //       spacing: 12.h,
  //       children: [
  //         _buildContactItem(
  //           HugeIcons.strokeRoundedMail01,
  //           controller.profileDetails['email_id'] ?? '-',
  //         ),
  //         _buildContactItem(
  //           HugeIcons.strokeRoundedCall02,
  //           controller.profileDetails['mobile_number'] ?? '-',
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildContactItem(var icon, String text) {
  //   return Row(
  //     spacing: 12.w,
  //     children: [
  //       HugeIcon(icon: icon, size: 20.r, color: primaryColor),
  //       Expanded(child: Text(text, style: _valueStyle())),
  //     ],
  //   );
  // }

  // ✅---------------- BUSINESS CARD ----------------✅

  Widget _businessCard() {
    final businesses = controller.profileDetails['businesses'] ?? [];
    if (businesses.length == 0) return const SizedBox();
    return Column(
      spacing: 8.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Business'),
        Column(
          children: businesses.map<Widget>((business) {
            return GestureDetector(
              onTap: controller.isMe.isTrue
                  ? null
                  : () {
                      Get.back();
                      Get.back();
                      navController.openSubPage(
                        CategoryDetailPage(
                          title: business['name']?.toString() ?? '',
                          businessId: business['id']?.toString() ?? '',
                        ),
                      );
                    },
              child: Container(
                margin: EdgeInsets.only(bottom: 10.h),
                padding: EdgeInsets.all(10.w),
                decoration: _boxDecoration(),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.network(
                        business['image']?.toString() ?? '',
                        width: 50.w,
                        height: 50.h,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          Images.defaultImage,
                          width: 50.w,
                          height: 50.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            title: business['name']?.toString() ?? '',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start,
                            color: primaryBlack,
                          ),
                          Text(
                            business['category']?.toString() ?? '',
                            style: TextStyle(fontSize: 12.sp, color: textGrey),
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              Icon(
                                Icons.people_alt_outlined,
                                size: 14.sp,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '${business['followers']?.toString() ?? '0'} Followers',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: textGrey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (controller.isMe.isTrue)
                      GestureDetector(
                        onTap: () => Get.toNamed(
                          Routes.editBusiness,
                          arguments: {'data': business},
                        ),
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedPencilEdit02,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ✅---------------- Business Requirement CARD ----------------✅

  Widget _businessRequirement() {
    final businesses = controller.profileDetails['business_requirements'] ?? [];
    if (businesses.length == 0) return const SizedBox.shrink();
    return Column(
      spacing: 8.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Business Requirements'),
        Column(
          children: businesses.map<Widget>((business) {
            return Stack(
              children: [
                BusinessCard(
                  data: business,
                  onDelete: () {
                    AllDialogs().showConfirmationDialog(
                      'Delete Recruitment',
                      'Are you sure you want to delete this recruitment?',
                      onConfirm: () async {
                        await getIt<PartnerDataController>()
                            .deleteBusinessRequirement(
                              business['id']?.toString() ?? '',
                            );
                        Get.back();
                        await controller.getProfile();
                      },
                    );
                  },
                ),

                /// 🔒 Blur Overlay
                if (business['is_deleted'] == true)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Get.theme.dividerColor,
                              width: 0.5.w,
                            ),
                            color: Colors.black.withValues(alpha: 0.25),
                          ),

                          alignment: Alignment.center,
                          child: business['is_revoke_requested'] == true
                              ? CustomText(
                                  title: 'Revoke Request Already Submitted',
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  textAlign: TextAlign.start,
                                  fontWeight: FontWeight.w600,
                                )
                              : CustomText(
                                  title: 'Requirement Deleted',
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  textAlign: TextAlign.start,
                                  fontWeight: FontWeight.w600,
                                ),
                        ),
                      ),
                    ),
                  ),

                /// ⋮ Menu Icon
                if (business['is_deleted'] == true &&
                    business['is_revoke_requested'] == false)
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: PopupMenuButton<String>(
                      color: Theme.of(Get.context!).cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      elevation: 0,
                      popUpAnimationStyle: AnimationStyle(
                        curve: Curves.easeInOut,
                      ),
                      padding: EdgeInsets.zero,
                      surfaceTintColor: Theme.of(
                        Get.context!,
                      ).scaffoldBackgroundColor,
                      onSelected: (value) async {
                        if (value == 'revoke') {
                          await getIt<PartnerDataController>()
                              .revokeBusinessRequirement(
                                business['id']?.toString() ?? '',
                              );
                          await controller.getProfile();
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'revoke',
                          child:
                              getIt<PartnerDataController>()
                                  .isRevokeLoading
                                  .value
                              ? LoadingWidget(color: primaryColor)
                              : Text('Request Revoke'),
                        ),
                      ],
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Icon(Icons.more_vert, color: primaryColor),
                      ),
                    ),
                  ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  // ✅---------------- LOGOUT ----------------✅
  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () {
        AllDialogs().showConfirmationDialog(
          'Logout',
          'Are you sure you want to logout?',
          onConfirm: () {
            // perform logout
            Get.back();
            LocalStorage.clear();
            Get.snackbar('Logout', 'You have logged out successfully');
            Get.offAllNamed(Routes.login);
          },
        );
      },
      child: Container(
        width: Get.width,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(100.r),
        ),
        alignment: Alignment.center,
        child: CustomText(
          title: 'Logout',
          fontSize: 16.sp,
          color: primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ✅---------------- COMMON STYLES ----------------✅

  // TextStyle _labelStyle() {
  //   return TextStyle(
  //     fontWeight: FontWeight.w500,
  //     color: textSmall,
  //     fontSize: 14.sp,
  //   );
  // }

  // Widget _buildDeleteButton() {
  //   return GestureDetector(
  //     onTap: () {
  //       AllDialogs().showConfirmationDialog(
  //         'Delete Account',
  //         'This will permanently delete your account. Continue?',
  //         onConfirm: () {
  //           // perform delete
  //           Get.back();
  //           Get.snackbar('Account Deleted', 'Your account has been removed');
  //         },
  //       );
  //     },
  //     child: Container(
  //       width: Get.width,
  //       padding: EdgeInsets.symmetric(vertical: 14.h),
  //       alignment: Alignment.center,
  //       child: CustomText(
  //         title: 'Delete account',
  //         fontSize: 16.sp,
  //         color: textLightGrey,
  //       ),
  //     ),
  //   );
  // }
}

BoxDecoration _boxDecoration() {
  final isDark = Theme.of(Get.context!).brightness == Brightness.dark;

  return BoxDecoration(
    color: Get.theme.cardColor,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: isDark ? Colors.grey.withValues(alpha: 0.3) : Colors.black12,
        blurRadius: 6,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

TextStyle _valueStyle() {
  return TextStyle(
    fontWeight: FontWeight.w600,
    color: textLightGrey,
    fontSize: 14.sp,
  );
}

class _SimpleTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _SimpleTile({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity(vertical: -4),
      dense: true,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String? value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Expanded(child: Text(value ?? '-', style: _valueStyle())),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: primaryBlack,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: _boxDecoration(),
          child: child,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  final dynamic icon;
  final String? value;

  const _ContactRow(this.icon, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12.w,
      children: [
        HugeIcon(icon: icon, color: primaryColor, size: 20.r),
        Expanded(child: Text(value ?? '-', style: _valueStyle())),
      ],
    );
  }
}
