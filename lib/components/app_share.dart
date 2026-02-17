import 'package:businessbuddy/utils/exported_path.dart';

enum ShareEntityType { post, offer }

class AppShare {
  static const String _baseUrl = AllUrl.base;

  /// Generate share link
  static String generateLink({
    required ShareEntityType type,
    required String id,
    required String slug,
  }) {
    switch (type) {
      case ShareEntityType.post:
        return '$_baseUrl/$slug/post/$id';
      case ShareEntityType.offer:
        return '$_baseUrl/$slug/offer/$id';
    }
  }

  /// Share link
  static Future<void> share({
    required ShareEntityType type,
    required String id,
    required String slug,
  }) async {
    final link = generateLink(type: type, id: id, slug: slug);

    await SharePlus.instance.share(ShareParams(text: link));
  }
}
