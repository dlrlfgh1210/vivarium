import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:vivarium/authentication/repos/authentication_repo.dart';
import 'package:vivarium/authentication/views/log_in_screen.dart';
import 'package:vivarium/users/views/widgets/avatar.dart';
import 'package:vivarium/users/views/widgets/persistent_tab_bar.dart';
import 'package:vivarium/users/view_models/users_view_model.dart';

class UserProfileSCreen extends ConsumerStatefulWidget {
  static const routeName = "My";
  static const routeURL = "/My";
  const UserProfileSCreen({super.key});

  @override
  UserProfileSCreenState createState() => UserProfileSCreenState();
}

class UserProfileSCreenState extends ConsumerState<UserProfileSCreen> {
  void _logOutPressed() {
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
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(usersProvider).when(
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          data: (data) => Scaffold(
            body: SafeArea(
              child: DefaultTabController(
                length: 2,
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        actions: [
                          IconButton(
                            onPressed: _logOutPressed,
                            icon: const FaIcon(
                              FontAwesomeIcons.doorOpen,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.email,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                    ],
                                  ),
                                  Avatar(
                                    uid: data.uid,
                                    hasAvatar: data.hasAvatar,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: PersistentTabBar(),
                      ),
                    ];
                  },
                  body: const TabBarView(
                    children: [
                      Center(
                        child: Text('Page one'),
                      ),
                      Center(
                        child: Text('Page two'),
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
