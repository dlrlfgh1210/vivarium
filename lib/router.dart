import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import 'package:vivarium/authentication/repos/authentication_repo.dart';
import 'package:vivarium/authentication/views/log_in_screen.dart';
import 'package:vivarium/authentication/views/sign_up_screen.dart';
import 'package:vivarium/chat_screen.dart';
import 'package:vivarium/home_screen.dart';
import 'package:vivarium/more_screen.dart';
import 'package:vivarium/my_screen.dart';
import 'package:vivarium/navigation/main_navigation_screen.dart';
import 'package:vivarium/post/views/post_screen.dart';
import 'package:vivarium/search_screen.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: "/home",
    redirect: (context, state) {
      final isLoggedIn = ref.read(authRepo).isLoggedIn;
      if (!isLoggedIn) {
        if (state.matchedLocation != SignUpScreen.routeURL &&
            state.matchedLocation != LogInScreen.routeURL) {
          return LogInScreen.routeURL;
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: LogInScreen.routeURL,
        name: LogInScreen.routeName,
        builder: (context, state) => const LogInScreen(),
      ),
      GoRoute(
        path: SignUpScreen.routeURL,
        name: SignUpScreen.routeName,
        builder: (context, state) => const SignUpScreen(),
      ),
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
      GoRoute(
        path: PostScreen.routeURL,
        name: PostScreen.routeName,
        builder: (context, state) => const PostScreen(),
      ),
    ],
  );
});
