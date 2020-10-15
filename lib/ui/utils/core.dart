import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

const Color black = Colors.black;
const Color white = Colors.white;



List<Color> kitGradients = [
  // new Color.fromRGBO(103, 218, 255, 1.0),
  // new Color.fromRGBO(3, 169, 244, 1.0),
  // new Color.fromRGBO(0, 122, 193, 1.0),
  Colors.blueGrey.shade800,
  Colors.black87,
];



class MainUtils{
  static bool parseBool(var value){
    if (value == null)return false;
    if (value.toString().toLowerCase() == "true")return true;
    return false;
  }

  static int parseInt(var value, {var def = 0}){
    if (value == null)return def;
    return int.parse(value.toString());

  }
}

class Const{
  static List<String> restHost = ["http://lkt.toptaxi.org:5872", "http://api1.toptaxi.org:5872", "http://api2.toptaxi.org:5872" ];
  //static List<String> restHost = [ "http://api1.toptaxi.org:5872", "http://api2.toptaxi.org:5872" ];
  static const String dispatchingToken = "C3345D6297882D04F0AAE85A19611119";
  static const int dbVersion = 1;


  static List<Color> kitGradients = [
    // new Color.fromRGBO(103, 218, 255, 1.0),
    // new Color.fromRGBO(3, 169, 244, 1.0),
    // new Color.fromRGBO(0, 122, 193, 1.0),
    Colors.blueGrey.shade800,
    Colors.black87,
  ];
  static const List<Color> signUpGradients = [
    Color(0xFFFF9945),
    Color(0xFFFc6076),
  ];
}

class DebugPrint{
  final isTest = true;
  final _allDebugPrint = true;

  final _splashScreen = false;
  final _geoCodeReplaceScreen = false;
  final _routePointScreen = false;





  final _restService = false;
  final _geoService = false;

  final _mainApplication = false;
  final _preferences    = false;
  final _profile        = false;
  final _order          = true;
  final _paymentType    = false;


  // final String TAG = (Preferences).toString(); // ignore: non_constant_identifier_names
  log(className, classMethod,  message) {
    bool isPrint = false;
    if (_allDebugPrint){
      if (className == "SplashScreen" && _splashScreen)isPrint = true;
      if (className == "RestService" && _restService)isPrint = true;
      if (className == "Preferences" && _preferences)isPrint = true;
      if (className == "Profile" && _profile)isPrint = true;
      if (className == "GeoCodeReplaceScreen" && _geoCodeReplaceScreen)isPrint = true;
      if (className == "GeoService" && _geoService)isPrint = true;
      if (className == "MainApplication" && _mainApplication)isPrint = true;
      if (className == "Order" && _order)isPrint = true;
      if (className == "PaymentType" && _paymentType)isPrint = true;
      if (className == "RoutePointScreen" && _routePointScreen)isPrint = true;


    }

    if (isPrint){
      Logger().v("########## " + className + "." + classMethod + ": " + message.toString());
    }
  }

  flog(message){
    Logger().v("########## " + message.toString());
  }

}


