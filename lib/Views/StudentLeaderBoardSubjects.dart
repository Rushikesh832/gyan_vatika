import 'package:flutter/material.dart';
import 'package:gyan_vatika/Models/SubjectModel.dart';
import 'package:gyan_vatika/Views/StudentLeaderBoard.dart';
import 'NavDrawer.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'StudentHomePage.dart';

class StudentLeaderBoardSubjects extends StatefulWidget {
  @override
  _StudentLeaderBoardSubjectsState createState() => _StudentLeaderBoardSubjectsState();
}

class _StudentLeaderBoardSubjectsState extends State<StudentLeaderBoardSubjects> {

  List<String> userData;
  Future<List<String>>  userInfoOffline;
  String id,loginId,district,standard,phoneNumber,email,fullName,parentsName,userIcon;
  SubjectsDataFormat subjectsData = SubjectsDataFormat(404,"status Message");
  bool isLoading = false;
  String standardUrl;


  loadSubjects() async {
    /*Future<bool> futureConnection = checkInterNetConnection();
    futureConnection.then((value) =>
    {
      checkInternetConnection = value
    });*/
    /* if (checkInternetConnection) {
      if (formKey.currentState.validate()) {*/
    userInfoOffline = read();
    userInfoOffline.then((data){
      setState(() {
        userData = data;
        fullName = userData[6];
        standard = userData[3];
        userIcon = userData[11];
      });
    });

    final standardKey = 'standard';
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      standardUrl = prefs.getString(standardKey) ?? null;
    });




    String uri = "http://navelsoft.com/gayan/studentsApi.php?standard=" + standardUrl.split(" ")[0] ;
    print(uri);
    final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});
    if (responseData.statusCode == 200) {

      subjectsData = SubjectsDataFormat.fromJson(json.decode(responseData.body));
      ////print(subjectsData.status);
      if(subjectsData.status == 402)
      {
        showMyDialog(context, subjectsData.status.toString(), "Do It Again",StudentHomePage());
      }
      if(subjectsData.status == 500)
      {
        showMyDialog(context,subjectsData.status.toString(), "Do It Again",StudentHomePage());
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
    loadSubjects();

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
                  height: 60,
                  color: Color(0xFFFFD835),
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(top: 55,left: 160),
                ),
                Container(color: Colors.grey,height: 1.5,),
                Container(
                  child: Center(

                    child: Text("     Student \n LeaderBoard",
                    style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.black87),),
                  ),),
              ],
            ),
            SizedBox(height: 16,),
            Wrap(
              spacing: 48, // gap between adjacent chips
              runSpacing: 32, // gap between lines
              children: <Widget>[
                if(subjectsData.subjectsData != null )
                  for(int i=0;i<subjectsData.subjectsData.length;i++)
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => StudentLeaderBoard(standardUrl,subjectsData.subjectsData[i].subjectsId)
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
                              child: Text( subjectsData.subjectsData[i].subjectName
                                ,style: TextStyle(color: Colors.black54),
                              ),
                            )],
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
