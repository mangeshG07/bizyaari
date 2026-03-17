import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

Future<http.Client> getHttpClient() async {
  final ioc = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) =>
        true;
  return IOClient(ioc);
}

const googleMapsApi = 'AIzaSyAvg-gpAbB2_lKgSIJ9tG6JqjGJFaVeXNc';

class AllUrl {
  static const String base = "http://192.168.29.37/bizyaari";
  // static const String base = "https://businessbuddy.deepmindsit.com";
  // static const String base = "https://beta.bizyaari.com";
  static const String baseUrl = "$base/api/user/v1";

  static const String sendOtp = '$baseUrl/check_user';
  static const String verifyOtp = '$baseUrl/verify_user';
  static const String register = '$baseUrl/register_user';
  static const String categories = '$baseUrl/get_categories';
  static const String regBusiness = '$baseUrl/register_business';
  static const String explore = '$baseUrl/explore';
  static const String businessDetails = '$baseUrl/business_details';
  static const String myBusinessDetails = '$baseUrl/my_business_details';
  static const String myBusiness = '$baseUrl/my_businesses';
  static const String addBusiness = '$baseUrl/register_business';
  static const String editBusiness = '$baseUrl/update_business';
  static const String addPost = '$baseUrl/add_business_post';
  static const String editPost = '$baseUrl/update_business_post';
  static const String addOffer = '$baseUrl/add_business_offer';
  static const String editOffer = '$baseUrl/update_business_offer';
  static const String postDetails = '$baseUrl/get_post_details';
  static const String offerDetails = '$baseUrl/get_offer_details';
  static const String getFeeds = '$baseUrl/get_feeds';
  static const String getHome = '$baseUrl/home';
  static const String getSpecialOffer = '$baseUrl/get_special_offers';
  static const String businessReqList = '$baseUrl/business_requirement_list';
  static const String getWulf = '$baseUrl/get_wulf_list';
  static const String getCapacity = '$baseUrl/get_investment_capacity_list';
  static const String addBusinessReq = '$baseUrl/add_business_requirement';
  static const String editBusinessReq = '$baseUrl/update_business_requirement';
  static const String deleteBusinessReq =
      '$baseUrl/delete_business_requirement';
  static const String deleteBusiness = '$baseUrl/delete_business';
  static const String revokeBusinessReq =
      '$baseUrl/revoke_business_requirement';
  static const String getMyProfile = '$baseUrl/my_profile_details';
  static const String getFollowList = '$baseUrl/get_business_following_list';
  static const String getFollowersList = '$baseUrl/my_business_followers';
  static const String getUserProfile = '$baseUrl/user_profile_details';
  static const String updateProfile = '$baseUrl/update_profile';
  static const String sendBusinessRequest =
      '$baseUrl/send_business_requirement_request';
  static const String getBusinessRequested =
      '$baseUrl/my_requested_business_requirements';
  static const String getBusinessReceived =
      '$baseUrl/my_received_business_requirement_requests';
  static const String acceptBusinessRequest =
      '$baseUrl/accept_business_requirement_request';
  static const String followBusiness = '$baseUrl/follow_business';
  static const String unfollowBusiness = '$baseUrl/unfollow_business';
  static const String likeBusiness = '$baseUrl/like_business_post';
  static const String unlikeBusiness = '$baseUrl/unlike_business_post';

  static const String likeOffer = '$baseUrl/like_business_offer';
  static const String unlikeOffer = '$baseUrl/unlike_business_offer';
  static const String addReview = '$baseUrl/add_review_rating';
  static const String addPostComment = '$baseUrl/add_business_post_comment';
  static const String addOfferComment = '$baseUrl/add_business_offer_comment';
  static const String chatList = '$baseUrl/get_chat_list';
  static const String getSingleChat = '$baseUrl/get_messages';
  static const String sendMsg = '$baseUrl/send_message';
  static const String initiateChat = '$baseUrl/initiate_chat';
  static const String globalSearch = '$baseUrl/global_search';
  static const String legalPageList = '$baseUrl/get_page_list';
  static const String legalPageDetails = '$baseUrl/get_page_details';
  static const String deleteAccount = '$baseUrl/delete_account';
  static const String updateFirebaseToken = '$baseUrl/update_firebase_token';
  static const String getNotification = '$baseUrl/get_notifications';
  static const String readNotification = '$baseUrl/read_notification';
  static const String acceptDisclaimer = '$baseUrl/save_user_disclaimer';

  static const String privacyPolicy = '$base/legal_page/privacy_policy';
  static const String termsCondition = '$base/legal_page/terms_and_conditions';
  static const String helpAndSupport = '$baseUrl/help_and_support';
  static const String blockUser = '$baseUrl/block_user';
  static const String blockUserList = '$baseUrl/blocked_users_list';
  static const String tutorials = '$baseUrl/get_tutorials';
  static const String sendChatRequest = '$baseUrl/send_user_chat_request';
}
