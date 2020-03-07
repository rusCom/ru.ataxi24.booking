import 'dart:async';

class AppBlocs{
  static final AppBlocs _singleton = AppBlocs._internal();
  factory AppBlocs() {return _singleton;}
  AppBlocs._internal();


  StreamController _mapMarkersController = StreamController();
  Stream get mapMarkersStream => _mapMarkersController.stream;
  StreamController get mapMarkersController => _mapMarkersController;

  StreamController _orderStateController = StreamController();
  Stream get orderStateStream => _orderStateController.stream;
  StreamController get orderStateController => _orderStateController;


}