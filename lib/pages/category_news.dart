import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newshub/models/show_category.dart';
import 'package:newshub/pages/article_view.dart';
import 'package:newshub/services/show_category_news.dart';

class CategoryNews extends StatefulWidget {
  final String name;

  const CategoryNews({required this.name});

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<ShowCategoryModel> categories = [];
  bool _loading = true;

  @override
  void initState() {
    getNews();
    super.initState();
  }

  getNews() async {
    ShowCategoryNews showCategoryNews = ShowCategoryNews();
    await showCategoryNews.getCategoiresNews(widget.name.toLowerCase());
    categories = showCategoryNews.categories;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: _loading
          ? Center(
              child:
                  CircularProgressIndicator()) // Display a progress indicator while loading
          : ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return ShowCategory(
                  image: categories[index].urlToImage!,
                  desc: categories[index].description!,
                  title: categories[index].title!,
                  url: categories[index].url!,
                );
              },
            ),
    );
  }
}

class ShowCategory extends StatelessWidget {
  final String image, desc, title, url;

  const ShowCategory({
    required this.image,
    required this.desc,
    required this.title,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ArticleView(blogurl: url)),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align content to the left
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: image,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width /
                    1.5, // Adjust image height based on screen width
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 6.0),
            Text(
              title,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              desc,
              maxLines: 4,
              overflow: TextOverflow
                  .ellipsis, // Add ellipsis (...) for overflowing text
            ),
            SizedBox(height: 5.0),
          ],
        ),
      ),
    );
  }
}
