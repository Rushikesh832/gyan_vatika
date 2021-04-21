class TopicImageModel
{
  int status;
  String statusMessage;
  List<TopicsImages> topicImagesData;

  TopicImageModel(this.status,this.statusMessage,[this.topicImagesData]);
  factory TopicImageModel.fromJson(dynamic json) {
    if (json['images'] != null) {
      var tagObisJson = json['images'] as List;
      List<TopicsImages> assignmentsData = tagObisJson.map((tagJson) =>
          TopicsImages.fromJson(tagJson)).toList();
      return TopicImageModel(
          json["status"],
          json["status_message"],
          assignmentsData
      );
    }
    else
    {
      return TopicImageModel(
          json["status"],
          json["status_message"]
      );
    }
  }
}

class TopicsImages {
  String id;
  String topicId;
  String image;
  TopicsImages(this.id,this.topicId,this.image);
  factory TopicsImages.fromJson(dynamic json) {
    return TopicsImages(
      json["id"],
      json["topic_id"],
      json["images"],

    );
  }
}