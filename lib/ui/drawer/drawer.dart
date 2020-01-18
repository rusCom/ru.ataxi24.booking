
import 'package:booking/services/profile_provider.dart';
import 'package:flutter/material.dart';

Widget MainDrawer(ProfileStateProvider state){
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