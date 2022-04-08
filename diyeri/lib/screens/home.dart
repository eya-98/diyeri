import 'package:flutter/material.dart';
import 'package:diari/screens/editProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../providers/reservation_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'favorites.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'About.dart';

class Home extends StatefulWidget  {
  const Home({Key? key}) : super(key: key);
  @override
  MyAppBar createState() => MyAppBar();
}
enum AppState {
  free,
  picked,
  cropped,
}
class MyAppBar extends State <Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>(); 
  var _image;
  late AppState state;
  //var imagePicker;
  var _file;
  var _sample;
  var _lastCropped;
  var path;
@override
  void initState() {
    super.initState();
    state = AppState.free;
    print('staaaaaaaaate $state');
  }
  @override
  Widget build (BuildContext context) {
    Auth_provider auth = Provider.of<Auth_provider>(context);
    Reservation_provider reservation = Provider.of<Reservation_provider>(context);
    GlobalKey<FormState> formstate =  GlobalKey<FormState>(); 
    TextEditingController title =  TextEditingController();
    TextEditingController description =  TextEditingController();
    //TextEditingController id =  TextEditingController();
    TextEditingController price =  TextEditingController();
    bool favorite =  false;
    String dropdownvalue = 'no';   
    var items = [    
    'yes', 'no'
  ];
    send(){
  var formdata = formstate.currentState;
  if (formdata!.validate()) {
    formdata.save();
  }
  else {
    print("not valid");
  }
}
Future<Null> _cropImage() async {
    File? croppedFile = await ImageCropper().cropImage(
        //cropStyle: CropStyle.circle,
        sourcePath: path,
         aspectRatioPresets: Platform.isAndroid
             ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {
        path = _image!.path;
        state = AppState.cropped;
      });
    }
  }
  _getFromGallery() async {
        XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery, maxHeight: 1080, maxWidth: 1080);
        setState(() {
          path = image!.path;
          state = AppState.picked;
        _image = File(path);
        });
        
        if (state == AppState.picked) {
            _cropImage();
          }
}
  void _clearImage() {
    path = null;
  setState(() {
  state = AppState.free;
}
);
  }
addDialog(context){
return Dialog(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  child: SingleChildScrollView (
    physics:  const BouncingScrollPhysics(),
    reverse: true,
    child:Column(
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
           height: 500,
          child: Form (
        autovalidateMode: AutovalidateMode.always,
        key: formstate,
        child: SingleChildScrollView(child: Column(children: [
          const SizedBox(child: Center(child: Text('Add a Plate', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),),
          Container(
          margin: const EdgeInsets.only(top: 10),
          width: 300,
          child: TextFormField(
             validator: (text){
               if (text!.isEmpty) {
                return "Please insert a title to your plate";
              }
               return null;
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
          margin: const EdgeInsets.only(top: 10),
          width: 300,
          child: TextFormField(
            maxLines: 5,
            minLines: 1,
             validator: (text){ 
               if (text!.isEmpty) {
                  return "Please insert a description";
                }
               return null;
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
          margin: const EdgeInsets.only(top: 10),
          width: 300,
          child: DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: true,
          child: DropdownButtonFormField(
              decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), topRight: Radius.circular(15.0),),
           ),
        labelText: 'Delivery',
        labelStyle: TextStyle( color: Colors.red, fontSize: 20),
        hintText: 'Delivery',
        hintStyle: TextStyle(height:2, fontSize: 14),

      ),
              icon: const Icon(Icons.keyboard_arrow_down),    
              value: dropdownvalue,
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: SizedBox(child: Text(items), width: 50,)
                );
              }).toList(),
              onChanged: (String? newValue) { 
                setState(() {
                  dropdownvalue = newValue!;
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
  child:  state == AppState.cropped || state == AppState.picked ? const ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    child: Center(child: Icon(Icons.add_a_photo)),
        ):  ClipRRect(
    borderRadius: const BorderRadius.all(Radius.circular(12)),
    child: Center(child: Icon(Icons.add), ),
  )
        ),
        ),
        onTap: () async{
        if (state == AppState.free) {
            _getFromGallery();
        }
        if (state == AppState.cropped) {
           _clearImage();
        }
        print('heeeeeeeeeeeeeeeeeedhiiiiiiii $_image');
      },
        ),
        Container (
          margin: const EdgeInsets.only(top: 10),
          width: 300,
          child: TextFormField(
             validator: (text){ 
               if (text!.isEmpty || text is int) {
               return "please enter a valid price ";
             }
               return null;
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
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.go,
          controller: price,
        ),
        ),
        const SizedBox(height: 25),
        GestureDetector(child: ClipRRect(
    borderRadius: const BorderRadius.all(Radius.circular(25)),
    child:Container(
          width: 200,
          height: 30,
decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(50),
    border: Border.all(color: Colors.red)
  ),          //color: Colors.orange[900],
          child: const Center(child: Text('Publish', style: TextStyle(fontWeight: FontWeight.bold),)),
        )
  ),
        onTap: ()  async{
          send();
          if (title.text.isNotEmpty && description.text.isNotEmpty && price.text.isNotEmpty)
          {
          setState(() {
            reservation.id = reservation.generate(reservation.id);
          });
          await reservation.upload(path);
          path = await reservation.downloadURLExample(reservation.id);
          if (title.text.isNotEmpty && description.text.isNotEmpty && price.text.isNotEmpty && path != 'no') {
          reservation.addReservation(title.text.trim(), description.text.trim(), dropdownvalue.trim(), price.text.trim(), auth.ID, favorite, path);
        Navigator.of(context).pop();
          }
          setState(() {
            _image = null;
            path = null;
          });
           }
        },
        ),
        const SizedBox(height: 20),
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
              onPressed: () async{
                var length = await reservation.listoffavorites();
                if (length != null) {
                  reservation.count = length.length;
                }
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
             onTap: () async{
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
            onTap: () {
                            Navigator.push( context, MaterialPageRoute(builder: (context) => Login())
              );
            },
           ),
           ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout out', style: TextStyle(fontSize: 18),),
            trailing: const Icon(Icons.arrow_right),
            onTap: () async{
              auth.SignOut();
          FirebaseAuth.instance.authStateChanges().listen((User? user) {
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
      body: const Products(),
    );
  }
}