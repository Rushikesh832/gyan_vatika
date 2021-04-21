import 'package:flutter/material.dart';
import 'package:gyan_vatika/Models/TeacherClassificationModel.dart';
import 'package:gyan_vatika/Views/TeachersHomePage.dart';
import 'NavDrawer.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';
import 'SignIn.dart';
import 'StudentHomePage.dart';


class TeacherProfile extends StatefulWidget {
  @override
  _TeacherProfileState createState() => _TeacherProfileState();
}

class _TeacherProfileState extends State<TeacherProfile> {

  Future<List<String>>  userInfoOffline;
  List<String> userData;

  String id,loginId,district,standard,phoneNumber,email,fullName,motherName,fatherName,userType,userIcon;
  bool isLoading = false;
  TeacherClassificationFormat teacherClassificationData = TeacherClassificationFormat(404,"status Message");
  Set<String>  subjectsSet ={};
  Set<String>  standardSet ={};
  String idValue;


  loadSharedPref()
  {
    userInfoOffline = read();

    userInfoOffline.then((data){

      setState(() {
        userData = data;
        id =  data.elementAt(0) != null ? data.elementAt(0) : "1";
        loginId = data.elementAt(1) != null ? data.elementAt(1) : "   loginId";
        district = data.elementAt(2) != null ? data.elementAt(2) : "district";
        standard = data.elementAt(3) != null ? data.elementAt(3) : "standard";
        phoneNumber = data.elementAt(5) != null ? data.elementAt(5) : "   PhoneNumber";
        email = data.elementAt(4) != null ? data.elementAt(4) : "   E-mail";
        fullName = data.elementAt(6) != null ? data.elementAt(6) : "   FullName";
        motherName = data.elementAt(7) != null ? data.elementAt(7) : "   Parents Full Name";
        fatherName = data.elementAt(9) != null ? data.elementAt(9) : "   Father's  Name";
        userType = data.elementAt(8) != null ? data.elementAt(8) : "   User Type";
        userIcon = data.elementAt(11);
      });
    });
  }

  teacherClassification() async {
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




    String uri = "http://navelsoft.com/gayan/teacherClassificationApi.php?user_id=" + idValue ;
    ////print(uri);
    final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});
    if (responseData.statusCode == 200) {

      teacherClassificationData = TeacherClassificationFormat.fromJson(json.decode(responseData.body));

      if(teacherClassificationData.teachersClassification != null)
      for(int i=0;i<teacherClassificationData.teachersClassification.length;i++)
        {
          standardSet.add(teacherClassificationData.teachersClassification[i].standard.toString());
          subjectsSet.add(teacherClassificationData.teachersClassification[i].subjectName.toString());
        }

      if(teacherClassificationData.status == 500)
      {
        showMyDialog(context,teacherClassificationData.status.toString(), "Do It Again",TeachersHomePage());
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
    this.loadSharedPref();
    this.teacherClassification();
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
              Container(
                height: MediaQuery.of(context).size.height/2,
                child: Column(
                  children: <Widget>[
                    Flexible(
                      flex: 10,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.black12,width: 1.5))
                        ),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(right: BorderSide(color: Colors.black12,width: 1))
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Flexible(
                                        flex: 8,
                                        child: Center(child:
                                        userIcon != null ? Image.network("http://navelsoft.com/gayan/images/Users/"+ "$userIcon") : Image.asset("teacher.jpg")),
                                      ),
                                      Flexible(
                                        flex: 3,
                                        child: Container(
                                            margin: EdgeInsets.only(top:12),
                                            child: Text("$fullName" != null ? "$fullName" : "Full Name",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15
                                              ),)),
                                      )
                                    ],
                                  )
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                child: Center(
                                  child: Column(
                                    children: <Widget>[

                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                            margin: EdgeInsets.only(top:12),
                                            child: Text("My Class",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18
                                              ),)),

                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: Container(
                                            margin: EdgeInsets.only(top:2),
                                            child: Text(
                                              standardSet.toString() != null ? standardSet.toString() : " ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 17
                                              ),)),

                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                            margin: EdgeInsets.only(top:12),
                                            child: Text("SUBJECTS",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18
                                              ),)),

                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: Container(
                                            margin: EdgeInsets.only(top:2),
                                            child: Text(subjectsSet.toString() != null ? subjectsSet.toString()  : " ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 17
                                              ),)),

                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                            margin: EdgeInsets.only(top:12),
                                            child: Text("ClASS TEACHER",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18
                                              ),)),

                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                            margin: EdgeInsets.only(top:4),
                                            child: Text("$standard" != null ? "$standard": "Standard",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 17
                                              ),)),

                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                    ,Flexible(
                      flex: 4,
                      child: Container(
                        padding: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.black12,width: 1.5))
                        ),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(right: BorderSide(color: Colors.black12,width: 1))
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.supervised_user_circle,
                                    size: 100,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: InkWell(
                                onTap: ()
                                {
                                  if(int.parse(userType) == 1)
                                  {
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                        StudentHomePage()), (Route<dynamic> route) => false);
                                  }
                                  else if(int.parse(userType) == 2)
                                  {
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                        TeachersHomePage()), (Route<dynamic> route) => false);
                                  }
                                  else
                                  {
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                        SignIn()), (Route<dynamic> route) => false);
                                  }
                                },
                                child: Container(
                                  child: Center(
                                    child: Icon(
                                      Icons.home,
                                      size: 100,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )

                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height/9,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black12 ,width: 1)),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 12),
                      child: Icon(
                        Icons.call,
                        size: 50,
                        color: Colors.black54,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 48),
                      child: Text(
                        "$phoneNumber" != null ? "$phoneNumber" : "Phone Number",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height/9,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black12 ,width: 1)),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 12),
                      child: Icon(
                        Icons.mail_outline,
                        size: 50,
                        color: Colors.black54,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 48),
                      width: MediaQuery.of(context).size.width-150,
                      child: Text(
                        "$email" != null ? "$email" + "$email" : "Email",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}
