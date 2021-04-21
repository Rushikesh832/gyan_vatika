class LeaderBoardFormat
{
  int status;
  String statusMessage;
  List<LeaderBoard> leaderBoardData;

  LeaderBoardFormat(this.status,this.statusMessage,[this.leaderBoardData]);
  factory LeaderBoardFormat.fromJson(dynamic json) {
    if (json['leaderBoard'] != null) {
      var tagObisJson = json['leaderBoard'] as List;
      List<LeaderBoard> data = tagObisJson.map((tagJson) =>
          LeaderBoard.fromJson(tagJson)).toList();
      return LeaderBoardFormat(
          json["status"],
          json["status_message"],
          data
      );
    }
    else
    {
      return LeaderBoardFormat(
          json["status"],
          json["status_message"]
      );
    }
  }
}

class LeaderBoard {
  String fullName;
  String ratingSum;


  LeaderBoard(this.fullName,this.ratingSum);
  factory LeaderBoard.fromJson(dynamic json) {
    return LeaderBoard(

        json["fullName"],
        json["ratingSum"],


    );
  }
}