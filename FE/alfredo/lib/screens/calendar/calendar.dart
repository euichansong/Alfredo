import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  _Calendar createState() => _Calendar();
}

class _Calendar extends State<Calendar> {
  // ignore: non_constant_identifier_names
  final CalendarController _controller = CalendarController();
  // ignore: prefer_const_constructors, prefer_final_fields
  MonthViewSettings _monthViewSettings = MonthViewSettings(
    appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
    showTrailingAndLeadingDates: false,
  );
  double screenHeight = 0.0;
  bool _isDragging = false;

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
              dataSource: getCalendarDataSource(),
              onTap: calendarTapped,
              // by default the month appointment display mode set as Indicator, we can
              // change the display mode as appointment using the appointment display
              // mode property
              monthViewSettings: _monthViewSettings,
            )));
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) async {
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
      // setState 호출 이후에 작업을 스케줄링하여 showAgenda를 true로 설정
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
      setState(() {});
    }
  }

  void calendarDragEnd(DragEndDetails details) {
    _isDragging = false;
  }

  void monthCalendar() {
    _monthViewSettings = const MonthViewSettings(
      showAgenda: false,
      appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
      showTrailingAndLeadingDates: false,
    );
  }

  void detailMonthCalendar() {
    // ignore: no_leading_underscores_for_local_identifiers
    _monthViewSettings = MonthViewSettings(
      showAgenda: true,
      showTrailingAndLeadingDates: false,
      agendaViewHeight: screenHeight / 2.5,
    );
  }

  void detailWeekCalendar() {
    // ignore: prefer_const_constructors
    _monthViewSettings = MonthViewSettings(
      showAgenda: true,
      showTrailingAndLeadingDates: false,
      numberOfWeeksInView: 1,
      agendaViewHeight: screenHeight / 1.34,
    );
  }

  _DataSource getCalendarDataSource() {
    final List<Appointment> appointments = <Appointment>[];
    appointments.add(Appointment(
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 1)),
      subject: 'Meeting',
      color: Colors.pink,
    ));
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(hours: 4)),
      endTime: DateTime.now().add(const Duration(hours: 5)),
      subject: 'Release Meeting',
      color: Colors.lightBlueAccent,
    ));
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(hours: 6)),
      endTime: DateTime.now().add(const Duration(hours: 7)),
      subject: 'Performance check',
      color: Colors.amber,
    ));
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(hours: 8)),
      endTime: DateTime.now().add(const Duration(hours: 9)),
      subject: 'Support',
      color: Colors.green,
    ));
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(hours: 9)),
      endTime: DateTime(2024, 4, 29, 17, 30),
      subject: 'Retrospective',
      color: Colors.purple,
    ));

    return _DataSource(appointments);
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(this.source);

  List<Appointment> source;

  @override
  List<dynamic> get appointments => source;
}
