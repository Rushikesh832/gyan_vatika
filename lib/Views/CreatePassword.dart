import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gyan_vatika/Models/SimpleResponseFormat.dart';
import 'package:gyan_vatika/Models/TopicQueriesModel.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'dart:core';
import 'NavDrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class CreatePassword extends StatefulWidget {

  @override
  _CreatePasswordState createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  SimpleResponseFormat simpleResponse = SimpleResponseFormat(100,"Status Message");
  bool obsecureText = true;
  bool obsecureText1 = true;

  TextEditingController newPassword = new TextEditingController();
  TextEditingController confirmPassword = new TextEditingController();
  bool checkInternetConnection = true;
  TopicQueriesFormat queriesData = TopicQueriesFormat(404,"status Message");
  String id;
  String loginId;

  void _toggle() {
    setState(() {
      obsecureText = !obsecureText;
    });
  }

  void _toggle1() {
    setState(() {
      obsecureText1 = !obsecureText1;
    });
  }


  createPassword()
  async {
    Future<bool> futureConnection = checkInterNetConnection();
    futureConnection.then((value) =>{
      checkInternetConnection = value
    } );
    if (checkInternetConnection) {
      if (formKey.currentState.validate()) {

        if(newPassword.text == confirmPassword.text)
          {
            final idKey = 'loginId';
            final prefs = await SharedPreferences.getInstance();

            setState(() {
              loginId = prefs.getString(idKey) ?? null;
            });



            String uri = "http://navelsoft.com/gayan/changePassword.php";
            ////print(uri);
            var map = new Map<String, String>();

            map['password'] = newPassword.text;
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
                showMyDialog(context, "Successful","Password Change Successfully.");
                (context as Element).reassemble();
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
        else
          {
            showMyDialog(context, "error", "Password Does Not Matched.");
          }
      }
    }
    else
    {
      showMyDialog(context, "InterNet Connectivity", "Check Internet Connection");
    }
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
                    margin: EdgeInsets.all(12),
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
                            : "Enter New Password";
                      },
                      controller: newPassword,

                      obscureText: obsecureText,

                      decoration: InputDecoration(
                        hintText: "Enter New Password",
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

                  Container(
                    margin: EdgeInsets.all(12),
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
                            : "Confirm New Password";
                      },
                      controller: confirmPassword,

                      obscureText: obsecureText1,

                      decoration: InputDecoration(
                          hintText: "Confirm New Password",
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
                                obsecureText1
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black54,
                              ),
                              onPressed: () {
                                _toggle1();
                              }
                          )

                      ),

                    ),
                  ),
                  SizedBox(height: 16,),
                  GestureDetector(
                    onTap: (){
                      createPassword();
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
                      child: Text("Change Password" ,style: TextStyle(
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
