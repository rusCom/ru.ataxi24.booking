
import 'package:flutter/material.dart';

const Color black = Colors.black;
const Color white = Colors.white;

class Const{
  static List<String> restHost = ["http://192.168.1.199:5876", "http://api1.toptaxi.org:5874", "http://api2.toptaxi.org:5874" ];
  static const String dispatchingToken = "E88FF2D642DC9E11D4718385E2A62663";

}

class DebugPrint{
  final _allDebugPrint = true;

  final _geoDebugPrint = false;
  final _geoCodeDebugPrint = true;

  final _restServiceDebugPrint = true;


  get restServiceDebugPrint => _restServiceDebugPrint && _allDebugPrint;

  get geoCodeDebugPrint => _geoDebugPrint && _geoCodeDebugPrint && _allDebugPrint;

}

