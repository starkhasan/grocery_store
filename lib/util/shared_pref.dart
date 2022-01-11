import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery_plus/util/constants.dart';

class SharedPref {
  static SharedPreferences? _sharedPreferences;
  static Future<SharedPreferences> get _instance async => _sharedPreferences ?? await SharedPreferences.getInstance();

  static Future<SharedPreferences?> init() async {
    _sharedPreferences = await _instance;
    return _sharedPreferences;
  }

  void setLogin(bool isLogin){
    _sharedPreferences!.setBool(Constants.login, isLogin);
  }

  bool getLogin(){
    return _sharedPreferences!.getBool(Constants.login) ?? false;
  }

  void setUserId(String userId){
    _sharedPreferences!.setString(Constants.userID, userId);
  }

  String getUserId(){
    return _sharedPreferences!.getString(Constants.userID) ?? '';
  }
}
