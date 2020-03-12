import 'package:booking/ui/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'ui/main_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MainApp();
  }

}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'aTaxi.Заказ такси',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      initialRoute: '/splash',
      routes: {
        '/main': (context) => MainScreen(),
        '/splash': (context) => SplashScreen(),
      },
    );
  }


}
