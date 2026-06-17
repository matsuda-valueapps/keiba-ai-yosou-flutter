import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

class JraService {

  /// ⭐開催競馬場取得
  Future<List<String>> fetchTodayPlaces() async {

    final url = Uri.parse("https://www.jra.go.jp/keiba/calendar/");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("JRAデータ取得失敗");
    }

    final document = html_parser.parse(response.body);

    final places = <String>[];

    final elements = document.querySelectorAll(".schedule td");

    for (final el in elements) {
      final text = el.text.trim();

      if (text.contains("開催")) {
        final place = text.replaceAll("開催", "");
        if (place.isNotEmpty) {
          places.add(place);
        }
      }
    }

    return places;
  }
}