import '../../../../../utils/exported_path.dart';

class CommentsBottomSheet extends StatefulWidget {
  final String postId;
  final bool isPost;
  final bool isSingle;

  const CommentsBottomSheet({
    super.key,
    required this.postId,
    this.isPost = true,
    this.isSingle = false,
  });

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final commentController = getIt<FeedsController>();
  final controller = getIt<LBOController>();

  @override
  void initState() {
    super.initState();
    if (widget.isSingle == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.isPost == true) {
          commentController.getSinglePost(widget.postId);
        } else {
          controller.getSingleOffer(widget.postId);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.85,
      minChildSize: 0.50,
      builder: (context, scroll) {
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
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      title: 'Comments',
                      fontSize: 18.sp,
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.bold,
                      color: primaryBlack,
                    ),
                    IconButton(
                      onPressed: closeBottomSheet,
                      icon: Icon(Icons.close, size: 24.sp),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
              ),

              Divider(height: 1, color: lightGrey),

              // Comments List
              widget.isPost == true
                  ? Expanded(
                      child: Obx(() {
                        if (commentController.isCommentLoading.value) {
                          return LoadingWidget(color: primaryColor);
                        }

                        if (commentController.comments.isEmpty) {
                          return _buildEmptyComment();
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: commentController.comments.length,
                          itemBuilder: (context, index) {
                            final comment = commentController.comments[index];
                            return _buildCommentItem(comment);
                          },
                        );
                      }),
                    )
                  : Expanded(
                      child: Obx(() {
                        if (controller.isSingleOfferLoading.value) {
                          return LoadingWidget(color: primaryColor);
                        }

                        if (controller.comments.isEmpty) {
                          return _buildEmptyComment();
                        }

                        return ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: controller.comments.length,
                          itemBuilder: (context, index) {
                            final comment = controller.comments[index];
                            return _buildCommentItem(comment);
                          },
                        );
                      }),
                    ),

              // Add Comment Section
              _buildAddCommentSection(),
            ],
          ),
        );
      },
    );
  }

  void closeBottomSheet() {
    if (Get.isBottomSheetOpen ?? false) {
      Navigator.of(context).pop(); // close bottom sheet only
      return;
    }

    if (Get.isDialogOpen ?? false) {
      Get.back(); // dialog is safe
      return;
    }

    Get.back();

    // if (Get.isBottomSheetOpen ?? false) {
    //   Get.back();
    // }
  }

  Widget _buildEmptyComment() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedMessage02,
            size: 60.r,
            color: Colors.grey,
          ),
          SizedBox(height: 16.h),
          Text(
            'No comments yet',
            style: TextStyle(color: Colors.grey, fontSize: 16.sp),
          ),
          Text(
            'Be the first to comment',
            style: TextStyle(color: Colors.grey, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Avatar
          _buildUserAvatar(comment),

          SizedBox(width: 8.w),

          // Comment Content
          Expanded(child: _buildCommentContent(comment)),
        ],
      ),
    );
  }

  Widget _buildUserAvatar(Map<String, dynamic> comment) {
    final String? profileImage = comment['user_profile_image']?.toString();
    final String userName = comment['user_name']?.toString() ?? '';
    final String initials = userName.isNotEmpty
        ? userName.substring(0, 1).toUpperCase()
        : '';

    return Container(
      width: 24.w,
      height: 24.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: ClipOval(
        child: profileImage != null && profileImage.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: profileImage,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    _buildAvatarPlaceholder(initials),
                errorWidget: (context, url, error) =>
                    _buildAvatarPlaceholder(initials),
              )
            : _buildAvatarPlaceholder(initials),
      ),
    );
  }

  Widget _buildAvatarPlaceholder(String initials) {
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildCommentContent(Map<String, dynamic> comment) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Comment Bubble
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Get.theme.cardColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16.r),
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Name
                CustomText(
                  maxLines: 1,
                  title: comment['user_name']?.toString() ?? '',
                  fontSize: 12.sp,
                  textAlign: TextAlign.start,
                  color: primaryBlack,
                ),

                Text(
                  comment['comment']?.toString() ?? '',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: textGrey,
                    height: 1.4,
                  ),
                  softWrap: true,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: Text(
            TimestampFormatter.format(comment['created_at']?.toString()),
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: textGrey,
              letterSpacing: 0.2,
            ),
          ),
        ),
        // Timestamp
      ],
    );
  }

  // Widget _buildCommentItem(Map<String, dynamic> comment) {
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 16.h),
  //     child: Row(
  //       spacing: 12.h,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // Profile Image
  //         Container(
  //           width: 35.w,
  //           height: 35.h,
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             color: Colors.grey[200],
  //           ),
  //           child: ClipOval(
  //             child:
  //                 comment['user_profile_image']?.toString().isNotEmpty == true
  //                 ? Image.network(
  //                     comment['user_profile_image'].toString(),
  //                     fit: BoxFit.cover,
  //                     errorBuilder: (context, error, stackTrace) {
  //                       return Center(
  //                         child: Text(
  //                           comment['user_name']
  //                                   ?.toString()
  //                                   .substring(0, 1)
  //                                   .toUpperCase() ??
  //                               '',
  //                           style: TextStyle(
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.grey[600],
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                   )
  //                 : Center(
  //                     child: Text(
  //                       comment['user_name']
  //                               ?.toString()
  //                               .substring(0, 1)
  //                               .toUpperCase() ??
  //                           '',
  //                       style: TextStyle(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.grey[600],
  //                       ),
  //                     ),
  //                   ),
  //           ),
  //         ),
  //
  //         // Comment Content
  //         Expanded(
  //           child: Column(
  //             spacing: 4.h,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Container(
  //                 padding: EdgeInsets.all(8),
  //                 decoration: BoxDecoration(
  //                   color: Colors.grey[100],
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     CustomText(
  //                       title: comment['user_name']?.toString() ?? '',
  //                       fontWeight: FontWeight.w600,
  //                       fontSize: 13.sp,
  //                       textAlign: TextAlign.start,
  //                     ),
  //                     SizedBox(height: 2),
  //                     CustomText(
  //                       title: comment['comment']?.toString() ?? '',
  //                       fontSize: 13.sp,
  //                       textAlign: TextAlign.start,
  //                       maxLines: 2,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 8.0),
  //                 child: Text(
  //                   comment['created_at']?.toString() ?? '',
  //                   style: TextStyle(
  //                     color: Colors.grey.shade600,
  //                     fontSize: 10.sp,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildAddCommentSection() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(top: BorderSide(color: lightGrey)),
        ),
        child: Row(
          children: [
            // Text Field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController.commentTextController,
                        onChanged: (value) =>
                            commentController.newComment.value = value,
                        decoration: InputDecoration(
                          hintText: 'Write a comment...',
                          hintStyle: TextStyle(fontSize: 14.sp),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (value) async {
                          if (value.trim().isNotEmpty) {
                            widget.isPost
                                ? await commentController.addPostComment()
                                : await controller
                                      .addOfferComment(value.trim())
                                      .then((v) {
                                        commentController.commentTextController
                                            .clear();
                                        commentController.newComment.value = '';
                                      });
                          }
                        },
                      ),
                    ),

                    // Send Button
                    // Obx(
                    //   () => widget.isPost
                    //       ? commentController.isAddCommentLoading.isTrue
                    //       : controller.isOfferCommentLoading.isTrue
                    //       ? Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: LoadingWidget(
                    //             color: primaryColor,
                    //             size: 16.w,
                    //           ),
                    //         )
                    //       : Padding(
                    //           padding: const EdgeInsets.only(right: 8.0),
                    //           child: IconButton(
                    //             onPressed:
                    //                 commentController.newComment.value
                    //                     .trim()
                    //                     .isNotEmpty
                    //                 ? () async => widget.isPost
                    //                       ? await commentController
                    //                             .addPostComment()
                    //                       : await controller.addOfferComment(
                    //                           commentController
                    //                               .commentTextController
                    //                               .text
                    //                               .trim(),
                    //                         )
                    //                 // await commentController.addPostComment()
                    //                 : null,
                    //             icon: Icon(Icons.send),
                    //             color:
                    //                 commentController.newComment.value
                    //                     .trim()
                    //                     .isNotEmpty
                    //                 ? primaryColor
                    //                 : Colors.grey,
                    //             iconSize: 24,
                    //             padding: EdgeInsets.zero,
                    //             constraints: BoxConstraints(),
                    //           ),
                    //         ),
                    // ),
                    Obx(() {
                      final isLoading = widget.isPost
                          ? commentController.isAddCommentLoading.isTrue
                          : controller.isOfferCommentLoading.isTrue;

                      if (isLoading) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LoadingWidget(color: primaryColor, size: 16.w),
                        );
                      }

                      final hasText = commentController.newComment.value
                          .trim()
                          .isNotEmpty;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(
                          onPressed: hasText
                              ? () async {
                                  if (widget.isPost) {
                                    await commentController.addPostComment();
                                  } else {
                                    await controller
                                        .addOfferComment(
                                          commentController
                                              .commentTextController
                                              .text
                                              .trim(),
                                        )
                                        .then((v) {
                                          commentController
                                              .commentTextController
                                              .clear();
                                          commentController.newComment.value =
                                              '';
                                        });
                                  }
                                }
                              : null,
                          icon: const Icon(Icons.send),
                          color: hasText ? primaryColor : Colors.grey,
                          iconSize: 24,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
