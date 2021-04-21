class SimpleResponseFormat
{
  int status;
  String statusMessage;

  SimpleResponseFormat(this.status,this.statusMessage);
  factory SimpleResponseFormat.fromJson(dynamic json) {
    return SimpleResponseFormat(
          json["status"],
          json["status_message"]
      );
  }
}