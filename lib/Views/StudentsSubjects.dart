import 'package:flutter/material.dart';
import 'package:gyan_vatika/Models/SubjectModel.dart';
import 'package:gyan_vatika/Views/StudentChapters.dart';
import 'NavDrawer.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'StudentHomePage.dart';

class StudentSubjects extends StatefulWidget {
  @override
  _StudentSubjectsState createState() => _StudentSubjectsState();
}

class _StudentSubjectsState extends State<StudentSubjects> {

  List<String> userData;
  Future<List<String>>  userInfoOffline;
  String id,loginId,district,standard,phoneNumber,email,fullName,parentsName,userIcon;
  SubjectsDataFormat subjectsData = SubjectsDataFormat(404,"status Message");
  bool isLoading = false;
  String standardUrl,idUrl,districtUrl;
  List<String> subjectName = List<String>();


  loadSubjects() async {
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
    final idKey = 'id';

    setState(() {
      idUrl = prefs.getString(idKey) ?? null;
    });
    final districtKey = 'district';

    setState(() {
      districtUrl = prefs.getString(districtKey) ?? null;
    });





    String uri = "http://navelsoft.com/gayan/studentTopicsApi.php?standard=" + standardUrl.split(" ")[0]
        + "&division=" + standardUrl.split(" ")[1] +"&user_id=" + idUrl  +"&district=" + districtUrl ;
    ////print(uri);
    final responseData = await http.get(uri,headers: {'Content-Type':'application/json'});
    if (responseData.statusCode == 200) {

      subjectsData = SubjectsDataFormat.fromJson(json.decode(responseData.body));

      if(subjectsData.subjectsData != null)

        for(int i=0 ; i< subjectsData.subjectsData.length ; i++)
        {
          if(int.parse(subjectsData.subjectsData[i].count) > 0)
            subjectName.add(subjectsData.subjectsData[i].subjectName);
        }
      for(int i=0 ; i< subjectsData.subjectsData.length ; i++)
      {
        for(int j=0;j< subjectName.length ; j++)
        {
          //print(subjectsData.subjectsData[i].subjectName);
          if(subjectName[j] == subjectsData.subjectsData[i].subjectName
              && int.parse(subjectsData.subjectsData[i].count) == 0 )
          {
            subjectsData.subjectsData.removeAt(i);
          }
        }
      }
      //print(subjectsData.status);
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
                  height: 125,
                  color: Color(0xFFFFD835),
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(top: 55,left: 160),
                ),
                Container(color: Colors.grey,height: 1.5,),
                Container(

                    width: 350,
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
            Wrap(
              spacing: 48, // gap between adjacent chips
              runSpacing: 32, // gap between lines
              children: <Widget>[
                if(subjectsData.subjectsData != null )
                for(int i=0;i<subjectsData.subjectsData.length;i++)

                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => StudentChapters(subjectsData.subjectsData[i].subjectsId,this.standardUrl)
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
                                Icons.collections_bookmark,
                                size: 50,
                                color: Colors.black54,
                              ),

                            ),
                            if( int.parse(subjectsData.subjectsData[i].count) > 0)
                            Container(
                              padding: EdgeInsets.all(2),
                              margin: EdgeInsets.only(left: 40,top: 4),
                              decoration: BoxDecoration(
                                color: Colors.yellowAccent,
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                              ),
                              child: Text(subjectsData.subjectsData[i].count),

                            ),


                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          child: Text( subjectsData.subjectsData[i].subjectName,style: TextStyle(color: Colors.black54),
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
