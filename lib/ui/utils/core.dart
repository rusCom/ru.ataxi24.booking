
import 'package:flutter/material.dart';

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
  // static List<String> restHost = ["http://192.168.1.199:5876", "http://api1.toptaxi.org:5872", "http://api2.toptaxi.org:5872" ];
  static List<String> restHost = [ "http://api1.toptaxi.org:5872", "http://api2.toptaxi.org:5872" ];
  static const String dispatchingToken = "E88FF2D642DC9E11D4718385E2A62663";
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
  final _allDebugPrint = false;

  final _geoDebugPrint = false;
  final _geoCodeDebugPrint = false;

  final _restServiceDebugPrint = false;


  get restServiceDebugPrint => _restServiceDebugPrint && _allDebugPrint;

  get geoCodeDebugPrint => _geoDebugPrint && _geoCodeDebugPrint && _allDebugPrint;

}

