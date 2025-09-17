import 'package:flutter/material.dart';

import '../../screens/Auth/view/auth_view.dart';
import '../../screens/add_feeds_view/view/add_feeds_view.dart';
import '../../screens/home/view/home_view.dart';

class AppRoutes {
  static const String initial = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String addFeedsView = '/addFeedsView';

  static final Map<String, WidgetBuilder> routes = {
    // initial: (context) => const SplashView(),
    login: (context) => const AuthView(),
    home: (context) => const HomeView(),
    addFeedsView: (context) => const AddFeedsView(),
    //RegisterView
  };
}
