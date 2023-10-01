// ignore_for_file: public_member_api_docs, sort_constructors_first
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
}
