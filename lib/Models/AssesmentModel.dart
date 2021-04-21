class AssessmentFormat
{
  int status;
  String statusMessage;
  List<Assessment> assessmentData;

  AssessmentFormat(this.status,this.statusMessage,[this.assessmentData]);
  factory AssessmentFormat.fromJson(dynamic json) {
    if (json['assesment'] != null) {
      var tagObisJson = json['assesment'] as List;
      List<Assessment> AssessmentsData = tagObisJson.map((tagJson) =>
          Assessment.fromJson(tagJson)).toList();
      return AssessmentFormat(
          json["status"],
          json["status_message"],
          AssessmentsData
      );
    }
    else
    {
      return AssessmentFormat(
          json["status"],
          json["status_message"]
      );
    }
  }
}

class Assessment {
  String id;
  String assignmentId;
  String userId;
  String assessmentContent;
  String rating;
  String isComplete;
  String review;
  String classificationId;
  String assignmentNo;
  String assignmentName;
  String assignmentContent;
  String assessmentId;

  Assessment(this.id,this.assignmentId,this.userId,this.assessmentContent,this.rating,this.isComplete,this.review,
      this.classificationId,this.assignmentNo,this.assignmentName,this.assignmentContent,this.assessmentId);
  factory Assessment.fromJson(dynamic json) {
    return Assessment(
      json["id"],
      json["assignment_id"],
      json["user_id"],
      json["assesment_content"],
      json["rating"],
      json["isComplete"],
      json["review"],
      json["classification_id"],
      json["assignment_no"],
      json["assignment_name"],
      json["assignment_content"],
      json["assessmentId"],

    );
  }
}