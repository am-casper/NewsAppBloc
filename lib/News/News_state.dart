// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../data_layer/news.dart';

// part of 'News_bloc.g.dart';
// part of 'News_state.dart';

enum NewsStatus { initial, success, failure, loading }

// ignore: must_be_immutable
class NewsState extends Equatable {
  final List<News> news;
  final NewsStatus status;
  String category;
    NewsState({
    this.news = const <News>[],
    this.status = NewsStatus.initial,
    this.category = "entertainment",
  });

  @override
  List<Object> get props => [news, status];
  NewsState copyWith({
    List<News>? news,
    NewsStatus? status,
    String? category,
  }) {
    return NewsState(
      news: news ?? this.news,
      status: status ?? this.status,
      category: category ?? this.category,
    );
  }

  // factory NewsState.fromJson(Map<String, dynamic> json) =>
  //     _$NewsStateFromJson(json);
  // Map<String, dynamic> toJson() => _$NewsStateToJson(this);

  @override
  String toString() {
    return '''NewsState { status: $status, news: ${news.length}, category: $category }''';
  }

  @override
  bool get stringify => true;
}
