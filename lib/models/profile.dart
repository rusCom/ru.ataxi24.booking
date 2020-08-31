import 'package:booking/models/main_application.dart';
import 'package:booking/services/rest_service.dart';
import 'package:booking/ui/utils/core.dart';
import 'package:logger/logger.dart';

class Profile {
  static final Profile _singleton = Profile._internal();
  factory Profile() => _singleton;
  Profile._internal();

  String phone = "", code = "";


  void parseData(Map<String, dynamic> jsonData) {}

  Future<bool> auth() async{
    Map<String, dynamic> restResult = await RestService().httpGet("/profile/auth");
    if (restResult['status'] == 'OK'){
      if (DebugPrint().parseDataDebugPrint){
        Logger().d(restResult['result']);
      }
      MainApplication().parseData(restResult['result']);
      if (restResult['result'].containsKey("profile")){
        restResult = await RestService().httpGet("/data");
        MainApplication().parseData(restResult['result']);
        return true;
      }
    }
    if (restResult['status'] == 'UNAUTHORIZED'){
      if (restResult.containsKey('error')){
        MainApplication().parseData(restResult['error']);
      }
    }
    return false;
  }

  Future<String> login() async{
    Map<String, dynamic> restResult = await RestService().httpGet("/profile/login?phone=" + phone);
    if (restResult['status'] == 'OK'){
      return "OK";
    }
    return restResult['error'];
  }

  Future<String> registration() async{
    Map<String, dynamic> restResult = await RestService().httpGet("/profile/registration?phone=" + phone + "&code=" + code);
    if (restResult['status'] == 'OK'){
      print(restResult['result']);
      MainApplication().clientToken = restResult['result'];
      return "OK";
    }
    return restResult['error'];
  }




}


