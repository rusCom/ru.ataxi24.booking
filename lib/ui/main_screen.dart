import 'package:booking/services/profile_provider.dart';
import 'package:booking/services/app_state.dart';
import 'package:booking/ui/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'orders/new_order_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        drawer: Consumer<ProfileStateProvider>(builder: (context, state, _) {
          return MainDrawer(state);
        }),
        body: Stack(
          children: <Widget>[
            Center(
              child: Consumer<AppStateProvider>(
                builder: (context, state, _) {
                  switch (state.curOrderState()) {
                    case CurOrderState.new_order:
                      return NewOrderScreen();
                      break;
                    default:
                      return NewOrderScreen();
                  }
                },
              ),
            ),
            Positioned(
              left: 10,
              top: 35,
              child: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => scaffoldKey.currentState.openDrawer(),
              ),
            ),
          ],
        ));
  } // build


}
