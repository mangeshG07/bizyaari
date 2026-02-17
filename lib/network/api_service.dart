import 'dart:io';
import 'package:businessbuddy/network/all_url.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'api_service.g.dart';

@RestApi()
@injectable
abstract class ApiService {
  @factoryMethod
  factory ApiService(Dio dio) = _ApiService;

  @POST(AllUrl.sendOtp)
  Future<dynamic> sendOtp(@Part(name: "mobile_number") String number);

  @POST(AllUrl.verifyOtp)
  Future<dynamic> verifyOtp(
    @Part(name: "mobile_number") String number,
    @Part(name: "otp") String otp,
  );

  @POST(AllUrl.register)
  @MultiPart()
  Future<dynamic> register(
    @Part(name: "mobile_number") String emailOrPhone,
    @Part(name: "name") String name,
    @Part(name: "email_id") String email, {
    @Part(name: 'profile_image') File? profileImage,
  });

  @POST(AllUrl.addBusiness)
  @MultiPart()
  Future<dynamic> addBusiness(
    @Part(name: "user_id") String? userId,
    @Part(name: "name") String? name,
    @Part(name: "address") String? address,
    @Part(name: "mobile_number") String? mobileNumber,
    @Part(name: "category_id") String? categoryId,
    @Part(name: "about_business") String? aboutBusiness,
    @Part(name: "lat_long") String? latLong,
    @Part(name: "whatsapp_number") String? whatsappNo,
    @Part(name: "referral_code") String? referralCode, {
    @Part(name: 'image') File? profileImage,
    @Part(name: "attachments[]") List<MultipartFile>? attachment,
  });

  @POST(AllUrl.editBusiness)
  @MultiPart()
  Future<dynamic> editBusiness(
    @Part(name: "business_id") String? businessId,
    @Part(name: "name") String? name,
    @Part(name: "address") String? address,
    @Part(name: "mobile_number") String? mobileNumber,
    @Part(name: "category_id") String? categoryId,
    @Part(name: "about_business") String? aboutBusiness,
    @Part(name: "lat_long") String? latLong,
    @Part(name: "whatsapp_number") String? whatsappNo,
    @Part(name: "old_attachments[]") List<String> oldAttachment, {
    @Part(name: 'image') File? profileImage,
    @Part(name: "attachments[]") List<MultipartFile>? attachment,
  });

  @POST(AllUrl.categories)
  Future<dynamic> getCategories(@Part(name: "page_number") String pageNo);

  @POST(AllUrl.explore)
  Future<dynamic> explore(
    @Part(name: "category_id") String? catId,
    @Part(name: "lat_long") String? latLong,
    @Part(name: "user_id") String? userId,
    @Part(name: "page_number") String pageNo,
    @Part(name: "location") String location,
    @Part(name: "offer_available") String offerAvailable,
    @Part(name: "rating[]") List<String> rating,
  );

  @POST(AllUrl.businessDetails)
  Future<dynamic> businessDetails(
    @Part(name: "business_id") String? catId,
    @Part(name: "lat_long") String? latLong,
    @Part(name: "user_id") String? userId,
  );

  @POST(AllUrl.myBusinessDetails)
  Future<dynamic> myBusinessDetails(
    @Part(name: "business_id") String? catId,
    @Part(name: "lat_long") String? latLong,
    @Part(name: "user_id") String? userId,
  );

  @POST(AllUrl.myBusiness)
  Future<dynamic> myBusiness(@Part(name: "user_id") String? userId);

  @POST(AllUrl.addPost)
  @MultiPart()
  Future<dynamic> addPost(
    @Part(name: "user_id") String userId,
    @Part(name: "business_id") String businessId,
    @Part(name: "details") String details, {
    @Part(name: 'image') File? profileImage,
    @Part(name: 'video') File? videoFile,
  });

  @POST(AllUrl.editPost)
  @MultiPart()
  Future<dynamic> editPost(
    @Part(name: "post_id") String postId,
    @Part(name: "details") String details, {
    @Part(name: 'image') File? profileImage,
    @Part(name: 'video') File? videoFile,
  });

