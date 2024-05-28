import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:table_calendar/table_calendar.dart';

class Calender extends StatefulWidget {
  const Calender(
      {super.key,
      required this.getEventsForDay,
      required this.focusedDay,
      required this.selectedDay,
      required this.onDaySelected});
  final List<dynamic> Function(DateTime)? getEventsForDay;
  final DateTime focusedDay;
  final DateTime selectedDay;
  final void Function(DateTime, DateTime)? onDaySelected;

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      rowHeight: 40,
      headerVisible: true,
      headerStyle: HeaderStyle(
          headerPadding: EdgeInsets.symmetric(vertical: 5),
          formatButtonVisible: false,
          titleCentered: true),
      eventLoader: widget.getEventsForDay,
      locale: 'ar',
      focusedDay: widget.focusedDay,
      firstDay: DateTime.utc(2010, 3, 14),
      lastDay: DateTime.utc(2030, 3, 14),
      selectedDayPredicate: (day) {
        return isSameDay(widget.selectedDay, day);
      },
      onDaySelected: widget.onDaySelected,
      calendarStyle: const CalendarStyle(
          outsideDaysVisible: true,
          markersMaxCount: 5,
          markerDecoration:
              BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
          selectedDecoration:
              BoxDecoration(color: secondary, shape: BoxShape.circle),
          todayDecoration:
              BoxDecoration(color: primary, shape: BoxShape.circle)),
      startingDayOfWeek: StartingDayOfWeek.saturday,
      onPageChanged: (focusedDay) {
        focusedDay = focusedDay;
      },
    );
  }
}

class CustomCalendar extends StatefulWidget {
  final DateTime selectedDay;
  final DateTime focusedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final List<dynamic> Function(DateTime)? getEventsForDay;

  const CustomCalendar({
    Key? key,
    required this.selectedDay,
    required this.getEventsForDay,
    required this.focusedDay,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.selectedDay;
    _focusedDay = widget.focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ar',
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        widget.onDaySelected(selectedDay, focusedDay);
      },
      calendarStyle: const CalendarStyle(
          outsideDaysVisible: true,
          markersMaxCount: 5,
          markerDecoration:
              BoxDecoration(color: Colors.green, shape: BoxShape.circle),
          selectedDecoration:
              BoxDecoration(color: primary, shape: BoxShape.circle),
          todayDecoration:
              BoxDecoration(color: primary, shape: BoxShape.circle)),
      eventLoader: widget.getEventsForDay,
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerStyle: HeaderStyle(
          headerPadding: EdgeInsets.symmetric(vertical: 5),
          formatButtonVisible: false,
          titleCentered: true),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
    );
  }
}
