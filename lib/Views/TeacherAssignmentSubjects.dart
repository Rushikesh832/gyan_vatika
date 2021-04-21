import 'package:flutter/material.dart';
import 'package:gyan_vatika/Models/TeacherClassificationModel.dart';
import 'package:gyan_vatika/Views/TeachersAssignments.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';
import 'NavDrawer.dart';
import 'TeachersHomePage.dart';

class TeacherAssignmentsSubjects extends StatefulWidget {
  @override
  _TeacherAssignmentsSubjectsState createState() => _TeacherAssignmentsSubjectsState();
}

class _TeacherAssignmentsSubjectsState extends State<TeacherAssignmentsSubjects> {


  List<String> userData;
  Future<List<String>>  userInfoOffline;
  String id,loginId,district,standard,phoneNumber,email,fullName,parentsName,userIcon;
  TeacherClassificationFormat teacherClassificationData = TeacherClassificationFormat(404,"status Message");
  bool isLoading = false;
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
        phoneNumber = data.elementAt(4) != null ? data.elementAt(4) : "   PhoneNumber";
        email = data.elementAt(5) != null ? data.elementAt(5) : "   E-mail";
        fullName = data.elementAt(6) != null ? data.elementAt(6) : "   FullName";
        parentsName = data.elementAt(7) != null ? data.elementAt(7) : "   Parents Full Name";
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
    setState(() {
      isLoading = true;
    });

    final idKey = 'id';
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      idValue = prefs.getString(idKey) ?? null;
    });
    String uri = "http://navelsoft.com/gayan/teacherClassificationApi.php?user_id=" + idValue ;
    final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});
    if (responseData.statusCode == 200) {

      teacherClassificationData = TeacherClassificationFormat.fromJson(json.decode(responseData.body));

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
      body: isLoading ? successIndicator() : SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 125,
                  color: Color(0xFFFFD835),
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(top: 55,left: 160),
                ),
                Container(color: Colors.grey,height: 1.5,),
                Container(

                    width: 320,
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/25,left: MediaQuery.of(context).size.width/12),

                    child:Center(
                      child: Text("$fullName" != null ? "$fullName" : "Full Name" ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                    )
                ),
                Container(
                  width: 160,
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/15,left: MediaQuery.of(context).size.width/3),
                  child:
                  Center(child: Text("$standard" != null ? "Class - " + "$standard" : "Class - Standard",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
                ),

                Container(
                    width: 150,
                    height: 150,
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/9,left: MediaQuery.of(context).size.width/3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: Colors.white
                    ),
                    child: CircleAvatar(
                        radius: 50,
                        backgroundImage: userIcon != null && userIcon.isNotEmpty ? NetworkImage("http://navelsoft.com/gayan/images/Users/"+ "$userIcon") : AssetImage('schoolboy.jpg'),
                      )
                ),
              ],
            ),
            SizedBox(height: 16,),
            Wrap(
              spacing: 48, // gap between adjacent chips
              runSpacing: 32, // gap between lines
              children: <Widget>[
                if(teacherClassificationData.teachersClassification != null )
                  for(int i=0;i<teacherClassificationData.teachersClassification.length;i++)
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => TeacherAssignments(teacherClassificationData.teachersClassification[i].classificationId)
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
                                border: Border.all(width: 1,color: Colors.grey),
                              ),
                              child: Icon(
                                Icons.collections_bookmark,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              child: Text( teacherClassificationData.teachersClassification[i].subjectName
                                ,style: TextStyle(color: Colors.black54),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 2),
                              child: Text( teacherClassificationData.teachersClassification[i].standard
                                ,style: TextStyle(color: Colors.black54,fontSize: 17),
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
    );
  }
}
