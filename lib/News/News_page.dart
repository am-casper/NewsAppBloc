// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:news_app_final/News/News_list.dart';
import 'package:news_app_final/News/index.dart';
import 'package:news_app_final/data_layer/repository/news_repository.dart';

// class NewsPage extends StatefulWidget {
//   static const String routeName = '/news';

//   @override
//   _NewsPageState createState() => _NewsPageState();
// }

// class _NewsPageState extends State<NewsPage> {
//   final _newsBloc = NewsBloc(const NewsState() as NewsRepository);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('News'),
//       ),
//       body: NewsScreen(newsBloc: _newsBloc),
//     );
//   }
// }

// ignore: must_be_immutable
class NewsPage extends StatelessWidget {
  String category;
  NewsPage({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('News'),
        actions: [
          IconButton.filled(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.exit_to_app_rounded),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => NewsBloc(
          newsRepository: NewsRepository(),
          category: category,
        )..add(NewsFetched()),
        child: NewsList(category: category),
      ),
    );
  }
}
