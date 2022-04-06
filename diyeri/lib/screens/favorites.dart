import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
 import 'package:diari/screens/home.dart';
import '../providers/reservation_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/auth_provider.dart';


class Favorites extends StatefulWidget {
  @override
createState() => heart();
}
class heart extends State<Favorites> {
  
  @override
  Widget build(BuildContext context) {
    Reservation_provider reservation = Provider.of<Reservation_provider>(context);
    return Scaffold(
      body: Column(
           mainAxisSize:MainAxisSize.max,
            children: [
          Row(
           children: [
             const SizedBox(width: 10,height: 80,),
             InkWell (child: Icon(
       Icons.arrow_back,
       color: Colors.orange[900],
       size: 34.0,
     ),
     onTap: () {
     Navigator.push(context, MaterialPageRoute(builder: (context) => Home()),
     );
     },
     ), 
     const SizedBox(height: 150, width: 35),
     
        Center (child: Text(
          'List of Favorites(${reservation.count})',
         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
         )
     ]
          ),Expanded( 
            child: favs() 
          )]
            )
    );
  }
}

    class favs extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<favs> {
  
  @override
  Widget build(BuildContext context) {
    Reservation_provider reservation = Provider.of<Reservation_provider>(context);
    return StreamBuilder(stream: FirebaseFirestore.instance.collection('reservation').snapshots(), 
    builder: (context, AsyncSnapshot snapshot){
    if (snapshot.hasData) {
      final reservationDocs = snapshot.data.docs;
      reservation.counter(reservation.count);
      {
        return FutureBuilder(future: reservation.listoffavorites(),
          builder: (context, AsyncSnapshot snapshot1){
        var length = snapshot1.data;
        //print(reservation.counter(reservation.count));
        //print(reservation.count);
        if (length != null && length?.length > 0) {
        return GridView.builder(
        itemCount: length.length,
    dragStartBehavior: DragStartBehavior.down,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, index) {
          return  favorite(
             product_delivery: reservationDocs[snapshot1.data[index]].data()['delivery'],
             product_name: reservationDocs[snapshot1.data[index]].data()['title'],
             product_pic: reservationDocs[snapshot1.data[index]].data()['pic'],
             product_price: reservationDocs[snapshot1.data[index]].data()['price'],
             product_description: reservationDocs[snapshot1.data[index]].data()['description'],
             product_favorite: reservationDocs[snapshot1.data[index]].data()['favorite'],
             userid: reservationDocs[snapshot1.data[index]].data()['user_id'],
             reservid: reservationDocs[snapshot1.data[index]].data()['id'],
          );
        }
        );
          }
          else {
            return Container();
          }
          }
        );
      }
    }
      else {
        return const SizedBox(height: 0, width: 0);
      }
  }
    );
  }
}
class favorite extends StatefulWidget {
  final product_name;
  final product_pic;
  final product_price;
  final product_delivery;
  final product_description;
  final userid;
  final reservid;
  bool product_favorite;
  favorite(
      {
      this.product_delivery,
      this.product_name,
      this.product_pic,
      this.product_price,
      this.product_description,
      this.product_favorite=false,
      this.userid, 
      this.reservid});

  @override
  State<favorite> createState() => _ProductState();
}

class _ProductState extends State<favorite> {
  @override
  Widget build(BuildContext context) {
Reservation_provider reservation = Provider.of<Reservation_provider>(context);
return FutureBuilder(future: reservation.downloadprofileimg(context, widget.userid), 
builder: (context, snapshot) {
if (snapshot.connectionState == ConnectionState.done && snapshot.data.toString().trim() != 'no') {
return ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Card(
                child: Material(
                  child: InkWell(
                      onTap: () {},
                      child: GridTile(
                        footer: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.black54,
                          ),
                          child: ListTile(
                             trailing: IconButton(constraints: const BoxConstraints(), padding: EdgeInsets.zero, 
                             icon: widget.product_favorite == false ? const Icon(Icons.favorite_border, color: Colors.white, size: 25,) : const Icon(Icons.favorite, color: Colors.white, size: 25,), 
                             onPressed: () async {
                              setState(() {
                                widget.product_favorite = !widget.product_favorite;
                              });
                              reservation.favorite(widget.reservid, widget.product_favorite);
                              
                            },),
                            onTap: () {
                            },
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(snapshot.data.toString(),
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit
                                      .cover), 
                            ),
                            title: Text(
                              "${widget.product_price} TND",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        child: InkWell(
                          onTap: () async {
          await showDialog(
            context: context,
            builder: (_) => imageDialog(widget.product_pic ,context, widget.product_delivery, widget.product_price, widget.product_description, widget.product_name, widget.userid));
        },
              child: ClipRRect(
                  borderRadius:
                  const BorderRadius.all(Radius.circular(15.0)),
                  child: Image.network(widget.product_pic, fit: BoxFit.cover)),
                        ),
                      )),
                )));
  }
  
  else {
    return Center(child: CircularProgressIndicator(color: Colors.red,), );
  }
});
  }
}
  Widget imageDialog(image, context, delivery, price, description, title, userid) {

return Dialog(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  child: SingleChildScrollView (child:Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
              Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close_rounded),
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
      SizedBox(
        width: 220,
        height: 226,
        child: Image.network(image,
          fit: BoxFit.cover,
        ),
      ),
      Row(children: [
        Column( children: [
          Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 8, right: 8, bottom: 8), 
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
       Container(
         width: 180,
        padding: const EdgeInsets.only( left: 10, bottom: 8), child: 
                 Text(description,
          style: const TextStyle(fontWeight: FontWeight.w300),
        ),
      ),
        ]),
        Column(
          children : [Container( margin: const EdgeInsets.only(left: 38, bottom: 5, top: 5), 
          child: delivery.toString().trim() == 'yes'.trim() ?
                const Text(
          '* Delivery',
          style: TextStyle(fontWeight: FontWeight.bold),
        ) : 
        Container(height: 0), 
      ),
        Container(
          margin: const EdgeInsets.only(left: 50),
          height: 30, width: 70,  decoration: BoxDecoration(
    border: Border.all(color: Colors.red)
  ),
          child: Center(child: Text("$price TND")),
        ),
        Container( 
          margin: delivery == 'yes' ? const EdgeInsets.only(left: 30, top: 2): const EdgeInsets.only(left: 30, top: 6), 
          child: Row(children : [
           //Icon(Icons.phone), 
            FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
  future: FirebaseFirestore.instance.collection('user').doc(userid).get(),
  builder: (_, snapshot) {
    if (snapshot.hasData) {
      var data = snapshot.data!.data();
      var value = data?['Phone']; // <-- Your value
      return Row (children: [
        const SizedBox(height: 5),
        const Icon(Icons.phone),
        Text('$value')
      ]);
    }

    return Container();
  },
) 
        ])
        )
        ]
        )
    ],
  ),
    ]
  )
  )
);
  }
