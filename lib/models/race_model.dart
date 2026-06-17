class RaceModel {
  final String place;
  final int raceNumber;
  final int horseCount;
  final List<int> prediction; // ⭐追加

  RaceModel({
    required this.place,
    required this.raceNumber,
    required this.horseCount,
    required this.prediction,
  });

  factory RaceModel.fromJson(String place, Map<String, dynamic> json) {
    return RaceModel(
      place: place,
      raceNumber: json["race_number"],
      horseCount: json["horse_count"],
      prediction: List<int>.from(json["prediction"]), // ⭐重要
    );
  }
}