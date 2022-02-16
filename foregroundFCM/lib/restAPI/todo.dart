import 'package:fcm_notifications/main.dart';

class Todo {
  int userId;
  int id;
  String title;
  bool completed;

  Todo({this.userId, this.id, this.title, this.completed});

  Todo.fromJson(Map<String, dynamic> json){
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    completed = json['completed'];
  }

  // fake server는 post type 지원 x 이후에 .toString 제거
  Map<String, dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['userId'] = this.userId.toString();
    data['id'] = this.id.toString();
    data['title'] = this.title;
    data['completed'] = this.completed.toString();
    return data;
  }
}