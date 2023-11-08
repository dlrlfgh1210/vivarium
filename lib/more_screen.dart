import 'package:flutter/material.dart';

class MoreScreen extends StatefulWidget {
  static const routeName = "More";
  static const routeURL = "/More";
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "More Screen",
        ),
      ),
    );
  }
}
