import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 형식을 위해 추가
import '../../controller/schedule/schedule_controller.dart';
import '../../models/schedule/schedule_model.dart';

class ScheduleEditScreen extends StatefulWidget {
  final int scheduleId;

  ScheduleEditScreen({Key? key, required this.scheduleId}) : super(key: key);

  @override
  _ScheduleEditScreenState createState() => _ScheduleEditScreenState();
}

class _ScheduleEditScreenState extends State<ScheduleEditScreen> {
  final ScheduleController controller = ScheduleController();
  final _formKey = GlobalKey<FormState>();

  late String _title;
  late DateTime _startDate;
  late DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _title = '';
    _startDate = DateTime.now();
    _endDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Schedule>(
      future: controller.getScheduleDetail(widget.scheduleId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          var schedule = snapshot.data!;
          _title = schedule.scheduleTitle;
          _startDate = schedule.startDate;
          _endDate = schedule.endDate;

          return Scaffold(
            appBar: AppBar(
              title: Text("일정 수정"),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  TextFormField(
                    initialValue: schedule.scheduleTitle,
                    decoration: InputDecoration(labelText: '일정 제목'),
                    onSaved: (value) => _title = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '제목을 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  ListTile(
                    title: Text("시작 날짜: ${DateFormat('yyyy-MM-dd').format(_startDate)}"),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null && picked != _startDate) {
                        setState(() {
                          _startDate = picked;
                        });
                      }
                    },
                  ),
                  ListTile(
                    title: Text("종료 날짜: ${_endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : '설정 안됨'}"),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _endDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          _endDate = picked;
                        });
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        schedule.scheduleTitle = _title;
                        schedule.startDate = _startDate;
                        schedule.endDate = _endDate;
                        controller.updateSchedule(schedule.scheduleId!, schedule)
                          .then((_) => Navigator.pop(context));
                      }
                    },
                    child: Text('수정하기'),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(body: Center(child: Text("일정을 불러올 수 없습니다")));
        }
      },
    );
  }
}