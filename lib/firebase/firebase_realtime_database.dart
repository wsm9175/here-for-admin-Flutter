import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class FirebaseRealtimeDatabase{
  FirebaseDatabase _database = FirebaseDatabase.instance;
  FirebaseRealtimeDatabase._privateConstructor(){
    _database.databaseURL = 'https://here-flutter-default-rtdb.asia-southeast1.firebasedatabase.app';
  }
  final String userStudent = 'userStudent';
  final String attendance = 'attendance';


  static final FirebaseRealtimeDatabase _instance = FirebaseRealtimeDatabase._privateConstructor();

  factory FirebaseRealtimeDatabase() {
    return _instance;
  }

  Future<DataSnapshot> getUserInfo(String uid) async{
    print('getUserInfo');
    final ref = _database.ref();
    final snapshot = await ref.child('$userStudent/$uid').get();
    if (snapshot.exists) {
      print('user info : ${snapshot.value}');
    } else {
      print('No data available.');
    }
    return snapshot;
  }

  Future<DataSnapshot> getAttendanceDataByDate(DateTime dateTime) async{
    final ref = _database.ref();
    String selectDate = DateFormat('yyyyMMdd').format(dateTime);
    print('getAttendanceDataByDate $selectDate');
    final snapshot = await ref.child('$attendance/$selectDate').get();
    if(snapshot.exists){
      print('attendance info : ${snapshot.value}');
    }else{
      print('No data available.');
    }
    return snapshot;
  }


}

