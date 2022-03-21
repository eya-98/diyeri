import 'package:flutter/material.dart';
import 'package:diari/screens/editProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';
import '../providers/reservation_provider.dart';


class Home extends StatefulWidget  {
  @override
  MyAppBar createState() => MyAppBar();
}

class MyAppBar extends State <Home> {
  @override
  final _scaffoldKey = GlobalKey<ScaffoldState>(); 
  Widget build (BuildContext context) {
    Auth_provider auth = Provider.of<Auth_provider>(context);
    Reservation_provider reservation = Provider.of<Reservation_provider>(context);

   // var child;
    return Scaffold(
      key: _scaffoldKey,
      appBar: 
          AppBar (
        automaticallyImplyLeading: false,
        titleSpacing: 3.0,
        backgroundColor:  Colors.transparent,
        toolbarHeight: 100,
        elevation: 0,
        flexibleSpace: 
          Row(children: [
              const SizedBox(width: 24),
            IconButton(
              icon: const Icon(Icons.menu_open_outlined, color:Color(0xffffcc00), size: 40,),
              onPressed: () => _scaffoldKey.currentState!.openDrawer(),
            ),
            const SizedBox(width: 270),
            Column ( children: [
             const SizedBox(height: 28),
              Badge(
      position: BadgePosition.topEnd(top: 0, end: 3),
      animationDuration: const Duration(milliseconds: 300),
      animationType: BadgeAnimationType.scale,
      badgeContent: Text(
         reservation.count.toString(),
        style: const TextStyle(color: Colors.white),
      ),
      child: IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, color:Color(0xffffcc00), size: 40,),
              onPressed: () {
              },
            ),
              ),
              IconButton(
                icon: const Icon(Icons.add_box_outlined, color:Color(0xffffcc00), size: 40,),
                onPressed: () {}
              )
             ]
            ),
          ]
          )
        ),
    //),
    drawer: Drawer(
      child: ListView(
         children: <Widget> [
           const DrawerHeader(
             decoration: BoxDecoration(
               gradient: LinearGradient(colors: <Color>[
                 Colors.deepOrange,
                 Colors.orangeAccent,
               ]),
             ),
             child: Text('')),
           ListTile(
             leading: const Icon(Icons.home,),
             title: const Text('Home', style: TextStyle(fontSize: 18),),
             trailing: const Icon(Icons.arrow_right),
             onTap: () {},
           ),
           ListTile(
             leading: const Icon(Icons.person),
             title: const Text('My Profile', style: TextStyle(fontSize: 18),),
             trailing: const Icon(Icons.arrow_right),
             onTap: () {
               Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => EditProfile()),
  );
             },
           ),
           ListTile(
             leading: const Icon(Icons.settings),
             title: const Text('Settings', style: TextStyle(fontSize: 18),),
             trailing: const Icon(Icons.arrow_right),
             onTap: () {},
           ),
           ListTile(
             leading: const Icon(Icons.help_outline_outlined),
             title: const Text('Help', style: TextStyle(fontSize: 18),),
             trailing: const Icon(Icons.arrow_right),
             onTap: () {},
           ),
           ListTile(
            leading: const Icon(Icons.info_outlined),
            title: const Text('About Us', style: TextStyle(fontSize: 18),),
            trailing: const Icon(Icons.arrow_right),
            onTap: () {},
           ),
           ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout out', style: TextStyle(fontSize: 18),),
            trailing: const Icon(Icons.arrow_right),
            onTap: () {
              auth.SignOut();
          FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
              Navigator.push( context, MaterialPageRoute(builder: (context) => Login())
              );    } else {
          Navigator.push( context, MaterialPageRoute(builder: (context) => Login()));    }
        }); 
          },
           ),
         ],
      )),
      body:  Products(),
    );
  }
}
class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  
  final list_item = [
    {
      "name": "image 1",
      "pic": 'assets/ojja.jpg',
      "price": 15,
      "old_price": 20,
    },
    {
      "name": "image 2",
      "pic": 'assets/ojja.jpg',
      "price": 15,
      "old_price": 20,
    },
    {
      "name": "image 3",
      "pic": 'assets/ojja.jpg',
      "price": 15,
      "old_price": 20,
    },
    {
      "name": "image 4",
      "pic": 'assets/ojja.jpg',
      "price": 15,
      "old_price": 20,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: list_item.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Product(
            product_name: list_item[index]['name'],
            product_pic: list_item[index]['pic'],
            product_price: list_item[index]['price'],
            product_old_price: list_item[index]['old_price'],
          );
        });
  }
}

class Product extends StatelessWidget {
  
  final product_name;
  final product_pic;
  final product_price;
  final product_old_price;

  const Product(
      {this.product_name,
      this.product_pic,
      this.product_price,
      this.product_old_price});

  @override
  Widget build(BuildContext context) {
Reservation_provider reservation = Provider.of<Reservation_provider>(context);
return ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Card(
            child: Hero(
                tag: product_name,
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
                             trailing: IconButton(constraints: const BoxConstraints(), padding: EdgeInsets.zero, icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 25,), onPressed: () {
                            reservation.increaseCounter();
                            },),
                            onTap: () {
                              
                            },
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(product_pic,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit
                                      .cover), 
                            ),
                            title: Text(
                              "$product_price TND",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            //subtitle: Text( '\$$product_price', style: TextStyle(fontWeight:FontWeight.bold,
                            //decoration: TextDecoration.lineThrough, color: Colors.redAccent,fontSize: 15),),
                          ),
                        ),
                        child: InkWell(
                          onTap: () async {
          await showDialog(
            context: context,
            builder: (_) => imageDialog(product_pic, context));
        },
        
          //                   showPopover(
          //   context: context,
          //   bodyBuilder: (context) { return Container();},
          //   onPop: () => print('Popover was popped!'),
          // );
                        
                          child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15.0)),
                              child:
                                  Image.asset(product_pic, fit: BoxFit.cover)),
                        ),
                      )),
                ))));
  }
  
  }
  Widget imageDialog(image, context) {
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
              icon: Icon(Icons.close_rounded),
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
      const Padding(
        padding:  EdgeInsets.all(8.0), child:
      Text(
          'Add your plate name',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      const Padding(
        padding:  EdgeInsets.only(top: 12.0, left: 8, right: 8, bottom: 8), child: 
                Text(
          'Add your plate description',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ],
  ),
  )
);
  }
