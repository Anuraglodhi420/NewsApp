import 'package:flutter/material.dart';
import 'package:newshub/pages/landing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: Landingpage());
  }
}
// c8ef9c504c2c4d3e94c3316c55408f85