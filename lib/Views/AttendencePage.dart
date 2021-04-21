import 'package:flutter/material.dart';
import 'NavDrawer.dart';

class Attendance extends StatefulWidget {

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {




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
            Stack(
              children: <Widget>[
                Container(
                  height: 50,
                  color: Color(0xFFFFD835),
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(top: 55,left: 160),
                ),
                Container(color: Colors.grey,height: 1.5,),
                Container(
                  margin: EdgeInsets.only(top: 12),
                  child: Center(

                    child: Text("Attendance",
                      style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.black87),),
                  ),),
              ],
            ),
            SizedBox(height: 16,),

            Container(
              margin: EdgeInsets.fromLTRB(72, 32, 24, 24),
              width: MediaQuery.of(context).size.width,
              child: Text("This Page Is Under Construction.",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
            ),



          ],
        ),
      ),
    );
  }
}
