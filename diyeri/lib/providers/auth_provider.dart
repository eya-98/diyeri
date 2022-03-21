import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
class Auth_provider with ChangeNotifier {
FirebaseAuth auth = FirebaseAuth.instance;
get currentUser => auth.currentUser;
var error = '';
SignUp(email, password) async {
  try  {
            UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password); 
}
        on FirebaseException catch (e) {
          if (e.code == "weak-password" || e.code == 'email-already-in-use') {
        
            error = e.code.replaceAll('-', ' ');
          
         }
        else {
          error = e.code.replaceAll('-', ' ');
          print(error);
          }
        }
}
Login(email, password) async{
          try {
          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
          }
          on FirebaseException catch(e) {
            
            if (e.code == 'user-not-found' || e.code == 'wrong password')
             {
               error = e.code.replaceAll('-', ' ');
             }
            else {
              error = e.code.replaceAll('-', ' ');
               print(e.code);
            }
          }
 }
SignOut() async {
  await FirebaseAuth.instance.signOut();
}
}
