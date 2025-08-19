import 'package:practice/firestore/firestore_fetch_data.dart';
import 'package:practice/firestore/firestore_send_data.dart';
import 'package:practice/firestore/firestore_view.dart';
import 'package:practice/home_page/home_page_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:practice/ostad_flutter/live_test/add_employe.dart';
import 'package:practice/ostad_flutter/ostad_home.dart';
import 'package:practice/project/calculator/calculatorApp.dart';
import 'package:practice/project/crud_app/crud_app_screen.dart';
import 'package:practice/project/money_management/money_management.dart';
import 'package:practice/project/to_do_basic/basic_todo_app.dart';
import 'package:practice/project/water_tracker/water_tracker.dart';
import 'package:practice/rest_api/api_home_page_ui.dart';
import 'package:practice/rest_api/complex_json/complex_api.dart';
import 'package:practice/test/test_section.dart';

import '../firebase/wrapper_screen.dart';
import '../local_notification/local_notification.dart';
import '../ostad_flutter/extend_the_greeting_app/gretting_app_screen.dart';
final GoRouter router = GoRouter(
  routes: [

    GoRoute(path: '/', builder: (context, state) => const WrapperScreen()),
    GoRoute(path: '/addEmployee', builder: (context, state) => const AddEmployee()),
    GoRoute(path: '/grettingApp', builder: (context, state) => const GrettingAppScreen()),
    GoRoute(path: '/homepage', builder: (context, state) => const HomePageScreen()),
    GoRoute(path: '/notification', builder: (context, state) => LocalNotification()),
    GoRoute(path: '/complexApi', builder: (context, state) => const ComplexApi()),
    GoRoute(path: '/apiUI', builder: (context, state) => const ApiHomePageUi()),
    GoRoute(path: '/firestore', builder: (context, state) => const FirestoreView()),
    GoRoute(path: '/firestoreSend', builder: (context, state) => const FirestoreSendData()),
    GoRoute(path: '/firestoreFetch', builder: (context, state) => const FirestoreFetchData()),
    GoRoute(path: '/test', builder: (context, state) => const TestSection()),
    GoRoute(path: '/ostadHome', builder: (context, state) => const OstadHome()),
    GoRoute(path: '/calculator', builder: (context, state) => const CalculatorApp()),
    GoRoute(path: '/waterTracker', builder: (context, state) => const WaterTracker()),
    GoRoute(path: '/moneyManagement', builder: (context, state) => const MoneyManagement()),
    GoRoute(path: '/toDo', builder: (context, state) => const BasicTodoApp()),
    GoRoute(path: '/crudApp', builder: (context, state) => const CrudAppScreen()),



  ],
);