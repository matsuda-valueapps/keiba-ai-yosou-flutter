import 'ranking_model.dart';

class RankingDetailModel {

  // =========================
  // 基本
  // =========================
  final int id;

  final int rank;

  // =========================
  // 🔥 site
  // =========================
  final int siteId;

  final String siteName;

  // =========================
  // 🔥 追加
  // サイト画像
  // =========================
  final String imageUrl;

  // =========================
  // 🔥 blog_id
  // =========================
  final int? blogId;

  // =========================
  // 🔥 URL
  // =========================
  final String siteUrl;

  final String blogUrl;

  // =========================
  // レース情報
  // =========================
  final String date;

  final String raceName;

  // =========================
  // 金額
  // =========================
  final int hitAmount;

  // =========================
  // 的中数
  // =========================
  final int hitCount;

  // =========================
  // 🔥 ranking_type
  // =========================
  final String rankingType;

  // =========================
  // トレンド判定
  // =========================
  final bool isTrend;

  RankingDetailModel({

    required this.id,

    required this.rank,

    required this.siteId,

    required this.siteName,

    // =========================
    // 🔥 追加
    // =========================
    required this.imageUrl,

    required this.blogId,

    required this.siteUrl,

    required this.blogUrl,

    required this.date,

    required this.raceName,

    required this.hitAmount,

    required this.hitCount,

    required this.rankingType,

    required this.isTrend,
  });

  // =========================
  // fromJson
  // =========================
  factory RankingDetailModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return RankingDetailModel(

      // =========================
      // 基本
      // =========================
      id:
          json["id"] ?? 0,

      rank:
          json["rank"] ?? 0,

      // =========================
      // site
      // =========================
      siteId:
          json["site_id"] ?? 0,

      siteName:
          json["site_name"] ?? "",

      // =========================
      // 🔥 image_url追加
      // =========================
      imageUrl:
          json["image_url"] ?? "",

      // =========================
      // 🔥 blog_id
      // =========================
      blogId:
          json["blog_id"],

      // =========================
      // URL
      // =========================
      siteUrl:
          json["site_url"] ?? "",

      blogUrl:
          json["blog_url"] ?? "",

      // =========================
      // 日付
      // =========================
      date:
          json["date"] ?? "",

      // =========================
      // レース
      // =========================
      raceName:
          json["race_name"] ?? "",

      // =========================
      // 金額
      // =========================
      hitAmount:
          json["amount"] ?? 0,

      // =========================
      // 的中数
      // =========================
      hitCount:
          json["hit_count"] ?? 0,

      // =========================
      // 🔥 ranking_type
      // =========================
      rankingType:
          json["ranking_type"] ?? "",

      // =========================
      // 🔥 trend判定
      // =========================
      isTrend:
          json["ranking_type"] ==
              "hit_count",
    );
  }
}

/// =========================
/// ⭐ 変換
/// =========================
extension RankingDetailConvert
    on RankingDetailModel {

  RankingModel toRankingModel() {

    return RankingModel(

      // =========================
      // 基本
      // =========================
      id: id,

      rank: rank,

      // =========================
      // site
      // =========================
      siteId: siteId,

      siteName: siteName,

      // =========================
      // 🔥 imageUrl追加
      // =========================
      imageUrl: imageUrl,

      // =========================
      // 🔥 blog_id
      // =========================
      blogId: blogId,

      // =========================
      // 🔥 site_url
      // =========================
      siteUrl: siteUrl,

      // =========================
      // レース
      // =========================
      raceName: raceName,

      // =========================
      // 日付
      // =========================
      date: date,

      // =========================
      // 金額
      // =========================
      amount: hitAmount,

      // =========================
      // 的中数
      // =========================
      hitCount: hitCount,

      // =========================
      // 🔥 ranking_type
      // =========================
      rankingType: rankingType,
    );
  }
}