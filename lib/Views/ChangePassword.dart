import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gyan_vatika/Models/SimpleResponseFormat.dart';
import 'package:gyan_vatika/Models/TopicQueriesModel.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'dart:core';
import 'CreatePassword.dart';
import 'NavDrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ChangePassword extends StatefulWidget {

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  SimpleResponseFormat simpleResponse = SimpleResponseFormat(100,"Status Message");
  bool obsecureText = true;

  TextEditingController oldPassword = new TextEditingController();
  bool checkInternetConnection = true;
  TopicQueriesFormat queriesData = TopicQueriesFormat(404,"status Message");
  String id;
  String loginId;





  checkOldPassword()
  async {
    Future<bool> futureConnection = checkInterNetConnection();
    futureConnection.then((value) =>{
      checkInternetConnection = value
    } );
    if (checkInternetConnection) {
      if (formKey.currentState.validate()) {


        final idKey = 'loginId';
        final prefs = await SharedPreferences.getInstance();

        setState(() {
          loginId = prefs.getString(idKey) ?? null;
        });



        String uri = "http://navelsoft.com/gayan/passwordApi.php";
        ////print(uri);
        var map = new Map<String, String>();

        map['password'] = oldPassword.text;
        map['loginId'] = loginId;

        Map<String, String> headers = {
          "Content-Type": "application/x-www-form-urlencoded"};
        final responseData = await http.post(uri,
            body: map,headers: headers);
        ////print(responseData);
        if (responseData.statusCode == 200) {
          simpleResponse =
              SimpleResponseFormat.fromJson(json.decode(responseData.body));

          if (simpleResponse.status == 200) {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => CreatePassword()
            ));
          }
          else if (simpleResponse.status == 402) {
            showMyDialog(context, "Invalid", simpleResponse.statusMessage);
            (context as Element).reassemble();
          }
          else if (simpleResponse.status == 500) {
            showMyDialog(context, "error", simpleResponse.statusMessage);
            (context as Element).reassemble();
          }
          else {
            showMyDialog(context, "error", "Enter Data Again");
            (context as Element).reassemble();
          }
        }



        }
      }
      else
      {
        showMyDialog(context, "InterNet Connectivity", "Check Internet Connection");
      }
  }
  void _toggle() {
    setState(() {
      obsecureText = !obsecureText;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                        return val.isNotEmpty ? null
                            : "Enter Old Password";
                      },
                      controller: oldPassword,
                      obscureText: obsecureText,
                      decoration: InputDecoration(
                        hintText: "Enter Your Old Password",
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
                          suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                obsecureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black54,
                              ),
                              onPressed: () {
                                _toggle();
                              }
                          )

                      ),

                    ),
                  ),
                  SizedBox(height: 16,),
                  GestureDetector(
                    onTap: (){
                      checkOldPassword();
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
                      child: Text("Check" ,style: TextStyle(
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
