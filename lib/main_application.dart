import 'package:booking/services/map_markers_service.dart';
import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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


    curOrder = Order();
    curOrder.orderState = OrderState.new_order;

    return true;
  }

  LatLng get currentLocation => LatLng(currentPosition.latitude, currentPosition.longitude);

  get clientToken => _clientToken;

  set clientToken(value) {
    _clientToken = value;
    _sharedPreferences.setString("_clientToken", value);
  }


}