  @POST(AllUrl.addOffer)
  @MultiPart()
  Future<dynamic> addOffer(
    @Part(name: "user_id") String userId,
    @Part(name: "business_id") String businessId,
    @Part(name: "name") String name,
    @Part(name: "details") String details,
    @Part(name: "start_date") String startDate,
    @Part(name: "end_date") String endDate,
    @Part(name: "highlight_points[]") List<String> highlightPoints, {
    @Part(name: 'image') File? profileImage,
    @Part(name: 'video') File? videoFile,
  });

  @POST(AllUrl.editOffer)
  @MultiPart()
  Future<dynamic> editOffer(
    @Part(name: "offer_id") String offerId,
    @Part(name: "name") String name,
    @Part(name: "details") String details,
    @Part(name: "start_date") String startDate,
    @Part(name: "end_date") String endDate,
    @Part(name: "highlight_points[]") List<String> highlightPoints, {
    @Part(name: 'image') File? profileImage,
    @Part(name: 'video') File? videoFile,
  });

  @POST(AllUrl.postDetails)
  Future<dynamic> postDetails(
    @Part(name: "post_id") String? postId,
    @Part(name: "user_id") String? userId,
  );

  @POST(AllUrl.offerDetails)
  Future<dynamic> offerDetails(
    @Part(name: "offer_id") String? offerId,
    @Part(name: "user_id") String? userId,
  );

  @POST(AllUrl.getFeeds)
  Future<dynamic> getFeeds(
    @Part(name: "lat_long") String? latLong,
    @Part(name: "user_id") String? userId,
    @Part(name: "category_id") String? categoryId,
    @Part(name: "date_range") String? dateRange,
    @Part(name: "location") String? location,
    @Part(name: "page_number") String pageNo,
  );

  @POST(AllUrl.getHome)
  Future<dynamic> getHome(
    @Part(name: "lat_long") String? latLong,
    @Part(name: "user_id") String? userId,
  );

  @POST(AllUrl.getSpecialOffer)
  Future<dynamic> getSpecialOffer(
    @Part(name: "user_id") String? userId,
    @Part(name: "category_id") String? categoryId,
    @Part(name: "date_range") String? dateRange,
    @Part(name: "lat_long") String latLng,
    @Part(name: "location") String? location,
    @Part(name: "page_number") String pageNo,
  );

  @POST(AllUrl.businessReqList)
  Future<dynamic> businessReqList(
    @Part(name: "user_id") String? userId,
    @Part(name: "category_id") String? categoryId,
    @Part(name: "sort_order") String? sortOrder,
    @Part(name: "looking_for_id") String? lookingId,
    @Part(name: "investement_cap_id") String? investmentCapId,
    @Part(name: "lat_long") String latLng,
    @Part(name: "page_number") String pageNo,
    @Part(name: "location") String location,
  );

  @POST(AllUrl.getWulf)
  Future<dynamic> getWulf();

  @POST(AllUrl.getCapacity)
  Future<dynamic> getCapacity(@Part(name: "wulf_id") String? wulfId);

  @POST(AllUrl.deleteBusinessReq)
  Future<dynamic> deleteBusinessReq(
    @Part(name: "requirement_id") String? requirementId,
  );

  @POST(AllUrl.deleteBusiness)
  Future<dynamic> deleteBusiness(@Part(name: "business_id") String? businessId);

  @POST(AllUrl.revokeBusinessReq)
  Future<dynamic> revokeBusinessReq(
    @Part(name: "requirement_id") String? requirementId,
  );

  @POST(AllUrl.addBusinessReq)
  Future<dynamic> addBusinessReq(
    @Part(name: "user_id") String userId,
    @Part(name: "name") String name,
    @Part(name: "location") String location,
    @Part(name: "lat_long") String latLng,
    @Part(name: "wulf_id") String wulfId,
    @Part(name: "investment_cap_id") String capacityId,
    @Part(name: "history") String history,
    @Part(name: "note") String note,
    @Part(name: "can_invest") String canInvest,
    @Part(name: "category_ids[]") List<String> catIds,
  );

