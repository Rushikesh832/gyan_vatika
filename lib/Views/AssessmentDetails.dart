import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/main.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gyan_vatika/Models/AssesmentModel.dart';
import 'package:gyan_vatika/Models/AssessmentImagesModel.dart';
import 'package:gyan_vatika/Models/SimpleResponseFormat.dart';
import 'package:gyan_vatika/Models/UserData.dart';
import 'package:gyan_vatika/Views/TeachersHomePage.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'NavDrawer.dart';
import 'StudentHomePage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';

class AssessmentDetails extends StatefulWidget {
  Assessment assessmentDetails;
  AssessmentDetails(this.assessmentDetails);
  @override
  _AssessmentDetailsState createState() => _AssessmentDetailsState();
}

class _AssessmentDetailsState extends State<AssessmentDetails> {

  bool isLoading = false;
  UserDataFormat userData = UserDataFormat(100,"Status Message");
  String id,loginId,district,standard,phoneNumber,email,fullName,motherName,fatherName;
  String ratingToUpload = 0.toString();
  String ratingToShow = 0.toString();
  AssessmentImageModel imageData = AssessmentImageModel(100,"status message");
  final formKey = GlobalKey<FormState>();
  TextEditingController review = new TextEditingController();
  SimpleResponseFormat simpleResponse = SimpleResponseFormat(100,"Status Message");
  bool checkInternetConnection = true;



  fetchUserData() async {
    Future<bool> futureConnection = checkInterNetConnection();
    futureConnection.then((value) =>
    {
      checkInternetConnection = value
    });
     if (checkInternetConnection) {


    setState(() {
      isLoading = true;
    });


    String uri = "http://navelsoft.com/gayan/fetchUserByid.php?user_id="+widget.assessmentDetails.userId;
    final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});
    ////print(uri);
    if (responseData.statusCode == 200) {
      ////print(responseData.statusCode);

      userData = UserDataFormat.fromJson(json.decode(responseData.body));
      ////print(userData.status);
      if(userData.status == 200)
        {
          fullName = userData.userData[0].fullName;
          standard = userData.userData[0].standard;
          loginId = userData.userData[0].loginId;
          if(widget.assessmentDetails.rating != null)
            {
              setState(() {
                ratingToShow = widget.assessmentDetails.rating;
              });
            }
          else{
            ratingToShow = 0.toString();
          }

        }

      else if(userData.status == 500)
      {
        showMyDialog(context,userData.status.toString(), "Do It Again",StudentHomePage());
      }


      setState(() {
        isLoading = false;
      });




      }
      else {
        showMyDialog(
            context, "InterNet Connectivity", "Check Internet Connection");
      }
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
      ////print(uri);
      Map<String, String> data = {
        "assignment_id":widget.assessmentDetails.assignmentId,
        "user_id":widget.assessmentDetails.userId,
        "assesment_rating": ratingToUpload,
        "assesment_complete_status": 1.toString(),
        "assesment_review": review.text,
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
              builder: (context) => TeachersHomePage()
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


    setState(() {
      isLoading = true;
    });
    /*//print(widget.assessmentDetails.assessmentId);
    //print(widget.assessmentDetails.assignmentId);*/

    String uri = "http://navelsoft.com/gayan/getAssessmentImage.php?assessment_id=" + widget.assessmentDetails.assessmentId;
    ////print(uri);
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




    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchUserData();
    this.assessmentImages();
    review.text = widget.assessmentDetails.review;
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
                  height: 150,
                  color: Color(0xFFFFD835),
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(top: 55,left: 160),
                ),


                Container(
                  margin: EdgeInsets.only(top: 8 ,left: 12 ),
                  child: Row(
                    children: <Widget>[
                      Center(
                        child: Text( "Assessment \n    Details",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,

                        )),
                      ),

                      Container(
                        height: 130,
                        width: 200,
                        margin: EdgeInsets.only(left: 12),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text("Name",style: TextStyle(color: Colors.white),),
                                      Text("-",style: TextStyle(color: Colors.white)),
                                      Text("$fullName" != null ? "$fullName" : "Full Name" ,
                                        style: TextStyle(fontSize: 14,color: Colors.white
                                      ),),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text("Roll No.",style: TextStyle(color: Colors.white),),
                                      Text("-",style: TextStyle(color: Colors.white)),
                                      Text("$loginId" != null ? "$loginId" : "roll no." ,
                                        style: TextStyle(fontSize: 14,color: Colors.white
                                        ),),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text("Standard",style: TextStyle(color: Colors.white),),
                                      Text("-",style: TextStyle(color: Colors.white)),
                                      Text("$standard" != null ? "$standard" : "Standard" ,
                                        style: TextStyle(fontSize: 14,color: Colors.white
                                        ),),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text("Previous Rating",style: TextStyle(color: Colors.white),),
                                      Text("-",style: TextStyle(color: Colors.white)),
                                      Text(ratingToShow,
                                        style: TextStyle(fontSize: 14,color: Colors.white
                                        ),),
                                    ],
                                  ),
                                ],
                              ),

                            ),
                          ],
                        ),
                      ),



                    ],
                  ),
                ),

              ],
            ),
            SizedBox(height: 16,),
            Container(
              padding: EdgeInsets.all(16),
              child: Text("Teacher Assignment ",
                style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Text(widget.assessmentDetails.assignmentNo +". "+ widget.assessmentDetails.assignmentName ,
              style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Text(widget.assessmentDetails.assignmentContent + "\n",
                style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Text("Student Assessment \n\n"+widget.assessmentDetails.assessmentContent,),
            ),
            if(imageData.assessmentImagesData != null)
              for (int i=0 ; i < imageData.assessmentImagesData.length ;i++)
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
                    CachedNetworkImageProvider("http://navelsoft.com/gayan/images/Assessment/"+ imageData.assessmentImagesData[i].image),
                  ),
                  /*Image.network("http://navelsoft.com/gayan/images/Assignments/"+ imagesData.assignmentsImagesData[i].image),*/
                ),
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[

                  Container(
                    child: Text("Remark",
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                  ),
                  Container(
                    margin: EdgeInsets.all(16),
                    height: 80,
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
                      controller: review,
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
                  Container(
                    child: Text("Rating",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                  ),
                  RatingBar.builder(
                    initialRating: widget.assessmentDetails.rating != null ? double.parse(widget.assessmentDetails.rating) : double.parse("3") ,
                    itemCount: 5,
                    itemBuilder: (context, index)  {
                      switch (index) {
                        case 0:
                          return Icon(
                            Icons.sentiment_very_dissatisfied,
                            color: Colors.red,
                          );
                        case 1:
                          return Icon(
                            Icons.sentiment_dissatisfied,
                            color: Colors.redAccent,
                          );
                        case 2:
                          return Icon(
                            Icons.sentiment_neutral,
                            color: Colors.amber,
                          );
                        case 3:
                          return Icon(
                            Icons.sentiment_satisfied,
                            color: Colors.lightGreen,
                          );
                        case 4:
                          return Icon(
                            Icons.sentiment_very_satisfied,
                            color: Colors.green,
                          );

                      }
                      return Icon(
                        Icons.sentiment_very_dissatisfied,
                        color: Colors.yellow,
                      );
                    },
                    onRatingUpdate: (rating) {
                      setState(() {
                        ratingToUpload = rating.toString();
                      });
                    }),
                  SizedBox(height: 16,),
                  GestureDetector(
                    onTap: (){

                        updateAssessment();


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
                      child: Text("Submit",style: TextStyle(
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
