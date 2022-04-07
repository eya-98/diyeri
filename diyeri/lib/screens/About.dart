import 'package:diari/screens/home.dart';
import 'package:flutter/material.dart';


class About extends StatefulWidget  {
  @override
  MyAppBar createState() => MyAppBar();
}

class MyAppBar extends State <About> {
  @override

  Widget build (BuildContext context) {
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
          const SizedBox(height: 8),
          const Center(child: Text('About Diyeri', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Color(0xFFFFC107)
          )
          )),
          const SizedBox(height: 50,),
          const SizedBox(width: 350,
          child: Text('Our mobile application is based on a customer-to-customer business strategy that connects different actors in the Tunisian community interested in homemade food for sale and purchase.', 
          style: TextStyle(fontSize: 20,),
          maxLines: 20, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 20 ,width: 350,),
        Text('Contributors',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color(0xFFFFC107)),
        ),
          const SizedBox(height: 20,),
          Row(children: [
           Column(children: [
             SizedBox(height: 150,width: 200,
          child:
          CircleAvatar(
            child: ClipRRect(
            borderRadius: BorderRadius.circular(80),
            child: Image.asset('assets/contributor-pic.jpeg', width: 150, height: 200,fit: BoxFit.cover,),
          ),
        ),
             ),
                       const SizedBox(height: 20,),

            Text('Eya Nani', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ]
          ),
          Column(children: [
          Container(height: 150,width: 200,
          child: 
          new CircleAvatar(
            child: ClipRRect(
            borderRadius: BorderRadius.circular(80),
            child: Image.asset('assets/contributor-pic2.jpeg', width: 150, height: 200,fit: BoxFit.cover,),
          ),
        )

          ),
          const SizedBox(height: 20,),
          Text('Emna Bouaziz', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ]
          ),]),
        ])
      )
    );
  }
}