import 'package:booking/services/app_state.dart';
import 'package:booking/services/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/main_screen.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}



