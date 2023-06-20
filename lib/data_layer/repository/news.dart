// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class News extends Equatable {
  final String title;
  final String publishedAt;
  const News({
    required this.title,
    required this.publishedAt,
  });

  News copyWith({
    String? title,
    String? publishedAt,
  }) {
    return News(
      title: title ?? this.title,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'publishedAt': publishedAt,
    };
  }

  factory News.fromMap(Map<String, dynamic> map) {
    return News(
      title: map['title'] as String,
      publishedAt: map['publishedAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory News.fromJson(String source) => News.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'News(title: $title)';

  @override
  bool operator ==(covariant News other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title;
  }

  @override
  int get hashCode => title.hashCode;

  @override
  List<Object> get props => [title, publishedAt];

  @override
  bool get stringify => true;
}
