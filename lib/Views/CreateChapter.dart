import 'package:flutter/material.dart';
import 'package:gyan_vatika/Models/SimpleResponseFormat.dart';
import 'package:gyan_vatika/Views/TeacherChapters.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'dart:core';
import 'NavDrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'RercordingPlayer.dart';

class CreateChapter extends StatefulWidget {
  String classificationId;
  CreateChapter(this.classificationId);
  @override
  _CreateChapterState createState() => _CreateChapterState();
}

class _CreateChapterState extends State<CreateChapter> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  SimpleResponseFormat simpleResponse = SimpleResponseFormat(100,"Status Message");
  TextEditingController chapterNo = new TextEditingController();
  TextEditingController chapterName = new TextEditingController();
  TextEditingController topicNo = new TextEditingController();
  TextEditingController topicName = new TextEditingController();
  TextEditingController topicContent = new TextEditingController();
  TextEditingController youtubeUrl = new TextEditingController();
  bool checkInternetConnection = true;
  String _information = 'No';
  String districtValue;
  void updateInformation(String information) {
    setState(() => _information = information);
    //print(_information);
  }

  void moveToSecondPage(String data) async {
    final information = await Navigator.push(
      context,
      MaterialPageRoute(
          fullscreenDialog: true, builder: (context) => RecordingPlayer("Topic",data)),
    );
    updateInformation(information);
  }



  /*String idValue;
  Future<File> fileGallery;
  String galleryStatus = '';
  String base64ImageGallery;
  File tmpFileGallery;
  String errMessageGallery = 'Error Uploading Gallery Image.';
  String galleryName = '';

  Future<File> fileCamera;
  String statusCamera = '';
  String base64ImageCamera;
  File tmpFileCamera;
  String errMessageCamera = 'Error Uploading Camera Image';
  String cameraName = '';

  static final String uploadEndPointGallery = 'http://navelsoft.com/gayan/uploadGalleryTopics.php';

  static final String uploadEndPointCamera = 'http://navelsoft.com/gayan/uploadCameraTopics.php';


  chooseGalleryImage() {
    setState(() {
      fileGallery = ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 90,maxHeight: 540,maxWidth: 540);
    });
  }

  chooseImageCamera() {
    setState(() {
      fileCamera = ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 60,maxHeight: 500,maxWidth: 500)
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
    fileName =  idValue+"Camera"+"Chapter"+fileName;

    setState(() {
      cameraName = fileName;
    });
    http.post(uploadEndPointCamera, body: {
      "image": base64ImageCamera,
      "name": fileName,
    }).then((result) {
      setStatusCamera(result.statusCode == 200 ? result.body : errMessageCamera);
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
    fileName =  idValue+"Gallery"+"Chapter"+fileName;

    setState(() {
      galleryName = fileName;
    });
    http.post(uploadEndPointGallery, body: {
      "image": base64ImageGallery,
      "name": fileName,
    }).then((result) {
      setStatusGallery(result.statusCode == 200 ? result.body : errMessageGallery);
    }).catchError((error) {
      setStatusGallery(error);
    });
  }*/

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

  static final String deleteGalleryPoint =
      'http://navelsoft.com/gayan/Images/Topics/deleteGallery.php';

  static final String uploadEndPointGallery = 'http://navelsoft.com/gayan/uploadGalleryTopics.php';

  static final String uploadEndPointCamera = 'http://navelsoft.com/gayan/uploadCameraTopics.php';


  chooseGalleryImage() {
    setState(() {
      fileGallery = ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 90,maxHeight: 540,maxWidth: 540);
    });
  }

  chooseImageCamera() {
    setState(() {
      fileCamera = ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 75,maxHeight: 500,maxWidth: 500);
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
      setStatusGallery(error);
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

      final prefs = await SharedPreferences.getInstance();
      final districtKey = 'district';

      setState(() {
        districtValue = prefs.getString(districtKey) ?? null;
      });

      String uri = "http://navelsoft.com/gayan/topicsApi.php";
      var galleryNamePost = galleryNameArray.join("   ");
      var cameraNamePost = cameraNameArray.join("   ");
      ////print(uri);
      var map = new Map<String, String>();

      String assingmentContentFilter = chapterName.text.replaceAll("'", "\\'");
      String assingmentContentFilterFinal = assingmentContentFilter.replaceAll('"', '\\"');
      String assingmentNameFilter = topicName.text.replaceAll("'", "\\'");
      String assingmnetNameFinalFilter = assingmentNameFilter.replaceAll('"', '\\"');

      String topicContentFilter = topicContent.text.replaceAll("'", "\\'");
      String topicContentFilterFinal = topicContentFilter.replaceAll('"', '\\"');


      map['chapter_name'] = assingmentContentFilterFinal;
      map['topic_no'] = topicNo.text;
      map['topic_name'] = assingmnetNameFinalFilter;
      map['topic_content'] = topicContentFilterFinal;
      map['classification_id'] = widget.classificationId;
      map['chapter_no'] = chapterNo.text;
      map['galleryImage'] = galleryNamePost;
      map['cameraImage'] = cameraNamePost;
      map['youtubeUrl'] = youtubeUrl.text;
      map['district'] = districtValue;
      if(_information != "No" && _information !=null)
        {
          map["audio"] = _information;
        }


      Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded"};
      final responseData = await http.post(uri,
          body: map,headers: headers);
      ////print(responseData);
      if (responseData.statusCode == 200) {
        simpleResponse =
            SimpleResponseFormat.fromJson(json.decode(responseData.body));
        //print(simpleResponse);

        if (simpleResponse.status == 200) {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => TeacherChapters(widget.classificationId)
          ));
        }
        else if (simpleResponse.status == 402) {
          showMyDialog(context, "Invalid", simpleResponse.statusMessage);
        }
        else if (simpleResponse.status == 500) {
          showMyDialog(context, "error", simpleResponse.statusMessage);
        }
        else {
          showMyDialog(context, "error", "Enter Data Again");
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
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
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

                  /*OutlineButton(
                    onPressed: chooseGalleryImage,
                    child: Text('Choose Gallery Image'),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                      height: 200,
                      width: 200
                      ,child: Column(
                    children: <Widget>[
                      showImageGallery(),
                    ],
                  )),
                  SizedBox(
                    height: 20.0,
                  ),
                  OutlineButton(
                    onPressed: startUploadGallery,
                    child: Text('Upload Gallery Image'),
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
                  OutlineButton(
                    onPressed: chooseImageCamera,
                    child: Text('Choose  Camera Image'),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 200,
                    width: 200,
                    child: Column(
                      children: <Widget>[
                        showImageCamera(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  OutlineButton(
                    onPressed: startUploadCamera,
                    child: Text('Upload Camera Image'),
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
                  ),*/

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
                      controller: youtubeUrl,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
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
                  _information == "No"  ||  _information == null ?
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
                  SizedBox(
                    height: 20.0,
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
                      child: Text("Post" ,style: TextStyle(
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
