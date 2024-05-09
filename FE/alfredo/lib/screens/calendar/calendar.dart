import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../models/schedule/schedule_model.dart';
import '../../models/todo/todo_model.dart';
import '../../provider/schedule/schedule_provider.dart';
import '../../provider/todo/todo_provider.dart';
import '../../screens/todo/todo_detail_screen.dart';
import '../schedule/schedule_edit_screen.dart';

class Calendar extends ConsumerStatefulWidget {
  const Calendar({super.key});

  @override
  _Calendar createState() => _Calendar();
}

class _Calendar extends ConsumerState<Calendar> {
  final List<Appointment> appointments = <Appointment>[];
  // ignore: avoid_init_to_null
  ICalendar? _iCalendar;
  // ignore: prefer_final_fields
  bool? _isLoading;
  double screenHeight = 0.0;
  bool _isDragging = false;
  // ignore: unused_field
  Map? _iCalendarJson;
  _DataSource? _calendarDataSource;
  // ignore: prefer_final_fields
  final CalendarController _controller = CalendarController();
  // ignore: prefer_const_constructors, prefer_final_fields
  MonthViewSettings _monthViewSettings = MonthViewSettings(
    appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
    showTrailingAndLeadingDates: false,
  );

  Future<void> _fetchSchedule() async {
    final scheduleController = ref.read(scheduleControllerProvider);
    var fetchedSchedule = await scheduleController.getSchedules();
    for (Schedule _schedule in fetchedSchedule) {
      appointments.add(
        Appointment(
          startTime: _schedule.startDate,
          endTime: _schedule.endDate ?? _schedule.startDate,
          isAllDay: true,
          subject: _schedule.scheduleTitle,
          save_type: 'schedule',
          params: _schedule.scheduleId.toString(),
          color: const Color(0xFFe7d8bc),
        ),
      );
    }
  }

  Future<void> _fetchTodos() async {
    final todoController = ref.read(todoControllerProvider);
    var fetchedTodos = await todoController.fetchTodoList();
    for (Todo _todo in fetchedTodos) {
      appointments.add(
        Appointment(
          startTime: _todo.dueDate,
          endTime: _todo.dueDate,
          isAllDay: true,
          subject: _todo.todoTitle,
          save_type: 'todo',
          params: _todo.id.toString(),
          color: const Color(0xFFD6C3C3),
        ),
      );
    }
  }

  Future<void> _loadiCalendarData(String iCalUrl) async {
    try {
      final response = await http.get(Uri.parse(iCalUrl));
      if (response.statusCode == 200) {
        final icsString = response.body;
        _iCalendar = ICalendar.fromString(icsString);
        _iCalendarJson = _iCalendar!.toJson();
        await getCalendarDataSource(_iCalendarJson);
      } else {
        throw Exception('Failed to load iCal data');
      }
    } catch (error) {
      print('Error fetching iCal data: $error');
      // 오류 처리를 원하는 대로 수행하세요.
    }

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   setState(() {});
    // });
  }

  Future<void> _removeSchedule(String saveType) async {
    setState(() {
      appointments
          .removeWhere((appointment) => appointment.save_type == saveType);
    });
  }

  @override
  void initState() {
    super.initState();

    _fetchSchedule().then((value) => _fetchTodos().then((value) =>
        _loadiCalendarData(
                'https://calendar.google.com/calendar/ical/rlaxodhks770%40gmail.com/private-2b11b7a9fb0eea814024ec761591d8fb/basic.ics')
            .then((value) => loadCalendarDataSource())));
  }

