import 'package:flutter/material.dart';
import 'NavDrawer.dart';

class About extends StatefulWidget {

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {




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


            Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: Image.asset("signIn.jpeg",fit: BoxFit.fill,),
            ),
            SizedBox(height: 30,),
            Container(
              margin: EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              child: Text("             GYAN VATIKA provides a congenial environment for all-round "
                  "development of the whole personality and its integration with the society,"
                  " particularly in reference to the Indian context."
                  " Positive ideas are inculcated in students as regards, personal hygiene, neatness of uniform,"
                  " cleanliness of surroundings, protection of plants,"
                  " graceful manners, dignity of labour, obedience and discipline.",
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
            ),



          ],
        ),
      ),
    );
  }
}
