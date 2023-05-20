import 'package:excel/excel.dart';
import 'package:here_admin/model/print_attendance_data.dart';
import 'package:intl/intl.dart';

//이름, class, 입실, 퇴실
class ExcelModule{
  List<int>? createFile(List<PrintAttendanceData> dataList, DateTime selectDate){
    var excel = Excel.createExcel();
    String date = DateFormat('yyyy-MM-dd').format(selectDate);
    Sheet sheetObject = excel[date];
    sheetObject.insertRowIterables(['이름', 'class', '입실시간', '퇴실시간', date], 0);

    var rowIndex = 1;
    for(PrintAttendanceData data in dataList){
      sheetObject.insertRowIterables([data.name, data.classType, data.AttendanceTime, data.LeaveTime], rowIndex++);
    }

    for (var table in excel.tables.keys) {
      print(table);
      print(excel.tables[table]!.maxCols);
      print(excel.tables[table]!.maxRows);
      for (var row in excel.tables[table]!.rows) {
        print("${row.map((e) => e?.value)}");
      }
    }

    return excel.save();
  }
}
