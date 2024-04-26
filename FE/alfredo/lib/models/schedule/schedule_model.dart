import 'package:json_annotation/json_annotation.dart';

part 'schedule_model.g.dart';

@JsonSerializable()
class Schedule {
  int? id;
  String title;
  DateTime startDate;
  DateTime? endDate;
  bool startAlarm;
  String? place;
  DateTime? startTime;
  DateTime? endTime;
  bool withTime;

  Schedule({
    this.id,
    required this.title,
    required this.startDate,
    this.endDate,
    this.startAlarm = false,
    this.place,
    this.startTime,
    this.endTime,
    this.withTime = true,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}
