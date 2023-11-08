import 'package:flutter/material.dart';

class MyScreen extends StatefulWidget {
  static const routeName = "My";
  static const routeURL = "/My";
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "My Screen",
        ),
      ),
    );
  }
}
