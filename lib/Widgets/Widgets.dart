import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: missing_return
Future<bool> checkInterNetConnection() async
{
  try {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ) {
      return true;
    }
    else if (result == ConnectivityResult.wifi ) {
      return true;
    }
    else if (result == ConnectivityResult.none ) {
      return false;
    }
  } on SocketException catch (_) {
    return false;
  }
}

Container successIndicator()
{
  return Container(
    child: Center(child: CircularProgressIndicator()),
  );
}

Future<void> showMyDialog(BuildContext context,String title,String body,[Widget navigator]) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(body),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              navigator != null ?
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => navigator
              )) :
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


void save(String id,String loginId,String district,String standard,
    String phoneNumber,String email,String fullName,
    String parentsName,String fatherName,String userType,String password,String userIcon) async {
  final prefs = await SharedPreferences.getInstance();
  final idKey = 'id';
  final idValue = id;
  prefs.setString(idKey, idValue);

  final passwordKey = 'password';
  final passwordValue = password;
  prefs.setString(passwordKey, passwordValue);

  if(userType == 1.toString())
  {
    final userIconKey = 'userIcon';
    final userIconValue = userIcon != null ? userIcon : 'schoolboy.jpg';
    prefs.setString(userIconKey, userIconValue);
  }
  else
  {
    final userIconKey = 'userIcon';
    final userIconValue = userIcon != null ? userIcon : 'teacher.jpg';
    prefs.setString(userIconKey, userIconValue);
  }

  final loginIdKey = 'loginId';
  final String loginIdValue = loginId;
  prefs.setString(loginIdKey, loginIdValue);

  final districtKey = 'district';
  final districtValue = district;
  prefs.setString(districtKey, districtValue);

  final standardKey = 'standard';
  final standardValue = standard;
  prefs.setString(standardKey, standardValue);

  final phoneNumberKey = 'phoneNumber';
  final phoneNumberValue = phoneNumber;
  prefs.setString(phoneNumberKey, phoneNumberValue);

  final emailKey = 'email';
  final emailValue = email;
  prefs.setString(emailKey, emailValue);

  final fullNameKey = 'fulName';
  final fullNameValue = fullName;
  prefs.setString(fullNameKey, fullNameValue);

  final parentsNameKey = 'parentsName';
  final parentsNameValue = parentsName;
  prefs.setString(parentsNameKey, parentsNameValue);

  final fathersNameKey = 'fathersName';
  final fathersValue = fatherName;
  prefs.setString(fathersNameKey, fathersValue);

  final userTypeKey = 'userType';
  final userTypeValue = userType;
  prefs.setString(userTypeKey, userTypeValue);

  final userLoginKey = 'userLogin';
  final userLoginValue = true;
  prefs.setBool(userLoginKey, userLoginValue);

}

Future<List<String>> read() async {
  final prefs = await SharedPreferences.getInstance();

  final idKey = 'id';
  final loginIdKey = 'loginId';
  final districtKey = 'district';
  final standardKey = 'standard';
  final phoneNumberKey = 'phoneNumber';
  final emailKey = 'email';
  final fullNameKey = 'fulName';
  final parentsNameKey = 'parentsName';
  final fathersNameKey = 'fathersName';
  final userTypeKey = 'userType';
  final password = 'password';
  final userIcon = 'userIcon';

  final idValue = prefs.getString(idKey) ?? null;
  final loginIdValue = prefs.getString(loginIdKey) ?? null;
  final districtValue = prefs.getString(districtKey) ?? null;
  final standardValue = prefs.getString(standardKey) ?? null;
  final emailValue = prefs.getString(emailKey) ?? null;
  final phoneNumberValue = prefs.getString(phoneNumberKey) ?? null;
  final fullNameValue = prefs.getString(fullNameKey) ?? null;
  final parentsNameValue = prefs.getString(parentsNameKey) ?? null;
  final fathersNameValue = prefs.getString(fathersNameKey) ?? null;
  final userTypeValue = prefs.getString(userTypeKey) ?? null;
  final passwordKey = prefs.getString(password) ?? null;
  final userIconValue = prefs.getString(userIcon) ?? null;

  List<String> userInfoOffline = new List<String>();
  userInfoOffline.add(idValue);
  userInfoOffline.add(loginIdValue);
  userInfoOffline.add(districtValue);
  userInfoOffline.add(standardValue);
  userInfoOffline.add(emailValue);
  userInfoOffline.add(phoneNumberValue);
  userInfoOffline.add(fullNameValue);
  userInfoOffline.add(parentsNameValue);
  userInfoOffline.add(userTypeValue);
  userInfoOffline.add(fathersNameValue);
  userInfoOffline.add(passwordKey);
  userInfoOffline.add(userIconValue);

  return userInfoOffline;
}


void unsetUserLogin() async {
  final prefs = await SharedPreferences.getInstance();
  final userLoginKey = 'userLogin';
  final userLoginValue = false;
  prefs.setBool(userLoginKey, userLoginValue);
}

Future<bool> checkUserLogin() async {

  final prefs = await SharedPreferences.getInstance();
  final checkUserLoginKey = 'userLogin';
  final bool checkUserLoginValue = prefs.getBool(checkUserLoginKey) ?? false;

  return checkUserLoginValue;

}