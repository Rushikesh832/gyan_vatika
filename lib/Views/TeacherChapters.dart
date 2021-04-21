import 'package:flutter/material.dart';
import 'package:gyan_vatika/Models/ChaptersModel.dart';
import 'package:gyan_vatika/Models/SimpleResponseFormat.dart';
import 'package:gyan_vatika/Models/TopicImageModel.dart';
import 'package:gyan_vatika/Models/TopicModel.dart';
import 'package:gyan_vatika/Views/CreateChapter.dart';
import 'package:gyan_vatika/Views/EditChapters.dart';
import 'package:gyan_vatika/Views/TeachersTopics.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'dart:core';
import 'NavDrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'TeachersHomePage.dart';

class TeacherChapters extends StatefulWidget {
  String classificationId;
  TeacherChapters(this.classificationId);
  @override
  _TeacherChaptersState createState() => _TeacherChaptersState();
}

class _TeacherChaptersState extends State<TeacherChapters> {
  List<String> userData;
  Future<List<String>>  userInfoOffline;
  String id,loginId,district,standard,phoneNumber,email,fullName,parentsName,userIcon;
  ChaptersFormat teacherChapters = ChaptersFormat(404,"status Message");
  TopicFullFormat topicDetails = TopicFullFormat(404,"status Message");
  static final String deleteGalleryPoint1 =
      'http://navelsoft.com/gayan/Images/Topics/deleteGallery.php';
  SimpleResponseFormat simpleResponse = SimpleResponseFormat(100,"Status Message");
  TopicImageModel imagesData = TopicImageModel(100,"status Message");
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

  chapters() async {

    setState(() {
      isLoading = true;
    });
    String uri = "http://navelsoft.com/gayan/Chaptersapi.php?classification_id=" + widget.classificationId;
    print(uri);
    final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});
    if (responseData.statusCode == 200) {

      teacherChapters = ChaptersFormat.fromJson(json.decode(responseData.body));

      if(teacherChapters.status == 500)
      {
        showMyDialog(context,teacherChapters.status.toString(), "Do It Again",TeachersHomePage());
      }


      setState(() {
        isLoading = false;
      });
    }
  }


  deleteChapter(String chapterId) async {

    setState(() {
      isLoading = true;
    });

    String uri = "http://navelsoft.com/gayan/topicsApi.php?chapter_id=" + chapterId;
    ////print(uri);
    final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});
    if (responseData.statusCode == 200) {

      topicDetails = TopicFullFormat.fromJson(json.decode(responseData.body));

      if(topicDetails.status == 200)
      {


        for(int i=0;i< topicDetails.topicsData.length ; i++)
          {
            String uri = "http://navelsoft.com/gayan/getTopicsImages.php?topic_id=" + topicDetails.topicsData[i].id ;
            ////print(uri);
            final responseData1 = await http.get(uri,headers: {'Content-Type': 'application/json'});
            if (responseData1.statusCode == 200) {

              imagesData = TopicImageModel.fromJson(json.decode(responseData1.body));

              if(imagesData.topicImagesData != null)
              for(int i=0;i<imagesData.topicImagesData.length ; i++)
              {
                delete(imagesData.topicImagesData[i].image,imagesData.topicImagesData[i].id);
              }


              String uri = "http://navelsoft.com/gayan/topicsApi.php?id=" + topicDetails.topicsData[i].id;

              final responseData = await http.delete(uri);
              if (responseData.statusCode == 200) {
                simpleResponse =
                    SimpleResponseFormat.fromJson(json.decode(responseData.body));


                if (simpleResponse.status == 200) {
                  String uri = "http://navelsoft.com/gayan/Chaptersapi.php?chapter_id=" + chapterId;
                  ////print(uri);

                  final responseData = await http.delete(uri);
                  if (responseData.statusCode == 200) {
                    simpleResponse =
                        SimpleResponseFormat.fromJson(json.decode(responseData.body));


                    if (simpleResponse.status == 200) {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) =>
                              TeacherChapters(widget.classificationId)
                      ));
                    }
                    else {
                      showMyDialog(context, simpleResponse.status.toString(),
                          "Error While Deleting Chapter.");
                    }
                  }
                }
                else {
                  showMyDialog(context, simpleResponse.status.toString(),
                      "Error While Deleting Topic.");
                }
              }



            }
            else if (simpleResponse.status == 402) {
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => TeacherChapters(widget.classificationId)
              ));
            }
            else if (simpleResponse.status == 500) {
              showMyDialog(context, "error", simpleResponse.statusMessage,TeacherChapters(widget.classificationId));
            }
            else {
              showMyDialog(context, "error", "Enter Data Again",TeacherChapters(widget.classificationId));
            }

          }

      }
      else if(topicDetails.status == 402)
        {
          String uri = "http://navelsoft.com/gayan/Chaptersapi.php?chapter_id=" + chapterId;
          ////print(uri);

          final responseData = await http.delete(uri);
          if (responseData.statusCode == 200) {
            simpleResponse =
                SimpleResponseFormat.fromJson(json.decode(responseData.body));


            if (simpleResponse.status == 200) {
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) =>
                      TeacherChapters(widget.classificationId)
              ));
            }
            else {
              showMyDialog(context, simpleResponse.status.toString(),
                  "Error While Deleting Chapter.");
            }
          }
        }
      else if(topicDetails.status == 500)
      {
        showMyDialog(context,topicDetails.status.toString(), "Do It Again",TeachersHomePage());
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

      String uri = "http://navelsoft.com/gayan/getTopicsImages.php";

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
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => TeacherChapters(widget.classificationId)
          ));
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
    this.chapters();
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
                          builder: (context) => CreateChapter(widget.classificationId)
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
                            child: Text( "Post Chapter"
                              ,style: TextStyle(color: Colors.black54),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                if(teacherChapters.chaptersData != null)
                  for(int i=0;i<teacherChapters.chaptersData.length;i++)
                    Container(
                      width: MediaQuery.of(context).size.width/2,
                      padding: EdgeInsets.only(bottom: 32),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => TeachersTopics(teacherChapters.chaptersData[i].id)
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
                                        {
                                          Navigator.push(context, MaterialPageRoute(
                                              builder: (context) => EditChapters(teacherChapters.chaptersData[i])
                                          ));
                                        },
                                        child: Container(
                                            padding : EdgeInsets.only(left: 24,top: 16,bottom: 16,right: 24),
                                            child: Text("Edit"))),
                                  ),
                                  PopupMenuItem(
                                    child: InkWell(
                                        onTap: ()
                                        {
                                          deleteChapter(teacherChapters.chaptersData[i].id);
                                        },
                                        child: Container(
                                            padding : EdgeInsets.only(left: 24,top: 16,bottom: 16,right: 24),
                                            child: Text("Delete"))),
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
                                child: Text( "Chapter -"+teacherChapters.chaptersData[i].chapterNo
                                  ,style: TextStyle(color: Colors.black54),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                child: Text(teacherChapters.chaptersData[i].chapterName
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

