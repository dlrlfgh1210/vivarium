import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:vivarium/home/views/home_screen.dart';
import 'package:vivarium/calculator/views/calculator_screen.dart';
import 'package:vivarium/navigation/widgets/nav_tab.dart';
import 'package:vivarium/navigation/widgets/post_button.dart';
import 'package:vivarium/post/views/post_screen.dart';
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
    "xxxx",
    "my",
    "calculator",
  ];
  late int _selectedIndex = _tabs.indexOf(widget.tab);

  void _onTap(int index) {
    context.go("/${_tabs[index]}");
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onPostButtonTap() {
    context.pushNamed(PostScreen.routeName);
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
            offstage: _selectedIndex != 3,
            child: const UserProfileSCreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 4,
            child: const CalculatorScreen(),
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
                GestureDetector(
                  onTap: _onPostButtonTap,
                  child: PostButton(inverted: _selectedIndex != 0),
                ),
                NavTab(
                  text: "MY",
                  isSelected: _selectedIndex == 3,
                  icon: FontAwesomeIcons.solidUser,
                  selectedIcon: FontAwesomeIcons.solidUser,
                  onTap: () => _onTap(3),
                ),
                NavTab(
                  text: "계산",
                  isSelected: _selectedIndex == 4,
                  icon: FontAwesomeIcons.calculator,
                  selectedIcon: FontAwesomeIcons.calculator,
                  onTap: () => _onTap(4),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
