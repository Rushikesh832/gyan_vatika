class CircularFormat
{
  int status;
  String statusMessage;
  List<Circular> circularData;

  CircularFormat(this.status,this.statusMessage,[this.circularData]);
  factory CircularFormat.fromJson(dynamic json) {
    if (json['circular'] != null) {
      var tagObisJson = json['circular'] as List;
      List<Circular> circularData = tagObisJson.map((tagJson) =>
          Circular.fromJson(tagJson)).toList();
      return CircularFormat(
          json["status"],
          json["status_message"],
          circularData
      );
    }
    else
    {
      return CircularFormat(
          json["status"],
          json["status_message"]
      );
    }
  }
}

class Circular {
  String id;
  String text;
  String image;
  String userType;
  String status;

  Circular(this.id,this.text,this.image,this.userType,this.status);
  factory Circular.fromJson(dynamic json) {
    return Circular(
        json["id"],
        json["text"],
        json["image"],
        json["userType"],
        json["status"],

    );
  }
}