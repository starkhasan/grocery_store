import 'package:flutter/material.dart';

class HomeLoading extends StatelessWidget {
  final bool isLoading;
  const HomeLoading({ Key? key,required this.isLoading}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    var _loadingSize = MediaQuery.of(context).size.height * 0.02;
    return Container(
      padding: EdgeInsets.all(_loadingSize/2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(visible: isLoading,child: SizedBox(height: _loadingSize,width: _loadingSize,child: const CircularProgressIndicator(strokeWidth: 1.0,color: Colors.grey))),
          Visibility(visible: isLoading, child: SizedBox(width: _loadingSize/2)),
          Text(isLoading ?  'Loading...' : 'No Products Available',style: const TextStyle(color: Colors.grey,fontSize: 11))
        ]
      )
    );
  }
}