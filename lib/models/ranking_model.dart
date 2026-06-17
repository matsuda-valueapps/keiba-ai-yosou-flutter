class RankingModel {

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
  // 🔥 site_url
  // =========================
  final String siteUrl;

  // =========================
  // レース情報
  // =========================
  final String raceName;

  final String date;

  // =========================
  // 金額
  // =========================
  final int amount;

  // =========================
  // 的中数
  // =========================
  final int hitCount;

  // =========================
  // 🔥 ranking_type
  // =========================
  final String rankingType;

  RankingModel({

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

    required this.raceName,

    required this.date,

    required this.amount,

    required this.hitCount,

    required this.rankingType,
  });

  // =========================
  // fromJson
  // =========================
  factory RankingModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return RankingModel(

      // =========================
      // 基本
      // =========================
      id: json["id"] ?? 0,

      rank: json["rank"] ?? 0,

      // =========================
      // site
      // =========================
      siteId: json["site_id"] ?? 0,

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
      // 🔥 site_url
      // =========================
      siteUrl:
          json["site_url"] ?? "",

      // =========================
      // レース
      // =========================
      raceName:
          json["race_name"] ?? "",

      // =========================
      // 日付
      // =========================
      date:
          json["date"] ?? "",

      // =========================
      // 金額
      // =========================
      amount:
          json["amount"] ?? 0,

      // =========================
      // 的中数
      // =========================
      hitCount:
          json["hit_count"] ?? 0,

      // =========================
      // タイプ
      // =========================
      rankingType:
          json["ranking_type"] ?? "",
    );
  }

  // =========================
  // ⭐ 金額表示
  // =========================
  String get amountText {

    return "$amount円的中";
  }

  // =========================
  // ⭐ 的中数表示
  // =========================
  String get hitText {

    return "最近の的中数：$hitCount回";
  }

  // =========================
  // ⭐ レース表示
  // =========================
  String get raceText {

    if (raceName.isEmpty) {
      return "";
    }

    return "$date $raceName";
  }

  // =========================
  // 🔥 Blog存在判定
  // =========================
  bool get hasBlog {

    return blogId != null;
  }

  // =========================
  // 🔥 URL存在判定
  // =========================
  bool get hasSiteUrl {

    return siteUrl.isNotEmpty;
  }

  // =========================
  // 🔥 画像存在判定
  // =========================
  bool get hasImage {

    return imageUrl.isNotEmpty;
  }

  // =========================
  // ⭐ デバッグ
  // =========================
  @override
  String toString() {

    return '''
RankingModel(
  id: $id,
  rank: $rank,
  site: $siteName,
  imageUrl: $imageUrl,
  type: $rankingType,
  blogId: $blogId
)
''';
  }
}