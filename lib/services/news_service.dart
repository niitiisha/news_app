import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/article.dart';

class NewsService {
  final String apiKey;
  final http.Client client;

  NewsService(this.apiKey, {http.Client? client})
    : client = client ?? http.Client();

  Future<List<Article>> fetchHeadlines() async {
    final url = Uri.https('newsapi.org', '/v2/top-headlines', {
      'country': 'us',
      'apiKey': apiKey,
    });

    final response = await client.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return (data['articles'] as List)
          .map((json) => Article.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Failed to load headlines');
  }

  Future<List<Article>> searchNews(String query) async {
    final url = Uri.https('newsapi.org', '/v2/everything', {
      'q': query,
      'apiKey': apiKey,
    });

    final response = await client.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return (data['articles'] as List)
          .map((json) => Article.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Failed to search news');
  }
}
