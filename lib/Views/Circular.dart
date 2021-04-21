import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gyan_vatika/Models/CircularModel.dart';
import 'package:gyan_vatika/Views/CircularDetails.php.dart';
import 'NavDrawer.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CircularPage extends StatefulWidget {


  @override
  _CircularPageState createState() => _CircularPageState();
}

class _CircularPageState extends State<CircularPage> {


  CircularFormat circularData = CircularFormat(100,"Status Message");
  bool isLoading = false;
  String idValue,userType;
  int unSeenMessageCount = 0;


  loadCircular() async {
    /*Future<bool> futureConnection = checkInterNetConnection();
    futureConnection.then((value) =>
    {
      checkInternetConnection = value
    });*/
    /* if (checkInternetConnection) {
      if (formKey.currentState.validate()) {*/


    final idKey = 'id';
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      idValue = prefs.getString(idKey) ?? null;
    });

    final userTypeKey = 'userType';

    setState(() {
      userType = prefs.getString(userTypeKey) ?? null;
    });

    String uri = "http://navelsoft.com/gayan/circularApi.php?userId=" + idValue;
    ////print(uri);

    final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});
    if (responseData.statusCode == 200) {

      //print(responseData.body);

    circularData = CircularFormat.fromJson(json.decode(utf8.decode(responseData.bodyBytes)));

       ////print(circularData.circularData[0].text);

      //print(circularData.status);
       if(circularData.status == 402)
      {
        showMyDialog(context, circularData.status.toString(), "No Circular Yet.");
      }
      else if(circularData.status == 500)
      {
        showMyDialog(context,circularData.status.toString(), "Do It Again");
        Navigator.pop(context);
        Navigator.pop(context);
      }


      setState(() {
        isLoading = false;
      });



      /*  }
      }
      else {
        showMyDialog(
            context, "InterNet Connectivity", "Check Internet Connection");
      }*/
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.loadCircular();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Center(child: Text("GYAN VATIKA",style: TextStyle(color: Colors.black),) ),
        backgroundColor: Color(0xFFFFA300),
      ),
      body: isLoading ? successIndicator() : SingleChildScrollView(
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
                      Text(" Circular Messages",style: TextStyle(
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
                if(circularData.circularData != null )
                  for(int i=0;i<circularData.circularData.length;i++)
                    InkWell(

                      onTap: ()
                       {

                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => CircularDetails(circularData.circularData[i])
                        ));



                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(left: 12,top: 8),
                        margin: EdgeInsets.all(4),
                        height: 60,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: Text(  circularData.circularData[i].text
                                ,style: TextStyle(color: Colors.black,fontWeight: circularData.circularData[i].status == 0.toString() ? FontWeight.bold : FontWeight.w300),
                                overflow: TextOverflow.ellipsis,),
                            ),
                          ],
                        ),
                      ),
                    )
              ],
            ),



          ],
        ),
      ),
    );
  }
}
