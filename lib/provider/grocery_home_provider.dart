import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:grocery_plus/model/product_model.dart';

class GroceryHomePovider extends ChangeNotifier {
  bool _isLoading = false;
  bool get loading => _isLoading;
  List<ProductModel> listProducts = [];
  List<ProductModel> originalListProduct = [];
  List<String> listCategories = [];
  var products = FirebaseFirestore.instance.collection('grocery');
  var databaseReferene = FirebaseDatabase.instance.ref().child('covid_info');

  Future<void> getProducts(String tag) async {
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
}
