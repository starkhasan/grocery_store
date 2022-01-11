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


  var groceryMoreItems = ['My Account','My Wishlist','Saved Addresses','All Orders','My Rewards'];

}
