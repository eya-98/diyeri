import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
class Reservation_provider with ChangeNotifier {
int count = 0;
var id = const Uuid().v4();
CollectionReference reservation = FirebaseFirestore.instance.collection("reservation");
    counter() async{
      var reservationBody = await reservation.get();
      reservationBody.docs.forEach((element) {
    if (element['favorite'] == true){
      count += 1;
    }});
    print('Cooooooooooooooount $count');
      return int.parse(count.toString());

    }
    
    void increaseCounter(){
      count++ ;
      notifyListeners();
    }
     void decreaseCounter(){
        count-- ;
        notifyListeners();
     }

  addReservation(title, description, delivery, price, user_id, favorite){
        reservation.doc(id).set({"title": title, "description": description, "delivery":delivery, "price": price, "user_id": user_id, "favorite": favorite, "id" : id, "pic" : "assets/ojja.jpg"});
  }
  getReservationslength() async{
    final int documents = await reservation.snapshots().length;
    return documents;
  }
  favorite(reservation_id, bool favorite) async{
    reservation.doc(reservation_id).set({"favorite": favorite}, SetOptions(merge: true));
    if (favorite == true) {
      increaseCounter();
    }
    else {
      decreaseCounter();
    }
  }

}
