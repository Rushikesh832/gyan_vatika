import 'package:flutter/material.dart';
import 'package:gyan_vatika/Models/SimpleResponseFormat.dart';
import 'package:gyan_vatika/Models/TopicQueriesModel.dart';
import 'package:gyan_vatika/Views/TeacherTopicQueries.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'dart:core';
import 'NavDrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class CreateAnswerQuery extends StatefulWidget {
  Queries query;
  CreateAnswerQuery(this.query) : super();
  @override
  _CreateAnswerQueryState createState() => _CreateAnswerQueryState();
}

class _CreateAnswerQueryState extends State<CreateAnswerQuery> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  SimpleResponseFormat simpleResponse = SimpleResponseFormat(100,"Status Message");
  TextEditingController queryAnswer = new TextEditingController();
  bool checkInternetConnection = true;
  TopicQueriesFormat queriesData = TopicQueriesFormat(404,"status Message");
  String id;


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

      String uri = "http://navelsoft.com/gayan/queriesApi.php";
      ////print(uri);
      var map = new Map<String, String>();

      String TopicContent1 = queryAnswer.text.replaceAll("'", "\\'");
      String TopicContent = TopicContent1.replaceAll('"', '\\"');

      map['answer'] = TopicContent1;
      map['query_id'] = widget.query.id;

      Map<String, String> headers = {
        "Content-Type": "application/x-www-form-urlencoded"};
      final responseData = await http.post(uri,
          body: map,headers: headers);
      ////print(responseData);
      if (responseData.statusCode == 200) {
        simpleResponse = SimpleResponseFormat.fromJson(json.decode(responseData.body));

        if (simpleResponse.status == 200) {
          showMyDialog(context, "Invalid", simpleResponse.statusMessage,TeacherTopicQueries(widget.query.topicId));
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryAnswer.text = widget.query.answer;
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
                            : "Enter Your Answer";
                      },
                      controller: queryAnswer,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Enter Your Answer",
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
