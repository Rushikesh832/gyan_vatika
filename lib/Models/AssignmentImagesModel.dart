class AssignmentImagesModel
{
  int status;
  String statusMessage;
  List<AssignmentsImages> assignmentsImagesData;

  AssignmentImagesModel(this.status,this.statusMessage,[this.assignmentsImagesData]);
  factory AssignmentImagesModel.fromJson(dynamic json) {
    if (json['images'] != null) {
      var tagObisJson = json['images'] as List;
      List<AssignmentsImages> assignmentsData = tagObisJson.map((tagJson) =>
          AssignmentsImages.fromJson(tagJson)).toList();
      return AssignmentImagesModel(
          json["status"],
          json["status_message"],
          assignmentsData
      );
    }
    else
    {
      return AssignmentImagesModel(
          json["status"],
          json["status_message"]
      );
    }
  }
}

class AssignmentsImages {
  String id;
  String assignmentId;
  String image;
  AssignmentsImages(this.id,this.assignmentId,this.image);
  factory AssignmentsImages.fromJson(dynamic json) {
    return AssignmentsImages(
        json["id"],
        json["assignment_id"],
        json["image"],

    );
  }
}