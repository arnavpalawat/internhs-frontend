import 'dart:async'; // Import this for Stopwatch
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "http://127.0.0.1:5000";

  Future<List<String>> getRecommendations({required String uid}) async {
    const apiUrl = '$baseUrl/server/recommend';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'uid': uid}),
      );

      print(response.body);

      if (response.statusCode == 200) {
        // Assuming the response body contains a JSON object with a 'recommendedIds' key
        List<String> stringList = response.body
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll('\n', '')
            .split(',')
            .map((e) => e.trim().replaceAll('"', ''))
            .toList();
        return stringList;
      } else {
        print(
            'Failed to recommend jobs: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to recommend jobs');
      }
    } catch (e, stacktrace) {
      print('Error recommending jobs: $e');
      print('Stacktrace: $stacktrace');
      throw e;
    }
  }

  Future<Map<String, dynamic>> scrapeJobs({
    required String countryValue,
    required String radiusValue,
    required bool remoteValue,
    required String ageValue,
  }) async {
    const apiUrl = '$baseUrl/server/scrape';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'country': countryValue,
          'radius': radiusValue,
          'remote': remoteValue,
          'age': ageValue,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print(
            'Failed to scrape jobs: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to scrape jobs');
      }
    } catch (e, stacktrace) {
      print('Error scraping jobs: $e');
      print('Stacktrace: $stacktrace');
      throw e;
    }
  }
}
