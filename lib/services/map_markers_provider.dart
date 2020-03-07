
import 'dart:async';

import 'package:booking/models/order.dart';
import 'package:booking/models/route_point.dart';
import 'package:booking/services/app_blocs.dart';
import 'package:booking/services/app_state.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarkersProvider{
  static final MapMarkersProvider _singleton = MapMarkersProvider._internal();
  factory MapMarkersProvider() {return _singleton;}
  MapMarkersProvider._internal();


  // StreamController _mapMarkersController = StreamController();

  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  BitmapDescriptor _mapPickUpIcon, _mapDestinationIcon;
  BuildContext _context;
  MarkerId _mapPickUpMarkerID, _mapDestinationMarkerID;
  Marker _mapPickUpMarker, _mapDestinationMarker;
  LatLng _pickUpLocation;
  RoutePoint _pickUpRoutePoint;

  init(BuildContext context) async {
    _context = context;
    ImageConfiguration configuration = createLocalImageConfiguration(_context);

    _mapPickUpIcon = await BitmapDescriptor.fromAssetImage(configuration, 'assets/icons/ic_onboard_pick_up.png');
    _mapDestinationIcon = await BitmapDescriptor.fromAssetImage(configuration, 'assets/icons/ic_onboard_destination.png');

    _pickUpLocation = AppStateProvider().curLocation;

    _mapPickUpMarkerID = MarkerId('_mapPickUpMarkerID');
    _mapDestinationMarkerID = MarkerId('_mapDestinationMarkerID');

    _mapPickUpMarker = Marker(
        markerId: _mapPickUpMarkerID,
        position: _pickUpLocation,
        draggable: false,
        icon: _mapPickUpIcon
    );

    _mapDestinationMarker = Marker(
        markerId: _mapDestinationMarkerID,
        position: _pickUpLocation,
        draggable: false,
        icon: _mapDestinationIcon
    );
  }


  set pickUpLocation(LatLng value) {
    _pickUpLocation = value;
    Marker updatedPickUpMarker = _mapPickUpMarker.copyWith(
      positionParam: _pickUpLocation,
    );
    _markers[_mapPickUpMarkerID] = updatedPickUpMarker;
    if (_markers[_mapDestinationMarkerID] != null){
      _markers.remove(_mapDestinationMarkerID);
    }
    AppBlocs().mapMarkersController.sink.add(Set<Marker>.of(_markers.values));
  }

  LatLng get pickUpLocation => _pickUpLocation;

  set pickUpRoutePoint(RoutePoint value) {
    _pickUpRoutePoint = value;
    Marker updatedPickUpMarker = _mapPickUpMarker.copyWith(
      positionParam: _pickUpRoutePoint.getLocation(),
    );
    _markers[_mapPickUpMarkerID] = updatedPickUpMarker;
  }


  RoutePoint get pickUpRoutePoint => _pickUpRoutePoint;

  Set<Marker> markers(){
    return Set<Marker>.of(_markers.values);
  }

  void refresh(){

    RoutePoint pickUpRoutePoint = AppStateProvider().curOrder.routePoints.first;
    Marker updatedPickUpMarker = _mapPickUpMarker.copyWith(
      positionParam: pickUpRoutePoint.getLocation(),
    );
    _markers[_mapPickUpMarkerID] = updatedPickUpMarker;

    RoutePoint destinationRoutePoint = AppStateProvider().curOrder.routePoints.last;
    Marker updatedDestinationMarker = _mapDestinationMarker.copyWith(
      positionParam: destinationRoutePoint.getLocation(),
    );
    _markers[_mapDestinationMarkerID] = updatedDestinationMarker;

    AppBlocs().mapMarkersController.sink.add(Set<Marker>.of(_markers.values));
  }

  LatLngBounds mapBounds() {
    List<Marker> list = List<Marker>.of(_markers.values);
    assert(list.isNotEmpty);
    double x0, x1, y0, y1;
    for (Marker marker in list) {
      if (x0 == null) {
        x0 = x1 = marker.position.latitude;
        y0 = y1 = marker.position.longitude;
      } else {
        if (marker.position.latitude > x1) x1 = marker.position.latitude;
        if (marker.position.latitude < x0) x0 = marker.position.latitude;
        if (marker.position.longitude > y1) y1 = marker.position.longitude;
        if (marker.position.longitude < y0) y0 = marker.position.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0 - 0.02, y0));
  }

}