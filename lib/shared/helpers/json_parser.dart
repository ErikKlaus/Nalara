import 'dart:convert';

class JsonParser {
  JsonParser._();

  static Map<String, dynamic>? tryParse(String raw) {
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      final start = raw.indexOf('{');
      final end = raw.lastIndexOf('}');
      if (start >= 0 && end > start) {
        final sliced = raw.substring(start, end + 1);
        try {
          return jsonDecode(sliced) as Map<String, dynamic>;
        } catch (_) {
          return null;
        }
      }
      return null;
    }
  }
}
