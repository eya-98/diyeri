import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:diari/screens/home.dart';
class Reservation_provider with ChangeNotifier {
int count = 0;
int get counter{
      return count ; 
    }
  
    void increaseCounter(){
      count++ ;
      notifyListeners();
    }
  
     void decreaseCounter(){
        count-- ;
        notifyListeners();
     }
}