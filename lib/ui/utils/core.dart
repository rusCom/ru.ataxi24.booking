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

class Const{
  static List<String> restHost = ["http://192.168.1.199:5872", "http://api1.toptaxi.org:5872", "http://api2.toptaxi.org:5872" ];
  // static List<String> restHost = [ "http://api1.toptaxi.org:5872", "http://api2.toptaxi.org:5872" ];
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
  final _restService = false;
  final _preferences = false;
  final _geoCodeReplaceScreen = true;
  final _geoService = true;


  log(className, classMethod,  message) {
    bool isPrint = false;
    if (_allDebugPrint){
      if (className == "SplashScreen" && _splashScreen)isPrint = true;
      if (className == "RestService" && _restService)isPrint = true;
      if (className == "Preferences" && _preferences)isPrint = true;
      if (className == "GeoCodeReplaceScreen" && _geoCodeReplaceScreen)isPrint = true;
      if (className == "GeoService" && _geoService)isPrint = true;

    }

    if (isPrint){
      Logger().d("########## " + className + "." + classMethod + ": " + message.toString());
    }
  }

  flog(message){
    Logger().d("########## " + message);
  }




  final _parseDataDebugPrint = true;

  final _geoDebugPrint = true;
  final _geoCodeDebugPrint = false;

  final _restServiceDebugPrint = false;

  final _orderDebugPrint = true;
  final _orderCalcDebugPrint = true;

  final _splashDebugPrint = true;


  get restServiceDebugPrint => _restServiceDebugPrint && _allDebugPrint;
  get geoCodeDebugPrint => _geoDebugPrint && _geoCodeDebugPrint && _allDebugPrint;
  get orderCalcDebugPrint => _orderCalcDebugPrint && _orderDebugPrint && _allDebugPrint;
  get orderDebugPrint => _orderDebugPrint && _allDebugPrint;
  get parseDataDebugPrint => _parseDataDebugPrint && _allDebugPrint;

  get geoDebugPrint => _geoDebugPrint && _allDebugPrint;
  get splashDebugPrint => _splashDebugPrint && _allDebugPrint;



}

