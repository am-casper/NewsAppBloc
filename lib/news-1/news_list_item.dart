import 'package:flutter/material.dart';

import '../data_layer/news.dart';

class NewsListItem extends StatelessWidget {
  const NewsListItem({required this.news, super.key});

  final News news;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child: ListTile(
        leading:
            Text(news.publishedAt.substring(0, 10), style: textTheme.bodySmall),
        title: Text(news.title),
        isThreeLine: false,
        dense: true,
      ),
    );
  }
}
