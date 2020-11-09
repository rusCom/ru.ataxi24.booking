import 'dart:convert';
import 'dart:io';
import 'package:booking/models/main_application.dart';
import 'package:booking/models/preferences.dart';
import 'package:booking/ui/utils/core.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

class RestService {
  final String TAG = (RestService).toString(); // ignore: non_constant_identifier_names
  static final RestService _singleton = RestService._internal();

  factory RestService() => _singleton;

  RestService._internal();

  int _curRestIndex = 0;

  Future<dynamic> httpPost(String path, Map<String, dynamic> body) async {
    DebugPrint().log(TAG, "httpPost", "path = $path");
    var result;

    http.Response response;
    String url = GlobalConfiguration().getValue("restHost")[_curRestIndex] + path;
    response = await _httpPostH(url, json.encode(body));
    if (response == null) {
      for (var host in  GlobalConfiguration().getValue("restHost")) {
        if ((response == null) & ( GlobalConfiguration().getValue("restHost").indexOf(host) != _curRestIndex)) {
          url = host + path;
          response = await _httpPostH(url, json.encode(body));
          if (response != null) {
            _curRestIndex =  GlobalConfiguration().getValue("restHost").indexOf(host);
          }
        }
      } // for (var host in AppSettings.restHost){
    } // if (response == null){

    if (response != null) {
      if (response.statusCode == 200) {
        result = json.decode(response.body);
      }
    }
    DebugPrint().log(TAG, "httpPost", "result = $result");

    return result;
  }

  Future<Map<String, dynamic>> httpGet(path) async {
    var result;

    http.Response response;
    String url =  GlobalConfiguration().getValue("restHost")[_curRestIndex] + path;
    DebugPrint().log(TAG, "httpGet", "path = $url");
    response = await _httpGetH(url);
    if (response == null) {
      for (var host in  GlobalConfiguration().getValue("restHost")) {
        if ((response == null) & ( GlobalConfiguration().getValue("restHost").indexOf(host) != _curRestIndex)) {
          url = host + path;
          response = await _httpGetH(url);
          if (response != null) {
            _curRestIndex =  GlobalConfiguration().getValue("restHost").indexOf(host);
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
    DebugPrint().log(TAG, "httpGet", "result = $result");
    return result;
  }

  Future<http.Response> _httpPostH(String url, String body) async {
    http.Response response;
    try {
      response = await http.post(url, headers: {HttpHeaders.authorizationHeader: "Bearer " + _authHeader()}, body: body).timeout(
        Duration(seconds: Preferences().systemHttpTimeOut),
        onTimeout: () {
          DebugPrint().log(TAG, "_httpPostH", "$url timeout");
          return null;
        },
      );
    } catch (e) {
      DebugPrint().log(TAG, "_httpPostH", "$url catch error = " + e.toString());
    }

    return response;
  }

  Future<http.Response> _httpGetH(url) async {
    http.Response response;
    try {
      response = await http.get(
        url,
        headers: {HttpHeaders.authorizationHeader: "Bearer " + _authHeader()},
      ).timeout(
        Duration(seconds: Preferences().systemHttpTimeOut),
        onTimeout: () {
          DebugPrint().log(TAG, "_httpGetH", "$url timeout");
          return null;
        },
      );
    } catch (e) {
      DebugPrint().log(TAG, "_httpGetH", "catch error = " + e.toString());
    }

    return response;
  }

  String _authHeader() {
    var header = {
      "deviceId": MainApplication().deviceId,
      "dispatching": GlobalConfiguration().getValue("dispatchingToken"),
      "lt": MainApplication().currentPosition.latitude,
      "ln": MainApplication().currentPosition.longitude,
      "platform": MainApplication().targetPlatform.toString(),
      "token": MainApplication().clientToken,
      "test": GlobalConfiguration().getValue("isTest"),
    };

    var bytes = utf8.encode(header.toString());
    return base64.encode(bytes);
  }
}
