import 'package:booking/models/main_application.dart';
import 'package:booking/models/route_point.dart';
import 'package:booking/services/app_blocs.dart';
import 'package:booking/services/geo_service.dart';
import 'package:booking/services/map_markers_service.dart';
import 'package:booking/ui/route_point/route_point_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewOrderFirstPointScreen extends StatelessWidget {
  final TextEditingController _controller = new TextEditingController();
  final ValueChanged<RoutePoint> onChanged;
  BuildContext _context;

  NewOrderFirstPointScreen({this.onChanged}) : super();

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
                        RoutePoint pickUpRoutePoint = await Navigator.push<RoutePoint>(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RoutePointScreen(
                                      isFirst: true,
                                    )));
                        if (pickUpRoutePoint != null) {
                          // print(pickUpRoutePoint);
                          RoutePoint destinationRoutePoint =
                              await Navigator.push<RoutePoint>(context, MaterialPageRoute(builder: (context) => RoutePointScreen()));
                          if (destinationRoutePoint != null) {
                            // print(destinationRoutePoint);
                            MainApplication().curOrder.addRoutePoint(pickUpRoutePoint);
                            MainApplication().curOrder.addRoutePoint(destinationRoutePoint);
                          }
                        }
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
          bottom: 8,
          left: 8,
          right: 8,
          child: Container(
            constraints: const BoxConstraints(minWidth: double.infinity),
            alignment: Alignment.center,
            height: 60,
            width: double.infinity,
            // margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: StreamBuilder(
                  stream: AppBlocs().pickUpStream,
                  builder: (context, snapshot) {
                    // print("!!!!!" + snapshot.data.toString());
                    return RaisedButton(
                      onPressed: MapMarkersService().pickUpState == PickUpState.enabled ? _mainButtonClick : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.only(bottomLeft: Radius.circular(18), bottomRight: Radius.circular(18)),
                      ),
                      splashColor: Colors.yellow[200],
                      textColor: Colors.white,
                      color: Colors.amber,
                      disabledColor: Colors.grey,
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Container(width: 40, child: Icon(Icons.find_replace)),
                          snapshot.data == PickUpState.disabled
                              ? Expanded(
                                  child: Text(
                                    "Извините, регион не обслуживается",
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              : Text(
                                  "Куда?",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ),
        Positioned(
          bottom: 120,
          right: 8,
          child: FloatingActionButton(
            heroTag: '_moveToCurLocation',
            backgroundColor: Colors.white,
            onPressed: (){MainApplication().curOrder.moveToCurLocation();},
            child: Icon(Icons.near_me, color: Colors.black,),
          ),
        ),
      ],
    );
  }

  void onCameraMove(CameraPosition position){
    MapMarkersService().pickUpLocation = position.target;
    MapMarkersService().zoomLevel = position.zoom;
  }

  void onCameraIdle(){
    GeoService().geocode(MapMarkersService().pickUpLocation).then((routePoint){
      // print(routePoint.toString());
      if (routePoint != MapMarkersService().pickUpRoutePoint){
        MapMarkersService().pickUpRoutePoint = routePoint;
        setText(routePoint.name + " " + routePoint.dsc);
        MainApplication().mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: routePoint.getLocation(),
              zoom: MapMarkersService().zoomLevel,
            ),
          ),
        );
      }
      else {
        MapMarkersService().pickUpRoutePoint.checkPickUp();
      }
    });
  }

  void  _mainButtonClick() async {
    RoutePoint routePoint = await Navigator.push<RoutePoint>(_context, MaterialPageRoute(builder: (_context) => RoutePointScreen()));
    if (routePoint != null) {
      MainApplication().curOrder.addRoutePoint(MapMarkersService().pickUpRoutePoint);
      MainApplication().curOrder.addRoutePoint(routePoint);
      // print(MainApplication().curOrder.toJson());
    }
  }

}