  // SharedPreferences에 iCalendar 데이터를 비교 하는 함수
  Future<bool> compareLastModified(String lastModifiedData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedlastModified = prefs.getString('lastModified');
    if (DateTime.parse(savedlastModified!)
        .isAtSameMomentAs(DateTime.parse(lastModifiedData))) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> loadCalendarDataSource() async {
    setState(() {
      _calendarDataSource = _DataSource(appointments);
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0), // AppBar의 높이 설정
        child: AppBar(),
      ),
      body: GestureDetector(
        onVerticalDragUpdate: calendarDarged,
        onVerticalDragEnd: calendarDragEnd,
        child: SfCalendar(
          view: CalendarView.month,
          allowedViews: const <CalendarView>[
            CalendarView.day,
            CalendarView.week,
            CalendarView.workWeek,
            CalendarView.month,
            CalendarView.schedule
          ],
          showTodayButton: true,
          showDatePickerButton: true,
          controller: _controller,
          initialSelectedDate: DateTime.now(),
          dataSource: _calendarDataSource,
          onTap: calendarTapped,
          monthViewSettings: _monthViewSettings,
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant Calendar oldWidget) {
    print('#################################################');
    print(oldWidget);
    print('############################################');
    super.didUpdateWidget(oldWidget);
    // 여기에서 oldWidget을 사용하여 이전 위젯의 정보에 접근할 수 있습니다.
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) async {
    if (_controller.view == CalendarView.month &&
        calendarTapDetails.targetElement == CalendarElement.calendarCell &&
        !_monthViewSettings.showAgenda) {
      setState(() {
        detailMonthCalendar();
      });
    }
    if (calendarTapDetails.targetElement == CalendarElement.appointment) {
      if (calendarTapDetails.appointments![0].save_type == 'todo') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return TodoDetailScreen(
                todoId: int.parse(calendarTapDetails.appointments![0].params));
          },
        );
      } else if (calendarTapDetails.appointments![0].save_type == 'schedule') {
        var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScheduleEditScreen(
                  scheduleId:
                      int.parse(calendarTapDetails.appointments![0].params))),
        );
        if (result != null && result == true) {
          appointments.clear();
          _fetchSchedule().then((value) => _fetchTodos().then((value) =>
              _loadiCalendarData(
                      'https://calendar.google.com/calendar/ical/rlaxodhks770%40gmail.com/private-2b11b7a9fb0eea814024ec761591d8fb/basic.ics')
                  .then((value) => loadCalendarDataSource())));
        }
      }
    }
  }

  void calendarDarged(DragUpdateDetails details) {
    if (!_isDragging) {
      _isDragging = true;
      if (details.delta.dy > screenHeight / 100) {
        if (_monthViewSettings.numberOfWeeksInView == 6) {
          monthCalendar();
        } else if (_monthViewSettings.numberOfWeeksInView == 1) {
          detailMonthCalendar();
        }
      } else if (details.delta.dy < -screenHeight / 100) {
        if (!_monthViewSettings.showAgenda) {
          detailMonthCalendar();
        } else if (_monthViewSettings.appointmentDisplayMode !=
            MonthAppointmentDisplayMode.appointment) {
          detailWeekCalendar();
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
      setState(() {});
    }
  }

  Future<void> calendarDragEnd(DragEndDetails details) async {
    _isDragging = false;
  }

  Future<void> monthCalendar() async {
    _monthViewSettings = const MonthViewSettings(
      showAgenda: false,
      appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
      showTrailingAndLeadingDates: false,
    );
  }

  Future<void> detailMonthCalendar() async {
    // ignore: no_leading_underscores_for_local_identifiers
    _monthViewSettings = MonthViewSettings(
      showAgenda: true,
      showTrailingAndLeadingDates: false,
      agendaViewHeight: screenHeight / 4.05,
    );
  }

  Future<void> detailWeekCalendar() async {
    // ignore: prefer_const_constructors
    _monthViewSettings = MonthViewSettings(
      showAgenda: true,
      showTrailingAndLeadingDates: false,
      numberOfWeeksInView: 1,
      agendaViewHeight: screenHeight / 1.4,
    );
  }

  Future<void> getCalendarDataSource(Map? iCalendarJson) async {
    if (iCalendarJson != null) {
      for (Map? datas in iCalendarJson['data']) {
        if (datas!['dtstart'] != null) {
          DateTime startDateTime = DateTime.parse(datas['dtstart']['dt']);
          DateTime endDateTime = DateTime.parse(datas['dtend']['dt']);
          if (startDateTime.hour == 0 &&
              startDateTime.minute == 0 &&
              startDateTime.second == 0 &&
              endDateTime.hour == 0 &&
              endDateTime.minute == 0 &&
              endDateTime.second == 0) {
            appointments.add(Appointment(
              startTime: startDateTime,
              endTime: endDateTime.subtract(const Duration(days: 1)),
              save_type: 'iCal',
              isAllDay: true,
              subject: datas['summary'] ?? '(제목 없음)',
            ));
          } else {
            appointments.add(Appointment(
              startTime: startDateTime,
              endTime: endDateTime,
              save_type: 'iCal',
              subject: datas['summary'] ?? '(제목 없음)',
            ));
          }
        }
      }
    }
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(this.source);

  List<Appointment> source;

  @override
  List<dynamic> get appointments => source;
}
