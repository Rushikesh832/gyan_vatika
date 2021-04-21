import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gyan_vatika/Models/classTeacherName.dart';
import 'package:gyan_vatika/Views/StudentHomePage.dart';
import 'NavDrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gyan_vatika/Widgets/Widgets.dart';

class StudentProfile extends StatefulWidget {
  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {


  Future<List<String>>  userInfoOffline;
  List<String> userData;
  ClassTeacherNameFormat classTeacherName = ClassTeacherNameFormat(100,"Status Message");
  bool isLoading = false;
  String id,loginId,district,standard,phoneNumber,email,fullName,mothersName,fathersName,userIcon;
  String userId;


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
        mothersName = data.elementAt(7) != null ? data.elementAt(7) : "   mothers Full Name";
        fathersName = data.elementAt(9) != null ? data.elementAt(9) : "   fathers Name";
        userIcon = data.elementAt(11);
      });
    });
  }

  classTeacher() async {


    setState(() {
      isLoading = true;
    });
    /*//print(widget.assessmentDetails.assessmentId);
    //print(widget.assessmentDetails.assignmentId);*/

    final standardKey = 'id';
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      userId = prefs.getString(standardKey) ?? null;
    });

    String uri = "http://navelsoft.com/gayan/getTeachersName.php?user_id="+userId;
    //print(uri);
    final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});
    if (responseData.statusCode == 200) {

      classTeacherName = ClassTeacherNameFormat.fromJson(json.decode(responseData.body));
      //print(classTeacherName.status);

      if(classTeacherName.status == 500)
      {
        showMyDialog(context,classTeacherName.status.toString(), "Do It Again to Load Images");
      }


      setState(() {
        isLoading = false;
      });




    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.loadSharedPref();
    this.classTeacher();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Center(child: Text("GYAN VATIKA",style: TextStyle(color: Colors.black),) ),
        backgroundColor: Color(0xFFFFA300),
      ),
      body: isLoading ? successIndicator() :  SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height/2.5,
              child: Column(
                children: <Widget>[
                  Flexible(
                    flex: 8,
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
                                    child: Container(
                                      padding: EdgeInsets.all(2),
                                        child: Center(child: userIcon != null ? Image.network(
                                            "http://navelsoft.com/gayan/images/Users/"+ "$userIcon",fit: BoxFit.cover,) : Image.asset("schoolboy.jpg"))),
                                  ),
                                  Flexible(
                                    flex: 3,
                                    child: Container(
                                      margin: EdgeInsets.only(top:12),
                                        child: Center(
                                          child: Text("$fullName" != null ? "$fullName" : "Full Name",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15
                                          ),),
                                        )),
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
                                          child: Text("ADMISSION NO",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18
                                            ),)),

                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                          margin: EdgeInsets.only(top:4),
                                          child: Text("$loginId" != null ? "$loginId" : "Login Id",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 17
                                            ),)),

                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                          margin: EdgeInsets.only(top:12),
                                          child: Text("CLASS-SECTION",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18
                                            ),)),

                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                          margin: EdgeInsets.only(top:4),
                                          child: Text("$standard" != null ? "$standard" : "Login Id",
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
                                      child: classTeacherName.classTeacherName != null ?  Container(
                                          margin: EdgeInsets.only(top:4),
                                          child:
                                          Text( classTeacherName.classTeacherName[0].classTeacherName , style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 17
                                          ) ) )
                                      : Container(
                                    margin: EdgeInsets.only(top:4),
                                  child:
                                  Text( "Class Teacher Name", style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17
                                  )))),
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
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                  builder: (context) => StudentHomePage()
                                ), (Route<dynamic> route) => false);
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
                      Icons.mail_outline,
                      size: 50,
                      color: Colors.black54,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 48),
                    child: Text(
                      "$fathersName" != null ? "$fathersName" : "Father Name",
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
                    child: Text(
                      "$mothersName" != null ? "$mothersName" : "Mother Name",
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
                      "$email" != null ? "$email"  : "Email",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
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


