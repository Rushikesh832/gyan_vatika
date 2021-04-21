import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:gyan_vatika/Models/AssesmentModel.dart';
import 'package:gyan_vatika/Models/AssignmentImagesModel.dart';
import 'package:gyan_vatika/Models/AssignmentsModel.dart';
import 'package:gyan_vatika/Models/SimpleResponseFormat.dart';
import 'package:gyan_vatika/Models/TopicUrlFormat.dart';
import 'package:gyan_vatika/Views/CreateAssesment.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:core';
import 'AudioDemo.dart';
import 'NavDrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StudentAssignmentDetails extends StatefulWidget {

  Assignments assignmentDetails;
  StudentAssignmentDetails(this.assignmentDetails);

  @override
  _StudentAssignmentDetailsState createState() => _StudentAssignmentDetailsState();
}

class _StudentAssignmentDetailsState extends State<StudentAssignmentDetails> {
  List<String> userData;
  Future<List<String>>  userInfoOffline;
  String id,loginId,district,standard,phoneNumber,email,fullName,parentsName,userIcon;
  bool isLoading = false;
  AssignmentImagesModel imagesData = AssignmentImagesModel(100,"status Message");
  AssessmentFormat assessmentData = AssessmentFormat(100,"Status Message");
  SimpleResponseFormat simpleResponse = SimpleResponseFormat(100,"Status Message");
  TopicUrlFormat urlData = TopicUrlFormat(100,"status Message");
  bool checkInternetConnection = true;
  String idValue;
  bool pendingDateOver = false;

  YoutubePlayerController _controller;

