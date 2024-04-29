// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoutineModel _$RoutineModelFromJson(Map<String, dynamic> json) => RoutineModel(
      id: (json['id'] as num?)?.toInt(),
      routineTitle: json['routineTitle'] as String?,
      startTime: RoutineModel._timeFromString(json['startTime'] as String?),
      days: (json['days'] as List<dynamic>?)?.map((e) => e as String).toSet(),
      alarmSound: json['alarmSound'] as String?,
      memo: json['memo'] as String?,
    );

Map<String, dynamic> _$RoutineModelToJson(RoutineModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'routineTitle': instance.routineTitle,
      'startTime': RoutineModel._stringFromTime(instance.startTime),
      'days': instance.days?.toList(),
      'alarmSound': instance.alarmSound,
      'memo': instance.memo,
    };
