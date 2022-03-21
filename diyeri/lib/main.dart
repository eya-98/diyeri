import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'providers/auth_provider.dart';
import 'providers/reservation_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
              providers: [
                ChangeNotifierProvider<Auth_provider>(create: (_) => Auth_provider()),
                ChangeNotifierProvider<Reservation_provider>(create: (_) => Reservation_provider())
              ],
              child:
    MaterialApp(
      title: 'Diyeri',
      // home: Login()
      home: Login()
      )
  );
}
}