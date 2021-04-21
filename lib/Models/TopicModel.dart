class TopicFullFormat
{
  int status;
  String statusMessage;
  List<Topics> topicsData;

  TopicFullFormat(this.status,this.statusMessage,[this.topicsData]);
  factory TopicFullFormat.fromJson(dynamic json) {
    if (json['topics'] != null) {
      var tagObisJson = json['topics'] as List;
      List<Topics> subjectsData = tagObisJson.map((tagJson) =>
          Topics.fromJson(tagJson)).toList();
      return TopicFullFormat(
          json["status"],
          json["status_message"],
          subjectsData
      );
    }
    else
    {
      return TopicFullFormat(
          json["status"],
          json["status_message"]
      );
    }
  }
}

class Topics {
  String id;
  String chapterId;
  String topicNo;
  String topicName;
  String topicContents;
  String classificationId;
  String chapterNo;
  String chapterName;
  String youtubeVideo;
  String status;
  String audio;
  Topics(this.id,this.chapterId,this.topicNo,this.topicName,
      this.topicContents,this.classificationId,this.chapterNo,this.chapterName,this.youtubeVideo,this.status,this.audio);
  factory Topics.fromJson(dynamic json) {
    return Topics(
      json["id"],
      json["chapter_id"],
      json["topic_no"],
      json["topic_name"],
      json["topic_content"],
      json["classification_id"],
      json["chapter_no"],
      json["chapter_name"],
      json["youtubeVideo"],
      json["status"],
      json["audio"]
    );
  }
}