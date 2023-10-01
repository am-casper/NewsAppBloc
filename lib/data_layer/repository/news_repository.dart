import 'package:news_app_final/data_layer/news.dart';
import 'package:news_app_final/data_layer/news_api.dart';

class NewsRepository {
  NewsRepository({NewsApi? newsApiClient})
      : newsApiClient = newsApiClient ?? NewsApi();

  final NewsApi newsApiClient;

  Future<List<News>?> fetchNews(String category) async {
    var newsList = await newsApiClient.fetchNews(category);

    return newsList;
  }
}
