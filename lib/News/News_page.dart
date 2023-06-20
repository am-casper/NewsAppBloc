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

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    String category = 'entertainment';
    return Scaffold(
      appBar: AppBar(title: const Text('News')),
      body: BlocProvider(
        create: (context) => NewsBloc(
          newsRepository: NewsRepository(),
          category: category,
        )..add(NewsFetched()),
        child: const NewsList(),
      ),
    );
  }
}
