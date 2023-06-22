// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:news_app_final/News/index.dart';
import 'package:news_app_final/data_layer/news.dart';

import 'package:news_app_final/data_layer/repository/news_repository.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc({required this.newsRepository, required this.category})
      : super(NewsState(category: category)) {
    on<NewsFetched>(
      (event, emit) {
        _onNewsFetched(event, emit, category);
      },
    );
    on<NewsRefreshed>(_onNewsRefreshed);
  }

  final NewsRepository newsRepository;
  final String category;

  Future<void> _onNewsFetched(
      NewsFetched event, Emitter<NewsState> emit, String category) async {
    print(category);
    emit(state.copyWith(status: NewsStatus.loading));

    try {
      // print(state.category);
      final news = await newsRepository.fetchNews(state.category);
      if (news != null) {
        emit(
          state.copyWith(
            status: NewsStatus.success,
            //news: news if dont want continuous
            news: await allNews(news),
          ),
        );
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "No Internet Connection");
      emit(state.copyWith(status: NewsStatus.failure));
    }
  }

  Future<List<News>> allNews(List<News>? news) async {
    final newsBox = Hive.box<News>("news_box");
    for (var element in news!) {
      if (!newsBox.values.contains(element)) {
        await newsBox.add(element);
      }
    }
    return news;
  }

  FutureOr<void> _onNewsRefreshed(
      NewsRefreshed event, Emitter<NewsState> emit) async {
    emit(state.copyWith(status: NewsStatus.loading));

    try {
      print(state.category);
      final news = await newsRepository.fetchNews(state.category);
      if (news != null) {
        emit(
          state.copyWith(
            status: NewsStatus.success,
            news: news,
          ),
        );
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "No Internet Connection");
      emit(state.copyWith(status: NewsStatus.failure));
    }
  }
}
