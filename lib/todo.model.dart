import 'package:flutter/foundation.dart';

class TodoModel {
  final String id;
  final String description;

  TodoModel({
    this.id,
    @required this.description
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['_id'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() => { 'description': description };
}
