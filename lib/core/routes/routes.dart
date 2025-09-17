import 'package:flutter/material.dart';

import '../../screens/Auth/view/auth_view.dart';

class AppRoutes {
  static const String initial = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';

  static final Map<String, WidgetBuilder> routes = {
    // initial: (context) => const SplashView(),
    login: (context) => const AuthView(),
    // home: (context) => const HomeView(),
    // register: (context) => const RegisterView(),
    //RegisterView
  };
}
