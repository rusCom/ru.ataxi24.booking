import 'dart:convert';
import 'dart:io';
import 'package:booking/models/main_application.dart';
import 'package:booking/ui/utils/core.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class RestService {
  static final RestService _singleton = RestService._internal();

  factory RestService() => _singleton;

  RestService._internal();

  int _curRestIndex = 0;

  Future<dynamic> httpPost(String path, Map<String, dynamic> body) async {
    if (DebugPrint().restServiceDebugPrint) {
      Logger().d("##### RestService httpGet path = $path");
    }
    var result;

    http.Response response;
    String url = Const.restHost[_curRestIndex] + path;
    response = await _httpPostH(url, json.encode(body));
    if (response == null) {
      for (var host in Const.restHost) {
        if ((response == null) & (Const.restHost.indexOf(host) != _curRestIndex)) {
          url = host + path;
          response = await _httpPostH(url, json.encode(body));
          if (response != null) {
            _curRestIndex = Const.restHost.indexOf(host);
          }
        }
      } // for (var host in AppSettings.restHost){
    } // if (response == null){

    if (response != null) {
      if (response.statusCode == 200) {
        result = json.decode(response.body);
      }
    }
    if (DebugPrint().restServiceDebugPrint) {
      Logger().d("##### RestService httpGet result = $result");
    }
    return result;
  }

  Future<Map<String, dynamic>> httpGet(path) async {
    var result;

    http.Response response;
    String url = Const.restHost[_curRestIndex] + path;
    if (DebugPrint().restServiceDebugPrint) {
      Logger().d("##### RestService httpGet path = $url");
    }
    response = await _httpGetH(url);
    if (response == null) {
      for (var host in Const.restHost) {
        if ((response == null) & (Const.restHost.indexOf(host) != _curRestIndex)) {
          url = host + path;

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
      }
      if (response.statusCode == 401) {
        result = json.decode(response.body);
      }
    }
    if (DebugPrint().restServiceDebugPrint) {
      Logger().d("##### RestService httpGet result = $result");
    }
    return result;
  }

  Future<http.Response> _httpPostH(String url, String body) async {
    http.Response response;
    try {
      response = await http.post(url, headers: {HttpHeaders.authorizationHeader: "Bearer " + _authHeader()}, body: body);
    } catch (e) {
      print(e.toString());
    }

    return response;
  }

  Future<http.Response> _httpGetH(url) async {
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
      "deviceId": MainApplication().deviceId,
      "dispatching": Const.dispatchingToken,
      "lt": MainApplication().currentPosition.latitude,
      "ln": MainApplication().currentPosition.longitude,
      "platform": MainApplication().targetPlatform.toString(),
      "token": MainApplication().clientToken,
      "test": false,
    };

    var bytes = utf8.encode(header.toString());
    return base64.encode(bytes);
  }
}
