import 'package:businessbuddy/utils/exported_path.dart';

@lazySingleton
class InboxController extends GetxController {
  final ApiService _apiService = Get.find();
  final isLoading = true.obs;
  final receivedRequestList = [].obs;

  ///////////////////////////////////////chat////////////////////////////////
  final allChats = [].obs;
  final singleChat = {}.obs;
  final allMessages = [].obs;
  final isChatLoading = true.obs;
  final isSingleLoading = true.obs;
  final isSendLoading = false.obs;
  final msgController = TextEditingController();

  final isLoadMore = false.obs;
  int currentPage = 1;
  int totalPages = 1;
  int perPage = 10;
  bool hasMore = true;

  Future<void> getAllChat({
    bool showLoading = true,
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      currentPage = 1;
      totalPages = 1;
      hasMore = true;
      allChats.clear();
    }

    currentPage == 1
        ? isChatLoading.value = showLoading
        : isLoadMore.value = true;

    // if (showLoading) isChatLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    // allChats.clear();
    try {
      final response = await _apiService.getChatList(
        userId,
        currentPage.toString(),
      );

      if (response['common']['status'] == true) {
        final data = response['data'];

        final List list = data['chats'] ?? [];

        perPage = data['per_page'] ?? perPage;
        totalPages = data['total_pages'] ?? totalPages;

        /// 🔹 IMPORTANT
        if (isRefresh || currentPage == 1) {
          allChats.assignAll(list); // 🔥 replaces list
        } else {
          allChats.addAll(list); // pagination
        }

        /// 👇 backend-accurate pagination check
        hasMore = currentPage < totalPages;

        if (hasMore) currentPage++;
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isChatLoading.value = false;
      isLoadMore.value = false;
    }
  }

  ////////////////////////////////////////////Single Chat///////////////////////////////

  final isSingleLoadMore = false.obs;
  int currentSinglePage = 1;
  int totalSinglePages = 1;
  int perSinglePage = 10;
  bool hasSingleMore = true;

  Future<void> getSingleChat(
    String chatId, {
    bool showLoading = true,
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      currentSinglePage = 1;
      totalSinglePages = 1;
      hasSingleMore = true;
      singleChat.clear();
      allMessages.clear();
    }

    currentSinglePage == 1
        ? isSingleLoading.value = showLoading
        : isSingleLoadMore.value = true;

    final userId = await LocalStorage.getString('user_id') ?? '';

    try {
      final response = await _apiService.getSingleChat(
        userId,
        chatId,
        currentSinglePage.toString(),
      );
      // print('getSingleChat response $response');
      if (response['common']['status'] == true) {
        final data = response['data'];
        singleChat.value = response['data'] ?? {};
        final List list = data['messages'] ?? [];
        perSinglePage = data['per_page'] ?? perSinglePage;
        totalSinglePages = data['total_pages'] ?? totalSinglePages;

        /// 🔹 IMPORTANT
        if (isRefresh || currentSinglePage == 1) {
          allMessages.assignAll(list); // 🔥 replaces list
        } else {
          allMessages.addAll(list); // pagination

        }

        /// 👇 backend-accurate pagination check
        hasSingleMore = currentSinglePage < totalSinglePages;

        if (hasSingleMore) currentSinglePage++;

        // singleChat.value = response['data'] ?? {};
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isSingleLoading.value = false;
      isSingleLoadMore.value = false;
    }
  }

  /////////////////////////////////////////////send msg////////////////////////

  Future<void> sendMsg(String chatId, {bool showLoading = true}) async {
    if (showLoading) isSendLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.sendMsg(
        userId,
        chatId,
        msgController.text.trim(),
      );
      if (response['common']['status'] == true) {
        await getSingleChat(chatId, showLoading: false, isRefresh: true);
        msgController.clear();
      } else {
        ToastUtils.showErrorToast(response['common']['message'].toString());
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isSendLoading.value = false;
    }
  }

  final initiateLoadingMap = <String, bool>{}.obs;
  final nav = getIt<NavigationController>();

  Future<void> initiateChat({
    String reqId = '',
    String otherUserId = '',
    String type = '',
    String from = '',
  }) async {
    initiateLoadingMap[reqId] = true;
    initiateLoadingMap.refresh();

    try {
      final userId = await LocalStorage.getString('user_id') ?? '';
      final response = await _apiService.initiateChat(
        userId,
        reqId,
        otherUserId,
        type,
      );
      if (response['common']['status'] == true) {
        String chatId = '';

        chatId =
            response['data']?['chat_details']?['chat_id']?.toString() ?? '';

        // if (chatId.isEmpty) {
        //   ToastUtils.showErrorToast("Chat ID not found!");
        //   return;
        // }

        if (from == 'profile') {
          Get.back();
          nav.openSubPage(SingleChat(chatId: chatId));
        } else if (from == 'rec') {
          nav.updateBottomIndex(1); // Inbox
          // wait for stack rebuild
          Future.microtask(() {
            nav.openSubPage(SingleChat(chatId: chatId));
          });
        } else {
          nav.openSubPage(SingleChat(chatId: chatId));
        }
      } else {
        ToastUtils.showErrorToast(response['common']['message'].toString());
      }
    } catch (e) {
      showError(e);
    } finally {
      initiateLoadingMap[reqId] = false;
      initiateLoadingMap.refresh();
    }
  }

  ///////////////////////////////////////request////////////////////////////////

  final isRecLoadMore = false.obs;
  int currentRecPage = 1;
  int totalRecPages = 1;
  int perRecPage = 10;
  bool hasRecMore = true;

  Future<void> getReceiveBusinessRequest({
    bool showLoading = true,
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      currentRecPage = 1;
      totalRecPages = 1;
      hasRecMore = true;
      receivedRequestList.clear();
    }
    currentRecPage == 1
        ? isLoading.value = showLoading
        : isRecLoadMore.value = true;

    // if (showLoading) isLoading.value = true;
    // receivedRequestList.clear();
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.getBusinessReceivedRequest(
        userId,
        currentRecPage.toString(),
      );

      if (response['common']['status'] == true) {
        final data = response['data'];

        final List list = data['received_requests'] ?? [];

        perRecPage = data['per_page'] ?? perRecPage;
        totalRecPages = data['total_pages'] ?? totalRecPages;

        /// 🔹 IMPORTANT
        if (isRefresh || currentRecPage == 1) {
          receivedRequestList.assignAll(list);
        } else {
          receivedRequestList.addAll(list);
        }

        /// 👇 backend-accurate pagination check
        hasRecMore = currentRecPage < totalRecPages;

        if (hasRecMore) currentRecPage++;

        // singleChat.value = response['data'] ?? {};
      }
      // if (response['common']['status'] == true) {
      //   receivedRequestList.value = response['data'] ?? [];
      // }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isLoading.value = false;
      isRecLoadMore.value = false;
    }
  }

  Future<void> acceptRequest(String reqId, {bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.acceptBusinessRequest(userId, reqId);

      if (response['common']['status'] == true) {
        await getReceiveBusinessRequest(isRefresh: true);
        ToastUtils.showSuccessToast(response['common']['message']);
      } else {
        ToastUtils.showWarningToast(response['common']['message']);
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }
}
