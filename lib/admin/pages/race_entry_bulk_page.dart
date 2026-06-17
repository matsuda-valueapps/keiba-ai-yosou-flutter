import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logging/logging.dart';

class RaceEntryBulkPage extends StatefulWidget {
  const RaceEntryBulkPage({super.key});

  @override
  State<RaceEntryBulkPage> createState() => _RaceEntryBulkPageState();
}

class _RaceEntryBulkPageState extends State<RaceEntryBulkPage> {

  final log = Logger('RaceEntryBulk');

  final String baseUrl = "https://api.keiba-ai-yosou.com";

  final List<String> places = ["中山", "阪神", "福島"];

  final Map<String, List<TextEditingController>> controllers = {};

  @override
  void initState() {
    super.initState();

    for (var place in places) {
      controllers[place] = List.generate(
        12,
        (_) => TextEditingController(),
      );
    }
  }

  Future submit() async {

    List<Map<String, dynamic>> data = [];

    final today = DateTime.now().toString().substring(0, 10);

    for (var place in places) {
      for (int i = 0; i < 12; i++) {

        final value = controllers[place]![i].text;

        if (value.isEmpty) continue;

        data.add({
          "date": today,
          "place": place,
          "race_number": i + 1,
          "horse_count": int.parse(value),
        });
      }
    }

    log.info("送信データ: $data");

    try {
      final res = await http.post(
        Uri.parse("$baseUrl/admin/race-entry/bulk"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      log.info("ステータス: ${res.statusCode}");
      log.info("レスポンス: ${res.body}");

      if (!mounted) return;

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("保存完了")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("保存失敗: ${res.statusCode}")),
        );
      }

    } catch (e) {
      log.severe("通信エラー: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("通信エラー")),
      );
    }
  }

  Widget buildGrid(String place) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          place,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 12,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 2,
          ),
          itemBuilder: (_, index) {
            return Padding(
              padding: const EdgeInsets.all(6),
              child: TextField(
                controller: controllers[place]![index],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "${index + 1}R",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  @override
  void dispose() {
    for (var list in controllers.values) {
      for (var c in list) {
        c.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("出走頭数 一括入力")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            buildGrid("中山"),
            buildGrid("阪神"),
            buildGrid("福島"),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submit,
                child: const Text("一括保存"),
              ),
            )
          ],
        ),
      ),
    );
  }
}