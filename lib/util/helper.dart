import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

mixin Helper {
  
  void showSnackbar(BuildContext context,String message){
    var snackbar = SnackBar(content: Text(message),duration: const Duration(seconds: 1));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Future<bool> checkInternetConnection() async{
    var result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi || result == ConnectivityResult.ethernet){
      return true;
    }
    return false;
  }


  bool validateEmail(String email){
    var regExp = RegExp(r'^(([a-zA-Z0-9_\.\-]*)@([a-zA-Z0-9]+)\.([a-zA-Z0-9]{2,5}))$');
    if(regExp.hasMatch(email)){
      return true;
    }
    return false;
  }


  var groceryMoreItems = ['My Account','My Wishlist','Saved Addresses','All Orders','My Rewards'];

}
