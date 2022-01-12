import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery_plus/util/constants.dart';

class SharedPref {
  static SharedPreferences? _sharedPreferences;
  static Future<SharedPreferences> get _instance async => _sharedPreferences ?? await SharedPreferences.getInstance();

  static Future<SharedPreferences?> init() async {
    _sharedPreferences = await _instance;
    return _sharedPreferences;
  }

  static setUserEmail(String email){
    _sharedPreferences!.setString(Constants.useEmail, email);
  }

  static String getUserEmail(){
    return _sharedPreferences!.getString(Constants.useEmail) ?? '';
  }

  static setUserName(String name){
    _sharedPreferences!.setString(Constants.userName, name);
  }

  static String getUserName(){
    return _sharedPreferences!.getString(Constants.userName) ?? '';
  }

  static setLogin(bool isLogin){
    _sharedPreferences!.setBool(Constants.login, isLogin);
  }

  static bool get getLogin{
    return _sharedPreferences!.getBool(Constants.login) ?? false;
  }

  static setUserId(String userId){
    _sharedPreferences!.setString(Constants.userID, userId);
  }

  static String getUserId(){
    return _sharedPreferences!.getString(Constants.userID) ?? '';
  }
}
