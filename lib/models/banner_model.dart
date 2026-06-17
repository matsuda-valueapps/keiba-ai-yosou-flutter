class BannerModel {

  final int id;
  final String title;
  final String imageUrl;
  final String url;

  BannerModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.url,
  });

  factory BannerModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return BannerModel(

      id: json["id"] ?? 0,

      title: json["title"] ?? "",

      imageUrl:
          json["image_url"] ?? "",

      // 超重要
      url: json["link"] ?? "",
    );
  }
}