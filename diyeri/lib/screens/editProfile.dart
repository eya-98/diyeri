import 'package:flutter/material.dart';
import 'home.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image_crop/image_crop.dart';
import 'package:image_cropper/image_cropper.dart';
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
  var _image = null;
  late AppState state;
  var imagePicker;
  final cropKey = GlobalKey<CropState>();
  var _file;
  var _sample;
  var _lastCropped;
  var path;
  @override
  void initState() {
    super.initState();
    state = AppState.free;
  awaitinit();
  }
  void awaitinit(){
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
     Auth_provider auth = Provider.of<Auth_provider>(context, listen: false);
      var test = await auth.downloadURLExample();
      if (test.trim() != 'no') {
        path =  await auth.downloadURLExample();
      }
      else {
        path = null;
      }
      print("yyyyyyyyyyyyyyyyyy $path");

    });
  }
  Widget build(BuildContext context) {
    Auth_provider auth = Provider.of<Auth_provider>(context);
    GlobalKey<FormState> formstate = GlobalKey<FormState>();
    TextEditingController email = TextEditingController();
    TextEditingController pwd = TextEditingController();
    TextEditingController phone = TextEditingController();
    TextEditingController adress = TextEditingController();
    TextEditingController fullname = TextEditingController();
    @override
//// get from Galleriea
    Future<Null> _cropImage() async {
      File? croppedFile = await ImageCropper().cropImage(
          //cropStyle: CropStyle.circle,
          sourcePath: imagePicker,
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
        imagePicker = image?.path;
        state = AppState.picked;
        _image = imagePicker == null ? null : File(imagePicker);
      });
      if (state == AppState.picked) {
        _cropImage();
      }
      print("leeeeeeeeeeeee $_image");
    }
    void _clearImage() {
      imagePicker = null;
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
                    child: path != null ? Image.network(path, height: 150, width: 150, fit: BoxFit.fill) :  Image.asset('assets/unknown.jpg'),
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Home()));
            auth.update(email.text.trim(), pwd.text.trim());
            auth.EditProfile(email.text.trim(), pwd.text.trim(),
                adress.text.trim(), phone.text.trim(), fullname.text.trim());
            if (_image != null) {
              await auth.upload(imagePicker);
            }
          }),
    ])));
  }
}
