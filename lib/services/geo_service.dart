import 'dart:convert';
import 'package:booking/models/main_application.dart';
import 'package:booking/models/profile.dart';
import 'package:booking/models/route_point.dart';
import 'package:booking/ui/utils/core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class GeoService {
  final String TAG = (GeoService).toString(); // ignore: non_constant_identifier_names
  static final GeoService _singleton = GeoService._internal();
  factory GeoService() => _singleton;
  GeoService._internal();
  RoutePoint _lastGeoCodeRoutePoint;

  LatLng _lastGeoCodeLocation = LatLng(0, 0);

  Future<List<RoutePoint>> autocomplete(String input) async {
    if (input.isEmpty) return null;
    if (input == "") return null;
    LatLng location = MainApplication().currentLocation;

    String url =
        "http://geo.toptaxi.org/autocomplete?keyword=" + Uri.encodeFull(input) + "&lt=" + location.latitude.toString() + "&ln=" + location.longitude.toString() + "&key=" + MainApplication().preferences.googleKey;
    DebugPrint().log(TAG, "autocomplete", url);
    http.Response response = await http.get(url);
    if (response == null) return null;
    if (response.statusCode != 200) return null;
    var result = json.decode(response.body);
    DebugPrint().log(TAG, "autocomplete", result.toString());

    if (result['status'] == 'OK') {
      Iterable list = result['result'];
      List<RoutePoint> listRoutePoints = list.map((model) => RoutePoint.fromJson(model)).toList();
      return listRoutePoints;
    }
    return null;
  }

  Future<List<RoutePoint>> nearby() async {
    LatLng location = MainApplication().currentLocation;
    String url = "http://geo.toptaxi.org/nearby?lt=" + location.latitude.toString() + "&ln=" + location.longitude.toString() + "&key=" + MainApplication().preferences.googleKey;
    http.Response response = await http.get(url);
    if (response == null) return null;
    if (response.statusCode != 200) return null;
    var result = json.decode(response.body);
    DebugPrint().log(TAG, "nearby", result.toString());

    if (result['status'] == 'OK') {
      Iterable list = result['result'];
      List<RoutePoint> listRoutePoints = list.map((model) => RoutePoint.fromJson(model)).toList();
      return listRoutePoints;
    }
    return null;
  }

  Future<RoutePoint> detail(RoutePoint routePoint) async {
    String url = "http://geo.toptaxi.org/detail?uid=" + routePoint.placeId + "&key=" + MainApplication().preferences.googleKey;
    http.Response response = await http.get(url);
    if (response == null) return routePoint;
    if (response.statusCode != 200) return routePoint;
    var result = json.decode(response.body);
    if (result['status'] == 'OK') {
      return RoutePoint.fromJson(result['result']);
    }
    return routePoint;
  }

  Future<bool> geocodeReplace(String from, String to) async {
    String url = "http://geo.toptaxi.org/geocode/replace?from=" + from + "&to=" + to + "&phone=" + Profile().phone;
    DebugPrint().log(TAG, "geocodeReplace", "url = " + url);
    http.Response response = await http.get(url);
    DebugPrint().log(TAG, "geocodeReplace", "response = " + response.toString());
    return true;
  }

  Future<bool> geocodeClear(RoutePoint routePoint) async {
    String url = "http://geo.toptaxi.org/geocode/clear?place_id=" + routePoint.placeId + "&phone=" + Profile().phone;
    DebugPrint().log(TAG, "geocodeClear", "url = " + url);
    http.Response response = await http.get(url);
    DebugPrint().log(TAG, "geocodeClear", "response = " + response.toString());
    return true;
  }

  Future<RoutePoint> geocode(LatLng location) async {
    if (location == null) return null;
    if (location == _lastGeoCodeLocation) return _lastGeoCodeRoutePoint;
    String url = "http://geo.toptaxi.org/geocode?lt=" + location.latitude.toString() + "&ln=" + location.longitude.toString() + "&key=" + MainApplication().preferences.googleKey;
    DebugPrint().log(TAG, "geocode", "url = " + url);
    http.Response response = await http.get(url);
    if (response == null) return null;
    if (response.statusCode != 200) return null;
    var result = json.decode(response.body);
    DebugPrint().log(TAG, "geocode", "result = " + result.toString());
    if (result['status'] == 'OK') {
      _lastGeoCodeLocation = location;
      RoutePoint routePoint = RoutePoint.fromJson(result['result']);
      _lastGeoCodeRoutePoint = routePoint;
      return routePoint;
    }
    return null;
  }
}
