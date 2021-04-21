class UserDataFormat
{
  int status;
  String statusMessage;
  List<UserData> userData;

  UserDataFormat(this.status,this.statusMessage,[this.userData]);
  factory UserDataFormat.fromJson(dynamic json) {
    if (json['userData'] != null) {
      var tagObisJson = json['userData'] as List;
      List<UserData> userData = tagObisJson.map((tagJson) =>
          UserData.fromJson(tagJson)).toList();
      return UserDataFormat(
          json["status"],
          json["status_message"],
          userData
      );
    }
    else
    {
      return UserDataFormat(
          json["status"],
          json["status_message"]
      );
    }
  }
}

class UserData {
  String id;
  String loginId;
  String password;
  String district;
  String standard;
  String email;
  String phoneNumber;
  String fullName;
  String motherName;
  String fatherName;
  String districtName;
  String userType;
  String userIcon;
  String token;

  UserData(this.id, this.loginId, this.password, this.district,
      this.standard,this.email, this.phoneNumber, this.fullName,
      this.motherName,this.fatherName,this.districtName,this.userType,this.userIcon,this.token);

  factory UserData.fromJson(dynamic json) {
    return UserData(
        json["id"],
        json[ "loginId"],
        json["password"],
        json["district"],
        json["standard"],
        json["email"],
        json["phoneNumber"],
        json["fullName"],
        json["motherName"],
        json["fatherName"],
        json["districtName"],
        json["userType"],
        json["user_icon"],
        json["token"]
      );
  }
}