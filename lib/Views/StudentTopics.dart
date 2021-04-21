import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gyan_vatika/Models/TopicModel.dart';
import 'package:gyan_vatika/Views/StudentTopicDetails.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'dart:core';
import 'NavDrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'TeachersHomePage.dart';

class StudentTopics extends StatefulWidget {

  String chapterId;
  StudentTopics(this.chapterId);

  @override
  _StudentTopicsState createState() => _StudentTopicsState();
}

class _StudentTopicsState extends State<StudentTopics> {
  List<String> userData;
  Future<List<String>>  userInfoOffline;
  String id,loginId,district,standard,phoneNumber,email,fullName,parentsName,userIcon;
  TopicFullFormat studentTopics = TopicFullFormat(404,"status Message");
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

  topics() async {
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



    String uri = "http://navelsoft.com/gayan/topicsApi.php?chapter_id=" + widget.chapterId+"&user_id="+idValue;
    ////print(uri);
    final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});
    if (responseData.statusCode == 200) {

      studentTopics = TopicFullFormat.fromJson(json.decode(responseData.body));

      if(studentTopics.status == 500)
      {
        showMyDialog(context,studentTopics.status.toString(), "Do It Again",TeachersHomePage());
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
    this.topics();
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
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/25,left: MediaQuery.of(context).size.width/3.5),

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
                if(studentTopics.topicsData != null)
                  for(int i=0;i<studentTopics.topicsData.length;i++)
                    Container(
                      width: MediaQuery.of(context).size.width/2,
                      padding: EdgeInsets.only(bottom: 32),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => StudentTopicDetails(studentTopics.topicsData[i])
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
                                  color: studentTopics.topicsData[i].status == 0.toString() ?  Colors.red  : Colors.green
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                child: Text( "Topic -"+studentTopics.topicsData[i].topicNo
                                  ,style: TextStyle(color: Colors.black54),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                child: Text(studentTopics.topicsData[i].topicName
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
