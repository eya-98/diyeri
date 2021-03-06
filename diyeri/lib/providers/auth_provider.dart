import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Auth_provider with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  get currentUser => auth.currentUser;
  bool verified = false;
  CollectionReference user = FirebaseFirestore.instance.collection("user");
  var ID;
// Sign up
  SignUp(email, password, adress, phone, fullname) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user!.emailVerified == false) {
        User? users = FirebaseAuth.instance.currentUser;
        await auth.currentUser!.sendEmailVerification();
      }
      var ID = currentUser.uid;
      user.doc(ID).set({
        "email": email,
        "password": password,
        "adress": adress,
        "fullname": fullname,
        "Phone": phone,
        "favorite": false,
        "userpic": "assets/unknown.jpg"
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

//login Method
  Login(email, password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      ID = currentUser.uid;
      if (userCredential.user?.emailVerified == true) {
        verified = true;
      }
    } on FirebaseException catch (e) {
      print(e);
    }
  }
  EditProfile(email, password, adress, phone, fullname) {
    ID = currentUser.uid;
    if (email.length > 0) {
      user.doc(ID).set({"email": email}, SetOptions(merge: true));
    }
    if (fullname.length > 0) {
      user.doc(ID).set({"fullname": fullname}, SetOptions(merge: true));
    }
    if (password.length > 0) {
      user.doc(ID).set({"password": password}, SetOptions(merge: true));
    }
    if (adress.length > 0) {
      user.doc(ID).set({
        "adress": adress,
      }, SetOptions(merge: true));
    }
    if (phone.length > 0) {
      user.doc(ID).set({"Phone": phone}, SetOptions(merge: true));
    }
  }

//signout
  SignOut() async {
    await FirebaseAuth.instance.signOut();
  }

//update email
  update(email, password) async {
    if (email.isNotEmpty) {
      try {
        FirebaseAuth.instance.currentUser!.updateEmail(email);
      } on FirebaseException catch (e) {
        print(e);
      }
    }
    if (password.isNotEmpty) {
      try {
        FirebaseAuth.instance.currentUser!.updatePassword(password);
      } on FirebaseException catch (e) {
        print(e);
      }
    }
  }
//upload profile picture
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  Future<void> upload(filepath) async {
    File file = File(filepath);
    try {
      await storage.ref().child('profiles').child(ID).putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }
// get image
Future<String> downloadURLExample() async {
  try {
  String downloadURL = await firebase_storage.FirebaseStorage.instance
      .ref('profiles/$ID')
      .getDownloadURL();
    return downloadURL;
}
catch (e) {
print(e);
return 'no';
    }
}
}
