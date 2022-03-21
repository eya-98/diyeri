import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:badges/badges.dart';
import 'dart:async';

class EditProfile extends StatefulWidget {
  @override
createState() => TheEdit();
}
class TheEdit extends State<EditProfile> {
  Widget build(BuildContext context) {
      Auth_provider auth = Provider.of<Auth_provider>(context);
    GlobalKey<FormState> formstate =  GlobalKey<FormState>();
    TextEditingController email =  TextEditingController();
    TextEditingController pwd =  TextEditingController();
    TextEditingController phone =  TextEditingController();
    TextEditingController adress =  TextEditingController();
    TextEditingController fullname =  TextEditingController();
    var imageFile;
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
//// get from Gallerie
  _getFromGallery() async {
    var pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
    );
    if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
    }
}
    return Scaffold(
      body: SingleChildScrollView(
        child:Column( children: [
       const SizedBox(height: 50),
          Row(
          children: [
            const SizedBox(width: 10,),
            InkWell (child: Icon(
      Icons.arrow_back,
      color: Colors.orange[900],
      size: 34.0,
    ),
    onTap: () {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()),
  );
                      },),]),
          const SizedBox(height: 20),
      const Center(child: Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30))),
                const SizedBox(height: 30),
Container(
  height: 150,
  width: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        shape: BoxShape.circle,
      ),
      child: imageFile == null
                ? Badge(
      position: BadgePosition.bottomEnd(bottom: 0, end: 3),
      badgeContent: GestureDetector(child: 
      const Icon(Icons.camera_alt_outlined, size: 30,), onTap: (){
        _getFromGallery();
      },), child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
              alignment: Alignment.center,
              child: Image.asset('assets/unknown.jpg'),
            ),
              ),
            ): Container(
              child: Image.file(
                imageFile,
                fit: BoxFit.cover,
              ),
 ),
),
    const SizedBox(height: 50),
      Form (
        autovalidateMode: AutovalidateMode.always,
        key: formstate,
        child: Column(children: [ 
          SizedBox(
          width: 370, child: TextFormField(
          decoration: const InputDecoration(
            focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
    ),
    borderSide: BorderSide(color: Color(0xffffaa00)),
  ),
            hintText: "Enter your fullname",
            hintStyle: TextStyle(fontSize: 14),
          prefixIcon: Icon(Icons.person, color: Color(0xffffaa00)),
          ),
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          controller: fullname,
        ),
        ),
          const SizedBox(height: 25.0,),
          SizedBox(
          width: 370, child: TextFormField(
            validator: (text){ 
              if (text!.isEmpty || !text.contains('@') || !text.contains('.')) {
                return "Please enter a valid email";
              }
              return null;
            },
          decoration: const InputDecoration(
            focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
    ),
    borderSide: BorderSide(color: Color(0xffffaa00)),
  ),
            hintText: "Enter your email",
            hintStyle: TextStyle(fontSize: 14),
          prefixIcon: Icon(Icons.mail, color: Color(0xffffaa00)),
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          controller: email,
        ),
        ),
      const SizedBox(height: 25.0,),
      SizedBox(
          width: 370,
         child: TextFormField(
            validator: (text){ 
              RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])');
              if (text!.isEmpty || text.length < 8) {
                return "Please enter a valid password over 8 characters";
              }
              if (!regex.hasMatch(text)){
              // || !text.contains(RegExp("r'[A-Z]+").toString()) || !text.contains(RegExp("r'[1-9]+").toString())) {
                return "Password should contains  at least one upper case, one lower case and one digit ";
              }
              return null;
            },
           decoration: const InputDecoration(
           focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
    ),
    borderSide: BorderSide(color: Color(0xffffaa00)),
  ),
          hintText: "Enter your password",
          hintStyle: TextStyle(fontSize: 14),
          prefixIcon: Icon(Icons.lock, color: Color(0xffffaa00)),
          ),
          obscureText: true,
          textInputAction: TextInputAction.next,
          controller: pwd,
          ),
      ),
          const SizedBox(height: 25.0,),
          SizedBox(
          width: 370, child:
         TextFormField(
            validator: (text){ 
              if (text!.isEmpty || text.length < 3) {
                return "Please enter a valid adress";
              }
              return null;
            },
           decoration: const InputDecoration(
           focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
    ),
    borderSide: BorderSide(color: Color(0xffffaa00)),
  ),
          hintText: "Enter your adress",
          hintStyle: TextStyle(fontSize: 14),
          prefixIcon: Icon(Icons.home, color: Color(0xffffaa00)),
          ),
          obscureText: true,
          textInputAction: TextInputAction.next,
          controller: adress,
          ),
          ),
          const SizedBox(height: 25.0,),
         SizedBox(
          width: 370,
          child: TextFormField(
           validator: (text){ 
            if (text!.isEmpty || text.length < 8) {
                return "Please enter a valid number";
              }
              return null;
            },
          decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(15.0),
      topRight: Radius.circular(15.0),
    ),
    borderSide: BorderSide(color: Color(0xffffaa00)),

  ),
            hintText: "Enter your phone",
            hintStyle: TextStyle(fontSize: 14),
          prefixIcon: Icon(Icons.phone, color: Color(0xffffaa00)),
          ),
          keyboardType: TextInputType.phone,

          obscureText: true,
          textInputAction: TextInputAction.go,
          controller: phone,
          )
         ),
          ])
        ),
        const SizedBox(height: 50),
        InkWell(
        child: Container(
          decoration: BoxDecoration(color: Colors.transparent, borderRadius: const BorderRadius.all(Radius.circular(30)), border: Border.all(color: const Color(0xffffaa00), width: 1.2)), 
          height: 33, width: 150, child: const Center(child: Text('Sign Up', style: TextStyle(fontSize: 12))),), 
        onTap: (){
          send;
Navigator.push( context, MaterialPageRoute(builder: (context) => Home()));}
        ),
        ]
        )
      )
    );
  }}
