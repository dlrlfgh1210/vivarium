import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "home";
  static const routeURL = "/home";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Home Screen",
        ),
      ),
    );
  }
}
