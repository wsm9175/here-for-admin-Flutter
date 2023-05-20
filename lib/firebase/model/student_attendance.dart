class StudentAttendanceInfo{
  late String uid;
  late String phoneNumber;
  late String name;
  late String classType;
  late bool attendance;
  late String time;


  StudentAttendanceInfo(Map<dynamic, dynamic> map){
    uid = map['studentUid'];
    phoneNumber = map['phoneNumber'];
    name = map['name'];
    classType = map['classType'];
    attendance = map['attendance'];
    time = map['time'];
  }

}