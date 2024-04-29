import 'package:flutter/material.dart';
import '../../api/schedule/schedule_api.dart'; // API 호출을 위한 경로 수정
import '../../models/schedule/schedule_model.dart'; // 모델 클래스 경로 수정

class ScheduleController {
  final ScheduleApi api = ScheduleApi();

  // 모든 스케줄을 가져오는 메서드
  Future<List<Schedule>> getSchedules() async {
    return await api.fetchSchedules();
  }

  // 특정 스케줄의 상세 정보를 가져오는 메서드
  Future<Schedule> getScheduleDetail(int id) async {
    return await api.getScheduleDetail(id);
  }

  // 스케줄 생성 메서드
  Future<Schedule> createSchedule(Schedule schedule) async {
    return await api.createSchedule(schedule);
  }

  // 스케줄 수정 메서드
  Future<Schedule> updateSchedule(int id, Schedule schedule) async {
    return await api.updateSchedule(id, schedule);
  }

  // 스케줄 삭제 메서드
  Future<void> deleteSchedule(int id) async {
    await api.deleteSchedule(id);
  }
}
