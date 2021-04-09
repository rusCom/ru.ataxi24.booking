import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class MainUtils {
  static bool parseBool(var value) {
    if (value == null) return false;
    if (value.toString().toLowerCase() == "true") return true;
    if (value.toString() == "1") return true;
    return false;
  }

  static int parseInt(var value, {var def = 0}) {
    if (value == null) return def;
    return int.parse(value.toString());
  }
}

class Const {
  static List<Color> kitGradients = [
    Colors.blueGrey.shade800,
    Colors.black87,
  ];
  static const List<Color> signUpGradients = [
    Color(0xFFFF9945),
    Color(0xFFFc6076),
  ];

  static const modalBottomSheetsBorderRadius = Radius.circular(10.0);
  static const modalBottomSheetsLeadingSize = 32.0;
}

class DebugPrint {
  final _allDebugPrint = false;

  final _systemGeocodeReplaceScreen = false;
  final _systemGeocodeAddressReplaceScreen = false;

  final _splashScreen = false;
  final _routePointScreen = false;

  final _restService = true;
  final _geoService = false;

  final _mainApplication = false;
  final _preferences = false;
  final _profile = false;
  final _order = false;
  final _paymentType = false;

  // final String TAG = (Preferences).toString(); // ignore: non_constant_identifier_names
  log(className, classMethod, message) {
    bool isPrint = false;
    if (_allDebugPrint) {
      if (className == "SplashScreen" && _splashScreen) isPrint = true;
      if (className == "RestService" && _restService) isPrint = true;
      if (className == "Preferences" && _preferences) isPrint = true;
      if (className == "Profile" && _profile) isPrint = true;

      if (className == "GeoService" && _geoService) isPrint = true;
      if (className == "MainApplication" && _mainApplication) isPrint = true;
      if (className == "Order" && _order) isPrint = true;
      if (className == "PaymentType" && _paymentType) isPrint = true;
      if (className == "RoutePointScreen" && _routePointScreen) isPrint = true;

      if (className == "SystemGeocodeReplaceScreen" && _systemGeocodeReplaceScreen) isPrint = true;
      if (className == "SystemGeocodeAddressReplaceScreen" && _systemGeocodeAddressReplaceScreen) isPrint = true;
    }

    if (isPrint) {
      Logger().v("########## " + className + "." + classMethod + ": " + message.toString());
    }
  }

  flog(message) {
    if (_allDebugPrint) {
      Logger().v("########## " + message.toString());
    }
  }
}
