import 'package:businessbuddy/network/local_storage.dart';

class AlertHelper {
  static const String _keyLastShownDate = "last_alert_date";

  /// Check if alert should be shown today
  static Future<bool> shouldShowAlert() async {
    final lastDateString = await LocalStorage.getString(_keyLastShownDate);

    if (lastDateString == null) return true;

    final lastDate = DateTime.parse(lastDateString);
    final now = DateTime.now();

    // Compare only date (ignore time)
    return !(lastDate.year == now.year &&
        lastDate.month == now.month &&
        lastDate.day == now.day);
  }

  /// Save current date after showing alert
  static Future<void> saveTodayDate() async {
    await LocalStorage.setString(
      _keyLastShownDate,
      DateTime.now().toIso8601String(),
    );
  }
}
