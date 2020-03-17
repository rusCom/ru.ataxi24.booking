import 'dart:async';
import 'dart:convert';

import 'package:booking/models/preferences.dart';
import 'package:booking/models/route_point.dart';
import 'package:booking/services/geo_service.dart';
import 'package:booking/services/map_markers_service.dart';
import 'package:booking/services/rest_service.dart';
import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

import 'models/order.dart';
import 'models/profile.dart';

class MainApplication {
  static final MainApplication _singleton = MainApplication._internal();

  factory MainApplication() {
    return _singleton;
  }

  MainApplication._internal();

  SharedPreferences _sharedPreferences;
  Position currentPosition;
  Order curOrder;
  String deviceId, _clientToken;
  GoogleMapController mapController;
  String targetPlatform;
  Profile profile = Profile();
  Preferences preferences = Preferences();
  bool timerStarted = false;

  Future<bool> init(BuildContext context) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    deviceId = await DeviceId.getID;

    currentPosition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    Geolocator().getPositionStream(locationOptions).listen((Position position) {
      if (position != null) {
        currentPosition = position;
      }
    });

    // текущая платформа
    if (Theme.of(context).platform == TargetPlatform.android) {
      targetPlatform = "android";
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      targetPlatform = "iOS";
    } else if (Theme.of(context).platform == TargetPlatform.fuchsia) {
      targetPlatform = "fuchsia";
    }

    await MapMarkersService().init(context);

    _clientToken = _sharedPreferences.getString("_clientToken") ?? "";
    // _clientToken = "2F0ED6B4-5EE1-4DE8-B5E0-E757A8541064";
    await profileAuth();


    curOrder = Order();
    curOrder.orderState = OrderState.search_car;
    RoutePoint route = await GeoService().geocode(currentLocation);
    curOrder.addRoutePoint(route);

    startTimer();
    return true;
  }

  profileAuth() async{
    Map<String, dynamic> restResult = await RestService().httpGet("/profile/auth");
    if (restResult['status'] == 'OK'){
      parseData(restResult['result']);
      if (restResult['result'].containsKey("profile")){
        restResult = await RestService().httpGet("/data");
        parseData(restResult['result']);
        startTimer();
      }
    }
  }

  parseData(Map<String, dynamic> jsonData){
    if (jsonData == null)return;
    if (jsonData.containsKey("preferences"))preferences.parseData(jsonData["preferences"]);
    if (jsonData.containsKey("profile"))profile.parseData(jsonData["profile"]);
  }

  LatLng get currentLocation => LatLng(currentPosition.latitude, currentPosition.longitude);

  get clientToken {
    if (_clientToken == "")return "_null";
    if (_clientToken == null)return "_null";
    return _clientToken;
  }

  set clientToken(value) {
    _clientToken = value;
    _sharedPreferences.setString("_clientToken", value);
  }

  startTimer(){
    if (!timerStarted){
      timerStarted = true;
      Timer.periodic(Duration(seconds: preferences.timerTask), (timer) async {
        /*
        Map<String, dynamic> restResult = await RestService().httpGet("/data");
        if ((restResult['status'] == 'OK') & (restResult.containsKey("result"))){
          parseData(restResult['result']);
        }

         */
        if (!timerStarted)timer.cancel();
      });

    }

  }


}
