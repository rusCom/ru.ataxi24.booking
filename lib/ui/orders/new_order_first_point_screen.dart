import 'package:booking/models/route_point.dart';
import 'package:booking/services/app_state.dart';
import 'package:booking/services/map_markers_provider.dart';
import 'package:booking/ui/route_point/route_point_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class NewOrderFirstPointScreen extends StatelessWidget {
  final TextEditingController _controller = new TextEditingController();
  final ValueChanged<RoutePoint> onChanged;
  GoogleMapController _mapController;
  BuildContext _context;


  NewOrderFirstPointScreen({this.onChanged}): super();

  set mapController(GoogleMapController value) {
    _mapController = value;
  }

  void setText(String data) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.text = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 55,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.transparent,
            constraints: const BoxConstraints(minWidth: double.infinity),
            margin: EdgeInsets.only(left: 8, right: 8),
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(topLeft: const Radius.circular(18), topRight: const Radius.circular(18)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: TextField(
                  readOnly: true,
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "search",
                    hintStyle: TextStyle(color: Color(0xFF757575), fontSize: 16),
                    prefixIcon: Icon(
                      Icons.add_location,
                      color: Color(0xFF757575),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Color(0xFF757575),
                      ),
                      onPressed: () async {
                        RoutePoint pickUpRoutePoint = await Navigator.push<RoutePoint>(context, MaterialPageRoute(builder: (context) => RoutePointScreen(isFirst: true,)));
                        if (pickUpRoutePoint != null){
                          print(pickUpRoutePoint);
                          RoutePoint destinationRoutePoint = await Navigator.push<RoutePoint>(context, MaterialPageRoute(builder: (context) => RoutePointScreen()));
                          if (destinationRoutePoint != null){
                            print(destinationRoutePoint);
                            AppStateProvider().curOrder.addRoutePoint(pickUpRoutePoint);
                            AppStateProvider().curOrder.addRoutePoint(destinationRoutePoint);
                          }

                        }
                        /*

                        RoutePoint curPickUpRoutePoint = AppStateProvider().curOrder.routePoints.first;
                        RoutePoint routePoint = await Navigator.push<RoutePoint>(context, MaterialPageRoute(builder: (context) => RoutePointScreen(destenation: 0)));
                        if (routePoint != null){
                          AppStateProvider().curOrder.addPickUp(routePoint);
                          routePoint = await Navigator.push<RoutePoint>(context, MaterialPageRoute(builder: (context) => RoutePointScreen()));
                          if (routePoint == null){
                            AppStateProvider().curOrder.addPickUp(curPickUpRoutePoint);
                          }
                          else {
                            AppStateProvider().curOrder.addRoutePoint(routePoint);
                          }
                        }

                         */
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                    fillColor: Color(0xFFEEEEEE),
                    filled: true,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            constraints: const BoxConstraints(minWidth: double.infinity),
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: RaisedButton(
                onPressed: () async {
                  RoutePoint routePoint = await Navigator.push<RoutePoint>(context, MaterialPageRoute(builder: (context) => RoutePointScreen()));
                  if (routePoint != null){
                    AppStateProvider().curOrder.addRoutePoint(MapMarkersProvider().pickUpRoutePoint);
                    AppStateProvider().curOrder.addRoutePoint(routePoint);
                    print(AppStateProvider().curOrder.toJson());
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.only(bottomLeft: Radius.circular(18), bottomRight: Radius.circular(18)),
                ),
                splashColor: Colors.yellow[200],
                textColor: Colors.white,
                color: Colors.amber,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Container(width: 40, child: Icon(Icons.find_replace)),
                    new Text(
                      "Куда?",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 120,
          right: 8,
          child: FloatingActionButton(
            heroTag: '_moveToCurLocation',
            onPressed: _moveToCurLocation,
            child: Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }

  void _moveToCurLocation() {
    LatLng curLocation = AppStateProvider().curLocation;
    if (curLocation != null) {
      // GoogleMapController controller = await _mapController.future;
      if (_mapController != null) {
        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: curLocation,
              zoom: 17.0,
            ),
          ),
        );
      }
    }
  }
}
