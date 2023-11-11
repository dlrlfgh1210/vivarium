import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:vivarium/post_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "home";
  static const routeURL = "/home";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: SizedBox(
            height: 50,
            child: CupertinoSearchTextField(
              placeholder: "수초나 동물이름, 궁금한 글 검색",
              placeholderStyle: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(PostScreen.routeName),
        elevation: 0,
        child: const FaIcon(
          FontAwesomeIcons.plus,
        ),
      ),
      body: const Center(
        child: Text(
          "Home Screen",
        ),
      ),
    );
  }
}
