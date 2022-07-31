import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_plus/model/all_product_model.dart';
import 'package:grocery_plus/util/shared_pref.dart';

class ProductProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get loading => _isLoading;
  List<AllProductModel> listProduct = [];
  List<AllProductModel> listCommonProduct = [];
  AllProductModel? commonProduct;
  int cartItemCount = 0;

  var firestore = FirebaseFirestore.instance.collection('grocery');

  getAllProduct(String id) async {
    _isLoading = true;
    notifyListeners();
    await firestore.doc('allProducts').collection(id).get().then((QuerySnapshot value) {
      for (var item in value.docs) {
        var data = item.data() as Map;
        listProduct.add(AllProductModel(
          id: item.id, 
          name: data['name'], 
          imageUrl: data['imageUrl'],
          description: data['description'],
          dop: data['dop'],
          doe: data['doe'],
          rating: data['rating'],
          price: data['price']
        ));
      }
    });
    _isLoading = false;
    notifyListeners();
  }

  getCommonProducts(String id,String productId) async{
    _isLoading = true;
    notifyListeners();
    listCommonProduct.clear();
    await firestore.doc('allProducts').collection(id).get().then((QuerySnapshot value) {
      for (var item in value.docs) {
        var data = item.data() as Map;
        if(item.id == productId){
          commonProduct = AllProductModel(
            id: item.id, 
            name: data['name'], 
            imageUrl: data['imageUrl'],
            description: data['description'],
            dop: data['dop'],
            doe: data['doe'],
            rating: data['rating'],
            price: data['price']
          );
        }else{
          listCommonProduct.add(AllProductModel(
            id: item.id, 
            name: data['name'], 
            imageUrl: data['imageUrl'],
            description: data['description'],
            dop: data['dop'],
            doe: data['doe'],
            rating: data['rating'],
            price: data['price']
          ));
        }
      }
    });
    if(SharedPref.getLogin){
      await getCartData();
    }
    _isLoading = false;
    notifyListeners();
  }

  getCartData() async{
    await firestore.doc('users').collection(SharedPref.getUserId()).doc('cart').get().then((DocumentSnapshot value){
      print(value);
    });
  }

}