  playVideo(String url)
  {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(url));
  }


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

  assignmentImages() async {
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


    String uri = "http://navelsoft.com/gayan/getAssignmentImages.php?assignment_id=" + widget.assignmentDetails.id ;
    //print(uri);
    final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});
    if (responseData.statusCode == 200) {

      imagesData = AssignmentImagesModel.fromJson(json.decode(responseData.body));
      //print(imagesData.status);
      /*//print(imagesData.assignmentsImagesData[0].image);
      //print(imagesData.assignmentsImagesData.length);*/

      if(imagesData.status == 500)
      {
        showMyDialog(context,imagesData.status.toString(), "Do It Again to Load Images");
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

  getAssessment()
  async {
    Future<bool> futureConnection = checkInterNetConnection();
    futureConnection.then((value) =>{
      checkInternetConnection = value
    } );
    if (checkInternetConnection) {



      final standardKey = 'id';
      final prefs = await SharedPreferences.getInstance();

      setState(() {
        idValue = prefs.getString(standardKey) ?? null;
      });

      String uri = "http://navelsoft.com/gayan/AssesmentApi.php?user_id="+idValue+"&assignment_id="+widget.assignmentDetails.id;
      ////print(uri);



      final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});
      ////print(responseData);
      if (responseData.statusCode == 200) {
        assessmentData = AssessmentFormat.fromJson(json.decode(responseData.body));
       // //print(assessmentData.status);

         if (assessmentData.status == 500) {
          showMyDialog(context, "error", "Failed To Load Assessment Details");
        }




       }
    else
    {
      showMyDialog(context, "InterNet Connectivity", "Check Internet Connection");
    }
    }
  }

  changeStatus()
  async {

    final standardKey = 'id';
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      idValue = prefs.getString(standardKey) ?? null;
    });

    String uri = "http://navelsoft.com/gayan/setStatus.php?assignment_id="+ widget.assignmentDetails.id+"&user_id="+idValue;
    ////print(uri);
    final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});
    if (responseData.statusCode == 200) {
      simpleResponse =
          SimpleResponseFormat.fromJson(json.decode(
              responseData.body));
     // //print(simpleResponse.status);
    }
  }

  assignmentUrls() async {
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

    String uri = "http://navelsoft.com/gayan/topicsUrl.php?assignment_id=" + widget.assignmentDetails.id;
    ////print(uri);
    final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});
    if (responseData.statusCode == 200) {

      urlData = TopicUrlFormat.fromJson(json.decode(responseData.body));
      //print(urlData.status);
      ////print(urlData.topicUrlData[0].videoUrl);

      if(urlData.status == 500)
      {
        showMyDialog(context,urlData.status.toString(), "Do It Again to Load Images");
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
  checkGreater()
  {
    final pendingDate = DateTime.parse(widget.assignmentDetails.pendingDate);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
     final parsePendingDate = DateTime(pendingDate.year,pendingDate.month,pendingDate.day);
     if(parsePendingDate.isBefore(today))
       {
         setState(() {
           pendingDateOver = true;
         });

       }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });

    // TODO: implement initState

    this.assignmentImages();
    this.getAssessment();
    this.loadSharedPref();
    this.changeStatus();
    this.assignmentUrls();
    this.checkGreater();
    setState(() {
      isLoading = false;
    });

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
                )
              ],
            ),
            SizedBox(height: 16,),
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text(widget.assignmentDetails.pendingDate != null ? "Pending Date : " + widget.assignmentDetails.pendingDate.split(" ")[0] :" ",
                  style:  TextStyle(fontWeight:  FontWeight.bold),),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text(widget.assignmentDetails.assignmentNo +"."+widget.assignmentDetails.assignmentName),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text(widget.assignmentDetails.assignmentContent),
                ),

                widget.assignmentDetails.audio != null && widget.assignmentDetails.audio.isNotEmpty ?
                InkWell(
                    onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => AudioDemo(widget.assignmentDetails.audio,"Assignment")
                      ));
                    },

                    child: Container(
                      height: 45,
                      margin: EdgeInsets.only(top : 12,left: 48,right: 48),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: Colors.blueAccent

                      ),
                      child: Center(child:  Text("Audio Available",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white
                          ) )),
                    )
                ) : Text(""),
                if(urlData.topicUrlData != null)
                  for (int i=0 ; i < urlData.topicUrlData.length ;i++)
                  RegExp(
                      "/((http\:\/\/){0,}(www\.){0,}(youtube\.com){1} || (youtu\.be){1}(\/watch\?v\=[^\s]){1})/")
                      .hasMatch(urlData.topicUrlData[i].videoUrl) ?
                    InkWell(
                      onTap: playVideo(urlData.topicUrlData[i].videoUrl),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(16),
                            child: Text(urlData.topicUrlData[i].videoUrl,style: TextStyle(color: Colors.blueAccent),),
                          ),
                          YoutubePlayer(
                            controller: _controller,
                          ) ,
                        ],
                      ),
                    ) : Text("Enter Valid Url.",style: TextStyle(color: Colors.red),),
                if(imagesData.assignmentsImagesData != null)
                  for (int i=0 ; i < imagesData.assignmentsImagesData.length ;i++)
                    Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 1),
                      child:
                      PhotoView(
                        enableRotation: true,
                        backgroundDecoration: BoxDecoration(
                          color: Colors.white,),
                        imageProvider:
                        CachedNetworkImageProvider("http://navelsoft.com/gayan/images/Assignments/"+ imagesData.assignmentsImagesData[i].image),
                      ),
                      /*Image.network("http://navelsoft.com/gayan/images/Assignments/"+ imagesData.assignmentsImagesData[i].image),*/
                    ),
              ],
            ),

           !pendingDateOver ? assessmentData.assessmentData != null ?
           assessmentData.assessmentData[0].isComplete == 1.toString() ? Column(
             children: <Widget>[
               SizedBox(height: 32,),
               Container(
                 margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/4,top: 8),
                 child: Row(
                   children: <Widget>[
                     for(int i=0;i < int.parse(assessmentData.assessmentData[0].rating) ; i++)
                       Icon(
                         Icons.star,color: Colors.amber,size: 30,
                       ),
                   ],
                 ),
               ),
               Container(
                 margin: EdgeInsets.only(left:16,top: 8,bottom: 16),
                 decoration: BoxDecoration(
                     borderRadius: BorderRadius.all(Radius.circular(5)),
                     border: Border.all(width: 1)

                 ),

                 child: Center(
                   child: Text(assessmentData.assessmentData[0].review != null ? "Remark:    " + assessmentData.assessmentData[0].review + "\n\n" : " ",
                     style: TextStyle(fontWeight: FontWeight.bold),),
                 ),
               ),
             ],
           ):
           InkWell(
             onTap: ()
             {
               Navigator.push(context, MaterialPageRoute(
                   builder: (context) => CreateAssessment(widget.assignmentDetails.id,idValue,
                       assessmentData.assessmentData[0].assessmentContent,assessmentData.assessmentData[0].id,"Update",widget.assignmentDetails)
               ));
             },
             child: Container(
               height: 60,
               margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/5,left: 15,right: 15),
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.all(Radius.circular(100)),
                   color: Colors.green

               ),
               child: Center(child:  Text("Complete Your Assessment",
                   style: TextStyle(
                       fontSize: 18,
                       color: Colors.white
                   ) )),
             ),
           ) :
           InkWell(
              onTap: ()
              {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => CreateAssessment(widget.assignmentDetails.id,idValue,"","","Create",widget.assignmentDetails)
                ));
              },

              child: Container(
                height: 60,
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/5,left: 15,right: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Colors.blueAccent

                ),
                child: Center(child:  Text("Complete Your Assessment",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white
                    ) )),
              )
            ) :
           Container(
             margin: EdgeInsets.only(top: 48,bottom: 24),
               child: Text("Date Of Completion Is Over.",style: TextStyle(
                 color: Colors.red,
                 fontSize: 19
               ),))




          ],
        ),
      ),
    );
  }
}
