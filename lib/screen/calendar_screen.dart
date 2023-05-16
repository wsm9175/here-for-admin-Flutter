import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:here_admin/component/calendar.dart';
import 'package:here_admin/firebase/firebase_realtime_database.dart';
import 'package:here_admin/firebase/model/student_attendance.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> with  WidgetsBindingObserver{
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  ValueNotifier<List<StudentAttendanceInfo>> valueNotifier =
  ValueNotifier(<StudentAttendanceInfo>[]);

  FirebaseRealtimeDatabase firebaseRealtimeDatabase =
  FirebaseRealtimeDatabase();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Calendar(
          selectedDay: selectedDay,
          focusedDay: focusedDay,
          onDaySelected: onDaySelected,
        ),
        ValueListenableBuilder(
          valueListenable: valueNotifier,
          builder: (BuildContext context, List<StudentAttendanceInfo> value,
              Widget? child) {
            return _AttendanceDataList(attendanceDataList: valueNotifier.value);
          },
        ),
      ],
    );
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch(state){
      case AppLifecycleState.resumed:
        // TODO: Handle this case.
        getAttendanceData(selectedDay);
      case AppLifecycleState.inactive:
        // TODO: Handle this case.
      case AppLifecycleState.paused:
        // TODO: Handle this case.
      case AppLifecycleState.detached:
        // TODO: Handle this case.
    }
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    print(selectedDay);
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
    getAttendanceData(selectedDay);
  }

  getAttendanceData(DateTime selectedDay) {
    firebaseRealtimeDatabase
        .getAttendanceDataByDate(selectedDay)
        .then((value) =>
    {
      if (value.exists) settingData(value)
      else
        noData()
    })
        .catchError((error) =>
    {
      noData()
    });
  }

  settingData(DataSnapshot snapshot) {
    Map<dynamic, dynamic> valueList = snapshot.value as Map<dynamic, dynamic>;
    List<StudentAttendanceInfo> dataList = <StudentAttendanceInfo>[];

    for (Map<dynamic, dynamic> value in valueList.values) {
      dataList.add(StudentAttendanceInfo(value, snapshot.key!));
    }
    valueNotifier.value = dataList;
  }

  noData() {
    print('no Data');
    valueNotifier.value = <StudentAttendanceInfo>[];
  }
}

class _AttendanceDataList extends StatelessWidget {
  final List<StudentAttendanceInfo> attendanceDataList;

  const _AttendanceDataList({required this.attendanceDataList, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
          itemBuilder: (context, index) {
            return _AttendanceCard(
                studentAttendanceInfo: attendanceDataList[index]);
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 8.0,
            );
          },
          itemCount: attendanceDataList.length),
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  final StudentAttendanceInfo studentAttendanceInfo;
  final textStyle = const TextStyle(
    fontSize: 20.0,
  );

  const _AttendanceCard({
    required this.studentAttendanceInfo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              studentAttendanceInfo.attendance ? "출석" : "결석",
              style: textStyle,
            ),
            const SizedBox(height: 8.0,),
            Text(
              '전화번호 : ${studentAttendanceInfo.phoneNumber}',
              style: textStyle,
            ),
            const SizedBox(height: 8.0,),
            Text(
              '이름 : ${studentAttendanceInfo.name}',
              style: textStyle,
            ),
            const SizedBox(height: 8.0,),
            Text(
              '반 타입 : ${studentAttendanceInfo.classType}',
              style: textStyle,
            ),
            const SizedBox(height: 8.0,),
            Text(
              '시간 : ${studentAttendanceInfo.time}',
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
