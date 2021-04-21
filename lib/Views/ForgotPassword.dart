import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {




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
              child: Text("Admin : Please Contact To Your Respective Administrative.",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
            ),



          ],
        ),
      ),
    );
  }
}
