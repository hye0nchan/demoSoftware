
import 'package:fcm_notifications/restAPI/Repository.dart';
import 'package:fcm_notifications/restAPI/todo.dart';

class TodoController {
  final Repository _repository;

  TodoController(this._repository);

  // get
  Future<List<Todo>> fetchTodoList() async{
    return _repository.getTodoList();
  }

  // patch
  Future<String> updatePatchCompleted(Todo todo) async{
    return _repository.patchCompleted(todo);
  }

  // put
  Future<String> updatePutCompleted(Todo todo) async{
    return _repository.putCompleted(todo);
  }

  //del
  Future<String> deletedTodo(Todo todo) async{
    return _repository.deletedTodo(todo);
  }

  Future<String> postTodo(Todo todo) async{
    return _repository.postTodo(todo);
  }

}
