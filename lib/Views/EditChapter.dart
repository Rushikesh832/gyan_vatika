import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gyan_vatika/Models/SimpleResponseFormat.dart';
import 'package:gyan_vatika/Models/TopicImageModel.dart';
import 'package:gyan_vatika/Models/TopicUrlFormat.dart';
import 'package:gyan_vatika/Views/TeachersTopics.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'package:gyan_vatika/Models/TopicModel.dart';
import 'dart:core';
import 'NavDrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'RercordingPlayer.dart';
import 'TeachersTopicsDetails.dart';

class EditChapter extends StatefulWidget {
  Topics teacherTopicsDetails ;
  TopicImageModel imageData;
  TopicUrlFormat urlData;

  EditChapter(this.teacherTopicsDetails,this.imageData,this.urlData);
  @override
  _EditChapterState createState() => _EditChapterState();
}

class _EditChapterState extends State<EditChapter> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  SimpleResponseFormat simpleResponse = SimpleResponseFormat(100,"Status Message");
  TextEditingController chapterNo = new TextEditingController();
  TextEditingController chapterName = new TextEditingController();
  TextEditingController topicNo = new TextEditingController();
  TextEditingController topicName = new TextEditingController();
  TextEditingController topicContent = new TextEditingController();
  TextEditingController videoUrl = new TextEditingController();
  bool checkInternetConnection = true;
  String _information = 'No';
  String updatedInformation;
  String audio;

  void updateInformation(String information) {
    setState(() {
      _information = information;
      updatedInformation = information;
    });
  }

  void moveToSecondPage(String data) async {
    final information = await Navigator.push(
      context,
      MaterialPageRoute(
          fullscreenDialog: true, builder: (context) => RecordingPlayer("Topic",data)),
    );
    updateInformation(information);
  }

  static final String deleteGalleryPoint1 =
      'http://navelsoft.com/gayan/Images/Topics/deleteGallery.php';
  static final String deleteGalleryPoint =
      'http://navelsoft.com/gayan/Images/Topics/deleteGallery.php';

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
              builder: (context) => TeachersTopicDetails(widget.teacherTopicsDetails)
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


  String idValue;
  Future<File> fileGallery;
  String galleryStatus = '';
  String base64ImageGallery;
  File tmpFileGallery;
  String errMessageGallery = 'Error Uploading Gallery Image.';
  String galleryName;

  Future<File> fileCamera;
  String statusCamera = '';
  String base64ImageCamera;
  File tmpFileCamera;
  String errMessageCamera = 'Error Uploading Camera Image';
  String cameraName;

  List<String> cameraNameArray = [];
  List<String> galleryNameArray = [];
  bool isNextCamera = false;
  bool isNextGallery = false;
  bool isDeleteCamera = false;
  bool isDeleteGallery = false;

  static final String uploadEndPointGallery =
      'http://navelsoft.com/gayan/uploadGalleryTopics.php';


  static final String uploadEndPointCamera =
      'http://navelsoft.com/gayan/uploadCameraTopics.php';


  chooseGalleryImage() {
    setState(() {
      fileGallery = ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 85);
    });
  }

  chooseImageCamera() {
    setState(() {
      fileCamera = ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 92);
    });
  }

  Widget showImageCamera() {
    return FutureBuilder<File>(
      future: fileCamera,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFileCamera = snapshot.data;
          base64ImageCamera = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }
  setStatusCamera(String message) {
    setState(() {
      statusCamera = message;
    });
  }

  startUploadCamera() {
    setStatusCamera('Uploading Image...');
    if (null == tmpFileCamera) {
      setStatusCamera(errMessageCamera);
      return;
    }
    String fileName = tmpFileCamera.path.split('/').last;
    uploadCamera(fileName);
  }

  uploadCamera(String fileName) async{
    final idKey = 'loginId';
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      idValue = prefs.getString(idKey) ?? null;
    });
    fileName =  idValue+"Camera"+"Topics"+fileName;

    setState(() {
      cameraName = fileName;
    });
    http.post(uploadEndPointCamera, body: {
      "image": base64ImageCamera,
      "name": fileName,
    }).then((result) {
      setStatusCamera(result.statusCode == 200 ? result.body : errMessageCamera);
      if(result.statusCode == 200)
      {
        cameraNameArray.add(cameraName);
        isNextCamera = true;
        isDeleteCamera = true;
      }
    }).catchError((error) {
      setStatusCamera(error);
    });
  }

  Widget showImageGallery() {
    return FutureBuilder<File>(
      future: fileGallery,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFileGallery = snapshot.data;
          base64ImageGallery = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Gallery Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }
  setStatusGallery(String message) {
    setState(() {
      galleryStatus = message;
    });
  }
  startUploadGallery() {
    setStatusGallery('Uploading Image...');
    if (null == tmpFileGallery) {
      setStatusGallery(errMessageGallery);
      return;
    }
    String fileName = tmpFileGallery.path.split('/').last;
    upload(fileName);
  }

  upload(String fileName) async {

    final idKey = 'loginId';
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      idValue = prefs.getString(idKey) ?? null;
    });
    fileName =  idValue+"Gallery"+"Topics"+fileName;

    setState(() {
      galleryName = fileName;
    });
    http.post(uploadEndPointGallery, body: {
      "image": base64ImageGallery,
      "name": fileName,
    }).then((result) {
      setStatusGallery(result.statusCode == 200 ? result.body : errMessageGallery);
      if(result.statusCode == 200)
      {
        galleryNameArray.add(galleryName);
        isNextGallery = true;
        isDeleteGallery = true;
      }
    }).catchError((error) {
      setStatusGallery(error.toString());
    });
  }

  deleteGallery() async {
    setStatusGallery('Deleting Image...');

    var map = new Map<String, String>();

    map['delete_file'] = galleryName.toString();

    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded"};

    http.post(deleteGalleryPoint, body: map,headers: headers ).then((result) {
      setStatusGallery(result.statusCode == 200 ?
      result.body
          : "");
      setState(() {
        fileGallery = null;
        galleryName = '';
        isNextGallery = false;
        galleryNameArray.removeLast();
        isDeleteGallery = false;
      });
    }).catchError((error) {
      setStatusGallery(error.toString());
      //print(error.toString());
    });
  }

  deleteCamera() async {
    setStatusCamera('Deleting Image...');

    var map = new Map<String, String>();

    map['delete_file'] = cameraName.toString();

    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded"};

    http.post(deleteGalleryPoint, body: map,headers: headers ).then((result) {
      setStatusCamera(result.statusCode == 200 ?
      result.body
          : "");
      setState(() {
        fileCamera = null;
        cameraName = '';
        isNextCamera = false;
        isDeleteCamera = false;
        cameraNameArray.removeLast();
      });
    }).catchError((error) {
      setStatusCamera(error.toString());
      //print(error.toString());
    });
  }

  nextCamera()
  {
    setState(() {
      fileCamera = null;
      cameraName = '';
      isNextCamera = false;
    });
  }

  nextGallery()
  {
    setState(() {
      fileGallery = null;
      galleryName = '';
      isNextGallery = false;
    });
  }


  validateForm()
  async {
    Future<bool> futureConnection = checkInterNetConnection();
    futureConnection.then((value) =>{
      checkInternetConnection = value
    } );
    if (checkInternetConnection) {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      String uri = "http://navelsoft.com/gayan/topicsApi.php";
      var galleryNamePost = galleryNameArray.join("   ");
      var cameraNamePost = cameraNameArray.join("   ");
      //print(galleryNamePost);
      //print(cameraNamePost);



      if(_information != "No" && _information != null && _information.isNotEmpty)
      {
        audio = _information;
      }
      String TopicContent1 = topicContent.text.replaceAll("'", "\\'");
      String TopicContent = TopicContent1.replaceAll('"', '\\"');
      String assingmentNameFilter = topicName.text.replaceAll("'", "\\'");
      String assingmnetNameFinalFilter = assingmentNameFilter.replaceAll('"', '\\"');

      String assingmentContentFilter = chapterName.text.replaceAll("'", "\\'");
      String assingmentContentFilterFinal = assingmentContentFilter.replaceAll('"', '\\"');


      Map<String, String> data = {
        "topic_id":widget.teacherTopicsDetails.id,
        "chapter_id":widget.teacherTopicsDetails.chapterId,
        "topic_no":topicNo.text,
        "topic_name":assingmnetNameFinalFilter,
        "topic_content":TopicContent,
        "chapter_name":assingmentContentFilterFinal,
        "classification_id":widget.teacherTopicsDetails.classificationId,
        "chapter_no":chapterNo.text,
        "galleryImage" : galleryNamePost,
        "cameraImage" : cameraNamePost,
        "youtubeUrl" : videoUrl.text,
         "audio" : audio ,
      };
      var body = json.encode(data);
      log(body.toString());
      Map<String, String> headers = {
        "Content-Type": "application/json"};
      final responseData = await http.put(uri,
          body: body,headers: headers);
      ////print(responseData);
      if (responseData.statusCode == 200) {
        simpleResponse =
            SimpleResponseFormat.fromJson(json.decode(responseData.body));

        if (simpleResponse.status == 200) {
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => TeachersTopics(widget.teacherTopicsDetails.chapterId)
          ));
        }
        else if (simpleResponse.status == 402) {
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => TeachersTopics(widget.teacherTopicsDetails.chapterId)
          ));
        }
        else if (simpleResponse.status == 500) {
          showMyDialog(context, "error", simpleResponse.statusMessage,TeachersTopics(widget.teacherTopicsDetails.chapterId));
        }
        else {
          showMyDialog(context, "error", "Enter Data Again",TeachersTopics(widget.teacherTopicsDetails.chapterId));
        }


        setState(() {
          isLoading = false;
        });
      }
       }
    else
    {
      showMyDialog(context, "InterNet Connectivity", "Check Internet Connection");
    }
    }
  }

  deleteTopic()
  async {
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

    if(widget.imageData.topicImagesData != null)
    for(int i=0;i<widget.imageData.topicImagesData.length ; i++)
      {
        delete(widget.imageData.topicImagesData[i].image,widget.imageData.topicImagesData[i].id);
      }


      String uri = "http://navelsoft.com/gayan/topicsApi.php?id=" + widget.teacherTopicsDetails.id;

    final responseData = await http.delete(uri);
    if (responseData.statusCode == 200) {


      simpleResponse = SimpleResponseFormat.fromJson(json.decode(responseData.body));


      if(simpleResponse.status == 200)
      {
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => TeachersTopics(widget.teacherTopicsDetails.chapterId)
        ));
      }
      else
      {
        showMyDialog(context,simpleResponse.status.toString(), "Error While Deleting Assignments.");
      }



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
    chapterNo.text=widget.teacherTopicsDetails.chapterNo;
    chapterName.text = widget.teacherTopicsDetails.chapterName;
    topicNo.text = widget.teacherTopicsDetails.topicNo;
    topicName.text = widget.teacherTopicsDetails.topicName;
    topicContent.text = widget.teacherTopicsDetails.topicContents;
    ////print(widget.urlData.topicUrlData[0].videoUrl);
    if(widget.urlData.topicUrlData != null )
      {
        videoUrl.text = widget.urlData.topicUrlData[0].videoUrl;
      }

    _information = widget.teacherTopicsDetails.audio;
    audio = widget.teacherTopicsDetails.audio;

    //print(widget.teacherTopicsDetails.chapterId);

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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete,color: Colors.red,size: 30,),
            onPressed: () {
              deleteTopic();
            },
          ),
        ],
      ),
      body: isLoading ? successIndicator() : SingleChildScrollView(
        child: Column(
          children: <Widget>[

            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 12,),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 16,right: 16,top: 8,bottom: 5),
                        height: 50,
                        width: MediaQuery.of(context).size.width/6,
                        padding: EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(15))
                        ),
                        child: TextFormField(

                          validator: (val) {
                            return val.isNotEmpty ? null
                                : "Enter Chapter No";
                          },
                          controller: chapterNo,
                          decoration: InputDecoration(
                            hintText: "C No",
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 18,
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none
                            ),
                            errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none
                            ),
                            disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none
                            ),

                          ),

                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 16,top: 8,bottom: 5),
                        height: 50,
                        width: MediaQuery.of(context).size.width-MediaQuery.of(context).size.width/3,
                        padding: EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(15))
                        ),
                        child: TextFormField(

                          validator: (val) {
                            return val.isNotEmpty ? null
                                : "Enter Chapter Name";
                          },
                          controller: chapterName,
                          decoration: InputDecoration(
                            hintText: "Chapter Name",
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 18,
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none
                            ),
                            errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none
                            ),
                            disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none
                            ),

                          ),

                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12,),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(16),
                        height: 50,
                        width: MediaQuery.of(context).size.width/6,
                        padding: EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(15))
                        ),
                        child: Center(
                          child: TextFormField(

                            validator: (val) {
                              return val.isNotEmpty ? null
                                  : "Enter Topic No.";
                            },
                            controller: topicNo,
                            decoration: InputDecoration(
                              hintText: "T No",
                              hintStyle: TextStyle(
                                color: Colors.black54,
                                fontSize: 18,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                            ),

                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 16, 16, 16),
                        height: 50,
                        width: MediaQuery.of(context).size.width-MediaQuery.of(context).size.width/3,
                        padding: EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(15))
                        ),
                        child: Center(
                          child: TextFormField(

                            validator: (val) {
                              return val.isNotEmpty ? null
                                  : "Enter Topic Name";
                            },
                            controller: topicName,
                            decoration: InputDecoration(
                              hintText: "Topic Name",
                              hintStyle: TextStyle(
                                color: Colors.black54,
                                fontSize: 18,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                            ),

                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12,),
                  Container(
                    margin: EdgeInsets.all(16),
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left: 16
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    child: TextFormField(

                      validator: (val) {
                        return val.isNotEmpty ? null
                            : "Enter Topic Content";
                      },
                      controller: topicContent,
                      decoration: InputDecoration(
                        hintText: "Topic Content",
                        hintStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none
                        ),
                        errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none
                        ),
                        disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none
                        ),

                      ),

                    ),
                  ),
                  SizedBox(height: 4,),
                  Container(
                    margin: EdgeInsets.all(16),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left: 16
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    child: TextFormField(

                      validator: (val) {
                        return null;
                      },
                      controller: videoUrl,
                      decoration: InputDecoration(
                        hintText: "Enter Youtube Url",
                        hintStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none
                        ),
                        errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none
                        ),
                        disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none
                        ),

                      ),

                    ),
                  ),
                  _information == "No"  ||  _information == null || _information.isNotEmpty ?
                  InkWell(
                      onTap: ()
                      {
                        moveToSecondPage("Create");
                      },

                      child: Container(
                        height: 60,
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                            color: Colors.blueAccent

                        ),
                        child: Center(child:  Text("Record Your Audio",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white
                            ) )),
                      )
                  ) :
                  InkWell(
                      onTap: ()
                      {

                        moveToSecondPage("Update");
                      },

                      child: Container(
                        height: 60,
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                            color: Colors.green

                        ),
                        child: Center(child:  Text("Update Audio",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white
                            ) )),
                      )
                  ),
                  SizedBox(height: 4,),
                  if(widget.imageData.topicImagesData != null)
                    for (int i=0 ; i < widget.imageData.topicImagesData.length ;i++)
                      Row(
                        children: <Widget>[
                          Container(
                            height: 300,
                            width: 300,
                            padding: EdgeInsets.all(16),
                            child: Image.network("http://navelsoft.com/gayan/images/Topics/"+ widget.imageData.topicImagesData[i].image),
                          ),
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                border: Border.all(width: 1,color: Colors.black)
                            ),
                            child: InkWell(
                                onTap: ()
                                {
                                  delete(widget.imageData.topicImagesData[i].image,widget.imageData.topicImagesData[i].id);
                                },
                                child: Icon(
                                  Icons.cancel,
                                  semanticLabel: "Cancel",
                                  size: 50,
                                )
                            ),
                          )
                        ],
                      ),

                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 12),
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                border: Border.all(width: 1,color: Colors.black)
                            ),
                            child: InkWell(
                                onTap: chooseGalleryImage,
                                child: Icon(
                                  Icons.broken_image,
                                  size: 50,
                                )
                            ),
                          ),
                          isNextGallery ? Container(
                            margin: EdgeInsets.only(left: 12),
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                border: Border.all(width: 1,color: Colors.black)
                            ),
                            child: InkWell(
                                onTap: nextGallery,
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: 50,
                                )
                            ),
                          ) : Text(" ") ,
                        ],
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Container(
                          height: 200,
                          width: 200,
                          child: Column(
                            children: <Widget>[
                              showImageGallery(),
                            ],
                          )),
                      SizedBox(
                        width: 12,
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                border: Border.all(width: 1,color: Colors.black)
                            ),
                            child: InkWell(
                                onTap: startUploadGallery,
                                child: Icon(
                                  Icons.file_upload,
                                  semanticLabel: "Upload",
                                  size: 50,
                                )
                            ),
                          ),
                          isDeleteGallery ? Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                border: Border.all(width: 1,color: Colors.black)
                            ),
                            child: InkWell(
                                onTap: deleteGallery,
                                child: Icon(
                                  Icons.cancel,
                                  semanticLabel: "Cancel",
                                  size: 50,
                                )
                            ),
                          ) : Text(" "),
                        ],
                      ),
                    ],
                  ),



                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    galleryStatus,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 12),
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                border: Border.all(width: 1,color: Colors.black)
                            ),
                            child: InkWell(
                                onTap: chooseImageCamera,
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 50,
                                )
                            ),
                          ),
                          isNextCamera ? Container(
                            margin: EdgeInsets.only(left: 12),
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                border: Border.all(width: 1,color: Colors.black)
                            ),
                            child: InkWell(
                                onTap: nextCamera,
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: 50,
                                )
                            ),
                          ) : Text(" ") ,
                        ],
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Container(
                          height: 200,
                          width: 200,
                          child: Column(
                            children: <Widget>[
                              showImageCamera(),
                            ],
                          )),
                      SizedBox(
                        width: 12,
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                border: Border.all(width: 1,color: Colors.black)
                            ),
                            child: InkWell(
                                onTap: startUploadCamera,
                                child: Icon(
                                  Icons.file_upload,
                                  semanticLabel: "Upload",
                                  size: 50,
                                )
                            ),
                          ),
                          isDeleteCamera ? Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                border: Border.all(width: 1,color: Colors.black)
                            ),
                            child: InkWell(
                                onTap: deleteCamera,
                                child: Icon(
                                  Icons.cancel,
                                  semanticLabel: "Cancel",
                                  size: 50,
                                )
                            ),
                          ) : Text(" "),
                        ],
                      ),
                    ],
                  ),



                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    statusCamera,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 16,),
                  GestureDetector(
                    onTap: (){
                      validateForm();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color:  Color(0xFFFFD835)
                      ),
                      child: Text("Next" ,style: TextStyle(
                          fontSize: 18,
                          color: Colors.black
                      ),),
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
