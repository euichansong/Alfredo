import 'package:json_annotation/json_annotation.dart';

part 'todo_model.g.dart';

@JsonSerializable()
class Todo {
  int? id;
  String? subIndex;
  String todoTitle;
  String? todoContent;
  @JsonKey(fromJson: _fromJsonDateTime, toJson: _toJsonDateTime)
  DateTime dueDate;
  int? spentTime;
  bool isCompleted;
  String? url;
  String? place;
  String? uid; // 사용자 고유 ID 필드 추가

  Todo({
    this.id,
    this.subIndex,
    required this.todoTitle,
    this.todoContent,
    required this.dueDate,
    this.spentTime,
    this.isCompleted = false,
    this.url,
    this.place,
    this.uid, // 생성자에 uid 추가
  });

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
  Map<String, dynamic> toJson() => _$TodoToJson(this);

  static DateTime _fromJsonDateTime(String date) => DateTime.parse(date);
  static String _toJsonDateTime(DateTime date) => date.toIso8601String();
}


// import 'package:flutter/material.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'todo_model.g.dart';

// @JsonSerializable()
// class Todo {
//   int? id;
//   String todoTitle;
//   String? todoContent;

//   @JsonKey(fromJson: _fromJsonDateTime, toJson: _toJsonDateTime)
//   DateTime dueDate;

//   int? spentTime;
//   bool isCompleted;
//   String? url;
//   String? place;

//   Todo({
//     this.id,
//     required this.todoTitle,
//     this.todoContent,
//     required this.dueDate,
//     this.spentTime,
//     this.isCompleted = false,
//     this.url,
//     this.place,
//   });

//   factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
//   Map<String, dynamic> toJson() => _$TodoToJson(this);

//   static DateTime _fromJsonDateTime(String date) => DateTime.parse(date);
//   static String _toJsonDateTime(DateTime date) => date.toIso8601String();
// }
