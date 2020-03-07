
import 'dart:async';

import 'package:booking/services/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    await AppStateProvider().init(context);
    // var _duration = new Duration(seconds: 2);
    // return new Timer(_duration, navigationPage);
    Navigator.of(context).pushReplacementNamed('/main');
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/main');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Image.asset('assets/images/splash_logo.png'),
      ),
    );
  }
}