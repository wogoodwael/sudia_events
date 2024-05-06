import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:table_calendar/table_calendar.dart';

class Calender extends StatelessWidget {
  const Calender(
      {super.key,
    required  this.getEventsForDay,
      required this.focusedDay,
      required this.selectedDay,required this.onDaySelected});
  final List<dynamic> Function(DateTime)? getEventsForDay;
  final DateTime focusedDay;
  final DateTime selectedDay;
 final void Function(DateTime, DateTime)? onDaySelected;
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      rowHeight: 40,
      headerVisible: true,
      headerStyle: HeaderStyle(
          headerPadding: EdgeInsets.symmetric(vertical: 5),
          formatButtonVisible: false,
          titleCentered: true),
      eventLoader: getEventsForDay,
      locale: 'ar',
      focusedDay: focusedDay,
      firstDay: DateTime.utc(2010, 3, 14),
      lastDay: DateTime.utc(2030, 3, 14),
      selectedDayPredicate: (day) {
        return isSameDay(selectedDay, day);
      },
      onDaySelected: onDaySelected,
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
