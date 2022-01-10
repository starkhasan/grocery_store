import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:grocery_plus/model/product_model.dart';

class GroceryHomePovider extends ChangeNotifier {
  bool _isLoading = false;
  bool get loading => _isLoading;
  List<ProductModel> listProducts = []; 
  var products = FirebaseFirestore.instance.collection('grocery');
  var databaseReferene = FirebaseDatabase.instance.ref().child('covid_info');
  Future<void> getProducts(String tag) async {
    _isLoading = true;
    notifyListeners();
    await products.doc('products').collection(tag).get().then((QuerySnapshot value) {
      for (var item in value.docs) {
        var data = item.data() as Map;
        listProducts.add(ProductModel(id: item.id, name: data['name'], imageUrl: data['imageUrl']));
      }
    });
    _isLoading = false;
    notifyListeners();
  }
}
