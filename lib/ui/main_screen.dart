import 'package:booking/models/main_application.dart';
import 'package:booking/models/order.dart';
import 'package:booking/services/app_blocs.dart';
import 'package:booking/services/map_markers_service.dart';
import 'package:booking/ui/orders/new_order_calc_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'orders/new_order_first_point_screen.dart';
import 'orders/sliding_panel/order_sliding_panel.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GoogleMapController _mapController;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  MapType _currentMapType = MapType.normal;
  Set<Marker> _markers;
  DateTime _backButtonPressedTime;
  NewOrderFirstPointScreen newOrderFirstPointScreen;
  NewOrderCalcScreen newOrderCalcScreen;

  @override
  void initState() {
    super.initState();
    _markers = MapMarkersService().markers();
    AppBlocs().mapMarkersStream.listen((markers) {
      setState(() {
        _markers = markers;
      });
    });
    newOrderFirstPointScreen = NewOrderFirstPointScreen();
    newOrderCalcScreen = NewOrderCalcScreen();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: MainApplication().currentLocation,
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
                  switch (MainApplication().curOrder.orderState) {
                    case OrderState.new_order:
                      return newOrderFirstPointScreen;
                    case OrderState.new_order_calculating:
                      newOrderCalcScreen.mapBounds();
                      return newOrderCalcScreen;
                    case OrderState.new_order_calculated:
                      return newOrderCalcScreen;
                    default:
                      return OrderSlidingPanel();
                  }
                },
              ),
            ),
            Positioned(
              top: 40,
              right: 8,
              child: FloatingActionButton(
                heroTag: '_onMapTypeButtonPressed',
                onPressed: _onMapTypeButtonPressed,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.landscape,
                  color: Colors.black,
                ),
              ),
            ),
            MainApplication().curOrder.mapBoundsIcon
                ? Positioned(
              top: 100,
              right: 8,
              child: FloatingActionButton(
                heroTag: '_mapBounds',
                onPressed: _onMapBoundsButtonPressed,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.zoom_out_map,
                  color: Colors.black,
                ),
              ),
            )
                : Container(),
          ],
        ),
      ),
    );
  } // build

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    MainApplication().mapController = controller;
    if (MainApplication().curOrder.orderState == OrderState.new_order) {
      MapMarkersService().pickUpLocation = MainApplication().currentLocation;
    }
    _onCameraIdle();
    if (MainApplication().curOrder.mapBoundsIcon) {
      MainApplication().mapController.animateCamera(CameraUpdate.newLatLngBounds(MapMarkersService().mapBounds(), 50));
    }
  }

  void _onCameraMove(CameraPosition position) {
    if (MainApplication().curOrder.orderState == OrderState.new_order) {
      newOrderFirstPointScreen.onCameraMove(position);
    }
  }

  void _onCameraIdle() {
    if (MainApplication().curOrder.orderState == OrderState.new_order) {
      newOrderFirstPointScreen.onCameraIdle();
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
    if (scaffoldKey.currentState.isDrawerOpen) {
      Navigator.pop(context);
      return false;
    }

    // Если статус заказа - идет расчет стоимости, то ничего не делаем
    if (MainApplication().curOrder.orderState == OrderState.new_order_calculating) {
      return false;
    }
    // Если расчтет стоимости произведен, то возвращаем на новый заказ
    if (MainApplication().curOrder.orderState == OrderState.new_order_calculated) {
      newOrderCalcScreen.backPressed();
      return false;
    }

    DateTime currentTime = DateTime.now();
    //Statement 1 Or statement2
    bool backButton = _backButtonPressedTime == null || currentTime.difference(_backButtonPressedTime) > Duration(seconds: 3);
    if (backButton) {
      _backButtonPressedTime = currentTime;
      Fluttertoast.showToast(msg: "Для выхода из приложения нажмите кнопку \"Назад\" еще раз.", backgroundColor: Colors.black, textColor: Colors.white);
      return false;
    }
    return true;
  }

  void _onMapBoundsButtonPressed() {
    MainApplication().mapController.animateCamera(CameraUpdate.newLatLngBounds(MapMarkersService().mapBounds(), 50));
  }
}
