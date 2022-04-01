import 'package:flutter/material.dart';
import 'package:diari/screens/editProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';
import '../providers/reservation_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'favorites.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


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
    GlobalKey<FormState> formstate =  GlobalKey<FormState>(); 
    TextEditingController title =  TextEditingController();
    TextEditingController description =  TextEditingController();
    TextEditingController id =  TextEditingController();
    TextEditingController price =  TextEditingController();
    bool favorite =  false;
    String dropdownvalue = 'no';   
    var items = [    
    'yes', 'no'
  ];
    send(){
  var formdata = formstate.currentState;
  if (formdata!.validate()) {
    print("valid");
    formdata.save();
  }
  else {
    print("not valid");
  }
}
addDialog(context){
return Dialog(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  child: SingleChildScrollView (child:Column(
    // mainAxisSize: MainAxisSize.min,
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
         Container(
           height: 500,
          child: Form (
        autovalidateMode: AutovalidateMode.always,
        key: formstate,
        child: SingleChildScrollView(child: Column(children: [
          //SizedBox(height: 20, child: Text('Plate title'),),
          SizedBox(child: Center(child: Text('Add a Plate', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),),
          Container(
          margin: const EdgeInsets.only(top: 10),
          width: 300,
          child: TextFormField(
             validator: (text){
               if (text!.isEmpty) {
                return "Please insert a title to your plate";
              }
             },
          decoration: const InputDecoration(
           focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), topRight: Radius.circular(15.0),),
           // borderSide: BorderSide(color: Color(0xffffaa00)),
           ),
          labelText: "Title", 
          labelStyle: TextStyle( color: Colors.red, fontSize: 20),
            hintText: "Add your plate title ",
            hintStyle: TextStyle(height:2, fontSize: 14),
            floatingLabelBehavior: FloatingLabelBehavior.always 
          ),
          textInputAction: TextInputAction.next,
          controller: title,
        ),
        ),
        Container (
          margin: EdgeInsets.only(top: 10),
          width: 300,
          child: TextFormField(
            maxLines: 5,
            minLines: 1,
             validator: (text){ 
               if (text!.isEmpty) {
                  return "Please insert a description";
                }
             },
          decoration: const InputDecoration(
           focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), topRight: Radius.circular(15.0),),

           ),
          labelText: "Description", 
          labelStyle: TextStyle( color: Colors.red, fontSize: 20),
            hintText: "Add your Description",
            hintStyle: TextStyle(height:2, fontSize: 14),
            floatingLabelBehavior: FloatingLabelBehavior.always 
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          controller: description,
        )
        ),Container (
          margin: EdgeInsets.only(top: 10),
          width: 300,
          child: DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: true,
          child: DropdownButtonFormField(
              decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), topRight: Radius.circular(15.0),),
           // borderSide: BorderSide(color: Color(0xffffaa00)),
           ),
        labelText: 'Delivery',
        labelStyle: TextStyle( color: Colors.red, fontSize: 20),
        hintText: 'Delivery',
        hintStyle: TextStyle(height:2, fontSize: 14),

      ),
              // Initial Value
              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),    
              value: dropdownvalue,
              // Array list of items
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Container(child: Text(items), width: 50,)
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) { 
                setState(() {
                  dropdownvalue = newValue!;
                  print(dropdownvalue);
                });
              },
            ),
      ),
          )),
        GestureDetector(child: Container(
          margin: const EdgeInsets.only(top: 25),
          width: 250,
          height: 100,
          child: DottedBorder(
  borderType: BorderType.RRect,
  radius: const Radius.circular(12),
  child: const ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    child: Center(child: Icon(Icons.add_a_photo)),
        )
  )
        ),
        onTap: () {
          print('tapped (add photo)');
        },
        ),
        Container (
          margin: EdgeInsets.only(top: 10),
          width: 300,
          child: TextFormField(
             validator: (text){ 
               print("priiiice");
               print(text is int);
               if (text!.isEmpty || text is int) {
               return "please enter a valid price ";
             }
             },
          decoration: const InputDecoration(
           focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), topRight: Radius.circular(15.0),),
           ),
          labelText: "Price", 
          labelStyle: TextStyle( color: Colors.red, fontSize: 20),
            hintText: "Add your price",
            hintStyle: TextStyle(height:2, fontSize: 14),
            floatingLabelBehavior: FloatingLabelBehavior.always 
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.go,
          controller: price,
        ),
        ),
        SizedBox(height: 25),
        GestureDetector(child: ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(25)),
    child:Container(
          width: 200,
          height: 30,
decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(50),
    border: Border.all(color: Colors.red)
  ),          //color: Colors.orange[900],
          child: Center(child: Text('Publish', style: TextStyle(fontWeight: FontWeight.bold),)),
        )
  ),
        onTap: () {
          send();
          reservation.addReservation(title.text.trim(), description.text.trim(), dropdownvalue.trim(), price.text.trim(), auth.ID, favorite);
        Navigator.of(context).pop();
        },
        ),
        SizedBox(height: 100),
        ]
         )
         )
  ),
  )
    ])));
  
}
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
             const SizedBox(height: 28), IconButton(
              icon: const Icon(Icons.favorite_border, color:Color(0xffffcc00), size: 40,),
              onPressed: () {
                Navigator.push(context,
          MaterialPageRoute(builder: (context) => Favorites()),
              );
                },
            ),
              IconButton(
                icon: const Icon(Icons.add_box_outlined, color:Color(0xffffcc00), size: 40,),
                onPressed: () async {
                            await showDialog(
            context: context,
            builder: (_) => addDialog(context));
        },
              
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
            DrawerHeader(
             child: Image.asset('assets/logo2.png')),
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
            onTap: () async{
              auth.SignOut();
          await FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
            var snackBar = const SnackBar(
            content: Text('Succesfully Logout'),);
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.push( context, MaterialPageRoute(builder: (context) => Login())
              );} 
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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseFirestore.instance.collection('reservation').snapshots(), 
    builder: (context, AsyncSnapshot snapshot){
    if (snapshot.hasData) {
      final reservationDocs = snapshot.data.docs;
        //print(reservationDocs[1].data()['title']);
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
        return Text("");
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
            child: Hero(
                tag: widget.product_name,
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
                ))));
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
