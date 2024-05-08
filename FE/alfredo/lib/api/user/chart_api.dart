import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../provider/user/future_provider.dart';

class ChartApi {
  static final String _baseUrl = dotenv.env['TODO_API_URL']!;

  static Future<List<BarChartGroupData>> fetchChartData(WidgetRef ref) async {
    final idToken = await ref.watch(authManagerProvider.future);
    if (idToken == null) {
      throw Exception('No ID Token found');
    }

    var url = Uri.parse('$_baseUrl/dayresult');

    try {
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $idToken',
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return List.generate(
            7,
            (index) => BarChartGroupData(x: index, barRods: [
                  BarChartRodData(
                      toY: data[index.toString()].toDouble(),
                      color: const Color(0xFF0D2338)),
                ]));
      } else {
        throw Exception('Failed to load chart data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
