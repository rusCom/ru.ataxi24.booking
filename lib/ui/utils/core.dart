
import 'package:flutter/material.dart';

const Color black = Colors.black;
const Color white = Colors.white;

class DebugPrint{
  final _allDebugPrint = true;


  final _geoDebugPrint = true;
  final _geoCodeDebugPrint = true;

  bool getGeoCodeDebugPrint(){
    if (_allDebugPrint){
      if (_geoDebugPrint)
        return _geoCodeDebugPrint;
    }
    return false;
  }

}