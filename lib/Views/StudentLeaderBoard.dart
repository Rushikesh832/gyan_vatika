import 'package:flutter/material.dart';
import 'package:gyan_vatika/Models/LeaderBoardModel.dart';
import 'NavDrawer.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentLeaderBoard extends StatefulWidget {


  String subject;
  String standard;
  StudentLeaderBoard(this.standard,this.subject);

  @override
  _StudentLeaderBoardState createState() => _StudentLeaderBoardState();
}

class _StudentLeaderBoardState extends State<StudentLeaderBoard> {

  List<String> userData;
  Future<List<String>>  userInfoOffline;
  String id,loginId,district,standard,phoneNumber,email,fullName,parentsName,userIcon;
  LeaderBoardFormat leaderBoardData = LeaderBoardFormat(404,"status Message");
  bool isLoading = false;
  String standardUrl;
  String idValue;
  double iconSize = 40;
  int ranking = 1;

  loadLeaderBoardData() async {
    /*Future<bool> futureConnection = checkInterNetConnection();
    futureConnection.then((value) =>
    {
      checkInternetConnection = value
    });*/
    /* if (checkInternetConnection) {
      if (formKey.currentState.validate()) {*/




    String  uri = "http://navelsoft.com/gayan/leaderBoardApi.php?standard="+widget.standard+"&subject="+widget.subject;


    ////print(uri);
    final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});

    if (responseData.statusCode == 200) {

      leaderBoardData = LeaderBoardFormat.fromJson(json.decode(responseData.body));
      if(leaderBoardData.status == 200)
        {
          leaderBoardData.leaderBoardData.sort((b,a) => a.ratingSum.compareTo(b.ratingSum));
        }
      else if(leaderBoardData.status == 402)
      {
        showMyDialog(context, leaderBoardData.status.toString(), "No Data");
        Navigator.pop(context);
        Navigator.pop(context);
      }
      if(leaderBoardData.status == 500)
      {
        showMyDialog(context,leaderBoardData.status.toString(), "Do It Again");
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

  incrementCounter()
  {
    ranking = ranking +1;
    return ranking;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.loadLeaderBoardData();

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
                  height: 70,
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
            Column(
              children: <Widget>[

                    Center(
                    child: Column(children: <Widget>[
                    Container(
                    margin: EdgeInsets.all(8),
                    child: Table(
                    border: TableBorder.all(),
                    children: [
                    TableRow(  children: [

                    Column(children:[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Rank',style: TextStyle(fontWeight: FontWeight.bold),),
                      )
                    ]),
                    Column(children:[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Full Name',style: TextStyle(fontWeight: FontWeight.bold),),
                      )
                    ]),
                      Column(children:[

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Score',style: TextStyle(fontWeight: FontWeight.bold),),
                        )
                      ]),

                    ]),
                      if(leaderBoardData.leaderBoardData != null )
                        for(int i=0;i<leaderBoardData.leaderBoardData.length;i++)
                    TableRow( children: [
                    Center(child: Text((i+1).toString())),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: Text(leaderBoardData.leaderBoardData[i].fullName
                            ,style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      ),
                      leaderBoardData.leaderBoardData[i].ratingSum != null ? Center(
                        child: Text(  leaderBoardData.leaderBoardData[i].ratingSum
                            ,style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold)),
                      ) : Center(
                        child: Text( "Result \n Awaited"
                            ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                      )

                    ]),
                    ],
                    ),
                    ),
                    ])),
    ],
            ),



          ],
        ),
      ),
    );
  }
}
