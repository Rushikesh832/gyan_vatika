import 'package:flutter/material.dart';
import 'package:gyan_vatika/Models/SimpleResponseFormat.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'dart:core';
import 'NavDrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import 'SignIn.dart';
import 'StudentHomePage.dart';
import 'TeachersHomePage.dart';

class UpdateUserIcon extends StatefulWidget {

  @override
  _UpdateUserIconState createState() => _UpdateUserIconState();
}

class _UpdateUserIconState extends State<UpdateUserIcon> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  String userTypeValue;
  SimpleResponseFormat simpleResponse = SimpleResponseFormat(100,"Status Message");

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

  bool isDeleteCamera = false;
  bool isDeleteGallery = false;

  static final String uploadEndPointGallery =
      'http://navelsoft.com/gayan/uploadUserIconGallery.php';
  static final String deleteGalleryPoint =
      'http://navelsoft.com/gayan/Images/Users/deleteIcon.php';

  static final String uploadEndPointCamera =
      'http://navelsoft.com/gayan/uploadUserIconCamera.php';


  chooseGalleryImage() {
    setState(() {
      fileGallery = ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 50,maxHeight: 480,maxWidth: 480);
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
    fileName =  idValue+"Camera"+"Icon"+fileName;

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
    fileName =  idValue+"Gallery"+"Icon"+fileName;

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

        isDeleteCamera = false;

      });
    }).catchError((error) {
      setStatusCamera(error.toString());
      //print(error.toString());
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

        final idKey = 'id';
        final prefs = await SharedPreferences.getInstance();

        setState(() {
          idValue = prefs.getString(idKey) ?? null;
        });


        final userTypeKey = 'userType';

        setState(() {
          userTypeValue = prefs.getString(userTypeKey) ?? null;
        });

        String uri = "http://navelsoft.com/gayan/updateUserIcon.php";
        ////print(uri);

        var map = new Map<String, dynamic>();

        map['userId'] = idValue;
        if(galleryName != null)
          {
            map['userIcon'] =  galleryName;
          }
        else if(cameraName != null)
          {
            map['userIcon'] = cameraName;
          }
        else
          {
            showMyDialog(context, "Invalid", "Upload Image First or Do it Again.",UpdateUserIcon());
          }




        Map<String, String> headers = {
          "Content-Type": "application/x-www-form-urlencoded"};
        final responseData = await http.post(uri,
            body: map,headers: headers);
        ////print(responseData);
        if (responseData.statusCode == 200) {
          //print(responseData.statusCode);
          simpleResponse = SimpleResponseFormat.fromJson(json.decode(responseData.body));
          //print(simpleResponse.status);
          if (simpleResponse.status == 200) {

            if(galleryName != null)
            {
              final userIconKey = 'userIcon';
              prefs.setString(userIconKey, galleryName);
            }
            else if(cameraName != null)
            {
              final userIconKey = 'userIcon';
              prefs.setString(userIconKey, cameraName);
            }
            else
            {
              showMyDialog(context, "Invalid", "Upload Image First or Do it Again.",UpdateUserIcon());
            }


                if(int.parse(userTypeValue) == 1)
                {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      StudentHomePage()), (Route<dynamic> route) => false);
                }
                else if(int.parse(userTypeValue) == 2)
                {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      TeachersHomePage()), (Route<dynamic> route) => false);
                }
                else
                {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      SignIn()), (Route<dynamic> route) => false);
                }

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



        }
        setState(() {
          isLoading = false;
        });
      }
      else
      {
        showMyDialog(context, "InterNet Connectivity", "Check Internet Connection");
      }
    }
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
                        margin: EdgeInsets.only(left: 25),
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
                      Container(
                          height: 200,
                          width: 200,
                          child: Column(
                            children: <Widget>[
                              showImageGallery(),
                            ],
                          )),
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
                    height: 16.0,
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
                      Container(
                          height: 200,
                          width: 200,
                          child: Column(
                            children: <Widget>[
                              showImageCamera(),
                            ],
                          )),
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
                      child: Text("UpLoad" ,style: TextStyle(
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
