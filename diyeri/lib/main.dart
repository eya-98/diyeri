import 'dart:ffi';

import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'providers/auth_provider.dart';
import 'providers/reservation_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool logged = false; 
    return MultiProvider(
              providers: [
                ChangeNotifierProvider<Auth_provider>(create: (_) => Auth_provider()),
                ChangeNotifierProvider<Reservation_provider>(create: (_) => Reservation_provider())
              ],
              child:
    MaterialApp(
      title: 'Diyeri',
      // home: Login()
      home: get(logged) == true? Home(): Login() 
      )
  );
}
 
 get(logged) {
 FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) { 
    if (user != null){
    print (user);
     setState() {logged = true;}
    }
    else {
     setState() {logged = false;}
    }
}
  );
  print(logged);
  return logged;
 
 }
}