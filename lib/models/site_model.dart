class SiteModel {
  final int id;
  final String name;
  final String description; // 🔥 追加（最重要）
  final String imageUrl;
  final String url;
  final String blogUrl;

  SiteModel({
    required this.id,
    required this.name,
    required this.description, // 🔥 追加
    required this.imageUrl,
    required this.url,
    required this.blogUrl,
  });

  factory SiteModel.fromJson(Map<String, dynamic> json) {
    return SiteModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      description: json["description"] ?? "", // 🔥 追加
      imageUrl: json["image_url"] ?? "",
      url: json["url"] ?? "",
      blogUrl: json["blog_url"] ?? "",
    );
  }

  /// ⭐ デバッグ用（あると便利）
  @override
  String toString() {
    return 'SiteModel(id: $id, name: $name)';
  }
}