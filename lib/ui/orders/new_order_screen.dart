import 'package:booking/services/app_state.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';


class NewOrderScreen extends StatefulWidget {
  @override
  _NewOrderScreenState createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  GoogleMapController mapController;
  final Set<Marker> _markers = {};
  LatLng _lastLocation;

  @override
  void initState() {
    super.initState();
    _moveToCurLocation();

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: Provider.of<AppStateProvider>(context, listen: false).lastLocation,
            zoom: 16.0,
          ),
          onMapCreated: onCreated,
          myLocationEnabled: false,
          mapType: MapType.normal,
          compassEnabled: true,
          markers: _markers,
          onCameraMove: _onCameraMove,
          onCameraIdle: _onCameraIdle,
        ),
        Positioned(
          bottom: 25,
          right: 25,
          child: FloatingActionButton(
            onPressed: _moveToCurLocation,
            child: Icon(Icons.my_location),
          ),

        ),


      ],
    );
  }

  _moveToCurLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    LatLng latLng = new LatLng(currentLocation.latitude, currentLocation.longitude);
    CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(latLng, 16);
    mapController.animateCamera(cameraUpdate);
    Provider.of<AppStateProvider>(context, listen: false).lastLocation = latLng;
  }

  void onCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }


  void _onCameraIdle() {
    debugPrint("_onCameraIdle " + _lastLocation.toString());
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _lastLocation = position.target;
      // debugPrint("_onCameraMove " + _lastLocation.toString());
    });

  }
}
