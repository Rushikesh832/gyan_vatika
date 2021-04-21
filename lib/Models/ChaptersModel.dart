class ChaptersFormat
{
  int status;
  String statusMessage;
  List<Chapters> chaptersData;

  ChaptersFormat(this.status,this.statusMessage,[this.chaptersData]);
  factory ChaptersFormat.fromJson(dynamic json) {
    if (json['chapters'] != null) {
      var tagObisJson = json['chapters'] as List;
      List<Chapters> subjectsData = tagObisJson.map((tagJson) =>
          Chapters.fromJson(tagJson)).toList();
      return ChaptersFormat(
          json["status"],
          json["status_message"],
          subjectsData
      );
    }
    else
    {
      return ChaptersFormat(
          json["status"],
          json["status_message"]
      );
    }
  }
}

class Chapters {
  String id;
  String classificationId;
  String chapterNo;
  String chapterName;
  String userId;
  String status;
  Chapters(this.id,this.classificationId,this.chapterNo,this.chapterName,this.userId,this.status);
  factory Chapters.fromJson(dynamic json) {
    return Chapters(
      json["id"],
      json["classification_id"],
      json["chapter_no"],
      json["chapter_name"],
      json["userId"],
      json["status"],
    );
  }
}