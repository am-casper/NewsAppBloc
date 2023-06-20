// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app_final/data_layer/news.dart';

class NewsNotFound implements Exception {}

class NewsApi {
  NewsApi({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;
  static const _baseUrl = 'newsapi.org';
  Future<List<News>?> fetchNews(String category) async {
    final newsRequest = Uri.https(
      _baseUrl,
      '/v2/top-headlines',
      {
        'country': 'us',
        'category': category,
        'apiKey': 'e304f5ea92a44f5d89e1c5af74dd43b6'
      },
    );
    final newsResponse = await _httpClient.get(newsRequest);
    if (newsResponse.statusCode == 200) {
      final newsJson = jsonDecode(newsResponse.body) as Map;
      final articles = newsJson['articles'] as List;
      return articles.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return News.fromMap(map);
      }).toList();
    }
    throw NewsNotFound;
  }
}
