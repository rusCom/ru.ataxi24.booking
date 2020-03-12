import 'dart:convert';

import 'package:booking/main_application.dart';
import 'package:booking/models/route_point.dart';
import 'package:booking/ui/utils/core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class GeoService {
  static final GeoService _singleton = GeoService._internal();
  factory GeoService() {return _singleton;}
  GeoService._internal();
  RoutePoint _lastGeoCodeRoutePoint;

  LatLng _lastGeoCodeLocation = LatLng(0,0);

  Future<List<RoutePoint>> autocomplete(String input) async {
    if (input.isEmpty) return null;
    if (input == "") return null;
    LatLng location = MainApplication().currentLocation;

    String url =
        "http://geo.toptaxi.org/autocomplete?keyword=" + Uri.encodeFull(input) + "&lt=" + location.latitude.toString() + "&ln=" + location.longitude.toString();
    // print(url);
    http.Response response = await http.get(url);
    if (response == null) return null;
    if (response.statusCode != 200) return null;
    var result = json.decode(response.body);
    print(result.toString());
    if (result['status'] == 'OK') {
      Iterable list = result['result'];
      // print("!!" + list.toString());
      List<RoutePoint> listRoutePoints = list.map((model) => RoutePoint.fromJson(model)).toList();
      if (listRoutePoints == null){
        print("##### listRoutePoints = null");
      }
      // print(listRoutePoints);
      // print("!!" + listRoutePoints.cast<String>().toString());
      return listRoutePoints;
    }
    return null;
  }

  Future<RoutePoint> detail(RoutePoint routePoint) async {
    String url = "http://geo.toptaxi.org/detail?uid=" + routePoint.placeId;
    // debugPrint(url);
    http.Response response = await http.get(url);
    if (response == null) return routePoint;
    if (response.statusCode != 200) return routePoint;
    var result = json.decode(response.body);
    if (result['status'] == 'OK') {
      return RoutePoint.fromJson(result['result']);
    }
    return routePoint;
  }

  Future<RoutePoint> geocode(LatLng location) async {
    if (location == null) return null;
    if (location == _lastGeoCodeLocation)return _lastGeoCodeRoutePoint;
    String url = "http://geo.toptaxi.org/geocode/cache?lt=" + location.latitude.toString() + "&ln=" + location.longitude.toString();
    if (DebugPrint().geoCodeDebugPrint){
      print("########## GeoService.geocode debugPrint url = " + url);
    }
    http.Response response = await http.get(url);
    if (response == null) return null;
    if (response.statusCode != 200) return null;
    var result = json.decode(response.body);
    if (result['status'] == 'OK') {
      _lastGeoCodeLocation = location;
      if (DebugPrint().geoCodeDebugPrint){
        print("########## GeoService.geocode debugPrint result = " + result['result'].toString());
      }
      RoutePoint routePoint = RoutePoint.fromJson(result['result']);
      _lastGeoCodeRoutePoint = routePoint;
      return routePoint;
    }
    return null;
  }
}
