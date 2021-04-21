class AssessmentImageModel
{
  int status;
  String statusMessage;
  List<AssessmentImages> assessmentImagesData;

  AssessmentImageModel(this.status,this.statusMessage,[this.assessmentImagesData]);
  factory AssessmentImageModel.fromJson(dynamic json) {
    if (json['images'] != null) {
      var tagObisJson = json['images'] as List;
      List<AssessmentImages> assignmentsData = tagObisJson.map((tagJson) =>
          AssessmentImages.fromJson(tagJson)).toList();
      return AssessmentImageModel(
          json["status"],
          json["status_message"],
          assignmentsData
      );
    }
    else
    {
      return AssessmentImageModel(
          json["status"],
          json["status_message"]
      );
    }
  }
}

class AssessmentImages {
  String id;
  String assessement_id;
  String image;
  AssessmentImages(this.id,this.assessement_id,this.image);
  factory AssessmentImages.fromJson(dynamic json) {
    return AssessmentImages(
      json["id"],
      json["assessement_id"],
      json["image"],

    );
  }
}