import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/banner_model.dart';

class BannerService {

  static const baseUrl =
      "https://api.keiba-ai-yosou.com";

  // =========================
  // バナー取得
  // =========================
  static Future<List<BannerModel>> fetchBanners() async {

    final uri = Uri.parse(
      "$baseUrl/admin/banners/",
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception("バナー取得失敗");
    }

    final List data = jsonDecode(response.body);

    return data
        .map((e) => BannerModel.fromJson(e))
        .toList();
  }
}