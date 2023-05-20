import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:here_admin/component/date_container.dart';
import 'package:here_admin/firebase/firebase_realtime_database.dart';
import 'package:here_admin/firebase/model/print_attendance_data.dart';
import 'package:here_admin/firebase/model/student_attendance.dart';
import 'package:flutter/cupertino.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with WidgetsBindingObserver {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  ValueNotifier<List<PrintAttendanceData>> valueNotifier =
      ValueNotifier(<PrintAttendanceData>[]);

  FirebaseRealtimeDatabase firebaseRealtimeDatabase =
      FirebaseRealtimeDatabase();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DateContainer(
          selectDate: selectedDay,
          onPressed: getCalendar,
        ),
        const SizedBox(
          height: 16.0,
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text('이름', style: TextStyle(fontSize: 20.0),)),
              Expanded(child: Text('입실시간', style: TextStyle(fontSize: 20.0),)),
              Expanded(child: Text('퇴실시간', style: TextStyle(fontSize: 20.0),)),
            ],
          ),
        ),
        ValueListenableBuilder(
          valueListenable: valueNotifier,
          builder: (BuildContext context, List<PrintAttendanceData> value,
              Widget? child) {
            return _AttendanceDataList(printAttendanceList: valueNotifier.value);
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    getAttendanceData(selectedDay);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
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

  getCalendar() {
    print('getCalendar');
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context){
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            height: 300.0,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: selectedDay,
              maximumYear: DateTime.now().year,
              maximumDate: DateTime.now(),
              onDateTimeChanged: (DateTime date) {
                onDaySelected(date, date);
              },
            ),
          ),
        );
      },
    );
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
        .then((value) => {if (value.exists) settingData(value) else noData()})
        .catchError((error) => {noData()});
  }

  settingData(DataSnapshot snapshot) {
    Map<dynamic, dynamic> valueList = snapshot.value as Map<dynamic, dynamic>;
    List<StudentAttendanceInfo> dataList = <StudentAttendanceInfo>[];

    for (Map<dynamic, dynamic> value in valueList.values) {
      dataList.add(StudentAttendanceInfo(value));
    }

    Map<String, List<StudentAttendanceInfo>> printList = <String, List<StudentAttendanceInfo>>{};

    for (var element in dataList) {
      List<StudentAttendanceInfo> list = <StudentAttendanceInfo>[];
      list.add(element);
      if(printList[element.uid] == null) printList[element.uid] = list;
      else printList[element.uid]!.add(element);
    }

    print('printList ${printList}');

    List<PrintAttendanceData> attendanceDataList = <PrintAttendanceData>[];
    printList.forEach((key, value) {
        PrintAttendanceData printAttendanceData = PrintAttendanceData();
        printAttendanceData.uid = key;
        for (var element in value) {
          printAttendanceData.name = element.name;
          if(element.attendance) printAttendanceData.AttendanceTime = element.time;
          else printAttendanceData.LeaveTime = element.time;
        }

        attendanceDataList.add(printAttendanceData);
    });

    valueNotifier.value = attendanceDataList;
  }

  noData() {
    print('no Data');
    valueNotifier.value = <PrintAttendanceData>[];
  }
}

class _AttendanceDataList extends StatelessWidget {
  final List<PrintAttendanceData> printAttendanceList;

  const _AttendanceDataList({required this.printAttendanceList, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
          itemBuilder: (context, index) {
            return _AttendanceCard(
                printAttendanceData: printAttendanceList[index]);
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 8.0,
            );
          },
          itemCount: printAttendanceList.length),
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  final PrintAttendanceData printAttendanceData;
  final textStyle = const TextStyle(
    fontSize: 20.0,
  );

  const _AttendanceCard({
    required this.printAttendanceData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child:Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                printAttendanceData.name,
                style: textStyle,
              ),
            ),
            Expanded(
              child: Text(
                printAttendanceData.AttendanceTime,
                style: textStyle,
              ),
            ),
            Expanded(
              child: Text(
                printAttendanceData.LeaveTime,
                style: textStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
