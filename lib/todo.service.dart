import 'dart:convert' as convert;
import 'package:flutter_todo/todo.model.dart';
import 'package:http/http.dart' as http;

class TodoService {
  final String url = 'http://10.0.2.2:3333/todos';
  final Map<String, String> headers = {'Content-type': 'application/json'};

  Future<List<TodoModel>> getAll() async {
    http.Response res = await http.get(url, headers: headers);

    if (res.statusCode == 200) {
      List<dynamic> body = convert.jsonDecode(res.body);
      List<TodoModel> todos =
          body.map((dynamic item) => TodoModel.fromJson(item)).toList();
      return todos;
    } else {
      throw "There's nothing here. Start your own Todo list.";
    }
  }

  Future<String> post(TodoModel todo) async {
    http.Response res =
        await http.post(url, headers: headers, body: convert.jsonEncode(todo));

    if (res.statusCode == 200) {
      return "${todo.description} is added.";
    } else {
      return "Unable to add ${todo.description}!";
    }
  }

  Future<String> patch(TodoModel todo) async {
    http.Response res = await http.patch('$url/${todo.id}',
        headers: headers, body: convert.jsonEncode(todo));

    if (res.statusCode == 200) {
      return "${todo.description} is updated.";
    } else {
      return "Unable to update ${todo.description}!";
    }
  }

  Future<String> delete(TodoModel todo) async {
    http.Response res = await http.delete('$url/${todo.id}', headers: headers);

    if (res.statusCode == 200) {
      return "${todo.description} is removed.";
    } else {
      return "${todo.description} wasn't removed!";
    }
  }
}
