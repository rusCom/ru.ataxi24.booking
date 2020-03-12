import 'package:booking/main_application.dart';
import 'package:booking/models/order.dart';
import 'package:booking/models/route_point.dart';
import 'package:booking/services/app_blocs.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


enum PickUpState{
  searching,
  enabled,
  disabled
}

class MapMarkersService{
  static final MapMarkersService _singleton = MapMarkersService._internal();
  factory MapMarkersService() {return _singleton;}
  MapMarkersService._internal();

  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  BitmapDescriptor _mapPickUpIcon, _mapDestinationIcon, _mapAddressIcon;
  BuildContext _context;
  MarkerId _mapPickUpMarkerID, _mapDestinationMarkerID;
  Marker _mapPickUpMarker, _mapDestinationMarker;
  LatLng _pickUpLocation;
  RoutePoint _pickUpRoutePoint;
  PickUpState _pickUpState;
  double zoomLevel = 17.0;

  init(BuildContext context) async {
    _context = context;
    ImageConfiguration configuration = createLocalImageConfiguration(_context);

    _mapPickUpIcon      = await BitmapDescriptor.fromAssetImage(configuration, 'assets/icons/ic_onboard_pick_up.png');
    _mapDestinationIcon = await BitmapDescriptor.fromAssetImage(configuration, 'assets/icons/ic_onboard_destination.png');
    _mapAddressIcon     = await BitmapDescriptor.fromAssetImage(configuration, 'assets/icons/ic_onboard_address.png');

    _pickUpLocation = MainApplication().currentLocation;

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


  PickUpState get pickUpState => _pickUpState;

  set pickUpState(PickUpState value) {
    if (_pickUpState != value){
      _pickUpState = value;
      AppBlocs().pickUpController.sink.add(_pickUpState);
    }
  }

  set pickUpLocation(LatLng value) {
    _pickUpLocation = value;
    if (_markers.length > 1){
      _markers.clear();
    }

    Marker updatedPickUpMarker = _mapPickUpMarker.copyWith(
      positionParam: _pickUpLocation,
    );
    _markers[_mapPickUpMarkerID] = updatedPickUpMarker;
    pickUpState = PickUpState.searching;
    AppBlocs().mapMarkersController.sink.add(Set<Marker>.of(_markers.values));
  }

  LatLng get pickUpLocation => _pickUpLocation;

  set pickUpRoutePoint(RoutePoint value) {
    if (_pickUpRoutePoint != value){
      _pickUpRoutePoint = value;
      if (_pickUpRoutePoint != null){
        Marker updatedPickUpMarker = _mapPickUpMarker.copyWith(
          positionParam: _pickUpRoutePoint.getLocation(),
        );
        _markers[_mapPickUpMarkerID] = updatedPickUpMarker;
        _pickUpRoutePoint.checkPickUp();
      }
    }
  }

  RoutePoint get pickUpRoutePoint => _pickUpRoutePoint;

  Set<Marker> markers(){
    return Set<Marker>.of(_markers.values);
  }

  void refresh(){
    if (MainApplication().curOrder.orderState == OrderState.new_order){
      RoutePoint pickUpRoutePoint = MainApplication().curOrder.routePoints.first;
      Marker updatedPickUpMarker = _mapPickUpMarker.copyWith(
        positionParam: pickUpRoutePoint.getLocation(),
      );
      _markers[_mapPickUpMarkerID] = updatedPickUpMarker;
    }
    else if (MainApplication().curOrder.orderState == OrderState.new_order_calculating || MainApplication().curOrder.orderState == OrderState.new_order_calculated) {
      _markers.clear();
      if (MainApplication().curOrder.routePoints.length > 2){
        for (int index = 1; index < (MainApplication().curOrder.routePoints.length - 1); index ++){
          RoutePoint routePoint = MainApplication().curOrder.routePoints[index];
          MarkerId markerId = MarkerId(routePoint.placeId);
          Marker marker = Marker(
              markerId: markerId,
              position: routePoint.getLocation(),
              draggable: false,
              icon: _mapAddressIcon
          );
          _markers[markerId] = marker;
        }
      }


      RoutePoint pickUpRoutePoint = MainApplication().curOrder.routePoints.first;
      Marker updatedPickUpMarker = _mapPickUpMarker.copyWith(
        positionParam: pickUpRoutePoint.getLocation(),
      );
      _markers[_mapPickUpMarkerID] = updatedPickUpMarker;

      RoutePoint destinationRoutePoint = MainApplication().curOrder.routePoints.last;
      Marker updatedDestinationMarker = _mapDestinationMarker.copyWith(
        positionParam: destinationRoutePoint.getLocation(),
      );
      _markers[_mapDestinationMarkerID] = updatedDestinationMarker;


    } // else if (AppStateProvider().curOrder.orderState == OrderState.new_order_calculating || AppStateProvider().curOrder.orderState == OrderState.new_order_calculated) {
    else {
      _markers.clear();
    }


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
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }

}