import 'package:flutter/material.dart';
import 'package:gyan_vatika/Models/TopicQueriesModel.dart';
import 'package:gyan_vatika/Views/CreateAnswerQuery.dart';
import 'NavDrawer.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TeacherTopicQueries extends StatefulWidget {

  String topicId;
  TeacherTopicQueries(this.topicId);
  @override
  _TeacherTopicQueriesState createState() => _TeacherTopicQueriesState();
}

class _TeacherTopicQueriesState extends State<TeacherTopicQueries> {

  List<String> userData;
  Future<List<String>>  userInfoOffline;
  String id,loginId,district,standard,phoneNumber,email,fullName,parentsName,userIcon;
  TopicQueriesFormat queriesData = TopicQueriesFormat(404,"status Message");
  bool isLoading = false;
  String standardUrl;


  loadQueries() async {
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





    String uri = "http://navelsoft.com/gayan/queriesApi.php?topic_id=" + widget.topicId;
    ////print(uri);
    final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});
    if (responseData.statusCode == 200) {

      queriesData = TopicQueriesFormat.fromJson(json.decode(responseData.body));
      ////print(subjectsData.status);
      if(queriesData.status == 402)
      {
        showMyDialog(context, queriesData.status.toString(), "No Queries");
        Navigator.pop(context);
        Navigator.pop(context);
      }
      if(queriesData.status == 500)
      {
        showMyDialog(context,queriesData.status.toString(), "Do It Again");
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
    loadQueries();

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
                  Center(child: Text("$standard" != null ? "Class - " + "$standard"  : "Class - Standard",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
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
            Column(
              children: <Widget>[
                if(queriesData.queries != null )
                  for(int i=0;i<queriesData.queries.length;i++)
                    InkWell(
                      onTap: ()
                      {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => CreateAnswerQuery(queriesData.queries[i])
                        ));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(15))
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8),

                              child: Text( queriesData.queries[i].question
                                ,style: TextStyle(color: Colors.black54),
                              ),
                            ),
                            Divider(height: 2,color: Colors.black,),
                            Container(
                                padding: EdgeInsets.all(8),
                                child: queriesData.queries[i].answer != null ? Text(  queriesData.queries[i].answer
                                    ,style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)) : Text( "Answer Yet To Be Discovered."
                                    ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold))
                            )
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
