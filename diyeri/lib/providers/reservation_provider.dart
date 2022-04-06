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
int count = 0;
CollectionReference reservation = FirebaseFirestore.instance.collection("reservation");
CollectionReference auth = FirebaseFirestore.instance.collection("user");

    counter(count) async{
      count = 0;
      var reservationBody = await reservation.get();
      reservationBody.docs.forEach((element) {
    if (element['favorite'] == true){
      count += 1;
    }});
      return count;
    }
       void decreaseCounter(){
          count-- ;
          notifyListeners();
       }
  addReservation(title, description, delivery, price, user_id, favorite, path) async{
    print('idddddd add reservation $id');
    reservation.doc(id).set({"title": title, "description": description, "delivery":delivery, "price": price, "user_id": user_id, "favorite": favorite, "id" : id, "pic" : path ,});
  }
  getReservationslength() async{
    final int documents = await reservation.snapshots().length;
    return documents;
  }
  favorite(reservation_id, bool favorite) async{
    reservation.doc(reservation_id).set({"favorite": favorite}, SetOptions(merge: true));
    if (favorite == false) {
      decreaseCounter();
    }
  }
listoffavorites()async{
  var list = [];
  var idx = 0;
  var reservationBody = await reservation.get();
reservationBody.docs.forEach((element) {
  if (element['favorite'] == true){
      list.add(idx);
      }
      idx = idx + 1;
      });
return list;
}
generate(id) {
  id = const Uuid().v4();
  return id;
}
//upload profile picture
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  Future<void> upload(filepath) async {
        print('iddddddddddddd $id');
    try {
      
    File file = File(filepath);
      await storage.ref().child('food').child('$id').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }
// get image
Future<String> downloadURLExample(id) async {
  try {
  String downloadURL = await storage.ref().child('food').child('$id').getDownloadURL();
    print('hahahahaahahahahahahah $downloadURL');
    return downloadURL;
}
catch (e) {
print(e);
return 'no';
}
}
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
}