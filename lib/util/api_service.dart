import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import "package:http/http.dart" as http;

class ApiService {
  static const baseUrl = "internhs-vbgn4.ondigitalocean.app";

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

      if (kDebugMode) {
        print(response.body);
      }

      if (response.statusCode == 200) {
        List<String> stringList = response.body
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll('\n', '')
            .split(',')
            .map((e) => e.trim().replaceAll('"', ''))
            .toList();
        return stringList;
      } else {
        if (kDebugMode) {
          print(
              'Failed to recommend jobs: ${response.statusCode} - ${response.body}');
        }
        throw Exception('Failed to recommend jobs');
      }
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('Error recommending jobs: $e');
      }
      if (kDebugMode) {
        print('Stacktrace: $stacktrace');
      }
      rethrow;
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
        if (kDebugMode) {
          print(
              'Failed to scrape jobs: ${response.statusCode} - ${response.body}');
        }
        throw Exception('Failed to scrape jobs');
      }
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('Error scraping jobs: $e');
      }
      if (kDebugMode) {
        print('Stacktrace: $stacktrace');
      }
      rethrow;
    }
  }
}
