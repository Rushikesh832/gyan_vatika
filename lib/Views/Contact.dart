import 'package:flutter/material.dart';

class Contact extends StatefulWidget {

  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("GYAN VATIKA",style: TextStyle(color: Colors.black),) ),
        backgroundColor: Color(0xFFFFA300),
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: <Widget>[

            Container(
              margin: EdgeInsets.fromLTRB(72, 32, 24, 24),
              width: MediaQuery.of(context).size.width,
              child: Text("Address :- GYAN VATIKA \n"
                  "Near Town Than , DUMKA \n Jharkhand 814101.",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(72, 32, 24, 24),
              width: MediaQuery.of(context).size.width,
              child: Text("Address2 :- GYAN VATIKA \n"
                  "Raghunathpur , DUMKA \n Jharkhand 814148.",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(96, 32, 24, 24),
              width: MediaQuery.of(context).size.width,
              child: Text("CONTACT US :- \n"
                  "+91xxxxxxxxxx \n +91xxxxxxxxxx",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
            ),



          ],
        ),
      ),
    );
  }
}
