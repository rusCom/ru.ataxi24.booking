import 'package:booking/models/order.dart';
import 'package:booking/models/route_point.dart';
import 'package:booking/services/app_blocs.dart';
import 'package:booking/services/geo_service.dart';
import 'package:booking/services/map_markers_provider.dart';
import 'package:booking/services/profile_provider.dart';
import 'package:booking/services/app_state.dart';
import 'package:booking/ui/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'orders/new_order_first_point_screen.dart';
import 'orders/new_order_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GoogleMapController _mapController;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  MapType _currentMapType = MapType.normal;
  Set<Marker> _markers;
  double zoomLevel = 17.0;
  DateTime _backButtonPressedTime;
  NewOrderFirstPointScreen newOrderFirstPointScreen;

  @override
  void initState() {
    super.initState();
    _markers = MapMarkersProvider().markers();
     AppBlocs().mapMarkersStream.listen((markers) {
      setState(() {
        _markers = markers;
      });
    });
    newOrderFirstPointScreen = NewOrderFirstPointScreen();
  }

  @override
  void dispose() {
    print("close");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          key: scaffoldKey,
          drawer: Consumer<ProfileStateProvider>(builder: (context, state, _) {
            return MainDrawer(state);
          }),
          body: Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: AppStateProvider().curLocation,
                  zoom: 17.0,
                ),
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                mapType: _currentMapType,
                compassEnabled: true,
                markers: _markers,
                onCameraMove: _onCameraMove,
                onCameraIdle: _onCameraIdle,
                onTap: _onMapTap,
              ),
              Center(
                child: StreamBuilder<Object>(
                  stream: AppBlocs().orderStateStream,
                  builder: (context, snapshot) {
                    switch (AppStateProvider().curOrder.orderState){
                      case OrderState.new_order: return newOrderFirstPointScreen;
                      case OrderState.new_order_calc:{
                        _mapController.animateCamera(CameraUpdate.newLatLngBounds(
                            MapMarkersProvider().mapBounds(),
                            100
                        ));
                        return Container();
                      }

                      default: return Container();
                    }
                    return newOrderFirstPointScreen;
                  }
                )
              ),
              Positioned(
                top: 50,
                right: 8,
                child: FloatingActionButton(
                  heroTag: '_onMapTypeButtonPressed',
                  onPressed: _onMapTypeButtonPressed,
                  child: Icon(Icons.map),
                ),
              ),
              Positioned(
                left: 10,
                top: 35,
                child: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () => scaffoldKey.currentState.openDrawer(),
                ),
              ),
            ],
          )),
    );
  } // build

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    newOrderFirstPointScreen.mapController = controller;
    if (AppStateProvider().curOrder.orderState == OrderState.new_order){
      MapMarkersProvider().pickUpLocation = AppStateProvider().curLocation;
    }
    _onCameraIdle();
  }

  void _onCameraMove(CameraPosition position) {
    if (AppStateProvider().curOrder.orderState == OrderState.new_order){
      MapMarkersProvider().pickUpLocation = position.target;
      setState(() {
        zoomLevel = position.zoom;
      });
    }
  }


  void _onCameraIdle() {
    if (AppStateProvider().curOrder.orderState == OrderState.new_order){
      GeoService().geocode(MapMarkersProvider().pickUpLocation).then((routePoint){
        if (routePoint != null){
          MapMarkersProvider().pickUpRoutePoint = routePoint;
          newOrderFirstPointScreen.setText(routePoint.name + " " + routePoint.dsc);
          _mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: routePoint.getLocation(),
                zoom: zoomLevel,
              ),
            ),
          );
        }
      });
    }
  }

  void _onMapTap(LatLng location) {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: 17.0,
        ),
      ),
    );
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  Future<bool> _onWillPop() async {
    if (scaffoldKey.currentState.isDrawerOpen){
      Navigator.pop(context);
      return false;
    }

    if (AppStateProvider().curOrder.orderState == OrderState.new_order_calc){
      LatLng location = AppStateProvider().curOrder.routePoints.first.getLocation();
      AppStateProvider().curOrder.orderState = OrderState.new_order;
      MapMarkersProvider().pickUpLocation = location;
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: location,
            zoom: 17.0,
          ),
        ),
      );

      return false;
    }

    DateTime currentTime = DateTime.now();
    //Statement 1 Or statement2
    bool backButton = _backButtonPressedTime == null ||
        currentTime.difference(_backButtonPressedTime) > Duration(seconds: 3);
    if (backButton) {
      _backButtonPressedTime = currentTime;
      Fluttertoast.showToast(
          msg: "Double Click to exit app",
          backgroundColor: Colors.black,
          textColor: Colors.white);
      return false;
    }
    return true;
  }
}
