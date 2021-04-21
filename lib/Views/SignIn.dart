import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gyan_vatika/Models/SimpleResponseFormat.dart';
import 'package:gyan_vatika/Models/UserData.dart';
import 'package:gyan_vatika/Views/ForgotPassword.dart';
import 'package:gyan_vatika/Views/StudentHomePage.dart';
import 'package:gyan_vatika/Views/TeachersHomePage.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'Contact.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool _obsecureText = true;
  final formKey = GlobalKey<FormState>();
  UserDataFormat userData;
  bool checkInternetConnection = true;
  TextEditingController password = new TextEditingController();
  TextEditingController userId = new TextEditingController();
  bool isLoading = false;
  DateTime backButtonPressedTime;
  String tokenLoginId;
  SimpleResponseFormat simpleResponse = SimpleResponseFormat(100,"Status Message");
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String tokenToUpload;
  String isLogin;


  signMeUp() async {
    Future<bool> futureConnection = checkInterNetConnection();
    futureConnection.then((value) =>
    {
      checkInternetConnection = value
    });
     if (checkInternetConnection) {




        _firebaseMessaging.getToken().then((token) async {

          //print(token);
          setState(() {
            tokenToUpload = token;
          });
          _firebaseMessaging.configure(
            onMessage: (Map<String, dynamic> message) async {
              //print('on message $message');
            },
            onResume: (Map<String, dynamic> message) async {
              //print('on resume $message');
            },
            onLaunch: (Map<String, dynamic> message) async {
              //print('on launch $message');
            },
          );
          _firebaseMessaging.requestNotificationPermissions(
            const IosNotificationSettings(sound: true, badge: true, alert: true),
          );

        });

        setState(() {
          isLoading = true;
        });

        if(userId.text == null || password.text == null)
          {
            showMyDialog(
                context, "Invalid", "Field Can't be Empty.");
          }
        else {
          String uri = "http://navelsoft.com/gayan/userapi.php?login_id=" +
              userId.text + "&password=" + password.text;
          print(uri);
          final responseData = await http.get(uri,headers: {'Content-Type': 'application/json'});
          if (responseData.statusCode == 200) {
            userData =
                UserDataFormat.fromJson(json.decode(responseData.body));

            if (userData.status == 200) {
              save(
                  userData.userData[0].id,
                  userData.userData[0].loginId,
                  userData.userData[0].districtName,
                  userData.userData[0].standard,
                  userData.userData[0].phoneNumber,
                  userData.userData[0].email,
                  userData.userData[0].fullName,
                  userData.userData[0].motherName,
                  userData.userData[0].fatherName,
                  userData.userData[0].userType,
                  userData.userData[0].password,
                  userData.userData[0].userIcon);


              String uri = "http://navelsoft.com/gayan/updateToken.php";
              print(tokenToUpload);
              print(userData.userData[0].loginId);
              print(uri);
              var map = new Map<String, String>();

              map['login_id'] = userData.userData[0].loginId;
              if(tokenToUpload != null)
                {
                  map['token'] = tokenToUpload;
                }
              else
                {
                  map['token'] = userData.userData[0].token;
                }

              Map<String, String> headers = {
                "Content-Type": "application/x-www-form-urlencoded"};
              final responseData = await http.post(uri,
                  body: map, headers: headers);
              ////print(responseData.statusCode);
              if (responseData.statusCode == 200) {
                simpleResponse = SimpleResponseFormat.fromJson(
                    json.decode(responseData.body));
                ////print(simpleResponse.statusMessage);
              }


              if (int.parse(userData.userData[0].userType) == 1) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) =>
                        StudentHomePage()), (Route<dynamic> route) => false);
              }
              else {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) =>
                        TeachersHomePage()), (Route<dynamic> route) => false);
              }
            }
            else if (userData.status == 402) {
              showMyDialog(
                  context, "Invalid", "Enter Valid Credentials", SignIn());
            }
            else if (userData.status == 500) {
              showMyDialog(context, "error", "Enter Data Again", SignIn());
            }
            else {
              showMyDialog(context, "error", "Enter Data Again", SignIn());
            }


            setState(() {
              isLoading = false;
            });
          }
        }






          }


      else {
        showMyDialog(
            context, "InterNet Connectivity", "Check Internet Connection");
      }
    }


    void _toggle() {
      setState(() {
        _obsecureText = !_obsecureText;
      });
    }


  checkLogin() async {
    // TODO: implement initState
    super.initState();
    final prefs = await SharedPreferences.getInstance();
    final checkUserLoginKey = 'userLogin';
    final bool checkUserLoginValue = prefs.getBool(checkUserLoginKey) ?? false;
    final userType = 'userType';
    final  userTypeResult = prefs.getString(userType) ?? false;

    if(checkUserLoginValue)
    {
      if(userTypeResult == 1.toString())
      {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  StudentHomePage() ), (route) => false);
      }
      else if(userTypeResult == 2.toString())
      {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  TeachersHomePage() ), (route) => false);
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.checkLogin();
  }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: isLoading ? successIndicator() : WillPopScope(
          onWillPop: onWillPop,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 240,

                      alignment: Alignment.topRight,
                      padding: EdgeInsets.only(top: 40, left: 150),
                      decoration: BoxDecoration(
                          color: Color(0xFFFFD835),
                          image: DecorationImage(image: AssetImage("assets/signIn.jpeg"),fit: BoxFit.fill
                          )
                      ),
                      /*child: Row(
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              setState(() {
                                widget.district = "DUMKA";
                              });
                            },
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(0.0),
                            child: Container(
                              height: 50,
                              width: 75,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(50)),
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color(0xFFFFA300),
                                    Color(0xFFFFD740),
                                  ],
                                ),
                              ),
                              child: Center(child: Text("DUMKA",
                                  style: widget.district == "DUMKA" ? TextStyle(
                                      fontSize: 15
                                      ,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold) : TextStyle(
                                    fontSize: 14
                                    , color: Colors.black,))),
                            ),
                          ),

                          FlatButton(

                            onPressed: () {
                              setState(() {
                                widget.district = "RAGHUNATHPUR";
                              });
                            },
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(0.0),
                            child: Container(
                              height: 50,
                              width: 140,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.horizontal(
                                    right: Radius.circular(50)),
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color(0xFFFFD740),
                                    Color(0xFFFFA300),

                                  ],
                                ),
                              ),
                              child: Center(child: Text('RAGHUNATHPUR',
                                  style: widget.district == "RAGHUNATHPUR"
                                      ? TextStyle(fontSize: 14
                                      ,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)
                                      : TextStyle(fontSize: 13
                                    , color: Colors.black,))),
                            ),
                          )
                        ],
                      ),*/
                    ),
                    Container(color: Colors.black, height: 0.7,),
                    Container(
                      margin: EdgeInsets.only(top: MediaQuery
                          .of(context)
                          .size
                          .height / 4.5, left: MediaQuery
                          .of(context)
                          .size
                          .width / 3),
                      width: 140,
                      height: 140,
                      child: Image.asset("assets/splash_screen.jpeg", fit: BoxFit.fill,),
                    ),
                  ],
                ),
                SizedBox(height: 40,),
                Text("GYAN VATIKA", style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 22
                ),),

                SizedBox(height: 24,),

                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 225,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: TextFormField(

                          validator: (val) {
                            return RegExp(
                                r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$')
                                .hasMatch(val) ?
                            null : "Enter Valid User Id";
                          },
                          controller: userId,
                          decoration: InputDecoration(
                            hintText: "      UserId",
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
                            prefixIcon: Icon(Icons.account_box, size: 35,),

                          ),

                        ),
                      ),
                      SizedBox(height: 12,),
                      Container(
                        height: 50,
                        width: 225,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: TextFormField(

                          validator: (val) {
                            return RegExp(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                .hasMatch(val)
                                ?
                            null
                                : "Password Must Contains Lower,Upper,Number & Special Character";
                          },
                          controller: password,
                          obscureText: _obsecureText,
                          decoration: InputDecoration(
                              hintText: "      Password",
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
                              prefixIcon: Icon(Icons.lock, size: 35,),
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    _obsecureText
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

                    ],
                  ),
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: () {
                    signMeUp();
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        color: Color(0xFFFFD835),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("Sign In", style: TextStyle(
                            fontSize: 18
                        ),)),
                  ),
                ),

                Container(
                    padding: EdgeInsets.only(top: 24, bottom: 16),
                    child: Divider(height: 2, color: Colors.black,)),
                InkWell(
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ForgotPassword()
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                              color: Color(0xFFFFA300),
                              borderRadius: BorderRadius.all(Radius.circular(50))
                          ),
                          child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text("Forgot Password", style: TextStyle(
                                  fontSize: 18
                              ),)),
                        ),
                        InkWell(
                          onTap: ()
                          {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Contact()
                            ));
                          },
                          child: Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                color: Color(0xFFFFA300),
                                borderRadius: BorderRadius.all(Radius.circular(50))
                            ),
                            child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text("Contact", style: TextStyle(
                                    fontSize: 18
                                ),)),
                          ),
                        ),
                      ],
                    ),
                  ),
                )


              ],
            ),
          ),
        ),
      );
    }
  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    //Statement 1 Or statement2
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 3);

    if (backButton) {
      backButtonPressedTime = currentTime;
      Fluttertoast.showToast(
          msg: "Double Click to exit app",
          backgroundColor: Colors.white,
          textColor: Colors.black);
      return false;
    }
    return true;
  }
  }