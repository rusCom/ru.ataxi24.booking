import 'dart:convert';

import 'package:booking/models/route_point.dart';
import 'package:booking/services/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class GeoService {
  final _viewDebugPrint = false;
  LatLng _lastGeoCodeLocation = LatLng(0,0);

  static Future<List<RoutePoint>> autocomplete(BuildContext context, String input) async {
    if (input.isEmpty) return null;
    if (input == "") return null;
    LatLng location = Provider.of<AppStateProvider>(context, listen: false).lastLocation;
    // String url = "http://api.toptaxi.org/geo/autocomplete?input=" + Uri.encodeFull(input)  + "&lt=" + location.latitude.toString() + "&ln=" + location.longitude.toString();
    String url =
        "http://geo.toptaxi.org/autocomplete?keyword=" + Uri.encodeFull(input) + "&lt=" + location.latitude.toString() + "&ln=" + location.longitude.toString();
    //debugPrint(url);
    http.Response response = await http.get(url);
    if (response == null) return null;
    if (response.statusCode != 200) return null;
    var result = json.decode(response.body);
    //debugPrint(result.toString());
    if (result['status'] == 'OK') {
      Iterable list = result['result'];
      // debugPrint("!!" + result['result'].toString());
      return list.map((model) => RoutePoint.fromJson(model)).toList();
    }
    return null;
  }

  static Future<RoutePoint> detail(RoutePoint routePoint) async {
    String url = "http://geo.toptaxi.org/detail?uid=" + routePoint.place_id;
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
    if (location == _lastGeoCodeLocation)return null;
    String url = "http://geo.toptaxi.org/geocode/driver?lt=" + location.latitude.toString() + "&ln=" + location.longitude.toString();
    // debugPrint(url);
    http.Response response = await http.get(url);
    if (response == null) return null;
    if (response.statusCode != 200) return null;
    var result = json.decode(response.body);
    if (result['status'] == 'OK') {
      _lastGeoCodeLocation = location;
      return RoutePoint.fromJson(result['result']);
    }
    return null;
  }
}
