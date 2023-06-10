import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softwareproject/screens/admin_page_view.dart';
import 'package:softwareproject/screens/home_page_view.dart';
import 'package:softwareproject/screens/introduction_page_view.dart';
import 'package:softwareproject/screens/login_page_view.dart';
import 'package:softwareproject/screens/profile_page_view.dart';
import 'package:softwareproject/screens/register_page_view.dart';
import 'package:softwareproject/screens/router_page_view.dart';
import 'package:softwareproject/screens/splashScreen_page_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => IntroductionPageView(),
        '/login': (context) => LoginPageView(),
      },
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0 
        ),
        scaffoldBackgroundColor: Colors.black,
        
      ),
      debugShowCheckedModeBanner: false,
      home: RouterPageView(),
    );
  }
}


