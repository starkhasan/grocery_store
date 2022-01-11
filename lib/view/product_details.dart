import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:grocery_plus/provider/product_provider.dart';
import 'package:grocery_plus/util/helper.dart';
import 'package:grocery_plus/util/shared_pref.dart';
import 'package:grocery_plus/view/authentication_screen.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatelessWidget {
  final String productId;
  final String subProductId;
  const ProductDetails({ Key? key,required this.productId,required this.subProductId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductProvider>(
      create: (context) => ProductProvider(),
      child: MainScreen(id: productId,productId: subProductId),
    );
  }
}

class MainScreen extends StatefulWidget {
  final String id;
  final String productId;
  const MainScreen({ Key? key,required this.id, required this.productId}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with Helper{

  final currentPageNotifier = ValueNotifier<int>(0);
  var itemCount = 1;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      var provider = Provider.of<ProductProvider>(context,listen: false);
      provider.getCommonProducts(widget.id, widget.productId);
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child){
        return Scaffold(
          appBar: PreferredSize(preferredSize: const Size.fromHeight(0),child: AppBar(backgroundColor: Colors.green)),
          bottomNavigationBar: InkWell(
            onTap: () => SharedPref.getLogin 
             ? showSnackbar(context,'Add Item to Cart')
             : Navigator.push(context,MaterialPageRoute(builder: (context) => const AuthenticationScreen())),
            child: Container(
              height: 50,
              color: Colors.deepOrange,
              child: const Center(child: Text('Add to Cart',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.white)))
            )
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: const Text('Product Details',style: TextStyle(color: Colors.black,fontSize: 14)),
                backgroundColor: Colors.white,
                floating: true,
                snap: true,
                leading: IconButton(onPressed: () => Navigator.pop(context),icon: const Icon(Icons.arrow_back,color:Colors.black)),
                actions: [
                  IconButton(
                    onPressed: SharedPref.getLogin ? () => showSnackbar(context, 'You Click on the Badge') : null,
                    icon: SharedPref.getLogin
                      ? Badge(
                          badgeColor: Colors.red,
                          position: const BadgePosition(start: 10, bottom: 8.0),
                          badgeContent: const Text('2',style: TextStyle(color: Colors.white,fontSize: 12)),
                          child: const Icon(Icons.shopping_cart,color: Colors.black),
                        )
                      : const SizedBox()
                  )
                ]
              ),
              provider.loading
              ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
              : SliverList(delegate: SliverChildListDelegate([mainBody(provider)]))
            ]
          )
        );
      }
    );
  }

  Widget mainBody(ProductProvider provider){
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.30,
                child: PageView.builder(
                  itemCount: 1,
                  itemBuilder: (BuildContext contex,int index) {
                    return Container(
                      color: Colors.transparent,
                      child: provider.commonProduct == null ? const CircularProgressIndicator() : Image.network(provider.commonProduct!.imageUrl)
                    );
                  },
                  onPageChanged: (int index) {
                    currentPageNotifier.value = index;
                  }
                )
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: CirclePageIndicator(
                  itemCount: 1,
                  currentPageNotifier: currentPageNotifier,
                )
              )
            ]
          ),
          Container(
            padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.commonProduct == null ? '' : provider.commonProduct!.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  )
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: provider.commonProduct == null ? '' : '\u{20B9}${provider.commonProduct!.price}',style: const TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold)),
                              const TextSpan(text: '/ Kg',style: TextStyle(fontSize: 12,color: Colors.black,fontWeight: FontWeight.normal))
                            ]
                          )
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.only(left: 5,top: 2,right: 5,bottom: 2),
                          decoration: BoxDecoration(color:Colors.green[800],borderRadius: const BorderRadius.all(Radius.circular(2))),
                          child: Row(
                            children: [
                              Text(provider.commonProduct == null ? '' : provider.commonProduct!.rating,style: const TextStyle(color: Colors.white)),
                              const SizedBox(width: 5),
                              const Icon(Icons.star,size: 14,color: Colors.white)
                            ]
                          )
                        )
                      ]
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () => updateItemCount('down'),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.red[50]),
                            child: const Icon(Icons.remove,size: 22),
                          )
                        ),
                        Text(itemCount.toString(),style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)),
                        InkWell(
                          onTap: () => updateItemCount('up'),
                          child: Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.green[50]),
                            child: const Icon(Icons.add,size: 22),
                          )
                        )
                      ]
                    )
                  ]
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.watch_later_outlined,color: Colors.red,size: 24),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(provider.commonProduct == null ? '' : 'Manufactured date ${provider.commonProduct!.dop}',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                        Text(provider.commonProduct == null ? '' : 'Best Before ${provider.commonProduct!.doe}',style: const TextStyle(color: Color.fromARGB(255, 107, 107, 107),fontSize: 11))
                      ]
                    )
                  ]
                )
              ]
            )
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            margin: const EdgeInsets.only(top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(height: 1,thickness: 1,color: Colors.grey[300]),
                InkWell(
                  onTap: () => print('Click Here to see all details'),
                  child: Container(
                    padding: const EdgeInsets.only(top: 12,bottom: 12,right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('All Details'),
                        Icon(Icons.arrow_forward_ios_rounded,size: 20)
                      ]
                    )
                  )
                ),
                Divider(height: 1,thickness: 1,color: Colors.grey[300]),
                Container(
                  padding: const EdgeInsets.only(top: 10,bottom: 10,right: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Description'),
                      const SizedBox(width: 10),
                      Expanded(child: Text(provider.commonProduct == null ? '' : provider.commonProduct!.description,style: const TextStyle(fontSize: 12,color: Color.fromARGB(255, 100, 100, 100))))
                    ]
                  )
                )
              ]
            )
          ),
          Divider(height: 1,thickness: 1,color: Colors.grey[400]), 
          const Padding(
            padding: EdgeInsets.only(top: 15, left: 15),
            child: Text('You can also check this item',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(left: 20,top: 15),
            itemBuilder: (BuildContext context,int index){
              return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(productId: widget.id,subProductId: provider.listCommonProduct[index].id))),
                child: Container(
                  padding: const EdgeInsets.only(top: 10,bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.30,
                        child: Image.network(provider.listCommonProduct[index].imageUrl),
                      ),
                      const SizedBox(width: 10), 
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(provider.listCommonProduct[index].name,style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 5),
                            Text('\u{20B9}${int.parse(provider.listCommonProduct[index].price) + 40}',style: const TextStyle(fontSize: 14,color: Colors.grey,fontWeight: FontWeight.normal,decoration: TextDecoration.lineThrough)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: '\u{20B9}${provider.listCommonProduct[index].price}',style: const TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold)),
                                      const TextSpan(text: '/ Kg',style: TextStyle(fontSize: 12,color: Colors.black,fontWeight: FontWeight.normal))
                                    ]
                                  )
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.only(left: 5,top: 2,right: 5,bottom: 2),
                                  decoration: BoxDecoration(color:Colors.green[800],borderRadius: const BorderRadius.all(Radius.circular(2))),
                                  child: Row(
                                    children: [
                                      Text(provider.listCommonProduct[index].rating,style: const TextStyle(color: Colors.white,fontSize: 12)),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.star,size: 14,color: Colors.white)
                                    ]
                                  )
                                )
                              ]
                            )
                          ]
                        )
                      )
                    ]
                  )
                )
              );
            },
            separatorBuilder: (context,index) => Divider(height: 1,thickness: 1,color: Colors.grey[300]), 
            itemCount: provider.listCommonProduct.length
          )
        ]
      )
    );
  }

  updateItemCount(String type){
    setState(() {
      if(type == 'down' && (itemCount > 1)){
        itemCount-=1;
      }
      if(type == 'up' && itemCount < 30){
        itemCount+=1;
      }
    });
  }
}