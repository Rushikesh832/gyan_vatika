import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gyan_vatika/Models/CircularModel.dart';
import 'package:gyan_vatika/Models/SimpleResponseFormat.dart';
import 'NavDrawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

class CircularDetails extends StatefulWidget {


  Circular circularData;
  CircularDetails(this.circularData);


  @override
  _CircularDetailsState createState() => _CircularDetailsState();
}

class _CircularDetailsState extends State<CircularDetails> {

  SimpleResponseFormat simpleResponse = SimpleResponseFormat(100,"Status Message");
  String idValue;


  changeStatus()
  async {

    final standardKey = 'id';
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      idValue = prefs.getString(standardKey) ?? null;
    });

    String uri = "http://navelsoft.com/gayan/setStatus.php?circular_id="+ widget.circularData.id+"&user_id="+idValue;
    //print(uri);
    final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});
    if (responseData.statusCode == 200) {
      simpleResponse =
          SimpleResponseFormat.fromJson(json.decode(
              responseData.body));
      // //print(simpleResponse.status);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.changeStatus();

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Center(child: Text("GYAN VATIKA",style: TextStyle(color: Colors.black),) ),
        backgroundColor: Color(0xFFFFA300),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 80,
                  color: Color(0xFFFFD835),
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(top: 55,left: 160),
                ),


                Container(
                  margin: EdgeInsets.only(left: 80,top: 25 ),
                  child: Row(
                    children: <Widget>[
                      Text("Circular Messages",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,

                      )),


                    ],
                  ),
                ),

              ],
            ),
            SizedBox(height: 16,),
            Column(
              children: <Widget>[

                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 12,top: 8),
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  child: Text(  widget.circularData.text
                    ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400),),
                ),
                widget.circularData.image != null ? Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 1),
                  child: PhotoView(
                    enableRotation: true,
                    backgroundDecoration: BoxDecoration(
                      color: Colors.white,),
                    imageProvider:
                    CachedNetworkImageProvider("http://navelsoft.com/gayan/AdminPanel/circularImages/" + widget.circularData.image),
                  ),
                ) : Text(" "),
              ],
            ),



          ],
        ),
      ),
    );
  }
}
