import 'dart:convert';
import 'package:http/http.dart' as http;

class SiteService {
  Future<List<Map<String, dynamic>>> fetchSites() async {
    final url = Uri.parse("https://api.keiba-ai-yosou.com/sites/");

    final res = await http.get(url);

    if (res.statusCode != 200) {
      throw Exception("サイト取得失敗");
    }

    final data = jsonDecode(res.body);
    return List<Map<String, dynamic>>.from(data);
  }
}