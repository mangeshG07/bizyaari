import 'package:intl/intl.dart';

class TimestampFormatter {
  static String format(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) return 'Just now';

    DateTime? parsedDate;

    // Try multiple formats
    final formats = [
      'MMM dd, yyyy hh:mm a', // "Dec 01, 2025 12:08 PM"
      'yyyy-MM-dd HH:mm:ss',  // ISO-like format
      'yyyy-MM-ddTHH:mm:ssZ', // ISO-8601
      'MM/dd/yyyy HH:mm',     // US format
    ];

    for (final format in formats) {
      try {
        parsedDate = DateFormat(format).parse(timestamp);
        break;
      } catch (_) {
        continue;
      }
    }

    // If none of the formats work, try standard DateTime.parse
    parsedDate ??= _tryParseIso(timestamp);

    if (parsedDate == null) return timestamp;

    return _getRelativeTime(parsedDate);
  }

  static DateTime? _tryParseIso(String timestamp) {
    try {
      return DateTime.parse(timestamp);
    } catch (_) {
      return null;
    }
  }

  static String _getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    // For future dates, show absolute date
    if (difference.isNegative) {
      final diff = dateTime.difference(now);
      if (diff.inDays > 365) {
        return DateFormat('MMM d, yyyy').format(dateTime);
      } else if (diff.inDays > 30) {
        return DateFormat('MMM d').format(dateTime);
      } else {
        return 'In ${diff.inDays} ${diff.inDays == 1 ? 'day' : 'days'}';
      }
    }

    // Past dates - relative formatting
    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    if (difference.inDays < 30) return '${(difference.inDays / 7).floor()}w ago';
    if (difference.inDays < 365) return '${(difference.inDays / 30).floor()}mo ago';

    return DateFormat('MMM d, yyyy').format(dateTime);
  }
}
