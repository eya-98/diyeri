import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Reservation_provider with ChangeNotifier {
  var id;
  var favID;
int count = 0;
CollectionReference reservation = FirebaseFirestore.instance.collection("reservation");
CollectionReference auth = FirebaseFirestore.instance.collection("user");
 firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
 /////// upload plate photo
  Future<void> upload(filepath) async {
    try {
    File file = File(filepath);
      await storage.ref().child('food').child('$id').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }
 /////// download plate photo
Future<String> downloadURLExample(id) async {
  try {
  String downloadURL = await storage.ref().child('food').child('$id').getDownloadURL();
    return downloadURL;
}
catch (e) {
print(e);
return 'no';
}
}
 /////// download plate photo
Future<String>downloadprofileimg(BuildContext contex, ID)async{
  try {
    String downloadURL = await storage.ref().child('profiles').child('$ID').getDownloadURL();
    return downloadURL;
    }
  catch (e) {
    print(e);
    return 'no';
    }
  }
  
////// generate ID
 generate(id) {
   id = const Uuid().v4();
   return id;
 }
//////// add reservation
  addReservation(title, description, delivery, price, user_id, favorite, path) async{
    reservation.doc(id).set({"title": title, "description": description, "delivery":delivery, "price": price, "user_id": user_id, "favorite": favorite, "id" : id, "pic" : path ,});
  }
/////// add Favorite to the sub collection of users
addFav(userid, reservID){
  favID = generate(favID);
  auth.doc(userid).collection('favorites').doc(reservID).set({"id": reservID});
}
/////// delete Favorite to the sub collection of users
deleteFav(userid, reservID){
  try {  
    auth.doc(userid).collection('favorites').doc(reservID).delete();
}
catch (e) {
  print(e);
}
}
////// length of favorites
//  Future<int> favslength (userid) async{
//    QuerySnapshot body = await auth.doc(userid).collection('favorites').get();
// List allData = body.docs.map((doc) => doc.data()).toList();
// return allData.length;
// }
Stream favslength (userid) {
  var length = auth.doc(userid).collection('favorites').snapshots().map((documentSnapshot) => documentSnapshot.docs.length);
  return length;
  } 
/////// check if a document exists in the sub collection favorites
favexist (userid, reservID) async{
  bool exist = false;
QuerySnapshot body = await auth.doc(userid).collection('favorites').get();
List allData = body.docs.map((doc) => doc.data()).toList();
print(allData);
 for (var i in allData) {
   if (i != null) {
    if (i['id'].toString().trim() == reservID.toString().trim()) {
    exist = true;
    }
   }
   print('exiiiiiist $exist');
}
return exist;
}
///// get favorites elements
Future <List> getfavs (userid) async{
  QuerySnapshot body = await auth.doc(userid).collection('favorites').get();
//body
List allData = body.docs.map((doc) => doc.data()).toList();
//var body = auth.doc(userid).collection('favorites').snapshots();
//return body;
return allData;
}

listoffavorites(userid)async{
  var list = [];
  var idx = 0;
QuerySnapshot favorite = await auth.doc(userid).collection('favorites').get();
List allData = favorite.docs.map((doc) => doc.data()).toList();
var reservationBody = await reservation.get();
reservationBody.docs.forEach((element) {
 for (var i in allData) {
   if (i != null) {
    if (i['id'].toString().trim() == element['id']) {
      list.add(idx);
    }
   }
}
  idx = idx + 1;
  });
return list;
}
}