import 'package:flutter/foundation.dart';

class TodoModel {
  final String id;
  final String body;

  TodoModel({
    this.id,
    @required this.body
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['_id'] as String,
      body: json['body'] as String,
    );
  }

  Map<String, dynamic> toJson() => { 'Body': body };
}
