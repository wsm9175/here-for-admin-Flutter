import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:here_admin/screen/calendar_screen.dart';
import 'package:here_admin/screen/excel_screen.dart';
import 'package:here_admin/screen/nfc_screen.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MaterialApp(
    home: DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.calendar_month)),
              Tab(icon: Icon(Icons.nfc)),
              Tab(icon: Icon(Icons.document_scanner)),
            ],
            indicatorColor: Colors.white,
          ),
          title: Text('Here Admin'),
        ),
        body: SafeArea(
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: TabBarView(
              children: [
                CalendarScreen(),
                NfcScreen(),
                ExcelScreen(),
              ],
            ),
          ),
        ),
      ),
    ),
  ));
}
