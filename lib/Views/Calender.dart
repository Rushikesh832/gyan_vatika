import 'package:flutter/material.dart';
import 'package:gyan_vatika/Models/CalenderModel.dart';
import 'NavDrawer.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Calender extends StatefulWidget {

  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {

  List<String> userData;
  Future<List<String>>  userInfoOffline;
  String id,loginId,district,standard,phoneNumber,email,fullName,parentsName,userIcon;
  CalenderFormat calenderData = CalenderFormat(404,"status Message");
  bool isLoading = false;
  String standardUrl;
  String idValue;

  fetchCalender() async {

    setState(() {
      isLoading = true;
    });


    String uri = "http://navelsoft.com/gayan/calenderAPi.php";

    //print(uri);
    final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});

    if (responseData.statusCode == 200) {

      calenderData = CalenderFormat.fromJson(json.decode(responseData.body));

      //print(calenderData.calenderData[0].event);
       if(calenderData.status == 402)
      {
        showMyDialog(context, calenderData.status.toString(), "No Data");
        Navigator.pop(context);
        Navigator.pop(context);
      }
      if(calenderData.status == 500)
      {
        showMyDialog(context,calenderData.status.toString(), "Do It Again");
        Navigator.pop(context);
        Navigator.pop(context);
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
    this.fetchCalender();

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
                  margin: EdgeInsets.only(top: 20),
                  child: Center(

                    child: Text("Calender",
                      style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.black87),),
                  ),),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 8,right: 8,bottom: 8,top: 1),
              child: Table(

                border: TableBorder.all(color: Colors.black26),
                children: [
                  TableRow(
                      children: [

                    Column(children:[
                      Padding(

                        padding: const EdgeInsets.all(8.0),
                        child: Text('SR NO.',style: TextStyle(fontWeight: FontWeight.bold),),
                      )
                    ]),
                    Column(children:[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Date',style: TextStyle(fontWeight: FontWeight.bold),),
                      )
                    ]),
                    Column(children:[

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Event',style: TextStyle(fontWeight: FontWeight.bold),),
                      )
                    ]),

                  ]),
                  if(calenderData.calenderData != null )
                    for(int i=0;i<calenderData.calenderData.length;i++)
                      TableRow( children: [
                        Center(child: Text((i+1).toString(),
                        style: TextStyle(color: i%2 == 0 ? Colors.green : Colors.blueAccent),)),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                            child: Text(  calenderData.calenderData[i].date.split("-")[2] + "/" + calenderData.calenderData[i].date.split("-")[1] + "/" + calenderData.calenderData[i].date.split("-")[0]
                              ,style: TextStyle(color: i%2 == 0 ? Colors.green : Colors.blueAccent,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(

                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(calenderData.calenderData[i].event
                              ,style: TextStyle(color: i%2 == 0 ? Colors.green : Colors.blueAccent,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                      ]),
                ],
              ),
            ),



          ],
        ),
      ),
    );
  }
}
