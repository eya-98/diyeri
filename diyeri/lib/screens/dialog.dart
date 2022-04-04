import 'package:flutter/material.dart';
import 'package:diari/screens/editProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
// import 'package:badges/badges.dart';
import '../providers/reservation_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'favorites.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseFirestore.instance.collection('reservation').snapshots(), 
    builder: (context, AsyncSnapshot snapshot){
    if (snapshot.hasData) {
      final reservationDocs = snapshot.data.docs;
     if (reservationDocs.length > 0)
      {return GridView.builder(
        itemCount: reservationDocs.length,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
           return Product(
             product_delivery: reservationDocs[index].data()['delivery'],
             product_name: reservationDocs[index].data()['title'],
             product_pic: reservationDocs[index].data()['pic'],
             product_price: reservationDocs[index].data()['price'],
             product_description: reservationDocs[index].data()['description'],
             product_favorite: reservationDocs[index].data()['favorite'],
             userid: reservationDocs[index].data()['user_id'],
             reservid: reservationDocs[index].data()['id'],
           );
        }
        );
      }
      }
      else {
        return const Text("");
      }
    if (snapshot.hasError) {
      return const Text('Error');
    }
    if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.red,), );
    }
    return Container();
  }
    );
  }
}

class Product extends StatefulWidget {
  final product_name;
  final product_pic;
  final product_price;
  final product_delivery;
  final product_description;
  final userid;
  final reservid;
  bool product_favorite;
  Product(
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
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  @override
  Widget build(BuildContext context) {
Reservation_provider reservation = Provider.of<Reservation_provider>(context);
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
                              child: Image.asset(widget.product_pic,
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
                  child: Image.asset(widget.product_pic, fit: BoxFit.cover)),
                        ),
                      )),
                )));
  }
}
  Widget imageDialog(image, context, delivery, price, description, title, userid) {
return Dialog(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  child: SingleChildScrollView (
    child:Column(
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
        child: Image.asset(image,
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