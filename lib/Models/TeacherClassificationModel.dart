class TeacherClassificationFormat
{
  int status;
  String statusMessage;
  List<TeacherClassification> teachersClassification;

  TeacherClassificationFormat(this.status,this.statusMessage,[this.teachersClassification]);
  factory TeacherClassificationFormat.fromJson(dynamic json) {
    if (json['teachersClassification'] != null) {
      var tagObisJson = json['teachersClassification'] as List;
      List<TeacherClassification> data = tagObisJson.map((tagJson) =>
          TeacherClassification.fromJson(tagJson)).toList();
      return TeacherClassificationFormat(
          json["status"],
          json["status_message"],
          data
      );
    }
    else
    {
      return TeacherClassificationFormat(
          json["status"],
          json["status_message"]
      );
    }
  }
}

class TeacherClassification {
  String subjectName;
  String standard;
  String classificationId;
  TeacherClassification(this.standard,this.subjectName,this.classificationId);
  factory TeacherClassification.fromJson(dynamic json) {
    return TeacherClassification(
      json["standard"],
      json["SubjectName"],
      json["classification_id"]
    );
  }
}