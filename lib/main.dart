import 'package:booking/services/app_state.dart';
import 'package:booking/services/map_markers_provider.dart';
import 'package:booking/services/profile_provider.dart';
import 'package:booking/ui/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/main_screen.dart';
import 'ui/route_point/route_point_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppStateProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileStateProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MapMarkersProvider(),
        ),
      ],
      child: MainApp(),
    );
  }

}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      initialRoute: '/splash',
      routes: {
        '/main': (context) => MainScreen(),
        '/route_point': (context) => RoutePointScreen(),
        '/splash': (context) => SplashScreen(),
      },
    );
  }


}
