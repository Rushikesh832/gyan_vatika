import 'package:flutter/material.dart';
import 'package:gyan_vatika/Views/ChangePassword.dart';
import 'package:gyan_vatika/Views/SignIn.dart';
import 'package:gyan_vatika/Views/StudentHomePage.dart';
import 'package:gyan_vatika/Views/TeacherProfile.dart';
import 'package:gyan_vatika/Views/TeachersHomePage.dart';
import 'package:gyan_vatika/Views/UserIcon.dart';
import 'package:gyan_vatika/Widgets/Widgets.dart';
import 'StudentProfile.dart';

class NavDrawer extends StatelessWidget {

  List<String> userData;
  String id,loginId,district,standard,phoneNumber,email,fullName,parentsName,userType;
  Future<List<String>> userInfoOffline;

  NavDrawer()
  {
    this.loadSharedPref();
  }


  loadSharedPref()
  {
    userInfoOffline = read();

    userInfoOffline.then((data){


        userData = data;
        id =  data.elementAt(0) != null ? data.elementAt(0) : "1";
        loginId = data.elementAt(1) != null ? data.elementAt(1) : "   loginId";
        district = data.elementAt(2) != null ? data.elementAt(2) : "district";
        standard = data.elementAt(3) != null ? data.elementAt(3) : "standard";
        phoneNumber = data.elementAt(4) != null ? data.elementAt(4) : "   PhoneNumber";
        email = data.elementAt(5) != null ? data.elementAt(5) : "   E-mail";
        fullName = data.elementAt(6) != null ? data.elementAt(6) : "   FullName";
        parentsName = data.elementAt(7) != null ? data.elementAt(7) : "   Parents Full Name";
        userType = data.elementAt(8) != null ? data.elementAt(8) : "   User Type";
      });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
                decoration: BoxDecoration(
                color: Color(0xFFFFA300),
                image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('signIn.jpeg'))),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('HomePage'),
            onTap: () {
              if(int.parse(userType) == 1)
                {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      StudentHomePage()), (Route<dynamic> route) => false);
                }
              else if(int.parse(userType) == 2)
                {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      TeachersHomePage()), (Route<dynamic> route) => false);
                }
              else
                {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      SignIn()), (Route<dynamic> route) => false);
                }
            },
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {
                if(int.parse(userType) == 1)
                {
                Navigator.push(context, MaterialPageRoute(
                builder: (context) => StudentProfile()
                ))
                }
                else if(int.parse(userType) == 2)
                {
                Navigator.push(context, MaterialPageRoute(
                builder: (context) => TeacherProfile()
                ))
                }
                else
                {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                SignIn()), (Route<dynamic> route) => false)
                }
            }
          ),
          ListTile(
            leading: Icon(Icons.autorenew),
            title: Text('Change Password'),
            onTap: () => {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                ChangePassword()), (Route<dynamic> route) => false)},
          ),

          ListTile(
            leading: Icon(Icons.autorenew),
            title: Text('Change Icon'),
            onTap: () => {Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                UpdateUserIcon()), (Route<dynamic> route) => false)},
          ),

          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {
              unsetUserLogin(),
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  SignIn()), (Route<dynamic> route) => false)
              },
          ),
        ],
      ),
    );
  }
}