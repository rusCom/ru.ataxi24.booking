import 'dart:async';

import 'package:booking/models/order.dart';
import 'package:booking/models/route_point.dart';



class AppBlocs{
  static final AppBlocs _singleton = AppBlocs._internal();
  factory AppBlocs() {return _singleton;}
  AppBlocs._internal();

  StreamController _pickUpController;
  Stream get pickUpStream => pickUpController.stream;
  StreamController get pickUpController{
    if (_pickUpController == null){
      _pickUpController = StreamController.broadcast();
    }
    return _pickUpController;
  }

  StreamController _geoAutocompleteController;
  Stream get geoAutocompleteStream => geoAutocompleteController.stream;
  StreamController get geoAutocompleteController{
    if (_geoAutocompleteController == null){
      _geoAutocompleteController = StreamController.broadcast();
    }
    return _geoAutocompleteController;
  }




  StreamController _mapMarkersController = StreamController();
  Stream get mapMarkersStream => _mapMarkersController.stream;
  StreamController get mapMarkersController => _mapMarkersController;

  StreamController<OrderState> _orderStateController;
  Stream get orderStateStream => orderStateController.stream;
  StreamController get orderStateController {
    if (_orderStateController == null){
      _orderStateController = StreamController<OrderState>.broadcast();
    }
    return _orderStateController;
  }

  StreamController<List<RoutePoint>> _orderRoutePointsController;
  Stream get orderRoutePointsStream => orderRoutePointsController.stream;
  StreamController get orderRoutePointsController {
    if (_orderRoutePointsController == null){
      _orderRoutePointsController = StreamController<List<RoutePoint>>.broadcast();
    }
    return _orderRoutePointsController;
  }

  StreamController _newOrderTariffController; // = StreamController();
  Stream get newOrderTariffStream => newOrderTariffController.stream;
  StreamController get newOrderTariffController{
    if (_newOrderTariffController == null){
      _newOrderTariffController = StreamController.broadcast();
    }
    return _newOrderTariffController;
  }

  StreamController _newOrderNoteController; // = StreamController();
  Stream get newOrderNoteStream => newOrderNoteController.stream;
  StreamController get newOrderNoteController{
    if (_newOrderNoteController == null){
      _newOrderNoteController = StreamController.broadcast();
    }
    return _newOrderNoteController;
  }

  StreamController _newOrderPaymentController; // = StreamController();
  Stream get newOrderPaymentStream => newOrderPaymentController.stream;
  StreamController get newOrderPaymentController{
    if (_newOrderPaymentController == null){
      _newOrderPaymentController = StreamController.broadcast();
    }
    return _newOrderPaymentController;
  }

  void dispose(){
    if (_pickUpController != null)_pickUpController.close();
    if (_geoAutocompleteController != null)_geoAutocompleteController.close();
    if (_mapMarkersController != null)_mapMarkersController.close();
    if (_orderStateController != null)_orderStateController.close();
    if (_orderRoutePointsController != null)_orderRoutePointsController.close();
    if (_newOrderTariffController != null)_newOrderTariffController.close();
    if (_newOrderNoteController != null)_newOrderNoteController.close();
    if (_newOrderPaymentController != null)_newOrderPaymentController.close();

  }


}