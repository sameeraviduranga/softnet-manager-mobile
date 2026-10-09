import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:softnetmanager/core/locators/locator.dart';
import 'package:softnetmanager/core/router/auth_notifier.dart';
import 'package:softnetmanager/core/router/route_names.dart';
import 'package:softnetmanager/features/auth/cubit/AuthSessionManager.dart';
import 'package:softnetmanager/features/auth/cubit/auth_cubit.dart';
import 'package:softnetmanager/features/auth/views/login.dart';
import 'package:softnetmanager/features/home.dart';
import 'package:softnetmanager/features/splash/views/splash.dart';

//final _authNotifier = getIt<AuthNotifier>();
final _sessionManager = getIt<AuthSessionmanager>();
//final _authCubit = getIt<AuthCubit>();
final goRouter = GoRouter(
  initialLocation: '/splash',
  refreshListenable: _sessionManager,
  routes: [
    GoRoute(
      name: RouteNames.splash,
      path: '/splash',
      builder: (context, state) => Splash(),
    ),
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
    //final authState = _authCubit.state;
    final isLogin = location == '/login';
    final isSplash = location == '/splash';
    final isRegister = location == '/register';

    // 1. Session restore වෙනකම් splash එකේ ඉන්න
    if (!_sessionManager.isInitialized) {
      return isSplash ? null : '/splash';
    }
    // 2. User authenticated නැත්නම් login page එකට යවන්න
    if (!_sessionManager.isAuthenticated) {
      return isLogin || isRegister ? null : '/login';
    }
    // 3. User authenticated නම් splash/login/register වල ඉන්න දෙන්න එපා
    if (isLogin || isRegister || isSplash) {
      return '/home';
    }
    // 4. Already authenticated protected route එකක නම්
    return null;
  },
);
