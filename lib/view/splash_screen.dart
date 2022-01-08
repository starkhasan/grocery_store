import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_plus/view/main_screen.dart';
import 'dart:async';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.green));
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
    startTimer(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(color: const Color.fromARGB(255, 246, 246, 246),width: double.infinity,height: double.infinity,child: Align(alignment: Alignment.bottomRight,child: Image.asset('asset/grocery_background.jpg'))),
           const Align(
            alignment: Alignment.center,
            child: Text(
              'Grocery Plus',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,fontFamily: '')
            )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height * 0.01),
              child: const Text(
                'Traversal',
                style: TextStyle(color: Color.fromARGB(255, 201, 201, 201),fontSize: 11)
              )
            )
          )
        ]
      )
    );
  }

  void startTimer(BuildContext _context){
    Timer(const Duration(),() => Navigator.pushReplacement(_context, MaterialPageRoute(builder: (context) => const MainScreen())));
  }
}
