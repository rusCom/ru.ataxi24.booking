import 'package:booking/models/main_application.dart';
import 'package:booking/models/profile.dart';
import 'package:booking/services/rest_service.dart';
import 'package:booking/ui/main_screen.dart';
import 'package:booking/ui/profile/profile_login_screen.dart';
import 'package:booking/ui/profile/profile_registration_screen.dart';
import 'package:booking/ui/utils/background.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String state = "init";
  double posLogoBottom = 0;
  double posLogoLeft = 0;
  final Widget background = Background();

  Animation<double> _logoScaleAnimation;
  AnimationController _logoScaleAnimationController;

  Animation<double> _logoMoveAnimationBottom, _logoMoveAnimationLeft;
  AnimationController _logoMoveAnimationControllerBottom, _logoMoveAnimationControllerLeft;

  startTime() async {
    await MainApplication().init(context);
    await profileAuth();
  }

  profileAuth() async {
    bool isAuth = await Profile().auth();
    if (isAuth) {
      /*
      Map<String, dynamic> restResult = await RestService().httpGet("/data");
      if ((restResult['status'] == 'OK') & (restResult.containsKey("result"))){
        MainApplication().parseData(restResult['result']);
      }

       */
      setState(() {
        state = "main";
      });
    } else {
      setState(() {
        state = "login";
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _logoScaleAnimationController = new AnimationController(vsync: this, duration: new Duration(milliseconds: 1500));
    Tween _logoScaleTween = new Tween<double>(begin: 1, end: 0.8);
    _logoScaleAnimation = _logoScaleTween.animate(_logoScaleAnimationController);
    _logoScaleAnimationController.forward();
    _logoScaleAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        print("AnimationStatus.completed state = $state");
        if (state == "init") {
          _logoScaleAnimationController.forward();
        } else if (state == "main") {
          Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: MainScreen(),duration: Duration(seconds: 2)));
          // MainApplication().startTimer();
        } else {
          _logoMoveAnimationControllerBottom.forward();
          _logoMoveAnimationControllerLeft.forward();
        }
      } else if (status == AnimationStatus.completed) _logoScaleAnimationController.reverse();
    });

    startTime();

    initLogoMove();
  }

  initLogoMove() {
    int moveDuration = 500;
    _logoMoveAnimationControllerBottom = new AnimationController(vsync: this, duration: Duration(milliseconds: moveDuration));
    Tween _logoMoveTweenBottom = new Tween<double>(begin: 1 / 3, end: 1 - 1 / 3);
    _logoMoveAnimationBottom = _logoMoveTweenBottom.animate(_logoMoveAnimationControllerBottom);
    _logoMoveAnimationBottom.addListener(() {
      setState(() {});
    });

    _logoMoveAnimationControllerLeft = new AnimationController(vsync: this, duration: Duration(milliseconds: moveDuration));
    Tween _logoMoveTweenLeft = new Tween<double>(begin: 1 / 4, end: 1 / 2.5);
    _logoMoveAnimationLeft = _logoMoveTweenLeft.animate(_logoMoveAnimationControllerLeft);
    _logoMoveAnimationLeft.addListener(() {
      setState(() {});
    });

    _logoMoveAnimationControllerLeft.addStatusListener((status) {
      if (status == AnimationStatus.completed ){
        Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: ProfileLoginScreen(background: background),duration: Duration(seconds: 1)));
        // Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: ProfileRegistrationScreen(background: background),duration: Duration(seconds: 2)));

      }

    });
  }

  @override
  void dispose() {
    _logoMoveAnimationControllerBottom?.dispose();
    _logoMoveAnimationControllerLeft?.dispose();
    _logoScaleAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          background,
          Positioned(
            bottom: MediaQuery.of(context).size.height * _logoMoveAnimationBottom.value,
            left: MediaQuery.of(context).size.width * _logoMoveAnimationLeft.value,
            child: ScaleTransition(
              scale: _logoScaleAnimation,
              child: Image.asset(
                "assets/images/splash_logo.png",
                width: MediaQuery.of(context).size.width / 2,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
