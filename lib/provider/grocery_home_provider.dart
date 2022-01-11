import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:grocery_plus/model/product_model.dart';
import 'package:grocery_plus/util/helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class GroceryHomePovider extends ChangeNotifier with Helper{
  bool _isLoading = false;
  String _userLocation = '';
  String get userLocation => _userLocation;
  bool get loading => _isLoading;
  List<ProductModel> listProducts = [];
  List<ProductModel> originalListProduct = [];
  List<String> listCategories = [];
  var products = FirebaseFirestore.instance.collection('grocery');
  var databaseReferene = FirebaseDatabase.instance.ref().child('covid_info');

  Future<void> getProducts(BuildContext context,String tag) async {
    _isLoading = true;
    notifyListeners();
    await products.doc('categories').get().then((DocumentSnapshot value) {
      var data = value.data() as Map;
      for(var item in data['productCategories'].split('/')){
        listCategories.add(item);
      }
    });
    await products.doc('products').collection(tag).get().then((QuerySnapshot value) {
      for (var item in value.docs) {
        var data = item.data() as Map;
        listProducts.add(ProductModel(id: item.id, name: data['name'], imageUrl: data['imageUrl']));
      }
      originalListProduct.addAll(listProducts);
    });
    _isLoading = false;
    notifyListeners();
    getUserCurrentLocation(context);
  }

  searchProducts(String productName){
    listProducts.clear();
    if(productName.isNotEmpty){
      for(var item in originalListProduct){
        if(item.name.toLowerCase().startsWith(productName.toLowerCase())){
          listProducts.add(item);
        }
      }
    }else{
      listProducts.addAll(originalListProduct);
    }
    notifyListeners();
  }

  Future<void> getUserCurrentLocation(BuildContext context) async{

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _userLocation = 'Error';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _userLocation = 'Error';
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
      _userLocation = 'Error';
    } 

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(currentLocation.latitude, currentLocation.longitude);
    _userLocation = '${placemarks[0].subLocality.toString()}, ${placemarks[0].locality}, ${placemarks[0].postalCode}';
    notifyListeners();
  }
}
