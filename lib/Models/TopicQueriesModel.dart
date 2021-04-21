class TopicQueriesFormat
{
  int status;
  String statusMessage;
  List<Queries> queries;

  TopicQueriesFormat(this.status,this.statusMessage,[this.queries]);
  factory TopicQueriesFormat.fromJson(dynamic json) {
    if (json['queries'] != null) {
      var tagObisJson = json['queries'] as List;
      List<Queries> assignmentsData = tagObisJson.map((tagJson) =>
          Queries.fromJson(tagJson)).toList();
      return TopicQueriesFormat(
          json["status"],
          json["status_message"],
          assignmentsData
      );
    }
    else
    {
      return TopicQueriesFormat(
          json["status"],
          json["status_message"]
      );
    }
  }
}

class Queries {
  String id;
  String topicId;
  String question;
  String answer;

  Queries(this.id,this.topicId,this.question,this.answer);
  factory Queries.fromJson(dynamic json) {
    return Queries(
      json["id"],
      json["topic_id"],
      json["question"],
      json["answer"],

    );
  }
}