import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_plus/provider/grocery_home_provider.dart';
import 'package:grocery_plus/util/dialog_close_button.dart';
import 'package:grocery_plus/util/home_loading.dart';
import 'package:grocery_plus/view/notification_screen.dart';
import 'package:grocery_plus/view/product_details.dart';
import 'package:grocery_plus/util/helper.dart';
import 'package:provider/provider.dart';

class GroceryHome extends StatelessWidget {
  const GroceryHome({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroceryHomePovider>(
      create: (context) => GroceryHomePovider(),
      child: const MainScreen()
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({ Key? key }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp){
      var provider = Provider.of<GroceryHomePovider>(context,listen: false);
      provider.getProducts('veg');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GroceryHomePovider>(
      builder: (context,provider,child){
        return Scaffold(
          appBar: PreferredSize(preferredSize: const Size.fromHeight(0),child: AppBar()),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () => provider.getProducts('veg'),
          //   child: const Icon(Icons.add)
          // ),
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
                      children: [
                        const Icon(Icons.search),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: TextField(
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration.collapsed(hintText: 'Search Anything',hintStyle: TextStyle(fontSize: 14))
                          )
                        ),
                        InkWell(
                          onTap: () => showFilterDialog(context,provider.listCategories),
                          child: const Icon(Icons.filter_list_alt),
                        )
                      ]
                    )
                  ),
                  provider.loading
                  ? const HomeLoading(message: 'Loading...')
                  : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (MediaQuery.of(context).orientation == Orientation.landscape) ? 2 : 2),
                    itemCount: provider.listProducts.length,
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
                              Expanded(child: Image.network(provider.listProducts[index].imageUrl)),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text(provider.listProducts[index].name,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
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
    );
  }

  showFilterDialog(BuildContext context,List<String> items){
    //Remove focus from a single TextField in the Container 
    FocusScope.of(context).unfocus();
    //Dialog
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: const BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10,top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Filter Products',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 13)),
                      GestureDetector(onTap: () => Navigator.pop(context),child: const DialogCloseButton())
                    ]
                  )
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 30,
                    useMagnifier: true,
                    magnification: 1.2,
                    children: List.generate(items.length, (index) => Center(child: Text(items[index],style: const TextStyle(fontSize: 12)))),
                    onSelectedItemChanged: (value){

                    }
                  )
                ),
                GestureDetector(
                  onTap: () => print('Click Here to Publish Review'),
                  child: Container(
                    margin: const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                    padding: const EdgeInsets.only(top: 8,bottom: 8),
                    decoration: const BoxDecoration(color: Colors.green,borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: const Center(child: Text('Submit',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize:  12)))
                  )
                )
              ]
            )
          ),
        );
      }
    );
  }

}