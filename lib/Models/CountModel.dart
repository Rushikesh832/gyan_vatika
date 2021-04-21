class CountModel
{
  int status;
  String statusMessage;
  String assessmentCount;
  String notificationCount;
  String subjectCount;
  String assignmentCount;
  String circularCount;

  CountModel(this.status,this.statusMessage,this.assessmentCount,this.notificationCount,this.subjectCount,this.assignmentCount,this.circularCount);
  factory CountModel.fromJson(dynamic json) {
    return CountModel(
        json["status"],
        json["status_message"],
        json["assessmentCount"],
        json["notificationCount"],
        json["subjectCount"],
        json["assignmentCount"],
        json["circularCount"],
    );
  }
}