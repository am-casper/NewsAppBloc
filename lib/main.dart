import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_final/app.dart';
import 'package:news_app_final/simple_bloc_observer.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'data_layer/news.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const SimpleBlocObserver();
  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  Hive.registerAdapter(NewsAdapter());

  await Hive.openBox<News>('news_box');

  // final newsBox = Hive.box<News>("news_box");
  // final wljdjcn = (newsBox.deleteFromDisk());
  // print(wljdjcn);
  // print(newsBox.length);
  // for (int i = 0; i < 144; i++) {
  //   // News news = newsBox.get(i)!;
  //   print(newsBox.get(i));
  //   // list.add(news);
  // }
  // print(newsBox.get(143));
  runApp(const App());
}
