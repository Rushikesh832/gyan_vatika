import 'package:flutter/material.dart';
import 'package:gyan_vatika/Models/ChaptersModel.dart';
import 'package:gyan_vatika/Models/SimpleResponseFormat.dart';

import 'package:gyan_vatika/Widgets/Widgets.dart';

import 'dart:core';
import 'NavDrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


import 'TeacherChapters.dart';

class EditChapters extends StatefulWidget {
  Chapters chapterData;
  EditChapters(this.chapterData);
  @override
  _EditChaptersState createState() => _EditChaptersState();
}

class _EditChaptersState extends State<EditChapters> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  SimpleResponseFormat simpleResponse = SimpleResponseFormat(100,"Status Message");
  TextEditingController chapterNo = new TextEditingController();
  TextEditingController chapterName = new TextEditingController();
  bool checkInternetConnection = true;


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
        String uri = "http://navelsoft.com/gayan/Chaptersapi.php";

        String assingmentNameFilter = chapterName.text.replaceAll("'", "\\'");
        String assingmnetNameFinalFilter = assingmentNameFilter.replaceAll('"', '\\"');

        Map<String, String> data = {
          "chapter_id":widget.chapterData.id,
          "chapter_name":assingmnetNameFinalFilter,
          "chapter_no":chapterNo.text
        };
        var body = json.encode(data);
        ////print(body);
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
                builder: (context) => TeacherChapters(widget.chapterData.classificationId)
            ));
          }
          else if (simpleResponse.status == 402) {
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => TeacherChapters(widget.chapterData.classificationId)
            ));
          }
          else if (simpleResponse.status == 500) {
            showMyDialog(context, "error", simpleResponse.statusMessage,TeacherChapters(widget.chapterData.classificationId));
          }
          else {
            showMyDialog(context, "error", "Enter Data Again",TeacherChapters(widget.chapterData.classificationId));
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



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chapterNo.text=widget.chapterData.chapterNo;
    chapterName.text = widget.chapterData.chapterName;


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
                      child: Text("Update" ,style: TextStyle(
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