  @POST(AllUrl.editBusinessReq)
  Future<dynamic> editBusinessReq(
    @Part(name: "requirement_id") String reqId,
    @Part(name: "name") String name,
    @Part(name: "location") String location,
    @Part(name: "lat_long") String latLng,
    @Part(name: "wulf_id") String wulfId,
    @Part(name: "investment_cap_id") String capacityId,
    @Part(name: "history") String history,
    @Part(name: "note") String note,
    @Part(name: "can_invest") String canInvest,
    @Part(name: "category_ids[]") List<String> catIds,
  );

  @POST(AllUrl.getMyProfile)
  Future<dynamic> getMyProfile(@Part(name: "user_id") String? userId);

  @POST(AllUrl.getFollowList)
  Future<dynamic> getFollowList(
    @Part(name: "user_id") String? userId,
    @Part(name: "page_number") String pageNo,
  );

  @POST(AllUrl.getFollowersList)
  Future<dynamic> getFollowersList(
    @Part(name: "business_id") String? businessId,
    @Part(name: "page_number") String pageNo,
  );

  @POST(AllUrl.getUserProfile)
  Future<dynamic> getUserProfile(
    @Part(name: "user_id") String? userId,
    @Part(name: "login_user_id") String? loginUserId,
  );

  @POST(AllUrl.updateProfile)
  @MultiPart()
  Future<dynamic> updateProfile(
    @Part(name: "user_id") String userId,
    @Part(name: "name") String name,
    @Part(name: "experience") String experience,
    @Part(name: "education") String education,
    @Part(name: "specialization_id") String specializationId,
    @Part(name: "about") String about, {
    @Part(name: 'profile_image') File? profileImage,
  });

  @POST(AllUrl.sendBusinessRequest)
  Future<dynamic> sendBusinessRequest(
    @Part(name: "user_id") String? userId,
    @Part(name: "business_requirement_id") String? businessId,
  );

  @POST(AllUrl.getBusinessRequested)
  Future<dynamic> getBusinessRequested(
    @Part(name: "user_id") String? userId,
    @Part(name: "page_number") String pageNo,
  );

  @POST(AllUrl.getBusinessReceived)
  Future<dynamic> getBusinessReceivedRequest(
    @Part(name: "user_id") String? userId,
    @Part(name: "page_number") String pageNo,
  );

  @POST(AllUrl.acceptBusinessRequest)
  Future<dynamic> acceptBusinessRequest(
    @Part(name: "user_id") String? userId,
    @Part(name: "request_id") String? reqId,
  );

  @POST(AllUrl.followBusiness)
  Future<dynamic> followBusiness(
    @Part(name: "user_id") String? userId,
    @Part(name: "business_id") String? businessId,
  );

  @POST(AllUrl.unfollowBusiness)
  Future<dynamic> unfollowBusiness(
    @Part(name: "user_id") String? userId,
    @Part(name: "follow_id") String? followId,
  );

  @POST(AllUrl.likeBusiness)
  Future<dynamic> likeBusiness(
    @Part(name: "user_id") String? userId,
    @Part(name: "business_id") String? businessId,
    @Part(name: "business_post_id") String? postId,
  );

  @POST(AllUrl.unlikeBusiness)
  Future<dynamic> unlikeBusiness(
    @Part(name: "user_id") String? userId,
    @Part(name: "liked_id") String? likeId,
  );

  @POST(AllUrl.likeOffer)
  Future<dynamic> likeOffer(
    @Part(name: "user_id") String? userId,
    @Part(name: "business_id") String? businessId,
    @Part(name: "business_offer_id") String? offerId,
  );

  @POST(AllUrl.unlikeOffer)
  Future<dynamic> unlikeOffer(
    @Part(name: "user_id") String? userId,
    @Part(name: "offer_liked_id") String? likeId,
  );

  @POST(AllUrl.addReview)
  Future<dynamic> addReview(
    @Part(name: "user_id") String? userId,
    @Part(name: "business_id") String? businessId,
    @Part(name: "review") String? review,
    @Part(name: "rating") String? rating,
  );

