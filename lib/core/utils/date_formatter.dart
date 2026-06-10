import 'package:intl/intl.dart';

class DateFormatter {
  /// Parses ISO or plain date strings and returns a user-friendly display value.
  static String formatDisplayDate(String? raw, {bool includeTime = true}) {
    if (raw == null || raw.isEmpty) return '';

    try {
      final parsed = DateTime.parse(raw).toLocal();
      if (includeTime && raw.contains('T')) {
        return DateFormat('MMM d, yyyy • h:mm a').format(parsed);
      }
      return DateFormat('MMM d, yyyy').format(parsed);
    } catch (_) {
      return raw.split('T').first;
    }
  }

  static String formatDisplayTime(String? raw) {
    if (raw == null || raw.isEmpty) return '';

    try {
      return DateFormat('h:mm a').format(DateTime.parse(raw).toLocal());
    } catch (_) {
      return raw;
    }
  }
}
