import 'package:flutter/material.dart';

class HomeLoading extends StatelessWidget {
  final String message;
  const HomeLoading({ Key? key,required this.message}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    var _loadingSize = MediaQuery.of(context).size.height * 0.02;
    return Container(
      padding: EdgeInsets.all(_loadingSize/2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: _loadingSize,width: _loadingSize,child: const CircularProgressIndicator(strokeWidth: 1.0,color: Colors.grey)),
          SizedBox(width: _loadingSize/2),
          Text(message,style: const TextStyle(color: Colors.grey,fontSize: 11))
        ]
      )
    );
  }
}