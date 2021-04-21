import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:gyan_vatika/Models/TopicImageModel.dart';
import 'package:gyan_vatika/Models/TopicModel.dart';
import 'package:gyan_vatika/Models/TopicUrlFormat.dart';
import 'package:gyan_vatika/Views/AudioDemo.dart';
import 'package:gyan_vatika/Views/EditChapter.dart';
import 'package:gyan_vatika/Views/TeacherTopicQueries.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:core';
import 'NavDrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TeachersTopicDetails extends StatefulWidget {

  Topics teacherTopicsDetails ;
  TeachersTopicDetails(this.teacherTopicsDetails);

  @override
  _TeachersTopicDetailsState createState() => _TeachersTopicDetailsState();
}

class _TeachersTopicDetailsState extends State<TeachersTopicDetails> {
  List<String> userData;
  Future<List<String>>  userInfoOffline;
  String id,loginId,district,standard,phoneNumber,email,fullName,parentsName,userIcon;
  TopicImageModel imagesData = TopicImageModel(100,"status Message");
  TopicUrlFormat urlData = TopicUrlFormat(100,"status Message");
  bool isLoading = false;
  String idValue;

  YoutubePlayerController _controller;

  playVideo(String url)
  {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(url),

    );
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


  topicUrls() async {
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

    String uri = "http://navelsoft.com/gayan/topicsUrl.php?topic_id=" + widget.teacherTopicsDetails.id;
    ////print(uri);
    final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});
    if (responseData.statusCode == 200) {

      urlData = TopicUrlFormat.fromJson(json.decode(responseData.body));
      ////print(urlData.status);
      ////print(urlData.statusMessage);

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
  topicImages() async {
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

    String uri = "http://navelsoft.com/gayan/getTopicsImages.php?topic_id=" + widget.teacherTopicsDetails.id ;
    ////print(uri);
    final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});
    if (responseData.statusCode == 200) {

      imagesData = TopicImageModel.fromJson(json.decode(responseData.body));
      ////print(imagesData.status);

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



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.topicUrls();
    this.topicImages();
    this.loadSharedPref();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Center(child: Text("GYAN VATIKA",style: TextStyle(color: Colors.black),) ),
        backgroundColor: Color(0xFFFFA300),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit,color: Colors.black,),
            onPressed: () {
              if(imagesData != null && urlData != null )
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => EditChapter(widget.teacherTopicsDetails,imagesData,urlData)
              ));
            },
          ),
        ],
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
                InkWell(
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => TeacherTopicQueries(widget.teacherTopicsDetails.id)
                    ));
                  },

                  child: Container(
                    width: 110,
                    height: 50,
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/5,left: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: Colors.blueAccent

                    ),
                    child: Center(child: Text("Query",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70
                        ) )),
                  ),
                ),

              ],
            ),
            SizedBox(height: 16,),
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text(widget.teacherTopicsDetails.topicNo + ". " + widget.teacherTopicsDetails.topicName),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text(widget.teacherTopicsDetails.topicContents),
                ),

                widget.teacherTopicsDetails.audio != null && widget.teacherTopicsDetails.audio.isNotEmpty ?
                InkWell(
                    onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => AudioDemo(widget.teacherTopicsDetails.audio,"Topics")
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
                        .hasMatch(urlData.topicUrlData[i].videoUrl)  ?
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
                    ) : Text( urlData.topicUrlData[i].videoUrl.isNotEmpty ?  "Enter Valid Youtube Url" : "",style: TextStyle(color: Colors.red),),

                if(imagesData.topicImagesData != null)
                  for (int i=0 ; i < imagesData.topicImagesData.length ;i++)
                    Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 1),
                      child: PhotoView(
                        enableRotation: true,
                        backgroundDecoration: BoxDecoration(
                          color: Colors.white,),
                        imageProvider:
                        CachedNetworkImageProvider("http://navelsoft.com/gayan/images/Topics/" + imagesData.topicImagesData[i].image),
                      ),
                      /*Image.network("http://navelsoft.com/gayan/images/Topics/" + imagesData.topicImagesData[i].image),*/
                    ),
              ],
            )



          ],
        ),
      ),
    );
  }
}
