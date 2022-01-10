import 'package:flutter/material.dart';

class Helper {
  
  void showSnackbar(BuildContext context,String message){
    var snackbar = SnackBar(content: Text(message),duration: const Duration(seconds: 1));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  static List<String> listImageURL = [
    'https://m.media-amazon.com/images/I/91pDdDLHquL._SX522_.jpg',
    'https://www.bigbasket.com/media/uploads/p/xxl/40198145_1-popular-essentials-premium-jeera-rice.jpg',
    'https://m.media-amazon.com/images/I/71LpBnx+5xL._SL1500_.jpg',
    'https://m.media-amazon.com/images/I/71bSLxCaGGL._SL1500_.jpg',
    'https://www.jiomart.com/images/product/original/490001392/amul-butter-500-g-carton-6-20210315.jpg',
    'https://www.bigbasket.com/media/uploads/p/l/104823_3-amul-cheese-spread-yummy-plain.jpg',
    'https://5.imimg.com/data5/PF/FT/XN/SELLER-6800096/amul-gold-milk-500ml-500x500.jpg',
    'https://m.media-amazon.com/images/I/615etm93zBL._SX522_.jpg',
    'https://m.media-amazon.com/images/I/519YSKro-XL.jpg',
    'https://m.media-amazon.com/images/I/61L0w87gCML._SX522_.jpg',
  ];

  static List<String> listProductName = [
    'Flour',
    'Rice',
    'Sugar',
    'Salt',
    'Butter',
    'Cheese',
    'Milk',
    'Red Chilli Powder',
    'Turmeric Powder',
    'Coriander Powder' 
  ];

  static var screenNames = [
    'Facebook',
    'Twitter',
    'WhatsApp',
    'Cypto',
    'WebView',
    'Sliver Widget',
    'Firebase Services',
    'Square Payment',
    'Deep Link',
    'Rest API',
    'Web Socket',
    'Widget Element Keys',
    'Scroll Position',
    'Video Player',
    'Grocery Plus',
    'Learning Isolates',
    'Get Started With Flutter'
  ];
  static var screenAssets = [
    'asset/facebook.png',
    'asset/twitter.png',
    'asset/whatsapp.png',
    'asset/crypto.png'
  ];
  var groceryMoreItems = ['My Account','My Wishlist','Saved Addresses','All Orders','My Rewards'];

}
