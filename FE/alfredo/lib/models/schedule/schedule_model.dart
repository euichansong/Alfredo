import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'schedule_model.g.dart';

@JsonSerializable()
class Schedule {
  int? scheduleId;
  String scheduleTitle;
  DateTime startDate;
  DateTime? endDate;
  bool startAlarm;
  String? place;
  @JsonKey(fromJson: _timeFromString, toJson: _stringFromTime)
  TimeOfDay? startTime;
  @JsonKey(fromJson: _timeFromString, toJson: _stringFromTime)
  TimeOfDay? endTime;
  @JsonKey(fromJson: _timeFromString, toJson: _stringFromTime)
  TimeOfDay? alarmTime;
  bool withTime;

  Schedule({
    this.scheduleId,
    required this.scheduleTitle,
    required this.startDate,
    this.endDate,
    this.startAlarm = false,
    this.place,
    this.startTime,
    this.endTime,
    this.alarmTime,
    this.withTime = true,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);

  // Map<String, dynamic> toJson() => _$ScheduleToJson(this);
  Map<String, dynamic> toJson() => {
      'scheduleId': scheduleId,
      'scheduleTitle': scheduleTitle,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'startAlarm': startAlarm,  // 이 필드가 항상 포함되도록 보장
      'place': place,
      'startTime': _stringFromTime(startTime),
      'endTime': _stringFromTime(endTime),
      'alarmTime': _stringFromTime(alarmTime),
      'withTime': withTime,
    };

  Schedule copyWith({
    int? scheduleId,
    String? scheduleTitle,
    DateTime? startDate,
    DateTime? endDate,
    bool? startAlarm,
    String? place,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    TimeOfDay? alarmTime,
    bool? withTime,
  }) {
    return Schedule(
      scheduleId: scheduleId ?? this.scheduleId,
      scheduleTitle: scheduleTitle ?? this.scheduleTitle,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startAlarm: startAlarm ?? this.startAlarm,
      place: place ?? this.place,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      withTime: withTime ?? this.withTime,
      alarmTime: alarmTime ?? this.alarmTime
    );
  }

  static TimeOfDay _timeFromString(String? timeStr) {
    if (timeStr == null) return const TimeOfDay(hour: 0, minute: 0);
    final timeParts = timeStr.split(':').map(int.parse).toList();
    return TimeOfDay(hour: timeParts[0], minute: timeParts[1]);
  }

  static String _stringFromTime(TimeOfDay? time) {
    if (time == null) return '';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
  }
}
