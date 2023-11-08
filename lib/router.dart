import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import 'package:vivarium/chat_screen.dart';
import 'package:vivarium/home_screen.dart';
import 'package:vivarium/more_screen.dart';
import 'package:vivarium/my_screen.dart';
import 'package:vivarium/navigation/main_navigation_screen.dart';
import 'package:vivarium/search_screen.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: HomeScreen.routeURL,
    routes: [
      GoRoute(
        path: "/:tab(home|search|my|chat|more)",
        name: MainNavigationScreen.routeName,
        builder: (context, state) {
          final tab = state.pathParameters["tab"]!;
          return MainNavigationScreen(tab: tab);
        },
      ),
      GoRoute(
        path: HomeScreen.routeURL,
        name: HomeScreen.routeName,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: SearchScreen.routeURL,
        name: SearchScreen.routeName,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: MyScreen.routeURL,
        name: MyScreen.routeName,
        builder: (context, state) => const MyScreen(),
      ),
      GoRoute(
        path: ChatScreen.routeURL,
        name: ChatScreen.routeName,
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: MoreScreen.routeURL,
        name: MoreScreen.routeName,
        builder: (context, state) => const MoreScreen(),
      ),
    ],
  );
});
