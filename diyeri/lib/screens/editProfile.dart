import 'package:flutter/material.dart';
import 'home.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image_crop/image_crop.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:badges/badges.dart';

// import 'dart:async';
class EditProfile extends StatefulWidget {
  @override
  createState() => TheEdit();
}

enum AppState {
  free,
  picked,
  cropped,
}

class TheEdit extends State<EditProfile> {
  bool pic = false;
  var _image = null;
  late AppState state;
  final cropKey = GlobalKey<CropState>();
  var _file;
  
  var path;
  var _sample;
  var _lastCropped;
  String userpic = '';
  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }
  Widget build(BuildContext context) {
    Auth_provider auth = Provider.of<Auth_provider>(context);

  
  Future<String>_getImage(BuildContext context)async{
    var link = await auth.downloadURLExample();
    return link;
  }


    GlobalKey<FormState> formstate = GlobalKey<FormState>();
    TextEditingController email = TextEditingController();
    TextEditingController pwd = TextEditingController();
    TextEditingController phone = TextEditingController();
    TextEditingController adress = TextEditingController();
    TextEditingController fullname = TextEditingController();
    @override
//// crop image
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
          state = AppState.cropped;
        });
      }
    }

    _getFromGallery() async {
      XFile? image = await ImagePicker().pickImage(
          source: ImageSource.gallery, maxHeight: 1080, maxWidth: 1080);
      setState(() {
        path = image?.path;
        state = AppState.picked;
        _image = path == null ? null : File(path);
      });
      if (state == AppState.picked) {
        _cropImage();
      }
    }
    void _clearImage() {
      path = null;
      setState(() {
        state = AppState.free;
      });
    }

    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      const SizedBox(height: 50),
      Row(children: [
        const SizedBox(
          width: 10,
        ),
        InkWell(
          child: Icon(
            Icons.arrow_back,
            color: Colors.orange[900],
            size: 34.0,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          },
        ),
      ]),
      const SizedBox(height: 20),
      const Center(
          child: Text('Edit Profile',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30))),
      const SizedBox(height: 30),
      Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          shape: BoxShape.circle,
        ),
        child: _image == null
            ? Badge(
                position: BadgePosition.bottomEnd(bottom: 0, end: 3),
                badgeContent: GestureDetector(
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    size: 30,
                  ),
                  onTap: () async {
                    if (state == AppState.free) {
                      _getFromGallery();
                    }
                    if (state == AppState.cropped) {
                      _clearImage();
                    }
                  },
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    alignment: Alignment.center,
                    child: FutureBuilder(future: _getImage(context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.data.toString().trim() != 'no') {
                          return Image.network(snapshot.data.toString(), height: 150, width: 150, fit: BoxFit.fill,);
                        }
                      else {
                        print(snapshot.data);
                    return Image.asset('assets/unknown.jpg');
                      }
                    }
                    ),
                  ),
                ),
              )
            : Badge(
                position: BadgePosition.bottomEnd(bottom: 0, end: 3),
                badgeContent: GestureDetector(
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    size: 30,
                  ),
                  onTap: () async {
                    if (state == AppState.cropped) {
                      _clearImage();
                    }
                    if (state == AppState.free) {
                      _getFromGallery();
                    }
                  },
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.file(
                    _image,
                    height: 150,
                    width: 150,
                    fit: BoxFit.fill,
                  ),
                )),
      ),
      const SizedBox(height: 50),
      Form(
          autovalidateMode: AutovalidateMode.always,
          key: formstate,
          child: Column(children: [
            SizedBox(
              width: 370,
              child: TextFormField(
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
            const SizedBox(
              height: 25.0,
            ),
            SizedBox(
              width: 370,
              child: TextFormField(
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
            const SizedBox(
              height: 25.0,
            ),
            SizedBox(
              width: 370,
              child: TextFormField(
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
            const SizedBox(
              height: 25.0,
            ),
            SizedBox(
              width: 370,
              child: TextFormField(
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
            const SizedBox(
              height: 25.0,
            ),
            SizedBox(
                width: 370,
                child: TextFormField(
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
                )),
          ])),
      const SizedBox(height: 50),
      InkWell(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                border: Border.all(color: const Color(0xffffaa00), width: 1.2)),
            height: 33,
            width: 150,
            child: const Center(
                child: Text('Edit Profile',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
          ),
          onTap: () async {
            var link;
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Home()));
            auth.update(email.text.trim(), pwd.text.trim());
            if (_image != null) {
              await auth.upload(path);
            var link = await auth.downloadURLExample();
            if (link.toString() != 'no'){
                setState(() {
                pic = true;});
            }
            }
            auth.EditProfile(email.text.trim(), pwd.text.trim(),
                adress.text.trim(), phone.text.trim(), fullname.text.trim());

          }),
    ])));
  }
}
