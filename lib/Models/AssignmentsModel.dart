class AssignmentsFormat
{
  int status;
  String statusMessage;
  List<Assignments> assignmentsData;

  AssignmentsFormat(this.status,this.statusMessage,[this.assignmentsData]);
  factory AssignmentsFormat.fromJson(dynamic json) {
    if (json['assignments'] != null) {
      var tagObisJson = json['assignments'] as List;
      List<Assignments> assignmentsData = tagObisJson.map((tagJson) =>
          Assignments.fromJson(tagJson)).toList();
      return AssignmentsFormat(
          json["status"],
          json["status_message"],
          assignmentsData
      );
    }
    else
    {
      return AssignmentsFormat(
          json["status"],
          json["status_message"]
      );
    }
  }
}

class Assignments {
  String id;
  String classificationId;
  String assignmentNo;
  String assignmentName;
  String assignmentContent;
  String userId;
  String videoUrl;
  String status;
  String pendingDate;
  String audio;
  Assignments(this.id,this.classificationId,this.assignmentNo,this.assignmentName,
      this.assignmentContent,this.userId,this.videoUrl,this.status,this.pendingDate,this.audio);
  factory Assignments.fromJson(dynamic json) {
    return Assignments(
      json["id"],
      json["classification_id"],
      json["assignment_no"],
      json["assignment_name"],
      json["assignment_content"],
      json["user_id"],
      json["videoUrl"],
      json["status"],
      json["pendingDate"],
      json["audio"]

    );
  }
}