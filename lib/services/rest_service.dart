import 'dart:convert';
import 'dart:io';
import 'package:booking/main_application.dart';
import 'package:booking/ui/utils/core.dart';
import 'package:http/http.dart' as http;

class RestService {
  static final RestService _singleton = RestService._internal();
  factory RestService() =>  _singleton;
  RestService._internal();

  int _curRestIndex = 0;

  Future<dynamic> _fakeHttpGet(String path) async {
    String result;
    if (path.contains("/orders/pickup")) {
      result = ordersPickup.toString();
    }
    if (path.contains("/orders/calc")) {
      result = ordersCalc.toString();
    }
    if (result != null) {
      await Future.delayed(const Duration(seconds: 1));
    }
    return result;
  }

  Future<dynamic> httpGet(path) async {
    if (DebugPrint().restServiceDebugPrint) {
      print("##### RestService httpGet path = $path");
    }
    var result;

    result = await _fakeHttpGet(path);
    if (result != null) {
      print(result);
      return json.decode(result);
    }

    http.Response response;
    String url = Const.restHost[_curRestIndex] + path;
    response = await _httpGetH(url);
    if (response == null) {
      for (var host in Const.restHost) {
        if ((response == null) & (Const.restHost.indexOf(host) != _curRestIndex)) {
          url = host + path;
          // print(url);
          response = await _httpGetH(url);
          if (response != null) {
            _curRestIndex = Const.restHost.indexOf(host);
          }
        }
      } // for (var host in AppSettings.restHost){
    } // if (response == null){

    if (response != null) {
      if (response.statusCode == 200) {
        result = json.decode(response.body);
        //_appState.parseData(result);
      }
    }
    if (DebugPrint().restServiceDebugPrint) {
      print("##### RestService httpGet result = $result");
    }
    return result;
  }

  Future<http.Response> _httpGetH(url) async {
    // print('httpGet path = $url');
    http.Response response;
    try {
      response = await http.get(
        url,
        headers: {HttpHeaders.authorizationHeader: "Bearer " + _authHeader()},
      );
    } catch (e) {
      print(e.toString());
    }

    return response;
  }

  String _authHeader() {
    var header = {
      "device_id": MainApplication().deviceId,
      "dispatching": Const.dispatchingToken,
      "lt": MainApplication().currentPosition.latitude,
      "ln": MainApplication().currentPosition.longitude,
      "platform": MainApplication().targetPlatform,
      "token": MainApplication().clientToken,
    };

    //print(header);
    var bytes = utf8.encode(header.toString());
    //print(base64.encode(bytes));
    return base64.encode(bytes);
  }
}

String ordersPickup =
    '{"status":"OK","result":{"pick_up":true,"tariffs":[{"name":"Эконом","type":"econom"},{"name":"Комфорт","type":"comfort"},{"name":"Комфорт+","type":"comfort+"},{"name":"Бизнес","type":"buisness"},{"name":"Грузовой","type":"cargo"}]}}';
String ordersCalc =
    '{"status":"OK","result":{"distance":2568,"duration":658,"tariffs":[{"name":"Эконом","type":"econom","price":250},{"name":"Комфорт","type":"comfort","price":350},{"name":"Комфорт+","type":"comfort+","price":450},{"name":"Бизнес","type":"buisness","price":550},{"name":"Грузовой","type":"cargo","price":650}]}}';
