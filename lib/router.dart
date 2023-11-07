import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import 'package:vivarium/home_screen.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: HomeScreen.routeURL,
    routes: [
      GoRoute(
        path: HomeScreen.routeURL,
        name: HomeScreen.routeName,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
});
