class ClassTeacherNameFormat
{
  int status;
  String statusMessage;
  List<ClassTeacherName> classTeacherName;

  ClassTeacherNameFormat(this.status,this.statusMessage,[this.classTeacherName]);
  factory ClassTeacherNameFormat.fromJson(dynamic json) {
    if (json['userData'] != null) {
      var tagObisJson = json['userData'] as List;
      List<ClassTeacherName> AssessmentsData = tagObisJson.map((tagJson) =>
          ClassTeacherName.fromJson(tagJson)).toList();
      return ClassTeacherNameFormat(
          json["status"],
          json["status_message"],
          AssessmentsData
      );
    }
    else
    {
      return ClassTeacherNameFormat(
          json["status"],
          json["status_message"]
      );
    }
  }
}

class ClassTeacherName {
  String classTeacherName;

  ClassTeacherName(this.classTeacherName);
  factory ClassTeacherName.fromJson(dynamic json) {
    return ClassTeacherName(
      json["fullName"],

    );
  }
}