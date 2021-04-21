import 'package:flutter/material.dart';
import 'package:gyan_vatika/Models/TopicQueriesModel.dart';
import 'NavDrawer.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';

class ShowQueries extends StatefulWidget {

  Queries query;
  ShowQueries(this.query) : super();

  @override
  _ShowQueriesState createState() => _ShowQueriesState();
}

class _ShowQueriesState extends State<ShowQueries> {

  String id,loginId,district,standard,phoneNumber,email,fullName,parentsName,userIcon;
  List<String> userData;
  Future<List<String>>  userInfoOffline;


  loadUserData()
  {
    userInfoOffline = read();
    userInfoOffline.then((data){
      setState(() {
        userData = data;
        fullName = userData[6];
        standard = userData[3];
        userIcon = userData[11];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.loadUserData();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Center(child: Text("GYAN VATIKA",style: TextStyle(color: Colors.black),) ),
        backgroundColor: Color(0xFFFFA300),
      ),
      body:  SingleChildScrollView(
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
            SizedBox(height: 12,),
            Container(
              margin: EdgeInsets.only(left: 24,top: 16,bottom: 8,right: 8),
              width: MediaQuery.of(context).size.width,
              child: Text( widget.query.question != null ? "Q. "+widget.query.question : "Question" ,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
            ),
            SizedBox(height: 12,),
            Container(
              margin: EdgeInsets.only(left: 24,top: 8,bottom: 8,right: 8),
              width: MediaQuery.of(context).size.width,
              child: Text(widget.query.answer != null ? "Ans :- "+widget.query.answer : "Answer Yet To Be Discovered." ,
                  style: TextStyle(fontSize: 16)),
            ),





          ],
        ),
      ),
    );
  }
}