  @POST(AllUrl.addPostComment)
  Future<dynamic> addPostComment(
    @Part(name: "user_id") String? userId,
    @Part(name: "business_id") String? businessId,
    @Part(name: "business_post_id") String? postId,
    @Part(name: "comment") String? comment,
  );

  @POST(AllUrl.addOfferComment)
  Future<dynamic> addOfferComment(
    @Part(name: "user_id") String? userId,
    @Part(name: "business_id") String? businessId,
    @Part(name: "business_offer_id") String? offerId,
    @Part(name: "comment") String? comment,
  );

  @POST(AllUrl.chatList)
  Future<dynamic> getChatList(
    @Part(name: "user_id") String? userId,
    @Part(name: "page_number") String pageNo,
  );

  @POST(AllUrl.getSingleChat)
  Future<dynamic> getSingleChat(
    @Part(name: "user_id") String? userId,
    @Part(name: "chat_id") String? chatId,
    @Part(name: "page_number") String pageNo,
  );

  @POST(AllUrl.sendMsg)
  Future<dynamic> sendMsg(
    @Part(name: "user_id") String? userId,
    @Part(name: "chat_id") String? chatId,
    @Part(name: "message") String? message,
  );

  @POST(AllUrl.initiateChat)
  Future<dynamic> initiateChat(
    @Part(name: "user_id") String? userId,
    @Part(name: "business_requirement_id") String? chatId,
    @Part(name: "other_user_id") String? otherUserId,
    @Part(name: "type") String? type,
  );

  @POST(AllUrl.globalSearch)
  Future<dynamic> globalSearch(
    @Part(name: "keyword") String? keyword,
    @Part(name: "user_id") String? userId,
  );

  @POST(AllUrl.legalPageList)
  Future<dynamic> legalPageList();

  @POST(AllUrl.legalPageDetails)
  Future<dynamic> legalPageDetails(@Part(name: "slug") String? slug);

  @POST(AllUrl.deleteAccount)
  Future<dynamic> deleteAccount(@Part(name: "user_id") String? userId);

  @POST(AllUrl.updateFirebaseToken)
  Future<dynamic> updateFirebaseToken(
    @Part(name: "user_id") String userId,
    @Part(name: "firebase_token") String token,
  );

  @POST(AllUrl.getNotification)
  Future<dynamic> getNotification(
    @Part(name: "user_id") String userId,
    @Part(name: "page_number") String pageNo,
  );

  @POST(AllUrl.readNotification)
  Future<dynamic> readNotification(
    @Part(name: "user_id") String userId,
    @Part(name: "notification_id") String notificationId,
  );

  @POST(AllUrl.acceptDisclaimer)
  Future<dynamic> acceptDisclaimer(
    @Part(name: "data_accepted") String? data,
    @Part(name: "user_id") String? userId,
  );

  @POST(AllUrl.helpAndSupport)
  Future<dynamic> helpAndSupport();

  @POST(AllUrl.blockUser)
  Future<dynamic> blockUser(
    @Part(name: "user_id") String? userId,
    @Part(name: "block_user_id") String? blockUserId,
  );

  @POST(AllUrl.tutorials)
  Future<dynamic> getTutorials(@Part(name: "page_number") String pageNo);

  @POST(AllUrl.blockUserList)
  Future<dynamic> blockUserList(
    @Part(name: "user_id") String? userId,
    @Part(name: "page_number") String pageNo,
  );

  @POST(AllUrl.sendChatRequest)
  Future<dynamic> sendChatRequest(
    @Part(name: "user_id") String? userId,
    @Part(name: "other_user_id") String otherUserid,
  );
}

//
// @GET("/comments")
// @Headers(<String, dynamic>{ //Static header
//   "Content-Type" : "application/json",
//   "Custom-Header" : "Your header"
// })
// Future<List<Comment>> getAllComments();

// @Path- To update the URL dynamically replacement block surrounded by { } must be annotated with @Path using the same string.
// @Body- Sends dart object as the request body.
// @Query- used to append the URL.
// @Headers- to pass the headers dynamically.
