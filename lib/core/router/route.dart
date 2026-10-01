import 'package:go_router/go_router.dart';
import 'package:softnetmanager/core/locators/locator.dart';
import 'package:softnetmanager/core/router/auth_notifier.dart';
import 'package:softnetmanager/core/router/route_names.dart';
import 'package:softnetmanager/features/auth/cubit/auth_cubit.dart';
import 'package:softnetmanager/features/auth/views/login.dart';
import 'package:softnetmanager/features/home.dart';

final _authNotifier = getIt<AuthNotifier>();
final _authCubit = getIt<AuthCubit>();
final goRouter = GoRouter(
  initialLocation: '/login',
  refreshListenable: _authNotifier,
  routes: [
    GoRoute(
      name: RouteNames.login,
      path: '/login',
      builder: (context, state) => Login(),
    ),
    GoRoute(
      name: RouteNames.register,
      path: '/register',
      builder: (context, state) => Login(),
    ),
    GoRoute(
      name: RouteNames.home,
      path: '/home',
      builder: (context, state) => Home(),
    ),
  ],
  redirect: (context, state) {
    final location = state.matchedLocation;
    final authState = _authCubit.state;
    final isLogin = location == '/login';

    if (authState is AuthSuccess) {
      if (isLogin) {
        return '/home';
      }
      return null;
    }
    return null;
  },
);
