import 'package:fcm_notifications/main.dart';

class Todo {
  int id;
  String name;
  bool isComplete;

  Todo({this.id, this.name, this.isComplete,});

  Todo.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    isComplete = json['isComplete'];
  }

  // fake server는 post type 지원 x 이후에 .toString 제거
  Map<String, dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isComplete'] = this.isComplete;
    return data;
  }
}