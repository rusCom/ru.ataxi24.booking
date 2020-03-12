import 'package:flutter/material.dart';


class MainDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Настройки"),
          )
        ],
      ),

    );

  }
}