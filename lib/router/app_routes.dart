import 'package:practice/firebase/wrapper_screen.dart';
import 'package:practice/firestore/firestore_fetch_data.dart';
import 'package:practice/firestore/firestore_send_data.dart';
import 'package:practice/firestore/firestore_view.dart';
import 'package:practice/home_page/home_page_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:practice/local_notification/local_notification.dart';
import 'package:practice/rest_api/api_home_page_ui.dart';
import 'package:practice/rest_api/complex_json/complex_api.dart';
import 'package:practice/test/test_section.dart';
final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const WrapperScreen()),
    GoRoute(path: '/homepage', builder: (context, state) => const HomePageScreen()),
    GoRoute(path: '/notification', builder: (context, state) => LocalNotification()),
    GoRoute(path: '/complexApi', builder: (context, state) => const ComplexApi()),
    GoRoute(path: '/apiUI', builder: (context, state) => const ApiHomePageUi()),
    GoRoute(path: '/firestore', builder: (context, state) => const FirestoreView()),
    GoRoute(path: '/firestoreSend', builder: (context, state) => const FirestoreSendData()),
    GoRoute(path: '/firestoreFetch', builder: (context, state) => const FirestoreFetchData()),
    GoRoute(path: '/test', builder: (context, state) => const TestSection()),


  ],
);