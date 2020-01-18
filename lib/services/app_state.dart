import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CurOrderState{
  new_order,
  search_car
}

class AppStateProvider with ChangeNotifier{
  SharedPreferences _sharedPreferences;
  LatLng _lastLocation;


  AppStateProvider() {
    _lastLocation = new LatLng(0, 0);
    _init();
  }

  _init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _lastLocation = new LatLng(_sharedPreferences.getDouble("lastLocationLatitude") ?? 0, _sharedPreferences.getDouble("lastLocationLongitue") ?? 0);
  }


  set lastLocation(LatLng value) {
    _lastLocation = value;
    _sharedPreferences.setDouble("lastLocationLatitude", _lastLocation.latitude);
    _sharedPreferences.setDouble("lastLocationLongitue", _lastLocation.longitude);
  }

  LatLng get lastLocation => _lastLocation;

  CurOrderState curOrderState(){
    return CurOrderState.new_order;
  }



}