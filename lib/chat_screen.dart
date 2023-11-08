import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = "Chat";
  static const routeURL = "/Chat";
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Chat Screen",
        ),
      ),
    );
  }
}
