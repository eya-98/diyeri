import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'signup.dart';


class Login extends StatefulWidget {
  @override
createState() => Thelogin();
}
class Thelogin extends State<Login> {

  Widget build(BuildContext context) {
    Auth_provider auth = Provider.of<Auth_provider>(context);
    bool isChecked = false;
    GlobalKey<FormState> formstate =  GlobalKey<FormState>();
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
    TextEditingController email =  TextEditingController();
    TextEditingController pwd =  TextEditingController();
    return Scaffold(
body: SingleChildScrollView(
child: Column(
  children: [
    //images
  Container(
        width: double.infinity, height: 250,
        decoration: const BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))), 
        child: ClipRRect( borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)), child: ImageSlideshow(
          indicatorColor: Colors.yellow[200],
          children: [Image.asset(
              'assets/ojja.jpg',
              fit: BoxFit.cover,
            ),
            Image.asset(
              'assets/Tunisian-lablebi.jpeg',
              fit: BoxFit.cover,
            ),
            Image.asset(
              'assets/frecasse.jpg',
              fit: BoxFit.cover,
            ),], autoPlayInterval: 3000, isLoop: true,)),),
            //forms
            Container( 
          margin: const EdgeInsets.only(top: 50),
          child: Form (
        autovalidateMode: AutovalidateMode.always,
        key: formstate,
        child: Column(children: [
          SizedBox(
          width: 370,
          child: TextFormField(
            validator: (text){ 
              if (text!.isEmpty || text == null) {
                return "email is empty";
              }
              if (!text.contains('@') || !text.contains('.')) {
                return "incorrect email";
              }
              return null;
            },
          decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), topRight: Radius.circular(15.0),),
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
              if (text!.isEmpty) {
                return "password is empty";
              }
              if (text.length < 6) {
                return "incorrect password";
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
          prefixIcon: Icon(Icons.lock, color: Color(0xffffaa00) ),
          ),
          obscureText: true,
          textInputAction: TextInputAction.go,
          controller: pwd,
          ),)])
        )
        ),
           const SizedBox(height: 25.0,),
               Row( children : [
       Checkbox( value: isChecked,  
       onChanged: (value) {
             },
       ),
       const Text('Remember me'),
       ]
       ),
       const SizedBox(height: 25.0,),
        Row (
        children: [
        InkWell(
        child: Container(
          margin: const EdgeInsets.only(left: 80),
          decoration: BoxDecoration(color: Colors.transparent, borderRadius: const BorderRadius.all(Radius.circular(30)), border: Border.all(color: const Color(0xffffaa00), width: 1.2)), 
          height: 33, width: 250, child: const Center(child: Text('Login', style: TextStyle(fontSize: 12))),), 
        onTap: (){
          send;
          auth.Login(email.text.trim(), pwd.text.trim());
          FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
     // print(auth.error); {
      var snackBar = SnackBar(
  content: Text(auth.error),
);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
     else {
      var snackBar = SnackBar(
  content: Text('Succesfully Login'),
);
 ScaffoldMessenger.of(context).showSnackBar(snackBar);
Navigator.push( context, MaterialPageRoute(builder: (context) => Home()));
}
  }); 
      }
        ),
        ]),
        const SizedBox(height: 50.0,),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't Have Any Account?"),
                  GestureDetector(
                    child: const Text(
                      " Register Now", style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xffff6600)),
                    ),
                    onTap: () {
                      Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SignUp()),
  );
                      },
                      
                  )
                ],
              ),
            )
])
    ));}}