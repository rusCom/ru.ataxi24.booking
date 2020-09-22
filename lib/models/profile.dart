import 'package:booking/models/main_application.dart';
import 'package:booking/services/rest_service.dart';
import 'package:booking/ui/utils/core.dart';

class Profile {
  final String TAG = (Profile).toString(); // ignore: non_constant_identifier_names
  static final Profile _singleton = Profile._internal();
  factory Profile() => _singleton;
  Profile._internal();

  String phone = "", code = "";


  void parseData(Map<String, dynamic> jsonData) {
    phone = jsonData['phone'] != null ? jsonData['phone'] : "";

  }

  Future<bool> auth() async{
    Map<String, dynamic> restResult = await RestService().httpGet("/profile/auth");
    DebugPrint().log(TAG, "auth", restResult.toString());
    if (restResult['status'] == 'OK'){
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
      DebugPrint().log(TAG, "registration", restResult['result']);
      MainApplication().clientToken = restResult['result'];
      return "OK";
    }
    return restResult['error'];
  }




}


