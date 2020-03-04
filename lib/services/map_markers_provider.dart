
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarkersProvider with ChangeNotifier{

  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  BitmapDescriptor _mapPickUpIcon;
  BuildContext _context;
  MarkerId _mapPickUpMarkerID;
  Marker _mapPickUpMarker;

  init(BuildContext context, LatLng location) async {
    _context = context;
    ImageConfiguration configuration = createLocalImageConfiguration(_context);
    _mapPickUpIcon = await BitmapDescriptor.fromAssetImage(configuration, 'assets/icons/ic_onboard_pick_up.png');
    _mapPickUpMarkerID = MarkerId('_mapPickUpMarkerID');

    _mapPickUpMarker = Marker(
        markerId: _mapPickUpMarkerID,
        position: location,
        draggable: false,
        icon: _mapPickUpIcon
    );

    _markers[_mapPickUpMarkerID] = _mapPickUpMarker;

  }

  Set<Marker> markers(){
    return Set<Marker>.of(_markers.values);
  }

  Set<Marker> newCurLocation(LatLng position){
    Marker marker = _markers[_mapPickUpMarkerID];
    Marker updatedMarker = marker.copyWith(
      positionParam: position,
    );

    _markers[_mapPickUpMarkerID] = updatedMarker;

    return Set<Marker>.of(_markers.values);
  }


}