import 'package:practice/home_page/home_page_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:practice/local_notification/local_notification.dart';
import 'package:practice/rest_api/complex_json/complex_api.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePageScreen()),
    GoRoute(path: '/notification', builder: (context, state) => const LocalNotification()),
    GoRoute(path: '/complexApi', builder: (context, state) => const ComplexApi()),

  ],
);