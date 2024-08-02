import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';

class CalenderHome extends StatelessWidget {
  CalenderHome({
    required this.controller,
    required this.focusDate,
    required this.onDateChange,
    super.key,
  });
  EasyInfiniteDateTimelineController controller;
  DateTime focusDate;
  ValueChanged<DateTime> onDateChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: EasyInfiniteDateTimeLine(
        controller: controller,
        firstDate: DateTime(2024, 01, 01),
        focusDate: focusDate,
        lastDate: DateTime(2040, 12, 31),
        onDateChange: onDateChange,
        activeColor: Colors.blue,
        showTimelineHeader: false,
        dayProps: EasyDayProps(
            borderColor: Colors.black,
            width: 80,
            height: 100,
            //
            //active style
            //
            activeDayStyle: DayStyle(
              borderRadius: 20,
              dayStrStyle: TextStyle(
                color: Colors.white,
              ),
              monthStrStyle: TextStyle(color: Colors.white),
              dayNumStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            //
            //inactive style
            //
            inactiveDayStyle: DayStyle(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.transparent,
                border: Border.all(
                    color: Colors.black,
                    width: 0.5), // Change border width here
              ),
              borderRadius: 20,
              dayStrStyle: TextStyle(color: Colors.black),
              monthStrStyle: TextStyle(color: Colors.black),
              dayNumStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: "NotoSans Bold",
                  fontSize: 20),
            ),
            //
            //today style
            //
            todayStyle: DayStyle(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.transparent,
                border: Border.all(
                    color: Colors.blue, width: 2.0), // Change border width here
              ),
              borderRadius: 20,
              dayStrStyle: TextStyle(color: Colors.blue),
              monthStrStyle: TextStyle(color: Colors.blue),
              dayNumStyle: TextStyle(
                  color: Colors.blue,
                  fontFamily: "NotoSans Bold",
                  fontSize: 20),
            )),
        timeLineProps: const EasyTimeLineProps(
          hPadding: 100.0, // padding from left and right
          separatorPadding: 10.0, // padding between days
        ),
      ),
    );
  }
}
