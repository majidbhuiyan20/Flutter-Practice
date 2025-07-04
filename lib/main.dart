import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:practice/cart_provider/product_list.dart';
import 'package:practice/firebase/ui/splash_screen.dart';
import 'package:practice/rest_api/complex_json/complex_api.dart';
import 'package:practice/rest_api/complex_json_without_model/complex_json_without_model.dart';
import 'package:practice/rest_api/crud_rest_api/crud_api.dart';
import 'package:practice/rest_api/crud_rest_api/view/add_post.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: SplashScreen()
      // ComplexApi()
      // CrudApi(),
    );
  } //m
}
