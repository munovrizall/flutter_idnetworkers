import 'package:flutter/material.dart';
import 'package:news_app/article.dart';

class DetailPage extends StatelessWidget {
  final Article article;
  const DetailPage({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
      ),
      body: ListView(
        children: [
          Image.network(article.urlToImage),
          Text(
              article.content!)
        ],
      ),
    );
  }
}
