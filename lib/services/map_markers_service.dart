import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:booking/models/main_application.dart';
import 'package:booking/models/order.dart';
import 'package:booking/models/route_point.dart';
import 'package:booking/services/app_blocs.dart';
import 'package:booking/services/geo_service.dart';
import 'package:booking/ui/utils/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum PickUpState { searching, enabled, disabled }

class MapMarkersService {
  static final MapMarkersService _singleton = MapMarkersService._internal();

  factory MapMarkersService() {
    return _singleton;
  }

  MapMarkersService._internal();

  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  BitmapDescriptor _mapPickUpIcon, _mapDestinationIcon, _mapAddressIcon, _mapCarIcon;

  MarkerId _mapPickUpMarkerID, _mapDestinationMarkerID, _mapCarMarkerID;
  Marker _mapPickUpMarker, _mapDestinationMarker, _mapCarMarker;
  LatLng _pickUpLocation;
  RoutePoint _pickUpRoutePoint;
  PickUpState _pickUpState;
  double zoomLevel = 17.0;

  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates;
  Map<PolylineId, Polyline> polylines;
  List<PointLatLng> polylinePointLatLng;

  init(BuildContext context) async {
    _mapPickUpIcon = BitmapDescriptor.fromBytes(await getBytesFromAsset("assets/icons/ic_onboard_pick_up.png", 200));
    _mapDestinationIcon =
        BitmapDescriptor.fromBytes(await getBytesFromAsset("assets/icons/ic_onboard_destination.png", 200));
    _mapAddressIcon = BitmapDescriptor.fromBytes(await getBytesFromAsset("assets/icons/ic_onboard_address.png", 200));
    _mapCarIcon = BitmapDescriptor.fromBytes(await getBytesFromAsset("assets/icons/ic_onboard_car.png", 80));

    _pickUpLocation = MainApplication().currentLocation;

    _mapPickUpMarkerID = MarkerId('_mapPickUpMarkerID');
    _mapDestinationMarkerID = MarkerId('_mapDestinationMarkerID');
    _mapCarMarkerID = MarkerId('_mapCarMarkerID');

    _mapPickUpMarker = Marker(
      markerId: _mapPickUpMarkerID,
      position: _pickUpLocation,
      draggable: false,
      icon: _mapPickUpIcon,
    );

    _mapDestinationMarker = Marker(
      markerId: _mapDestinationMarkerID,
      position: _pickUpLocation,
      draggable: false,
      icon: _mapDestinationIcon,
    );

    _mapCarMarker = Marker(
      markerId: _mapCarMarkerID,
      position: _pickUpLocation,
      draggable: false,
      icon: _mapCarIcon,
      anchor: Offset(0.5, 0.5),
      flat: true,
    );
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  PickUpState get pickUpState => _pickUpState;

  set pickUpState(PickUpState value) {
    if (_pickUpState != value) {
      _pickUpState = value;
      AppBlocs().pickUpController.sink.add(_pickUpState);
    }
  }

  set pickUpLocation(LatLng value) {
    _pickUpLocation = value;
    if (_markers.length > 1) {
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
    if (_pickUpRoutePoint != value) {
      _pickUpRoutePoint = value;
      if (_pickUpRoutePoint != null) {
        Marker updatedPickUpMarker = _mapPickUpMarker.copyWith(
          positionParam: _pickUpRoutePoint.getLocation(),
        );
        _markers[_mapPickUpMarkerID] = updatedPickUpMarker;
        _pickUpRoutePoint.checkPickUp();
      }
    }
  }

  RoutePoint get pickUpRoutePoint => _pickUpRoutePoint;

  Set<Marker> markers() {
    return Set<Marker>.of(_markers.values);
  }

  void agentMarkerRefresh() {
    if (MainApplication().curOrder.agent != null) {
      Marker updatedPickUpMarker = _mapCarMarker.copyWith(
        positionParam: MainApplication().curOrder.agent.location,
      );
      _markers[_mapCarMarkerID] = updatedPickUpMarker;
      AppBlocs().mapMarkersController.sink.add(Set<Marker>.of(_markers.values));
    }
  }

  void clearAgentMarker() {
    if (_markers[_mapCarMarkerID] != null) {
      _markers[_mapCarMarkerID] = null;
    }
  }

  Future<void> getMapPolyline() async {
    if (MainApplication().curOrder.routePoints.length > 1) {
      List<String> polylineData = await GeoService().directions(jsonEncode(MainApplication().curOrder.routePoints));
      if (polylineData != null) {
        polylineCoordinates = [];
        polylines = {};
        polylineData.forEach((polylineString) {
          polylinePointLatLng = polylinePoints.decodePolyline(polylineString);
          polylinePointLatLng.forEach((PointLatLng polylinePointLatLngPoint) {
            polylineCoordinates.add(LatLng(polylinePointLatLngPoint.latitude, polylinePointLatLngPoint.longitude));
          });
        });
        PolylineId id = PolylineId("poly");
        Polyline polyline = Polyline(
            polylineId: id, color: Colors.blueAccent, points: polylineCoordinates, width: 4);
        polylines[id] = polyline;
        AppBlocs().mapPolylinesController.sink.add(polylines);
      }
    }
    else { // если точка маршрута одна, то очистить данные
      AppBlocs().mapPolylinesController.sink.add(null);

    }
  }

  void refresh() {
    if (MainApplication().curOrder.orderState == OrderState.new_order) {
      RoutePoint pickUpRoutePoint = MainApplication().curOrder.routePoints.first;
      Marker updatedPickUpMarker = _mapPickUpMarker.copyWith(
        positionParam: pickUpRoutePoint.getLocation(),
      );
      _markers[_mapPickUpMarkerID] = updatedPickUpMarker;
    } else if (MainApplication().curOrder.orderState == OrderState.new_order_calculating ||
        MainApplication().curOrder.orderState == OrderState.new_order_calculated) {
      _markers.clear();
      if (MainApplication().curOrder.routePoints.length > 2) {
        for (int index = 1; index < (MainApplication().curOrder.routePoints.length - 1); index++) {
          RoutePoint routePoint = MainApplication().curOrder.routePoints[index];
          MarkerId markerId = MarkerId(routePoint.placeId);
          Marker marker =
              Marker(markerId: markerId, position: routePoint.getLocation(), draggable: false, icon: _mapAddressIcon);
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

      if (MainApplication().curOrder.routePoints.length > 2) {
        for (int index = 1; index < (MainApplication().curOrder.routePoints.length - 1); index++) {
          RoutePoint routePoint = MainApplication().curOrder.routePoints[index];
          MarkerId markerId = MarkerId(routePoint.placeId);
          Marker marker =
              Marker(markerId: markerId, position: routePoint.getLocation(), draggable: false, icon: _mapAddressIcon);
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
      agentMarkerRefresh();
    } // else if (MainApplication().curOrder.orderState == OrderState.client_in_car){

    AppBlocs().mapMarkersController.sink.add(Set<Marker>.of(_markers.values));
  }

  LatLngBounds get _agentDestinationBounds {
    List<Marker> list = [];
    if (_markers[_mapDestinationMarkerID] != null) list.add(_markers[_mapDestinationMarkerID]);
    if (_markers[_mapCarMarkerID] != null)
      list.add(_markers[_mapCarMarkerID]);
    else {
      list.add(_markers[_mapPickUpMarkerID]);
    }
    return calcBounds(list);
  }

  LatLngBounds get _agentPickUpBounds {
    List<Marker> list = [];
    if (_markers[_mapPickUpMarkerID] != null) list.add(_markers[_mapPickUpMarkerID]);
    if (_markers[_mapCarMarkerID] != null)
      list.add(_markers[_mapCarMarkerID]);
    else {
      list.add(_markers[_mapPickUpMarkerID]);
    }

    return calcBounds(list);
  }

  LatLngBounds mapBounds() {
    if (MainApplication().curOrder.orderState == OrderState.drive_to_client) return _agentPickUpBounds;
    if (MainApplication().curOrder.orderState == OrderState.drive_at_client) return _agentPickUpBounds;
    if (MainApplication().curOrder.orderState == OrderState.paid_idle) return _agentPickUpBounds;
    if (MainApplication().curOrder.orderState == OrderState.client_in_car) return _agentDestinationBounds;

    return calcBounds(List<Marker>.of(_markers.values));
  }

  LatLngBounds calcBounds(List<Marker> list){
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
    x1 = x1 + (x1 - x0) * 0.15;
    x0 = x0 - (x1 - x0) * 1.3;
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }
}
