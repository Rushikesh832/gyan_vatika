import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gyan_vatika/Models/CountModel.dart';
import 'package:gyan_vatika/Views/Circular.dart';
import 'package:gyan_vatika/Views/NavDrawer.dart';
import 'package:gyan_vatika/Views/TeacherAssessmentList.dart';
import 'package:gyan_vatika/Views/TeacherAssignmentSubjects.dart';
import 'package:gyan_vatika/Views/TeacherProfile.dart';
import 'package:gyan_vatika/Views/TeacherSubjects.dart';
import 'package:gyan_vatika/Views/UserNotification.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'About.dart';
import 'Calender.dart';
import 'Help.dart';
import 'TopicQueries.dart';


class TeachersHomePage extends StatefulWidget {
  @override
  _TeachersHomePageState createState() => _TeachersHomePageState();
}

class _TeachersHomePageState extends State<TeachersHomePage> {

  List<String> userData;
  Future<List<String>> userInfoOffline;
  String id, loginId, district, standard, phoneNumber, email, fullName,
      parentsName,userIcon;
  DateTime backButtonPressedTime;
  CountModel countData = CountModel(100,"Status Message","0","0","0","0","0");
  String idValue;
  String assessmentCount;
  String notificationCount;
  String circularCount;

  loadSharedPref() {
    userInfoOffline = read();
    userInfoOffline.then((data) {
      setState(() {
        userData = data;
        fullName = userData[6];
        standard = userData[3];
        userIcon = userData[11];
      });
    });
  }
  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    //Statement 1 Or statement2
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 3);

    if (backButton) {
      backButtonPressedTime = currentTime;
      Fluttertoast.showToast(
          msg: "Double Click to exit app",
          backgroundColor: Colors.white,
          textColor: Colors.black);
      return false;
    }
    return true;
  }

  loadCount() async {
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

    String uri = "http://navelsoft.com/gayan/getCountByUser.php?user_id=" + idValue;
    ////print(uri);
    final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});
    if (responseData.statusCode == 200) {

      countData = CountModel.fromJson(json.decode(responseData.body));
      //print(countData.status);
      if(countData.status == 200) {

        setState(() {
          assessmentCount = countData.assessmentCount;
          notificationCount = countData.notificationCount;
          circularCount = countData.circularCount;
        });

      }



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
    loadSharedPref();
    this.loadCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Center(child: Text(
          "GYAN VATIKA", style: TextStyle(color: Colors.black),)),
        backgroundColor: Color(0xFFFFA300),
      ),
      body: WillPopScope( onWillPop: onWillPop,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 125,
                    color: Color(0xFFFFD835),
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(top: 55, left: 160),
                  ),
                  Container(color: Colors.grey, height: 1.5,),
                  Container(

                      width: 320,
                      margin: EdgeInsets.only(top: MediaQuery
                          .of(context)
                          .size
                          .height / 25, left: MediaQuery
                          .of(context)
                          .size
                          .width / 12),

                      child: Center(
                        child: Text("$fullName" != null
                            ? "Name - " + "$fullName"
                            : "Name - " + "Full Name", style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),),
                      )
                  ),
                  Container(
                    width: 160,
                    margin: EdgeInsets.only(top: MediaQuery
                        .of(context)
                        .size
                        .height / 15, left: MediaQuery
                        .of(context)
                        .size
                        .width / 3),
                    child:
                    Center(child: Text("$standard" != null
                        ? "Class - " + "$standard"
                        : "Class - Standard", style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),)),
                  ),

                  Container(
                      width: 150,
                      height: 150,
                      margin: EdgeInsets.only(top: MediaQuery
                          .of(context)
                          .size
                          .height / 9, left: MediaQuery
                          .of(context)
                          .size
                          .width / 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: Colors.white
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: userIcon != null && userIcon.isNotEmpty ? NetworkImage("http://navelsoft.com/gayan/images/Users/"+ "$userIcon") : AssetImage('teacher.jpg'),
                      )
                  ),
                ],
              ),
              SizedBox(height: 16,),
              Wrap(
                spacing: 48,
                runSpacing: 32, // gap between lines
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => TeacherProfile()
                      ));
                    },
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 70,
                            width: 70,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(100)),
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: Icon(
                              Icons.supervisor_account,
                              size: 50,
                              color: Colors.black54,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Text(
                              "My Profile", style: TextStyle(
                                color: Colors.black54),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => TeacherSubjects()
                      ));
                    },
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 70,
                            width: 70,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(100)),
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: Icon(
                              Icons.subject,
                              size: 50,
                              color: Colors.black54,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Text(
                              "Subjects", style: TextStyle(color: Colors.black54),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => TeacherAssignmentsSubjects()
                      ));
                    },
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 70,
                            width: 70,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(100)),
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: Icon(
                              Icons.assignment,
                              size: 50,
                              color: Colors.black54,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Text(
                              "Assignments", style: TextStyle(color: Colors
                                .black54),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => TeacherAssessmentList()
                      ));
                    },
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                height: 70,
                                width: 70,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(100)),
                                  border: Border.all(width: 1,color: Colors.grey),
                                ),
                                child: Icon(
                                  Icons.assignment_turned_in,
                                  size: 50,
                                  color: Colors.black54,
                                ),

                              ),
                              Container(
                                padding: EdgeInsets.all(2),
                                margin: EdgeInsets.only(left: 45),
                                decoration: BoxDecoration(
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                                child: Text( assessmentCount != null ? assessmentCount.toString() : 0.toString()
                                ),

                              ),


                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Text(
                              "Assessments", style: TextStyle(color: Colors
                                .black54),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Calender()
                      ));
                    },
                    child: Container(

                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 70,
                            width: 70,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(100)),
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: Icon(
                              Icons.calendar_today,
                              size: 50,
                              color: Colors.black54,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Text(
                              "Calender", style: TextStyle(color: Colors.black54),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => UserNotification()
                      ));
                    },
                    child: Container(
                      child: Column(
                        children: <Widget>[
                      Stack(
                      children: <Widget>[
                        Container(
                        height: 70,
                        width: 70,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          border: Border.all(width: 1,color: Colors.grey),
                        ),
                        child: Icon(
                          Icons.notifications,
                          size: 50,
                          color: Colors.black54,
                        ),

                      ),
                      Container(
                        padding: EdgeInsets.all(2),
                        margin: EdgeInsets.only(left: 42,top: 4),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        child: Text( notificationCount != null ? notificationCount.toString() : 0.toString()
                        ),

                      ),


                      ],
                    ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Text(
                              "Notifications", style: TextStyle(color: Colors
                                .black54),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => CircularPage()
                      ));
                    },
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                height: 70,
                                width: 70,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(100)),
                                  border: Border.all(width: 1,color: Colors.grey),
                                ),
                                child: Icon(
                                  Icons.blur_circular,
                                  size: 50,
                                  color: Colors.black54,
                                ),

                              ),
                              Container(
                                padding: EdgeInsets.all(2),
                                margin: EdgeInsets.only(left: 42,top: 4),
                                decoration: BoxDecoration(
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                                child: Text( circularCount != null ? circularCount.toString() : 0.toString()
                                ),

                              ),


                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Text(
                              "Circular", style: TextStyle(color: Colors
                                .black54),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => TopicQueries(1.toString(),"teacher")
                      ));
                    },
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 70,
                            width: 70,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(100)),
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: Icon(
                              Icons.assignment_turned_in,
                              size: 50,
                              color: Colors.black54,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Text(
                              "View Query", style: TextStyle(color: Colors.black54),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => About()
                      ));
                    },
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 70,
                            width: 70,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(100)),
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: Icon(
                              Icons.school,
                              size: 50,
                              color: Colors.black54,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Text(
                              "About", style: TextStyle(color: Colors.black54),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Help()
                      ));
                    },
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 70,
                            width: 70,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(100)),
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: Icon(
                              Icons.help,
                              size: 50,
                              color: Colors.black54,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Text(
                              "Help", style: TextStyle(color: Colors.black54),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),


                ],
              )


            ],
          ),
        ),
      ),
    );
  }
}
