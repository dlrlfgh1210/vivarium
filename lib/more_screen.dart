import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:vivarium/authentication/repos/authentication_repo.dart';
import 'package:vivarium/authentication/views/log_in_screen.dart';

class MoreScreen extends ConsumerStatefulWidget {
  static const String routeName = "More";
  static const String routeURL = "/More";
  const MoreScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MoreScreenState();
}

class _MoreScreenState extends ConsumerState<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("More"),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text("Log out"),
            textColor: Colors.blue.shade300,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("로그아웃 하시겠습니까?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        "No",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(authRepository).signOut();
                        context.goNamed(LogInScreen.routeName);
                      },
                      child: const Text(
                        "Yes",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
