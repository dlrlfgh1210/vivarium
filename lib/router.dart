import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import 'package:vivarium/authentication/repos/authentication_repo.dart';
import 'package:vivarium/authentication/views/log_in_screen.dart';
import 'package:vivarium/authentication/views/sign_up_screen.dart';
import 'package:vivarium/home/views/home_screen.dart';
import 'package:vivarium/calculator/views/calculator_screen.dart';
import 'package:vivarium/navigation/main_navigation_screen.dart';
import 'package:vivarium/post/views/post_screen.dart';
import 'package:vivarium/search/views/search_screen.dart';

import 'package:vivarium/users/views/users_profile_screen.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: "/home",
    redirect: (context, state) {
      final isLoggedIn = ref.read(authRepository).isLoggedIn;
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
        path: "/:tab(home|search|my|calculator)",
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
        path: UserProfileSCreen.routeURL,
        name: UserProfileSCreen.routeName,
        builder: (context, state) => const UserProfileSCreen(),
      ),
      GoRoute(
        path: CalculatorScreen.routeURL,
        name: CalculatorScreen.routeName,
        builder: (context, state) => const CalculatorScreen(),
      ),
      GoRoute(
        path: PostScreen.routeURL,
        name: PostScreen.routeName,
        builder: (context, state) => const PostScreen(),
      ),
    ],
  );
});
