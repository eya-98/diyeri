import 'package:flutter/material.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  @override
createState() => TheSignUp();
}
class TheSignUp extends State<SignUp> {
    bool Obscure = true;
    GlobalKey<FormState> formstate =  GlobalKey<FormState>();
    TextEditingController email =  TextEditingController();
    TextEditingController pwd =  TextEditingController();
    TextEditingController phone =  TextEditingController();
    TextEditingController adress =  TextEditingController();
    TextEditingController fullname =  TextEditingController();
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
void dispose() {
  email.dispose();
  pwd.dispose();
 // fullname.dispose();
  phone.dispose();
  adress.dispose();
    super.dispose();}

  Widget build(BuildContext context) {
      Auth_provider auth = Provider.of<Auth_provider>(context);
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
                      Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Login()),
  );
                      },),]),
          const SizedBox(height: 20),
      const Center(child: Text('Welcome', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30))),
                const SizedBox(height: 15),
       Image.asset('assets/logo.png', cacheHeight: 180,),
                const SizedBox(height: 30),

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
            obscureText: Obscure, 
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
           decoration: InputDecoration(
           focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
    ),
    borderSide: BorderSide(color: Color(0xffffaa00)),
  ),
          hintText: "Enter your password",
          hintStyle: const TextStyle(fontSize: 14),
          prefixIcon: const Icon(Icons.lock, color: Color(0xffffaa00)),
          suffixIcon: InkWell(
            child: const Icon(Icons.visibility,
            color: Color(0xffffaa00),
            ),
            onTap: () {
              setState(() {
                Obscure = !Obscure;
            });
            },
        ),
          ),
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
          height: 33, width: 150, child: const Center(child: Text('Sign Up', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),), 
        onTap: ()async {
          send;
           await auth.SignUp(email.text.trim(), pwd.text.trim(), adress.text.trim(), phone.text.trim(), fullname.text.trim());
          await FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      var snackBar = const SnackBar(
  content: Text("Please verify your Credential"),
);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    print('no user is signed up');
             }
    else {
      print('user is logged in');
Navigator.push( context, MaterialPageRoute(builder: (context) => Login()));}
             }
  ); 
          }
        
        ),
        ]
        )
      )
    );
  }}