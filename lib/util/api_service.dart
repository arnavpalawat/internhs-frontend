import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://127.0.0.1:8000";

  Future<Map<String, dynamic>> getRecommendations(String uid) async {
    final response =
        await http.get(Uri.parse('$baseUrl/py/recommend?uid=$uid'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recommendations');
    }
  }

  Future<Map<String, dynamic>> scrapeJobs({
    required String countryValue,
    required String radiusValue,
    required bool remoteValue,
    required String ageValue,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/py/scrape'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'country_value': countryValue,
        'radius_value': radiusValue,
        'remote_value': remoteValue,
        'age_value': ageValue,
      }),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to scrape jobs');
    }
  }
}
