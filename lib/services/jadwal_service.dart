import 'dart:convert';
import 'package:http/http.dart' as http;

class JadwalService {
  static Future<Map<String, dynamic>?> fetchJadwal(
      double lat, double lng, String metode, String bahasa) async {
    final url =
        'https://api.aladhan.com/v1/timings?latitude=$lat&longitude=$lng&method=$metode&school=0&iso8601=true&language=$bahasa';
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        return json.decode(res.body);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
