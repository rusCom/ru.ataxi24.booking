import 'package:flutter/material.dart';

import 'arc_clipper.dart';
import 'core.dart';

class MainBackground extends StatelessWidget {
  final showLogo;


  MainBackground({this.showLogo = false});

  Widget topHalf(BuildContext context) {
    var deviceSize = MediaQuery
        .of(context)
        .size;
    return new Flexible(
      flex: 2,
      child: ClipPath(
        clipper: new ArcClipper(),
        child: Stack(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                    colors: kitGradients,
                  )),
            ),
            showLogo
                ? new Center(
              child: SizedBox(
                  height: deviceSize.height / 6,
                  width: deviceSize.width / 2,
                  child: Image.asset("assets/images/splash_logo.png", fit: BoxFit.cover, height: deviceSize.height / 6,)
              ),
            )
                : new Container()


          ],
        ),
      ),
    );
  }

  final bottomHalf = new Flexible(
    flex: 3,
    child: new Container(),
  );


  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[topHalf(context), bottomHalf],
    );
  }


}
