import 'package:flutter/material.dart';
import 'package:gyan_vatika/Models/AssignmentImagesModel.dart';
import 'package:gyan_vatika/Models/AssignmentsModel.dart';
import 'package:gyan_vatika/Models/SimpleResponseFormat.dart';
import 'package:gyan_vatika/Views/CreateAssignments.dart';
import 'package:gyan_vatika/Views/TeacherAssignmentsDetails.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';
import 'NavDrawer.dart';
import 'TeachersHomePage.dart';
import 'EditAssignments.dart';

class TeacherAssignments extends StatefulWidget {

  String classificationId;
  TeacherAssignments(this.classificationId);
  @override
  _TeacherAssignmentsState createState() => _TeacherAssignmentsState();
}

class _TeacherAssignmentsState extends State<TeacherAssignments> {


  List<String> userData;
  Future<List<String>>  userInfoOffline;
  String id,loginId,district,standard,phoneNumber,email,fullName,parentsName,userIcon;
  AssignmentsFormat teacherAssignmentsData = AssignmentsFormat(404,"status Message");
  SimpleResponseFormat simpleResponse = SimpleResponseFormat(100,"Status Message");
  AssignmentImagesModel imagesData = AssignmentImagesModel(100,"status Message");
  bool isLoading = false;
  String idValue;

  static final String deleteGalleryPoint1 =
      'http://navelsoft.com/gayan/Images/Assignments/deleteGallery.php';


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
        setState(() {
      isLoading = true;
    });

    String uri = "http://navelsoft.com/gayan/AssignmentsApi.php?classification_id=" + widget.classificationId ;
    //print(uri);
    final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});
    if (responseData.statusCode == 200) {

      teacherAssignmentsData = AssignmentsFormat.fromJson(json.decode(responseData.body));

      if(teacherAssignmentsData.status == 500)
      {
        showMyDialog(context,teacherAssignmentsData.status.toString(), "Do It Again",TeachersHomePage());
      }


      setState(() {
        isLoading = false;
      });

    }
  }


  deleteAssignment(String Id)
  async {
    setState(() {
      isLoading = true;
    });

    String uri = "http://navelsoft.com/gayan/getAssignmentImages.php?assignment_id=" + Id;
    ////print(uri);
    final responseData = await http.get(
        uri, headers: {'Content-Type': 'application/json'});
    if (responseData.statusCode == 200) {
      imagesData =
          AssignmentImagesModel.fromJson(json.decode(responseData.body));

      if (imagesData.status == 500) {
        showMyDialog(context, imagesData.status.toString(),
            "Do It Again to Load Images");
      }
    }

      if (imagesData.assignmentsImagesData != null)
        for (int i = 0; i <
            imagesData.assignmentsImagesData.length; i++) {
          delete(imagesData.assignmentsImagesData[i].image,
              imagesData.assignmentsImagesData[i].id);
        }

      String uri1 = "http://navelsoft.com/gayan/AssignmentsApi.php?id=" + Id;

      //print(uri1);

      final responseData1 = await http.delete(uri1);
      //print(responseData1.statusCode);
      if (responseData1.statusCode == 200) {
        simpleResponse =
            SimpleResponseFormat.fromJson(json.decode(responseData1.body));
        //print(simpleResponse.statusMessage);


        if (simpleResponse.status == 200) {
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) =>
                  TeacherAssignments(widget.classificationId)
          ));
        }
        else {
          showMyDialog(context, simpleResponse.status.toString(),
              "Error While Deleting Assignments.");
        }

        setState(() {
          isLoading = false;
        });
      }

  }

  delete(String fileName,String id) async {

    var map = new Map<String, String>();

    map['delete_file'] = fileName.toString();

    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded"};

    http.post(deleteGalleryPoint1, body: map,headers: headers ).then((result) async {

      String uri = "http://navelsoft.com/gayan/getAssignmentImages.php";

      var map = new Map<String, String>();

      map['id'] = id;

      Map<String, String> headers = {
        "Content-Type": "application/x-www-form-urlencoded"};
      final responseData = await http.post(uri,
          body: map,headers: headers);
      ////print(responseData);
      if (responseData.statusCode == 200) {
        simpleResponse = SimpleResponseFormat.fromJson(json.decode(responseData.body));

        if (simpleResponse.status == 200) {
          (context as Element).reassemble();
        }
        else if (simpleResponse.status == 500) {
          showMyDialog(context, "error", simpleResponse.statusMessage);
        }
        else {
          showMyDialog(context, "error", "Enter Data Again");
        }

      }

    }).catchError((error) {
      //print(error.toString());
    });
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
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width/2,
                  padding: EdgeInsets.only(bottom: 32,top: 4),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => CreateAssignments(widget.classificationId)
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
                              color: Colors.blueAccent,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 16),
                            child: Text( "Post Assignment"
                              ,style: TextStyle(color: Colors.black54),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                if(teacherAssignmentsData.assignmentsData != null )
                  for(int i=0;i<teacherAssignmentsData.assignmentsData.length;i++)
                    Container(
                      width: MediaQuery.of(context).size.width/2,
                      padding: EdgeInsets.only(bottom: 32),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => TeachersAssignmentsDetails(teacherAssignmentsData.assignmentsData[i])
                          ));
                        },
                        onLongPress: ( )
                        {
                          showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(80,300,100,0),
                            items: [
                              PopupMenuItem(
                                child: InkWell(
                                    onTap: ()
                                    async {
                                      String uri = "http://navelsoft.com/gayan/"
                                          "getAssignmentImages.php?assignment_id=" + teacherAssignmentsData.assignmentsData[i].id;
                                      ////print(uri);
                                      final responseData = await http.get(
                                          uri, headers: {'Content-Type': 'application/json'});
                                      if (responseData.statusCode == 200) {
                                        imagesData =
                                            AssignmentImagesModel.fromJson(json.decode(responseData.body));

                                        if (imagesData.status == 500) {
                                          showMyDialog(context, imagesData.status.toString(),
                                              "Do It Again to Load Images");
                                        }
                                      }

                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => EditAssignments(teacherAssignmentsData.assignmentsData[i],imagesData)
                                      ));
                                    },
                                    child: Container(
                                        padding : EdgeInsets.only(left: 24,top: 16,bottom: 16,right: 24),
                                        child: Text("Edit"),

                                    )),
                              ),
                              PopupMenuItem(
                                child: InkWell(
                                    onTap: ()
                                    {
                                      deleteAssignment(teacherAssignmentsData.assignmentsData[i].id);
                                    },
                                    child:Container(
                                        padding : EdgeInsets.only(left: 24,top: 16,bottom: 16,right: 24),
                                    child:Text("Delete"))),
                              ),

                            ],
                            elevation: 8.0,
                          );
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
                                child: Text( teacherAssignmentsData.assignmentsData[i].assignmentNo +" "+ teacherAssignmentsData.assignmentsData[i].assignmentName
                                  ,style: TextStyle(color: Colors.black54),
                                ),
                              ),
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
