import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'routine_model.g.dart'; // 자동 생성될 파일 이름

@JsonSerializable()
class RoutineModel {
  int? id;

  String? routineTitle;
  @JsonKey(fromJson: _timeFromString, toJson: _stringFromTime)
  TimeOfDay? startTime;

  Set<String>? days;

  String? alarmSound;

  String? memo;

  RoutineModel({
    required this.id,
    required this.routineTitle,
    required this.startTime,
    required this.days,
    required this.alarmSound,
    this.memo,
  });

  // JSON 생성 및 해석을 위한 팩토리 메서드
  factory RoutineModel.fromJson(Map<String, dynamic> json) =>
      _$RoutineModelFromJson(json);
  Map<String, dynamic> toJson() => _$RoutineModelToJson(this);

  static TimeOfDay _timeFromString(String? timeStr) {
    if (timeStr == null) return TimeOfDay(hour: 0, minute: 0);
    final timeParts = timeStr.split(':').map(int.parse).toList();
    return TimeOfDay(hour: timeParts[0], minute: timeParts[1]);
  }

  static String _stringFromTime(TimeOfDay? time) {
    if (time == null) return '';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
  }
}

  // factory RoutineModel.fromJson(Map<String, dynamic> json) {
  //   return RoutineModel(
  //     id: json['routine_id'] ?? 0, // 널일 경우 기본값 제공
  //     routineTitle: json['routine_title'] ?? '', // 기본값 제공
  //     startTime: json['start_time'] != null
  //         ? DateTime.parse(json['start_time'])
  //         : DateTime.now(), // 변환 및 기본값 제공
  //     days: Set<String>.from(json['days'] ?? []), // 널 검사 및 변환
  //     alarmSound: json['alarm_sound'] ?? '', // 기본값 제공
  //     memo: json['memo'], // 널 가능 타입이므로 그대로 할당
  //   );
  // }
