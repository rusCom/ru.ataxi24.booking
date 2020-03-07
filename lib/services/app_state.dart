import 'dart:async';

import 'package:booking/models/order.dart';
import 'package:booking/services/map_markers_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CurOrderState{
  new_order,
  search_car
}

class AppStateProvider{
  static final AppStateProvider _singleton = AppStateProvider._internal();
  factory AppStateProvider() {return _singleton;}
  AppStateProvider._internal();

  SharedPreferences _sharedPreferences;
  LatLng _lastLocation, _curLocation;
  BuildContext _context;
  Order _curOrder;


  init(BuildContext context) async {
    print("AppStateProvider init start");
    _context = context;
    _sharedPreferences = await SharedPreferences.getInstance();
    _lastLocation = new LatLng(_sharedPreferences.getDouble("lastLocationLatitude") ?? 0, _sharedPreferences.getDouble("lastLocationLongitue") ?? 0);

    // текущее местоположение
    var currentLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    _curLocation = new LatLng(currentLocation.latitude, currentLocation.longitude);

    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    Geolocator().getPositionStream(locationOptions).listen(
            (Position position) {
              if (position != null){
                _curLocation = new LatLng(position.latitude, position.longitude);
                print("get location " + _curLocation.toString());
              }
        });

    await MapMarkersProvider().init(context);
    _curOrder = Order();
    _curOrder.orderState = OrderState.new_order;

  }


  Order get curOrder => _curOrder;

  get curLocation => _curLocation;

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