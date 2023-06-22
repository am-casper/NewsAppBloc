import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_final/app.dart';
import 'package:news_app_final/simple_bloc_observer.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'data_layer/news.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const SimpleBlocObserver();
  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  Hive.registerAdapter(NewsAdapter());

  await Hive.openBox<News>('news_box');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

 

  runApp(const App());
}
