import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gyan_vatika/Models/AssignmentsModel.dart';
import 'package:gyan_vatika/Views/StudentAssignmentsDetails.dart';
import 'package:gyan_vatika/Views/StudentHomePage.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'dart:core';
import 'NavDrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentAssignments extends StatefulWidget {

  String subjectId;
  String standard;
  StudentAssignments(this.subjectId,this.standard);

  @override
  _StudentAssignmentsState createState() => _StudentAssignmentsState();
}

class _StudentAssignmentsState extends State<StudentAssignments> {
  List<String> userData;
  Future<List<String>>  userInfoOffline;
  String id,loginId,district,standard,phoneNumber,email,fullName,parentsName,userIcon;
  AssignmentsFormat assignmentsData = AssignmentsFormat(404,"status Message");
  bool isLoading = false;
  String idValue,districtValue;


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

  assignments() async {
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

    final districtKey = 'district';

    setState(() {
      districtValue = prefs.getString(districtKey) ?? null;
    });


    String uri = "http://navelsoft.com/gayan/assignmentsByStandardSubjects.php?"
        "standard="+widget.standard+"&subject="+widget.subjectId+"&user_id="+idValue + "&district="+districtValue;
    //print(uri);
    final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});
    if (responseData.statusCode == 200) {

      assignmentsData = AssignmentsFormat.fromJson(json.decode(responseData.body));

      if(assignmentsData.status == 500)
      {
        showMyDialog(context,assignmentsData.status.toString(), "Do It Again",StudentHomePage());
      }
      else if(assignmentsData.status == 402)
      {
        showMyDialog(context,assignmentsData.status.toString(), assignmentsData.statusMessage.toString(),StudentHomePage());
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
    this.assignments();
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
              children: <Widget>[
                if(assignmentsData.assignmentsData != null)
                  for(int i=0;i<assignmentsData.assignmentsData.length;i++)
                    Container(
                      width: MediaQuery.of(context).size.width/2,
                      padding: EdgeInsets.only(bottom: 32),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => StudentAssignmentDetails(assignmentsData.assignmentsData[i])
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
                                    color: assignmentsData.assignmentsData[i].status == 0.toString() ?  Colors.red  : Colors.green,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                child: Text( "Assignment -"+assignmentsData.assignmentsData[i].assignmentNo
                                  ,style: TextStyle(color: Colors.black54),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                child: Text(assignmentsData.assignmentsData[i].assignmentName
                                  ,style: TextStyle(color: Colors.black54),
                                ),
                              )
                            ],
                          ),
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
