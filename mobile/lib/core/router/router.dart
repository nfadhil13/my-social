import 'package:my_social/features/auth/presentation/pages/login/login_page.dart';
import 'package:my_social/features/auth/presentation/pages/register/register_page.dart';
import 'package:my_social/features/home/presentation/pages/home/home_page.dart';
import 'package:my_social/features/landing/presentation/pages/landing/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routes.dart';

class AppRouter {
  const AppRouter._();

  static final router = GoRouter(
    initialLocation: AppRoutes.landing,
    routes: [
      GoRoute(
        path: AppRoutes.landing,
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(path: AppRoutes.login, builder: (context, state) => LoginPage()),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}
