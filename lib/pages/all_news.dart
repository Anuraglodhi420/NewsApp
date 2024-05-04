import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newshub/models/article_model.dart';
import 'package:newshub/models/slider_model.dart';
import 'package:newshub/pages/article_view.dart';
import 'package:newshub/services/news.dart';
import 'package:newshub/services/slider_data.dart';

class AllNews extends StatefulWidget {
  final String news; // Declaring variable as final since it won't change
  const AllNews({required this.news, Key? key})
      : super(key: key); // Add nullability check

  @override
  State<AllNews> createState() => _AllNewsState(); // Define state
}

class _AllNewsState extends State<AllNews> {
  List<sliderModel> sliders = [];
  List<ArticleModel> articles = []; // Initialize with empty lists
  bool _loading = true; // Track loading state

  @override
  void initState() {
    super.initState(); // Call parent initState
    getSlider(); // Fetch slider data
    getNews(); // Fetch news articles
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    setState(() {
      articles = newsClass.news; // Update articles
      _loading = false; // Set loading to false once data is loaded
    });
  }

  getSlider() async {
    Sliders sliderClass = Sliders();
    await sliderClass.getSlider();
    setState(() {
      sliders = sliderClass.sliders; // Update sliders
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.news} News", // Interpolate news type in the title
          style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black54),
        ),
        centerTitle: true, // Center the title
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(), // Avoid over-scrolling
              itemCount:
                  widget.news == "Breaking" ? sliders.length : articles.length,
              itemBuilder: (context, index) {
                return AllNewsSection(
                  image: widget.news == "Breaking"
                      ? sliders[index].urlToImage!
                      : articles[index].urlToImage!,
                  desc: widget.news == "Breaking"
                      ? sliders[index].description!
                      : articles[index].description!,
                  title: widget.news == "Breaking"
                      ? sliders[index].title!
                      : articles[index].title!,
                  url: widget.news == "Breaking"
                      ? sliders[index].url!
                      : articles[index].url!,
                );
              },
            ),
    );
  }
}

class AllNewsSection extends StatelessWidget {
  final String image; // Update variable name to lowercase
  final String desc;
  final String title;
  final String url;

  const AllNewsSection({
    required this.image,
    required this.desc,
    required this.title,
    required this.url,
    Key? key, // Add nullability check
  }) : super(key: key); // Proper superclass constructor

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleView(blogurl: url),
          ),
        ); // Navigate to article view
      },
      child: Padding(
        // Use consistent padding
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Start-align content
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10), // Rounded corners
              child: CachedNetworkImage(
                imageUrl: image, // Display the image
                width: MediaQuery.of(context).size.width, // Full width
                height: 200, // Fixed height
                fit: BoxFit.cover, // Ensure the image covers the space
                errorWidget: (context, url, error) =>
                    Icon(Icons.error), // Error icon if image fails to load
              ),
            ),
            const SizedBox(height: 6.0), // Consistent spacing
            Text(
              title, // Display title
              maxLines: 2, // Maximum number of lines
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black), // Styling for title
            ),
            const SizedBox(height: 5.0),
            Text(
              desc, // Display description
              maxLines: 4, // Maximum number of lines for description
              style: TextStyle(
                  // Ensure text is readable
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black54),
            ),
            const SizedBox(height: 5.0),
          ],
        ),
      ),
    );
  }
}
