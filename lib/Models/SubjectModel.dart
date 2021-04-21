class SubjectsDataFormat
{
  int status;
  String statusMessage;
  List<Subjects> subjectsData;

  SubjectsDataFormat(this.status,this.statusMessage,[this.subjectsData]);
  factory SubjectsDataFormat.fromJson(dynamic json) {
    if (json['subjects'] != null) {
      var tagObisJson = json['subjects'] as List;
      List<Subjects> subjectsData = tagObisJson.map((tagJson) =>
          Subjects.fromJson(tagJson)).toList();
      return SubjectsDataFormat(
          json["status"],
          json["status_message"],
          subjectsData
      );
    }
    else
    {
      return SubjectsDataFormat(
          json["status"],
          json["status_message"]
      );
    }
  }
}

class Subjects {
  String subjectName;
  String subjectsId;
  String count;
  Subjects(this.subjectName,this.subjectsId,this.count);
  factory Subjects.fromJson(dynamic json) {
    return Subjects(
      json["name"],
      json["id"],
        json["count"],
      );
  }
}