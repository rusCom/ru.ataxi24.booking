import 'package:booking/ui/profile/profile_login_screen.dart';
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
      title: 'Сервис Заказа Такси',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      initialRoute: '/splash',
      routes: {
        '/main': (context) => MainScreen(),
        '/splash': (context) => SplashScreen(),
        '/login': (context) => ProfileLoginScreen(),
      },
    );
  }


}
