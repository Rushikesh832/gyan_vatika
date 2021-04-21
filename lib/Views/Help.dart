import 'package:flutter/material.dart';
import 'NavDrawer.dart';

class Help extends StatefulWidget {

  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Center(child: Text("GYAN VATIKA",style: TextStyle(color: Colors.black),) ),
        backgroundColor: Color(0xFFFFA300),
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 12,),
            Container(
              margin: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              child: Text("1. What is Profile?",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
            ),
            Container(
              margin: EdgeInsets.all(4),
              width: MediaQuery.of(context).size.width,
              child: Text("Ans- you can you see all the details like admission number, name, class teacher.",
                  style: TextStyle(fontSize: 16)),
            ),
            Divider(),

            Container(
              margin: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              child: Text("2.What is subject?",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
            ),
            Container(
              margin: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              child: Text("Ans- Subject icon define your all subject and you will get all the study material under the subject icon",
                  style: TextStyle(fontSize: 16)),
            ),
            Divider(),
            Container(
              margin: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              child: Text("3. What is assignment section?",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
            ),
            Container(
              margin: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              child: Text("Ans- Teacher will give you the assignment and you will find all the assignment under the assignment icon",
                  style: TextStyle(fontSize: 16)),
            ),
            Divider(),
            Container(
              margin: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              child: Text("4. What is Calendar?",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
            ),
            Container(
              margin: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              child: Text("Ans - Calendar icon define school calendar and yoi can see all the event details , activity details, holiday etc",
                  style: TextStyle(fontSize: 16)),
            ),
            Divider(),
            Container(
              margin: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              child: Text("5. What is result?",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
            ),
            Container(
              margin: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              child: Text("Ans - result icon define your performance. As per you assignment.",
                  style: TextStyle(fontSize: 16)),
            ),
            Divider(),
            Container(
              margin: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              child: Text("6.what is Attendance icon?",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
            ),
            Container(
              margin: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              child: Text("Ans - you can see your attendance . ",
                  style: TextStyle(fontSize: 16)),
            ),
            Divider(),
            Container(
              margin: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              child: Text("7.what is notification ?",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
            ),
            Container(
              margin: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              child: Text("Ans - Check Notification Which Has To Be Send For Purpose.",
                  style: TextStyle(fontSize: 16)),
            ),
            Divider(),



          ],
        ),
      ),
    );
  }
}
