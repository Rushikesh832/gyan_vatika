class NotificationModel
{
  int status;
  String statusMessage;
  List<Notification> notification;

  NotificationModel(this.status,this.statusMessage,[this.notification]);
  factory NotificationModel.fromJson(dynamic json) {
    if (json['notifications'] != null) {
      var tagObisJson = json['notifications'] as List;
      List<Notification> notificationData = tagObisJson.map((tagJson) =>
          Notification.fromJson(tagJson)).toList();
      return NotificationModel(
          json["status"],
          json["status_message"],
          notificationData
      );
    }
    else
    {
      return NotificationModel(
          json["status"],
          json["status_message"]
      );
    }
  }
}

class Notification {
  String id;
  String userId;
  String message;
  String status;
  String category;

  Notification(this.id,this.userId,this.message,this.status,this.category);
  factory Notification.fromJson(dynamic json) {
    return Notification(
      json["id"],
      json["user_id"],
      json["message"],
      json["status"],
      json["category"]

    );
  }
}