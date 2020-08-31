import 'dart:async';
import 'package:audioplayers/audio_cache.dart';
import 'package:booking/models/order.dart';
import 'package:booking/models/preferences.dart';
import 'package:booking/models/profile.dart';
import 'package:booking/models/route_point.dart';
import 'package:booking/services/map_markers_service.dart';
import 'package:booking/services/rest_service.dart';
import 'package:booking/ui/utils/core.dart';
import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class MainApplication {
  static final MainApplication _singleton = MainApplication._internal();

  factory MainApplication() => _singleton;

  MainApplication._internal();

  SharedPreferences _sharedPreferences;
  Position currentPosition;
  Order _curOrder;
  String deviceId, _clientToken;
  GoogleMapController mapController;
  Preferences preferences = Preferences();
  bool _timerStarted = false;
  bool _dataCycle;
  TargetPlatform targetPlatform;
  Map<String, dynamic> clientLinks = Map();
  List<RoutePoint> nearbyRoutePoint = null;

  static AudioCache audioCache = new AudioCache();
  static const audioAlarmOrderStateChange = "sounds/order_state_change.wav";

  Future<bool> init(BuildContext context) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    deviceId = await DeviceId.getID;

    currentPosition = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.lowest);
    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    Geolocator().getPositionStream(locationOptions).listen((Position position) {
      if (position != null) {
        currentPosition = position;

      }
    });



    targetPlatform = Theme.of(context).platform;

    await MapMarkersService().init(context);
    _clientToken = _sharedPreferences.getString("_clientToken") ?? "";
    // _clientToken = "";
    return true;
  }




  Order get curOrder {
    if (_curOrder == null){_curOrder = Order();}
    return _curOrder;
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  hideProgress(BuildContext context) {
    Navigator.pop(context);
  }

  showProgress(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(
                  //backgroundColor: Colors.yellow,
                  ),
            ));
  }

  showSnackBarError(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(text),
      duration: Duration(seconds: 3),
    ));
  }

  parseData(Map<String, dynamic> jsonData) {
    if (DebugPrint().parseDataDebugPrint){
      Logger().v("##### MainApplication.parseData jsonData = " + jsonData.toString());
    }

    if (jsonData == null) return;
    if (jsonData.containsKey('client_links')){
      clientLinks['user_agreement'] = jsonData['client_links']['user_agreement'];
      clientLinks['privacy_policy'] = jsonData['client_links']['privacy_policy'];
      clientLinks['license_agreement'] = jsonData['client_links']['license_agreement'];

    }
    if (jsonData.containsKey("preferences")) preferences.parseData(jsonData["preferences"]);
    if (jsonData.containsKey("profile")) Profile().parseData(jsonData["profile"]);
    if (jsonData.containsKey("order"))
      curOrder.parseData(jsonData["order"]);
    else
      curOrder.orderState = OrderState.new_order;
  }

  LatLng get currentLocation => LatLng(currentPosition.latitude, currentPosition.longitude);

  get clientToken {
    if (_clientToken == "") return "_null";
    if (_clientToken == null) return "_null";
    return _clientToken;
  }

  set clientToken(value) {
    _clientToken = value;
    _sharedPreferences.setString("_clientToken", value);
  }

  set dataCycle(bool value) {
    _dataCycle = value;
    if (_dataCycle == false){
      _timerStarted = false;
    }
    // Logger().d("check start data cycle");

    if (_dataCycle) {
      // Logger().d("check start data cycle");
      if (!_timerStarted) {
        // Logger().d("start data cycle");
        _timerStarted = true;
        Timer.periodic(Duration(seconds: 5), (timer) async {
          // print("data cycle tick");

          Map<String, dynamic> restResult = await RestService().httpGet("/data");
          if ((restResult['status'] == 'OK') & (restResult.containsKey("result"))) {
            parseData(restResult['result']);
          }

          if (!_timerStarted) {
            // print("start data cycle");
            timer.cancel();
          }
        });
      }
    }
  }

}
