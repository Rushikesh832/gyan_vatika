class TopicUrlFormat
{
  int status;
  String statusMessage;
  List<TopicUrl> topicUrlData;

  TopicUrlFormat(this.status,this.statusMessage,[this.topicUrlData]);
  factory TopicUrlFormat.fromJson(dynamic json) {
    if (json['urls'] != null) {
      var tagObisJson = json['urls'] as List;
      List<TopicUrl> assignmentsData = tagObisJson.map((tagJson) =>
          TopicUrl.fromJson(tagJson)).toList();
      return TopicUrlFormat(
          json["status"],
          json["status_message"],
          assignmentsData
      );
    }
    else
    {
      return TopicUrlFormat(
          json["status"],
          json["status_message"]
      );
    }
  }
}

class TopicUrl {
  String id;
  String topicId;
  String assignmentId;
  String videoUrl;

  TopicUrl(this.id,this.topicId,this.assignmentId,this.videoUrl);
  factory TopicUrl.fromJson(dynamic json) {
    return TopicUrl(
      json["id"],
      json["topic_id"],
      json["assignment_id"],
      json["videoUrl"],
    );
  }
}