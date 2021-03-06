import 'package:flutter/material.dart';
import 'package:grocery_plus/view/order_details.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin{

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: const Size.fromHeight(0),child: AppBar(backgroundColor: Colors.green)),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              floating: true,
              pinned: true,
              snap: true,
              backgroundColor: Colors.white,
              title: const Text('Orders',style: TextStyle(color: Colors.black,fontSize: 14)),
              bottom: TabBar(
                isScrollable: false,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Colors.green,
                labelColor: Colors.green,
                unselectedLabelColor: Colors.grey,
                indicatorWeight: 2.0,
                controller: tabController,
                tabs: const [
                  Tab(text: 'Ongoing'),
                  Tab(text: 'Complete')
                ]
              )
            )
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: const [
            OngoingOrderScreen(),
            CompletedOrderScreen()
          ]
        )
      )
    );
  }
}

class OngoingOrderScreen extends StatefulWidget {
  const OngoingOrderScreen({ Key? key }) : super(key: key);

  @override
  _OngoingOrderScreenState createState() => _OngoingOrderScreenState();
}

class _OngoingOrderScreenState extends State<OngoingOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('There is no ongoing order right now\nyou can order from home',textAlign: TextAlign.center,style: TextStyle(fontSize: 14,color: Colors.black))
    );
  }
}

class CompletedOrderScreen extends StatefulWidget {
  const CompletedOrderScreen({ Key? key }) : super(key: key);

  @override
  _CompletedOrderScreenState createState() => _CompletedOrderScreenState();
}

class _CompletedOrderScreenState extends State<CompletedOrderScreen> {

  var listImageURL = [
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

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context,index){
        return InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetails(imagePath: listImageURL[index]))),
          child: Container(
            padding: const EdgeInsets.only(left: 8,right: 8),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: Image.network(listImageURL[index]),
                ),
                const SizedBox(width: 10),
                const Text('Aashirvaad Whole Wheat Atta 10 kg',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold))
              ]
            )
          )
        );
      },
      separatorBuilder: (context,index) => const Divider(color: Color.fromARGB(255, 191, 191, 191),height: 0.8,thickness: 0.8),
      itemCount: listImageURL.length
    );
  }
}
