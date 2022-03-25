import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Auth_provider with ChangeNotifier {
FirebaseAuth auth = FirebaseAuth.instance;
get currentUser => auth.currentUser;

// Sign up
SignUp(email, password) async {
  try  {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password); 
    }
  on FirebaseException catch (e) {
    print(e);
  }
}
//login Method
Login(email, password) async{
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    }
  on FirebaseException catch(e) {
    print(e);
    }
 }
//signout
SignOut() async {
  await FirebaseAuth.instance.signOut();
}
}