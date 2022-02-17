class TodoItems {
  int id;
  int name;
  String isComplete;

  TodoItems({
    this.id,
    this.name,
    this.isComplete
  });

  factory TodoItems.fromJson(Map<String, dynamic> json){
    return TodoItems(
        id : json['id'],
        name : json['name'],
        isComplete : json['isComplete']
    );
  }

}
