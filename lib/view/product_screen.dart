import 'package:flutter/material.dart';
import 'package:grocery_plus/provider/product_provider.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  final String productId;
  final String productName;
  const ProductScreen({Key? key,required this.productId,required this.productName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductProvider>(
      create: (context) => ProductProvider(),
      child: MainScreen(id: productId, name: productName)
    );
  }
}

class MainScreen extends StatefulWidget {
  final String id;
  final String name;
  const MainScreen({Key? key,required this.id,required this.name}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) { 
      var provider = Provider.of<ProductProvider>(context,listen: false);
      provider.getAllProduct(widget.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child){
        return Scaffold(
          appBar: PreferredSize(preferredSize: const Size.fromHeight(0),child: AppBar(backgroundColor: Colors.green)),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(widget.name,style: const TextStyle(color: Colors.black,fontSize: 14)),
                backgroundColor: Colors.white,
                floating: true,
                snap: true,
                automaticallyImplyLeading: false
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
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 20,top: 15),
      itemBuilder: (BuildContext context,int index){
        return Container(
          padding: const EdgeInsets.only(top: 10,bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.30,
                child: Image.network(provider.listProduct[index].imageUrl),
              ),
              const SizedBox(width: 10), 
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Aashirvaad Whole Wheat Atta 10 kg',style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 5),
                    const Text('\u{20B9}180',style: TextStyle(fontSize: 14,color: Colors.grey,fontWeight: FontWeight.normal,decoration: TextDecoration.lineThrough)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text('\u{20B9}300',style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold)),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.only(left: 5,top: 2,right: 5,bottom: 2),
                          decoration: BoxDecoration(color:Colors.green[800],borderRadius: const BorderRadius.all(Radius.circular(2))),
                          child: Row(
                            children: const [
                              Text('4.5',style: TextStyle(color: Colors.white,fontSize: 12)),
                              SizedBox(width: 4),
                              Icon(Icons.star,size: 14,color: Colors.white)
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
        );
      },
      separatorBuilder: (context,index) => Divider(height: 1,thickness: 1,color: Colors.grey[300]), 
      itemCount: provider.listProduct.length
    );
  }
}
