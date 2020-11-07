import 'package:booking/models/main_application.dart';
import 'package:booking/models/order.dart';
import 'package:booking/models/preferences.dart';
import 'package:booking/services/app_blocs.dart';
import 'package:booking/services/map_markers_service.dart';
import 'package:booking/ui/orders/new_order_calc_screen.dart';
import 'package:booking/ui/system/system_geocde_replace_screen.dart';
import 'package:booking/ui/system/system_geocode_address_replace_screen.dart';
import 'package:booking/ui/utils/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
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
  Map<PolylineId, Polyline> polylines = {};
  DateTime _backButtonPressedTime;
  NewOrderFirstPointScreen newOrderFirstPointScreen;
  NewOrderCalcScreen newOrderCalcScreen;

  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.blueAccent, points: polylineCoordinates, width: 4);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline()  {
    List<PointLatLng> result = polylinePoints.decodePolyline("aoimIosfuICg@My@Gg@BaBG[oAkDg@_B]b@eGnIeApAy@rAaBzCi@lAIZyAsAcAaA_EsDyGyFwFiFyBmBmA_AyAwA{DkDu@g@}@c@s@SiAS_CMaA@cAD_JbA]@[SWISAg@Gg@Im@OQUKa@Ik@MaAhAkRD}CdA{RTqEPiBh@eK~@iQ^}G?o@f@uJ|@qPtDkt@lFecAJiF@oEAqGBaD?kVBw^Ekk@CgAS}@MOSOSCaBC_CCwEDsHBcTC{K@_FGa@?e@Dm@JiA\\qF`CqIlEWXOTZdA\\r@bBjEvAdGf@`ClA|F^zAdAtFHn@Eh@@b@?fJA\\s@@gAA{A@sA@?tB");
    DebugPrint().flog(result);
    result.forEach((PointLatLng point) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    });
    _addPolyLine();
  }


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
    _getPolyline();
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
              polylines: Set<Polyline>.of(polylines.values),
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
            Preferences().mapAdmin
                ? Stack(
                    children: [
                      Positioned(
                        top: 200,
                        right: 8,
                        child: FloatingActionButton(
                          heroTag: '_mapAdminGeocodeReplace',
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SystemGeocodeReplaceScreen(MapMarkersService().pickUpRoutePoint))),
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.find_replace,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 260,
                        right: 8,
                        child: FloatingActionButton(
                          heroTag: '_mapAdminGeocodeAddressReplace',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SystemGeocodeAddressReplaceScreen(
                                routePoint: MapMarkersService().pickUpRoutePoint,
                                location: MapMarkersService().pickUpLocation,
                              ),
                            ),
                          ),
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.fireplace,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
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
