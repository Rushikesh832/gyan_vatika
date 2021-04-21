import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gyan_vatika/Models/NotificationModel.dart';
import 'package:gyan_vatika/Models/SimpleResponseFormat.dart';
import 'package:gyan_vatika/Views/SignIn.dart';
import 'package:gyan_vatika/Views/StudentAssignmentSubjects.dart';
import 'package:gyan_vatika/Views/StudentHomePage.dart';
import 'package:gyan_vatika/Views/StudentsSubjects.dart';
import 'package:gyan_vatika/Views/TeacherAssignmentSubjects.dart';
import 'package:gyan_vatika/Views/TeacherSubjects.dart';
import 'package:gyan_vatika/Views/TeachersHomePage.dart';
import 'NavDrawer.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserNotification extends StatefulWidget {


  @override
  _UserNotificationState createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {

  NotificationModel notificationData = NotificationModel(404,"status Message");
  SimpleResponseFormat simpleResponse = SimpleResponseFormat(100,"Status Message");
  bool isLoading = false;
  String idValue,userType;
  int unSeenMessageCount = 0;


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

    final userTypeKey = 'userType';

    setState(() {
      userType = prefs.getString(userTypeKey) ?? null;
    });

    String uri = "http://navelsoft.com/gayan/loadUserNotification.php?user_id=" + idValue;
    ////print(uri);
    final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});
    if (responseData.statusCode == 200) {

      notificationData = NotificationModel.fromJson(json.decode(responseData.body));
      //print(notificationData.status);
      if(notificationData.status == 200) {

        for (int i=0;i< notificationData.notification.length;i++)
          {
            if(notificationData.notification[i].status == 0.toString())
              {
                unSeenMessageCount = unSeenMessageCount + 1 ;
              }
          }
      }
      else if(notificationData.status == 402)
      {
        showMyDialog(context, notificationData.status.toString(), "No Notification Yet.");
      }
      else if(notificationData.status == 500)
      {
        showMyDialog(context,notificationData.status.toString(), "Do It Again");
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
                  height: 80,
                  color: Color(0xFFFFD835),
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(top: 55,left: 160),
                ),


                  Container(
                    margin: EdgeInsets.only(left: 80,top: 25 ),
                    child: Row(
                    children: <Widget>[
                      Text("Notification",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,

                      )),

                      Container(
                        margin: EdgeInsets.only(left: 80),
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
                              child: Text( unSeenMessageCount.toString()
                              ),

                            )

                          ],
                        ),
                      ),


                    ],
                ),
                  ),

              ],
            ),
            SizedBox(height: 16,),
            Column(
              children: <Widget>[
                if(notificationData.notification != null )
                  for(int i=0;i<notificationData.notification.length;i++)
                    InkWell(

                      onTap: ()
                      async {
                        String uri = "http://navelsoft.com/gayan/setStatus.php?notification_id=" + notificationData.notification[i].id;
                        ////print(uri);
                        final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});
                        if (responseData.statusCode == 200) {
                          simpleResponse =
                              SimpleResponseFormat.fromJson(json.decode(
                                  responseData.body));
                          //print(simpleResponse.status);
                          if (simpleResponse.status == 200) {

                            if (userType == 1.toString()) {
                              if (notificationData.notification[i].category ==
                                  1.toString()) {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => StudentSubjects()
                                ));
                              }
                              else
                              if (notificationData.notification[i].category ==
                                  2.toString()) {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) =>
                                        StudentAssignmentsSubjects()
                                ));
                              }
                              else
                              if (notificationData.notification[i].category ==
                                  3.toString()) {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => StudentHomePage()
                                ));
                              }
                              else {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => StudentHomePage()
                                ));
                              }
                            }
                            else if (userType == 2.toString()) {
                              if (notificationData.notification[i].category ==
                                  1.toString()) {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => TeacherSubjects()
                                ));
                              }
                              else
                              if (notificationData.notification[i].category ==
                                  2.toString()) {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) =>
                                        TeacherAssignmentsSubjects()
                                ));
                              }
                              else
                              if (notificationData.notification[i].category ==
                                  3.toString()) {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => TeachersHomePage()
                                ));
                              }
                              else {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => TeachersHomePage()
                                ));
                              }
                            }
                            else {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => SignIn()
                              ));
                            }
                          }
                        }


                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(4),
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(15))
                        ),
                        child: Container(
                            padding: EdgeInsets.all(8),
                            child: notificationData.notification[i].status == 1.toString()  ?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  child: Text(  notificationData.notification[i].message
                                      ,style: TextStyle(color: Colors.green,fontWeight: FontWeight.w400),
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
                                  child: Text(  notificationData.notification[i].message
                                      ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,),
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
      ),
    );
  }
}
