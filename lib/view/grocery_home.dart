import 'package:flutter/material.dart';
import 'package:grocery_plus/view/notification_screen.dart';
import 'package:grocery_plus/view/product_details.dart';
import 'package:grocery_plus/util/helper.dart';

class GroceryHome extends StatefulWidget {
  const GroceryHome({ Key? key }) : super(key: key);

  @override
  _GroceryHomeState createState() => _GroceryHomeState();
}

class _GroceryHomeState extends State<GroceryHome> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: const Size.fromHeight(0),child: AppBar(backgroundColor: Colors.green)),
      body: Container(
        padding: const EdgeInsets.only(left: 10,right: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Grocery Plus',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen())),
                    icon: const Icon(Icons.notifications),
                  )
                ]
              ),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    child: Icon(Icons.location_pin,color: Colors.white,size: 22),
                    backgroundColor: Colors.green
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Your Location',style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('Wali Ganj, Arrah, Arrah Town',style: TextStyle(color: Colors.black,fontSize: 14))
                    ]
                  )
                ]
              ),
              Container(
                padding: const EdgeInsets.only(left: 8,right: 8,top: 10,bottom: 10),
                margin: const EdgeInsets.only(top: 15),
                decoration: BoxDecoration(color: Colors.grey[300],borderRadius: const BorderRadius.all(Radius.circular(4))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.search),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration.collapsed(hintText: 'Search Anything',hintStyle: TextStyle(fontSize: 14))
                      )
                    )
                  ]
                )
              ),
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (MediaQuery.of(context).orientation == Orientation.landscape) ? 2 : 2),
                itemCount: Helper.listImageURL.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 5,bottom: 5),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context,int index){
                  return InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(imagePath: Helper.listImageURL[index], productDetails: Helper.listProductName[index], productId: '10'))),
                    child: Container(
                      margin: const EdgeInsets.only(top: 4,left: 4,bottom: 4,right: 4),
                      decoration: const BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(5.0)),boxShadow: [BoxShadow(blurRadius: 2.0,color: Color(0xFFE0E0E0))]),
                      child: Column(
                        children: [
                          Expanded(child: Image.network(Helper.listImageURL[index])),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(Helper.listProductName[index],style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                          )
                        ]
                      )
                    )
                  );
                }
              )
            ]
          )
        )
      )
    );
  }
}