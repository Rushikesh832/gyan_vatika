import 'package:flutter/material.dart';
import 'package:gyan_vatika/Models/AssesmentModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'AssessmentDetails.dart';
import 'NavDrawer.dart';

class TeacherAssessmentList extends StatefulWidget {

  String status = "All";
  @override
  _TeacherAssessmentListState createState() => _TeacherAssessmentListState();
}

class _TeacherAssessmentListState extends State<TeacherAssessmentList> {

  AssessmentFormat assessmentData = AssessmentFormat(100,"Status Message");
  bool isLoading = false;
  String idValue,userType;
  int unSeenAssessmentCount = 0;


  loadNotification() async {
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



    String uri = "http://navelsoft.com/gayan/AssesmentApi.php?user_id=" + idValue;
    ////print(uri);
    final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});
    if (responseData.statusCode == 200) {

      assessmentData = AssessmentFormat.fromJson(json.decode(responseData.body));
      //print(assessmentData.status);
      if(assessmentData.status == 200) {


        for (int i=0;i< assessmentData.assessmentData.length;i++)

        {
          if(assessmentData.assessmentData[i].isComplete == 0.toString() || assessmentData.assessmentData[i].isComplete == null )
          {
            unSeenAssessmentCount = unSeenAssessmentCount + 1 ;
          }
        }
      }
      else if(assessmentData.status == 402)
      {
        showMyDialog(context, assessmentData.status.toString(), "No Notification Yet.");
        Navigator.pop(context);
        Navigator.pop(context);

      }
      else if(assessmentData.status == 500)
      {
        showMyDialog(context,assessmentData.status.toString(), "Do It Again");
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
    this.loadNotification();

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
                  height: 120,
                  color: Color(0xFFFFD835),
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(top: 55,left: 160),
                ),


                Container(
                  margin: EdgeInsets.only(left: 24,top: 8 ),
                  child: Row(
                    children: <Widget>[
                      Text("Assessment",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,

                      )),

                      Container(
                        margin: EdgeInsets.only(left: 100),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius: BorderRadius.all(Radius.circular(50))
                              ),
                              child: Icon(
                                Icons.notifications,
                                size: 35,
                                color: Colors.yellowAccent,
                              ),

                            ),
                            Container(
                              padding: EdgeInsets.all(2),
                              margin: EdgeInsets.only(left: 30),
                              decoration: BoxDecoration(
                                color: Colors.yellowAccent,
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                              ),
                              child: Text( unSeenAssessmentCount.toString()
                              ),

                            ),


                          ],
                        ),
                      ),




                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/6,top: 60),
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                        color: Color(0xFFFFD835),
                        onPressed: () {
                          setState(() {
                            widget.status = "Complete";
                          });
                        },
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          height: 40,
                          width: 70,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(50)),
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFFFFA300),
                                Color(0xFFFFD740),
                              ],
                            ),
                          ),
                          child: Center(child: Text("Complete",
                              style: widget.status == "Complete" ? TextStyle(
                                  fontSize: 15
                                  ,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold) : TextStyle(
                                fontSize: 14
                                , color: Colors.black,))),
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        width: 0.4,
                        height: 50,
                      ),
                      FlatButton(
                        color: Color(0xFFFFD835),
                        onPressed: () {
                          setState(() {
                            widget.status = "All";
                          });
                        },
                        textColor: Colors.white,
                        child: Container(
                          child: Center(child: Text("All",
                              style: widget.status == "All" ? TextStyle(
                                  fontSize: 15
                                  ,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold) : TextStyle(
                                fontSize: 14
                                , color: Colors.black,))),
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        width: 0.4,
                        height: 50,
                      ),
                      FlatButton(
                        color: Color(0xFFFFD835),
                        onPressed: () {
                          setState(() {
                            widget.status = "InComplete";
                          });
                        },
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          height: 50,
                          width: 100,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(50)),
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFFFFD740),
                                Color(0xFFFFA300),

                              ],
                            ),
                          ),
                          child: Center(child: Text('InComplete',
                              style: widget.status == "InComplete"
                                  ? TextStyle(fontSize: 14
                                  ,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)
                                  : TextStyle(fontSize: 13
                                , color: Colors.black,))),
                        ),
                      )
                    ],
                  ),
                ),

              ],
            ),
            SizedBox(height: 16,),
            Column(
              children: <Widget>[
                if(assessmentData.assessmentData != null )
                  for(int i=0;i<assessmentData.assessmentData.length;i++)
                    Column(
                      children: <Widget>[
                        if(widget.status ==  "Complete" && assessmentData.assessmentData[i].isComplete == "1")
                          InkWell(
                            onTap: ()
                            {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => AssessmentDetails(assessmentData.assessmentData[i])
                              ));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.all(4),
                              height: MediaQuery.of(context).size.height/12,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: assessmentData.assessmentData[i].isComplete == 1.toString()  ?
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Flexible(
                                        child: Text(assessmentData.assessmentData[i].assessmentContent
                                          ,style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w400),
                                          overflow: TextOverflow.ellipsis,),
                                      ),
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 30,
                                      )
                                    ],
                                  ) :
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Flexible(
                                        child: Text(  assessmentData.assessmentData[i].assessmentContent
                                            ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                                      ),
                                      Icon(
                                        Icons.error,
                                        color: Colors.grey,
                                        size: 35,
                                      )
                                    ],
                                  )
                              ),
                            ),
                          )
                        else if(widget.status ==  "InComplete" && assessmentData.assessmentData[i].isComplete == "0")
                          InkWell(
                            onTap: ()
                            {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => AssessmentDetails(assessmentData.assessmentData[i])
                              ));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.all(4),
                              height: MediaQuery.of(context).size.height/12,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: assessmentData.assessmentData[i].isComplete == 1.toString()  ?
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Flexible(
                                        child: Text(assessmentData.assessmentData[i].assessmentContent
                                          ,style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w400),
                                          overflow: TextOverflow.ellipsis,),
                                      ),
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 30,
                                      )
                                    ],
                                  ) :
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Flexible(
                                        child: Text(  assessmentData.assessmentData[i].assessmentContent
                                            ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                                      ),
                                      Icon(
                                        Icons.error,
                                        color: Colors.grey,
                                        size: 35,
                                      )
                                    ],
                                  )
                              ),
                            ),
                          )
                        else if(widget.status ==  "All")
                            InkWell(
                              onTap: ()
                              {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => AssessmentDetails(assessmentData.assessmentData[i])
                                ));
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.all(4),
                                height: MediaQuery.of(context).size.height/12,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                ),
                                child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: assessmentData.assessmentData[i].isComplete == 1.toString()  ?
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          child: Text(assessmentData.assessmentData[i].assessmentContent
                                            ,style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w400),
                                            overflow: TextOverflow.ellipsis,),
                                        ),
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 30,
                                        )
                                      ],
                                    ) :
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          child: Text(  assessmentData.assessmentData[i].assessmentContent
                                              ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Icon(
                                          Icons.error,
                                          color: Colors.grey,
                                          size: 35,
                                        )
                                      ],
                                    )
                                ),
                              ),
                            )
                      ],
                    ),

              ],
            ),



          ],
        ),
      ),
    );
  }
  }
