import 'dart:core';

import 'package:alfredo/controller/todo/todo_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../provider/todo/todo_provider.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(todoControllerProvider);
    return Calendar(controller: controller);
  }
}

class Calendar extends StatefulWidget {
  final TodoController controller;

  const Calendar({super.key, required this.controller});

  @override
  _Calendar createState() => _Calendar();
}

class _Calendar extends State<Calendar> with TickerProviderStateMixin {
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
  bool _showAgenda = false; // 일정 표시 여부 상태 변수

  // ignore: non_constant_identifier_names
  final CalendarController _controller = CalendarController();
  // ignore: prefer_const_constructors, prefer_final_fields
  MonthViewSettings _monthViewSettings = MonthViewSettings(
    appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
    showTrailingAndLeadingDates: false,
  );

  @override
  void initState() {
    super.initState();

    _loadCalendarData(
        'https://calendar.google.com/calendar/ical/rlaxodhks770%40gmail.com/private-2b11b7a9fb0eea814024ec761591d8fb/basic.ics');
  }

  // ignore: body_might_complete_normally_nullable
  Future<void> _loadCalendarData(String iCalUrl) async {
    try {
      final response = await http.get(Uri.parse(iCalUrl));
      if (response.statusCode == 200) {
        final icsString = response.body;
        _iCalendar = ICalendar.fromString(icsString);
        _iCalendarJson = _iCalendar!.toJson();
        final dataSource = await getCalendarDataSource(_iCalendarJson);
        setState(() {
          _calendarDataSource = dataSource;
        });
      } else {
        throw Exception('Failed to load iCal data');
      }
    } catch (error) {
      print('Error fetching iCal data: $error');
      // 오류 처리를 원하는 대로 수행하세요.
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
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

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
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

  void calendarTapped(CalendarTapDetails calendarTapDetails) async {
    print('**************');
    print(calendarTapDetails.appointments);
    print('**************');
    print(calendarTapDetails.targetElement);
    print('**************');
    if (_controller.view == CalendarView.month &&
        calendarTapDetails.targetElement == CalendarElement.calendarCell &&
        !_monthViewSettings.showAgenda) {
      setState(() {
        detailMonthCalendar();
      });
    }
  }

  void calendarDarged(DragUpdateDetails details) {
    if (!_isDragging) {
      setState(() {
        _showAgenda = !_showAgenda;
      });
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
      agendaViewHeight: screenHeight / 2.5,
    );
  }

  Future<void> detailWeekCalendar() async {
    // ignore: prefer_const_constructors
    _monthViewSettings = MonthViewSettings(
      showAgenda: true,
      showTrailingAndLeadingDates: false,
      numberOfWeeksInView: 1,
      agendaViewHeight: screenHeight / 1.34,
    );
  }

  Future<_DataSource?> getCalendarDataSource(Map? iCalendarJson) async {
    if (iCalendarJson != null) {
      final List<Appointment> appointments = <Appointment>[];
      for (Map? datas in iCalendarJson['data']) {
        if (datas!['dtstart'] != null) {
          appointments.add(Appointment(
            startTime: DateTime.parse(datas['dtstart']['dt']),
            endTime: DateTime.parse(datas['dtend']['dt']),
            subject: datas['summary'] ?? '',
          ));
        } else {}
      }
      return _DataSource(appointments);
    } else {
      print('null널하네요 ********************************');
      return null;
    }
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(this.source);

  List<Appointment> source;

  @override
  List<dynamic> get appointments => source;
}
