class CalenderFormat
{
  int status;
  String statusMessage;
  List<Calender> calenderData;

  CalenderFormat(this.status,this.statusMessage,[this.calenderData]);
  factory CalenderFormat.fromJson(dynamic json) {
    if (json['calender'] != null) {
      var tagObisJson = json['calender'] as List;
      List<Calender> calenderData = tagObisJson.map((tagJson) =>
          Calender.fromJson(tagJson)).toList();
      return CalenderFormat(
          json["status"],
          json["status_message"],
          calenderData
      );
    }
    else
    {
      return CalenderFormat(
          json["status"],
          json["status_message"]
      );
    }
  }
}

class Calender {
  String id;
  String date;
  String event;
  String userType;

  Calender(this.id,this.date,this.event,this.userType);
  factory Calender.fromJson(dynamic json) {
    return Calender(
        json["id"],
        json["date"],
        json["event"],
        json["userType"]

    );
  }
}