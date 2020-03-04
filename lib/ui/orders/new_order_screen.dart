import 'dart:async';

import 'package:booking/services/app_state.dart';
import 'package:booking/services/geo_service.dart';
import 'package:booking/services/map_markers_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class NewOrderScreen extends StatefulWidget {
  @override
  _NewOrderScreenState createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  GoogleMapController mapController;
  Set<Marker> _markers;
  LatLng _lastLocation;
  TextEditingController _controller;
  MapType _currentMapType = MapType.normal;
  GeoService _geoService = GeoService();

  @override
  void initState() {
    super.initState();
    _moveToCurLocation();
    _controller = new TextEditingController(text: 'Initial value');
    _markers = Provider.of<MapMarkersProvider>(context, listen: false).markers();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: Provider.of<AppStateProvider>(context, listen: false).curLocation,
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
                      onPressed: () => Navigator.pushNamed(context, '/route_point'),
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
                onPressed: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.only(bottomLeft: Radius.circular(18), bottomRight: Radius.circular(18)),
                ),
                splashColor: Colors.yellow[200],
                textColor: Colors.white,
                color: Colors.amber,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Container(
                        width: 40,
                        child: Icon(Icons.find_replace)
                    ),
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

        Positioned(
          top: 50,
          right: 8,
          child: FloatingActionButton(
            heroTag: '_onMapTypeButtonPressed',
            onPressed: _onMapTypeButtonPressed,
            child: Icon(Icons.map),
          ),
        ),
      ],
    );
  }


  _moveToCurLocation() async {
    LatLng curLocation = Provider.of<AppStateProvider>(context, listen: false).curLocation;
    if (curLocation != null){
      // GoogleMapController controller = await _mapController.future;
      if (mapController != null){
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: curLocation,
              zoom: 17.0,
            ),
          ),
        );
      }
    }
    Provider.of<AppStateProvider>(context, listen: false).lastLocation = curLocation;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onCameraIdle() {
    debugPrint("_onCameraIdle " + _lastLocation.toString());

      _geoService.geocode(_lastLocation).then(((routePoint) async {
        if (routePoint != null) {
          _controller.text = routePoint.name + " " + routePoint.dsc;
          // GoogleMapController controller = await _mapController.future;
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: routePoint.getLocation(),
                zoom: 17.0,
              ),
            ),
          );

        }
      }));
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _markers = Provider.of<MapMarkersProvider>(context, listen: false).newCurLocation(position.target);
      _lastLocation = position.target;
    });
  }

  void _onMapTap(LatLng latLng)  {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: 17.0,
        ),
      ),
    );

  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }
}
