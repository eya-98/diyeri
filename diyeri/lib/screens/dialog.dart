import 'package:flutter/material.dart';
 import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
// import 'package:badges/badges.dart';
import '../providers/reservation_provider.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'favorites.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';


class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
    var path;
    @override
  void initState() {
    super.initState();
  }

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
             productDelivery: reservationDocs[index].data()['delivery'],
             productName: reservationDocs[index].data()['title'],
             productPic: reservationDocs[index].data()['pic'],
             productPrice: reservationDocs[index].data()['price'],
             productDescription: reservationDocs[index].data()['description'],
             productFavorite: reservationDocs[index].data()['favorite'],
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
  final productName;
  final productPic;
  final productPrice;
  final productDelivery;
  final productDescription;
  final userid;
  final reservid;
  bool productFavorite;
  Product(
      {
      this.productDelivery,
      this.productName,
      this.productPic,
      this.productPrice,
      this.productDescription,
      this.productFavorite=false,
      this.userid, 
      this.reservid});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  var favorite;
  Future <IconData> iconfav (userid, reservid)async{
    Reservation_provider reservation = Provider.of<Reservation_provider>(context);
      bool exist = await reservation.favexist(userid, reservid);
    if ( exist == true ) {
       return Icons.favorite;
}
      else {
      return Icons.favorite_border_outlined;
                  }
                  }
  @override
  Widget build(BuildContext context) {
  bool refresh = false;
Auth_provider auth = Provider.of<Auth_provider>(context);
Reservation_provider reservation = Provider.of<Reservation_provider>(context);
return FutureBuilder(future: reservation.downloadprofileimg(context, widget.userid), 
builder: (context, snapshot) {
if (snapshot.connectionState == ConnectionState.done) { 
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
                             icon: StreamBuilder(stream: Stream.fromFuture(iconfav(auth.currentUser.uid, widget.reservid)), builder: ((context, AsyncSnapshot snapshot){
                               return Icon(snapshot.data, color: Colors.white,);
                             })),
  onPressed: () async {
    print("eeeeee ${widget.reservid}");
         if (await reservation.favexist(auth.currentUser.uid, widget.reservid) == true) {
            await reservation.deleteFav(auth.currentUser.uid, widget.reservid);
           }
           else {
             await reservation.addFav(auth.currentUser.uid, widget.reservid);
           }    
          setState(() {
            refresh = !refresh;
    });
            },), onTap: () {},
               leading: GestureDetector(child: ClipRRect(
                      borderRadius: snapshot.data.toString().trim() != 'no' ? BorderRadius.circular(20): BorderRadius.circular(30),
                      child:  snapshot.data.toString().trim() != 'no' ? Image.network(snapshot.data.toString(),
                        width: 40, height: 40, fit: BoxFit.cover): Image.asset('assets/unknown.jpg', fit: BoxFit.cover, width: 40, height: 40), 
                            ),
                            onTap: ()async{
                              await showDialog(
            context: context,
            builder: (_) => profileimg(snapshot.data.toString(), context));
        },
                            ),
                            title: Text(
                              "${widget.productPrice} TND",
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
            builder: (_) => imageDialog(widget.productPic ,context, widget.productDelivery, widget.productPrice, widget.productDescription, widget.productName, widget.userid));
        },
              child: ClipRRect(
                  borderRadius:
                  const BorderRadius.all(Radius.circular(15.0)),
                  child: Image.network(widget.productPic, fit: BoxFit.cover)),
                        ),
                      )),
                )));
  }
  
  else {
    return const Center(child: CircularProgressIndicator(color: Colors.red,), );
  }
});
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
            FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
  future: FirebaseFirestore.instance.collection('user').doc(userid).get(),
  builder: (_, snapshot) {
    if (snapshot.hasData) {
      var data = snapshot.data!.data();
      var value = data?['Phone']; // <-- Your value
      return Row (children: [
        const SizedBox(height: 5),
        const Icon(Icons.phone),
         GestureDetector (child : Text('$value'),
        onTap: () async {
          bool? res = await FlutterPhoneDirectCaller.callNumber('$value');
        },)
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
  Widget profileimg(image, context) {
 return Dialog(
   backgroundColor: Colors.transparent,
  child: SizedBox(height: 350, width: 350,child:  ClipRRect(
                              borderRadius: BorderRadius.circular(100),
    //backgroundColor: Colors.transparent, 
    child: 
  Image.network(image,
      fit: BoxFit.fill,
      width: 80,
      height: 80,
    ),
  )));
}