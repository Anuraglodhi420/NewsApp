import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:newshub/models/article_model.dart';
import 'package:newshub/models/category_model.dart';
import 'package:newshub/models/slider_model.dart';
import 'package:newshub/pages/all_news.dart';
import 'package:newshub/pages/article_view.dart';
import 'package:newshub/pages/category_news.dart';
import 'package:newshub/services/data.dart';
import 'package:newshub/services/slider_data.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:newshub/services/news.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _HomeState();
}

class _HomeState extends State<home> {
  final ScrollController _scrollController =
      ScrollController(); // Scroll controller for scroll events
  bool _showScrollToTopButton =
      false; // Track visibility of "Scroll to Top" button

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose of the controller when done
    super.dispose();
  }

  void _scrollToTop() {
    // Function to scroll to the top
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  int currentIndex = 0;
  List<CategoryModel> categories = [];
  List<sliderModel> sliders = [];
  List<ArticleModel> articles = [];
  bool _loading = true; // Track loading state
  @override
  void initState() {
    super.initState();

    // Handle visibility of "Scroll to Top" button
    _scrollController.addListener(() {
      if (_scrollController.offset >= 300) {
        if (!_showScrollToTopButton) {
          setState(() {
            _showScrollToTopButton = true;
          });
        }
      } else {
        if (_showScrollToTopButton) {
          setState(() {
            _showScrollToTopButton = false;
          });
        }
      }
    });

    categories = getCategories(); // Get list of categories
    getSlider(); // Fetch slider data
    getNews(); // Fetch news articles
  }

  getNews() async {
    // Function to get news
    News newsclass = News();
    await newsclass.getNews();
    articles = newsclass.news;
    setState(() {
      _loading = false; // Set loading to false after fetching news
    });
  }

  getSlider() async {
    // Function to get sliders
    Sliders slider = Sliders();
    await slider.getSlider();
    sliders = slider.sliders; // Update slider data
  }

  // Function to build image for the slider
  Widget buildImage(String image, int index, String name) => Container(
          child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadiusDirectional.circular(6),
            child: CachedNetworkImage(
              imageUrl: image,
              height: 250, // Set height
              fit: BoxFit.cover, // Ensure image covers the space
              width: MediaQuery.of(context).size.width, // Full width
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 170.0),
            padding: EdgeInsets.only(left: 10.0),
            height: 250,
            width: MediaQuery.of(context).size.width, // Full width
            decoration: const BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
            ),
            child: Text(
              maxLines: 2,
              name,
              style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white), // Text styling
            ),
          )
        ],
      ));

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: currentIndex,
        count: 5, // Number of items in the indicator
        effect: ExpandingDotsEffect(
          activeDotColor: Colors.green,
          dotColor: Colors.red.shade400, // Dot color
          dotHeight: 10,
          dotWidth: 10,
          spacing: 6, // Spacing between dots
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // No back button on the app bar
        backgroundColor: Colors.grey.shade200,
        title: Center(
          child: Container(
            width:
                MediaQuery.of(context).size.width, // Full width for the title
            height: 34,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center title
              children: [
                Text(
                  "News",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize: 24.0,
                    shadows: [
                      Shadow(
                        blurRadius: 1.0,
                        color: Colors.grey.withOpacity(0.5),
                        offset: const Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.grey.shade300,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4), // Rounded corners
                  ),
                  child: Text(
                    "hub",
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                      shadows: [
                        Shadow(
                          blurRadius: 3.0,
                          color: Colors.grey.withOpacity(0.5),
                          offset: const Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _loading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator if data is loading
          : SingleChildScrollView(
              controller: _scrollController,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey.shade300,
                      Colors.white,
                    ],
                  ),
                ),
                width: double.infinity, // Full width
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Left-align content
                  children: [
                    // Category tiles
                    Container(
                      height: 70, // Fixed height for the category list
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return CategoryTile(
                            image: categories[index].image,
                            categoryName: categories[index].categoryName,
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Space between text and button
                        children: [
                          const Text(
                            "Breaking News",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily:
                                  AutofillHints.countryCode, // Font family
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllNews(
                                          news:
                                              "Breaking"))); // Navigate to "All News" page
                            },
                            child: const Text(
                              "View all",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Carousel for sliders
                    Container(
                      child: CarouselSlider.builder(
                          itemCount: 5,
                          itemBuilder: (context, index, realIndex) {
                            String? res =
                                sliders[index].urlToImage; // Get image URL
                            String? res1 = sliders[index].title; // Get title
                            return buildImage(
                                res!, index, res1!); // Create slider item
                          },
                          options: CarouselOptions(
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentIndex = index; // Update current index
                                });
                              },
                              autoPlayInterval: const Duration(
                                  seconds: 3), // Interval between slides
                              height: 250, // Height for carousel
                              autoPlay: true, // Auto-play slides
                              enlargeCenterPage: true, // Enlarge center page
                              enlargeStrategy: CenterPageEnlargeStrategy
                                  .height)), // Strategy for enlarging
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                        child:
                            buildIndicator()), // Show the indicator for the carousel
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 10.0,
                          right: 10.0), // Padding for "Trending News"
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Trending News",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily:
                                    AutofillHints.familyName), // Font family
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllNews(
                                          news:
                                              "Trending"))); // Navigate to "Trending News" page
                            },
                            child: const Text(
                              "View all",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ), // Button styling
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    // List of articles
                    Container(
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            return BlogTile(
                                url: articles[index].url!,
                                desc: articles[index].description!,
                                title: articles[index].title!,
                                imageUrl: articles[index].urlToImage!);
                          }),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton:
          _showScrollToTopButton // Conditionally show scroll-to-top button
              ? FloatingActionButton(
                  backgroundColor: Colors.lightBlue.shade100,
                  onPressed: _scrollToTop, // Scroll to the top
                  child: Icon(Icons.arrow_upward), // Icon for the button
                )
              : null, // No button if condition is false
    );
  }
}

class CategoryTile extends StatelessWidget {
  final image;
  final categoryName;

  CategoryTile({required this.categoryName, required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryNews(
                    name: categoryName))); // Navigate to category news
      },
      child: Container(
        margin: const EdgeInsets.only(left: 9),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow styling
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                image, // Display image
                width: 120, // Width of the image
                height: 70, // Height of the image
                fit: BoxFit.cover, // Cover the space
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter, // Gradient direction
                  colors: [
                    Colors.black.withOpacity(0.1), // Gradient start color
                    Colors.black.withOpacity(0.8), // Gradient end color
                  ],
                ),
              ),
              width: 120,
              height: 70,
              child: Center(
                child: Text(
                  categoryName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ), // Text styling
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String title;
  final String desc;
  final String url;
  final String imageUrl;

  BlogTile({
    required this.title,
    required this.desc,
    required this.url,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ArticleView(blogurl: url))); // Navigate to the article view
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0), // Space between tiles
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 10.0), // Padding for the blog tile
          child: Material(
            borderRadius: BorderRadius.circular(10), // Rounded corners
            elevation: 3,
            color: Colors.white, // Background color
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 5.0), // Padding inside the tile
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Start-align content
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl, // Image URL
                      height: 120, // Fixed height
                      width: 120, // Fixed width
                      fit: BoxFit.cover, // Ensure the image covers the space
                    ),
                  ),
                  SizedBox(width: 8.0), // Space between elements
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Start-align content
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width /
                            1.8, // Width for the text
                        child: Text(
                          title,
                          maxLines: 2, // Maximum lines for the title
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.8,
                        child: Text(
                          desc,
                          maxLines: 3, // Maximum lines for the description
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
