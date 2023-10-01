// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';

import 'package:news_app_final/News/news_list_item.dart';
import 'package:news_app_final/News/index.dart';

import 'package:news_app_final/data_layer/news.dart';

List<String> categories = [
  "business",
  "entertainment",
  "general",
  "health",
  "science",
  "sports",
  "technology"
];

class NewsList extends StatefulWidget {
  String category;

  NewsList({
    Key? key,
    required this.category,
  }) : super(key: key);
  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  late String category;

  @override
  void initState() {
    super.initState();
    category = widget.category;
  }

  Widget newsList(NewsState state) {
    switch (state.status) {
      case NewsStatus.failure:
        Fluttertoast.showToast(msg: "No Internet Connection");
        List<News>? list = [];
        final newsBox = Hive.box<News>("news_box");
        int length = newsBox.length;
        for (int i = 0; i < newsBox.length; i++) {
          News news = newsBox.get(i)!;
          list.add(news);
        }
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            if (index == length - 1) {
              String title = list[index].title;
              String publishedAt = list[index].publishedAt;
              return NewsListItem(
                  news: News(title: title, publishedAt: publishedAt));
            }
            return NewsListItem(news: list[index]);
          },
          itemCount: length,
        );
      case NewsStatus.success:
        if (state.news.isEmpty) {
          return const Center(child: Text('no posts'));
        }
        int length = state.news.length;
        List<News> list = state.news;
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            if (index == length - 1) {
              String title = state.news[index].title;
              String publishedAt = state.news[index].publishedAt;
              return NewsListItem(
                  news: News(title: title, publishedAt: publishedAt));
            }
            return NewsListItem(news: list[index]);
          },
          itemCount: state.news.length,
        );
      case NewsStatus.initial:
        return const Center(child: CircularProgressIndicator());
      case NewsStatus.loading:
        return const Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsBloc, NewsState>(
      bloc: BlocProvider.of<NewsBloc>(context),
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(15.0),
                child: DropdownButton<String>(
                  value: category,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      category = value!;
                    });
                  },
                  items:
                      categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )),
            ElevatedButton(
              onPressed: () {
                state.category = category;
                BlocProvider.of<NewsBloc>(context).add(NewsFetched());
              },
              child: const Text("Submit"),
            ),
            Expanded(
              child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<NewsBloc>().add(NewsRefreshed());
                  },
                  child: newsList(state)),
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
