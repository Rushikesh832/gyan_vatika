import 'package:flutter/material.dart';
import 'package:gyan_vatika/Models/AssessmentImagesModel.dart';
import 'package:gyan_vatika/Models/AssignmentsModel.dart';
import 'package:gyan_vatika/Models/SimpleResponseFormat.dart';
import 'package:gyan_vatika/Views/StudentAssignmentsDetails.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'dart:core';
import 'NavDrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';


class CreateAssessment extends StatefulWidget {
   String assignmentID,assessmentContent,userId,mode,assessmentId;
   Assignments assignmentDetails;

  CreateAssessment(this.assignmentID,this.userId,this.assessmentContent,this.assessmentId,this.mode,this.assignmentDetails) : super();
  @override
  _CreateAssessmentState createState() => _CreateAssessmentState();
}

class _CreateAssessmentState extends State<CreateAssessment> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  SimpleResponseFormat simpleResponse = SimpleResponseFormat(100,"Status Message");
  TextEditingController assessmentContent = new TextEditingController();
  AssessmentImageModel imageData = AssessmentImageModel(100,"status message");
  bool checkInternetConnection = true;


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
      'http://navelsoft.com/gayan/uploadAssessmentGallery.php';
  static final String deleteGalleryPoint =
      'http://navelsoft.com/gayan/Images/Assessment/deleteGallery.php';

  static final String uploadEndPointCamera =
      'http://navelsoft.com/gayan/uploadAssessmentCamera.php';


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
    fileName =  idValue+"Camera"+"Assignment"+fileName;

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
      setStatusCamera(error.toString());
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
    fileName =  idValue+"Gallery"+"Assignment"+fileName;

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


  createAssessment()
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

        var galleryNamePost = galleryNameArray.join("   ");
        var cameraNamePost = cameraNameArray.join("   ");
        //print(galleryNamePost);
        //print(cameraNamePost);
        String uri = "http://navelsoft.com/gayan/AssesmentApi.php";
        ////print(uri);
        var map = new Map<String, String>();
        String TopicContent1 = assessmentContent.text.replaceAll("'", "\\'");
        String TopicContent = TopicContent1.replaceAll('"', '\\"');

        map['assignment_id'] = widget.assignmentID;
        map['user_id'] = widget.userId;
        map['assesment_content'] = TopicContent;
        map['galleryImage'] = galleryNamePost;
        map['cameraImage'] = cameraNamePost;

        Map<String, String> headers = {
          "Content-Type": "application/x-www-form-urlencoded"};
        final responseData = await http.post(uri,
            body: map, headers: headers);
        ////print(responseData);
        if (responseData.statusCode == 200) {
          simpleResponse =
              SimpleResponseFormat.fromJson(json.decode(responseData.body));

          if (simpleResponse.status == 200) {
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) =>
                    StudentAssignmentDetails(widget.assignmentDetails)
            ));
          }
          else if (simpleResponse.status == 402) {
            showMyDialog(context, "Invalid", simpleResponse.statusMessage);
            Navigator.pop(context);
            Navigator.pop(context);
          }
          else if (simpleResponse.status == 500) {
            showMyDialog(context, "error", simpleResponse.statusMessage);
            Navigator.pop(context);
            Navigator.pop(context);
          }
          else {
            showMyDialog(context, "error", "Enter Data Again");
            Navigator.pop(context);
          }


          setState(() {
            isLoading = false;
          });
        }
      }
    }
    else
    {
      showMyDialog(context, "InterNet Connectivity", "Check Internet Connection");
    }

  }
  updateAssessment()
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

      String uri = "http://navelsoft.com/gayan/AssesmentApi.php";
      var galleryNamePost = galleryNameArray.join("   ");
      var cameraNamePost = cameraNameArray.join("   ");
      //print(galleryNamePost);
      //print(cameraNamePost);
      ////print(uri);
      Map<String, String> data = {
        "assignment_id":widget.assignmentID,
        "user_id":widget.userId,
        "assesment_content": assessmentContent.text,
        "galleryImage" : galleryNamePost,
        "cameraImage" : cameraNamePost,
        "assessement_id" : widget.assessmentId
      };
      var body = json.encode(data);

      Map<String, String> headers = {
        "Content-Type": "application/json"};
      final responseData = await http.put(uri,
          body: body,headers: headers);
      ////print(responseData);
      if (responseData.statusCode == 200) {
        simpleResponse = SimpleResponseFormat.fromJson(json.decode(responseData.body));
        ////print(simpleResponse.status);
        ////print(simpleResponse.statusMessage);

        if (simpleResponse.status == 200) {
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => StudentAssignmentDetails(widget.assignmentDetails)
          ));
        }
        else if (simpleResponse.status == 402) {
          showMyDialog(context, "Invalid", simpleResponse.statusMessage);
          Navigator.pop(context);
          Navigator.pop(context);
        }
        else if (simpleResponse.status == 500) {
          showMyDialog(context, "error", simpleResponse.statusMessage);
          Navigator.pop(context);
          Navigator.pop(context);
        }
        else {
          showMyDialog(context, "error", "Enter Data Again");
          Navigator.pop(context);
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


  assessmentImages() async {
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

    String uri = "http://navelsoft.com/gayan/getAssessmentImage.php?assessment_id="+widget.assessmentId;
    //print(uri);
    final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});
    if (responseData.statusCode == 200) {

      imageData = AssessmentImageModel.fromJson(json.decode(responseData.body));
      //print(imageData.status);

      if(imageData.status == 500)
      {
        showMyDialog(context,imageData.status.toString(), "Do It Again to Load Images");
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


  delete(String fileName,String id) async {

    var map = new Map<String, String>();

    map['delete_file'] = fileName.toString();

    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded"};

    http.post(deleteGalleryPoint, body: map,headers: headers ).then((result) async {

      String uri = "http://navelsoft.com/gayan/getAssessmentImage.php";

      var map = new Map<String, String>();

      map['id'] = id;

      Map<String, String> headers = {
        "Content-Type": "application/x-www-form-urlencoded"};
      final responseData = await http.post(uri,
          body: map,headers: headers);
      ////print(responseData);
      if (responseData.statusCode == 200) {
        simpleResponse = SimpleResponseFormat.fromJson(json.decode(responseData.body));

        //print(simpleResponse.status);

        if (simpleResponse.status == 200) {
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => StudentAssignmentDetails(widget.assignmentDetails)
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
    assessmentContent.text = widget.assessmentContent;
    this.assessmentImages();
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
                            : "Enter Assessment Data";
                      },
                      controller: assessmentContent,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Enter Assessment Data",
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
                  if(imageData.assessmentImagesData != null)
                    for (int i=0 ; i < imageData.assessmentImagesData.length ;i++)
                      Row(
                        children: <Widget>[
                          Container(
                            height: 300,
                            width: 300,
                            padding: EdgeInsets.all(16),
                            child: Image.network("http://navelsoft.com/gayan/images/Assessment/"+ imageData.assessmentImagesData[i].image),
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
                                  delete(imageData.assessmentImagesData[i].image,imageData.assessmentImagesData[i].id);
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
                  SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(height: 16,),
                  GestureDetector(
                    onTap: (){
                      if(widget.mode == "Create")
                        {
                          createAssessment();
                        }
                      else if(widget.mode == "Update")
                        {
                          updateAssessment();
                        }

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
                      child: Text(widget.mode == "Create" ? "Post" : "Update" ,style: TextStyle(
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
