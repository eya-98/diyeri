import 'package:flutter/material.dart';
import 'login.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
// ignore: use_key_in_widget_constructors
class First extends StatefulWidget {
  @override
 State<StatefulWidget> createState() =>  StartState();
}
class  StartState extends State<First> {
  get background => null;

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      body:Center(
        child: Container(
                  padding: const EdgeInsets.only(top: 2, left: 0),
                          child: Lottie.asset(
                    'assets/lottie.json',
                    width: 250,
                    height: 250,
                    fit: BoxFit.fill,
) 
      )  ),);
  }
  @override
void initState() {
 Timer(const Duration(seconds: 3), (){
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> 
 Login()));
});
 super.initState();
}
}
  