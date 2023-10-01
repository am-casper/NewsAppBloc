// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:hive/hive.dart';
part 'news.g.dart';

@HiveType(typeId: 0)
class News {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String publishedAt;
  News({
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

  factory News.fromJson(String source) =>
      News.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'News(title: $title, publishedAt: $publishedAt)';

  @override
  bool operator ==(covariant News other) {
    if (identical(this, other)) return true;

    return other.title == title && other.publishedAt == publishedAt;
  }

  @override
  int get hashCode => title.hashCode ^ publishedAt.hashCode;
}
