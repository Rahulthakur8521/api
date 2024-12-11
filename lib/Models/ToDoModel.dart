

class ToDoModel {
  String? title;
  String? body;
  int? userId;

  ToDoModel({
    this.title,
    this.body,
    this.userId,
  });

  factory ToDoModel.fromJson(Map<String, dynamic> json) => ToDoModel(
    title: json["title"],
    body: json["body"],
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "body": body,
    "userId": userId,
  };
}



