import 'package:flutter/material.dart';
import 'package:newshub/pages/home.dart';
import 'package:url_launcher/link.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Landingpage extends StatefulWidget {
  const Landingpage({super.key});

  @override
  State<Landingpage> createState() => _LandingpageState();
}

class _LandingpageState extends State<Landingpage> {
  final weburi = Uri.parse(
      'https://www.instagram.com/rajputanuraglodhi?igsh=MTZqdzRnbXhxOWt2aQ==');

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        // Allow scrolling if content overflows
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Material(
                borderRadius: BorderRadius.circular(30), // Rounded corners
                elevation: 3.0, // Elevation for shadow
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'images/landing.jpg', // Path to your image
                    width: double.infinity, // Stretch to full width
                    height:
                        screenHeight / 1.6, // Adjust height to avoid overflow
                    fit: BoxFit.cover, // Ensure the image covers the space
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                "Let's see what's happening\n        around the globe",
                style: TextStyle(
                    fontSize: screenWidth <= 350
                        ? 22
                        : 26, // Adapt font size for smaller screens
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  "A whole newspaper in your hands\n                 in one click!!!",
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      color: Colors.black38),
                ),
              ),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return const home(); // Navigate to your home page
                    }),
                  );
                },
                child: Container(
                  width:
                      screenWidth / 1.6, // Ensure width is within screen bounds
                  child: Material(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                    elevation: 5.0, // Shadow for button
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.amber), // Button color
                      child: const Center(
                        child: Text(
                          "Let's Read",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Link(
                uri: weburi,
                target: LinkTarget.defaultTarget,
                builder: (context, openLink) => GestureDetector(
                  onTap: openLink,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.instagram,
                        color: Colors.pink, // Instagram icon color
                        size: 10, // Icon size
                      ),
                      SizedBox(width: 2.0),
                      Text(
                        "@rajputanuraglodhi", // Instagram username
                        style: TextStyle(fontSize: 8, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
