import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  // =========================
  // ⭐ ベースURL
  // =========================
  static const baseUrl = "https://api.keiba-ai-yosou.com";


  // =========================
  // ⭐ サイト一覧
  // =========================
  static Future<List<dynamic>> getSites() async {
    final res = await http.get(Uri.parse("$baseUrl/sites"));

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("SITE API ERROR");
    }
  }


  // =========================
  // 🔥 ランキング取得（新API）
  // =========================
  static Future<List<dynamic>> getRankings(String type) async {
    final res = await http.get(
      Uri.parse("$baseUrl/rankings?ranking_type=$type"),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("RANKING API ERROR");
    }
  }

}