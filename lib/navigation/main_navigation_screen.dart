import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:vivarium/home_screen.dart';
import 'package:vivarium/more_screen.dart';
import 'package:vivarium/navigation/nav_tab.dart';
import 'package:vivarium/search/views/search_screen.dart';
import 'package:vivarium/users/views/users_profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  static const routeName = "navigation";
  static const routeURL = "/navigation";
  final String tab;
  const MainNavigationScreen({
    super.key,
    required this.tab,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final List<String> _tabs = [
    "home",
    "search",
    "my",
    "more",
  ];
  late int _selectedIndex = _tabs.indexOf(widget.tab);

  void _onTap(int index) {
    context.go("/${_tabs[index]}");
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: const HomeScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 1,
            child: const SearchScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 2,
            child: const UserProfileSCreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 3,
            child: const MoreScreen(),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NavTab(
                  text: "홈",
                  isSelected: _selectedIndex == 0,
                  icon: FontAwesomeIcons.house,
                  selectedIcon: FontAwesomeIcons.house,
                  onTap: () => _onTap(0),
                ),
                NavTab(
                  text: "검색",
                  isSelected: _selectedIndex == 1,
                  icon: FontAwesomeIcons.magnifyingGlass,
                  selectedIcon: FontAwesomeIcons.magnifyingGlass,
                  onTap: () => _onTap(1),
                ),
                NavTab(
                  text: "MY",
                  isSelected: _selectedIndex == 2,
                  icon: FontAwesomeIcons.solidUser,
                  selectedIcon: FontAwesomeIcons.solidUser,
                  onTap: () => _onTap(2),
                ),
                NavTab(
                  text: "전체",
                  isSelected: _selectedIndex == 3,
                  icon: FontAwesomeIcons.bars,
                  selectedIcon: FontAwesomeIcons.bars,
                  onTap: () => _onTap(3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
