import 'dart:ffi';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_admin/component/nfc_module.dart';
import 'dart:math';

import 'package:here_admin/component/nfc_write_dialog.dart';
import 'package:here_admin/firebase/firebase_realtime_database.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../component/nfc_dialog_android.dart';
import '../component/nfc_ios.dart';

bool isNfcAvaliable = false;

class NfcScreen extends StatefulWidget {
  const NfcScreen({Key? key}) : super(key: key);

  @override
  State<NfcScreen> createState() => _NfcScreenState();
}

class _NfcScreenState extends State<NfcScreen> {
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();
  final nfcModule = NfcModule();
  final firebaseRDB = FirebaseRealtimeDatabase();
  String tagMessage = '';


  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('생성/복사 key:', style: TextStyle(fontSize: 20.0),),
            SizedBox(width: 10.0,),
            Text('$tagMessage',style: TextStyle(fontSize: 20.0),),
          ],
        ),
        SizedBox(
          width: 16.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              renderCopyButton(),
              renderButton(),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return WriteSessionDialog(
                        '태깅',
                        nfcModule.handleTag,
                        tagMessage,
                        registerTag,
                      );
                    },
                  );
                },
                child: Text('nfc 쓰기'),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget renderButton() {
    return ElevatedButton(
      onPressed: () {
        String randomString = getRandomString(16);
        setState(() {
          tagMessage = randomString;
        });
      },
      child: Text('태그 키 랜덤 생성'),
    );
  }

  Widget renderCopyButton() {
    return ElevatedButton(
      onPressed: () {
        taggingNfc();
      },
      child: Text('태그 키 복사'),
    );
  }

  void taggingNfc() async {
    if (!await NfcManager.instance.isAvailable()) {
      checkNfc();
    } else {
      if (Platform.isIOS) {
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return IosSessionScreen(
            handleTag: nfcModule.handleTag,
            changeMessage: changeMessage,
          );
        }));
      } else {
        showDialog(
          context: context,
          builder: (_) {
            return AndroidSessionDialog(
              'nfc 태그에 기기를 태깅해주세요.',
              nfcModule.handleTag,
              changeMessage,
            );
          },
        );
      }
    }
  }

  void checkNfc() async {
    print('checkNfc');
    if (!(isNfcAvaliable)) {
      if (Platform.isAndroid) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("오류"),
            content: const Text(
              "NFC를 지원하지 않는 기기이거나 일시적으로 비활성화 되어 있습니다.",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  AppSettings.openNFCSettings();
                },
                child: Text("설정"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  "확인",
                ),
              ),
            ],
          ),
        );
      }
      throw "NFC를 지원하지 않는 기기이거나 일시적으로 비활성화 되어 있습니다.";
    }
  }

  void registerTag(String tagMessage){
    firebaseRDB.registerTag(tagMessage).then((value) => {showToast('서버에 등록 완료했습니다.')}).catchError((error) => {showToast('서버 등록 에러')});
  }

  void changeMessage(String recogMessage){
    setState(() {
       tagMessage = recogMessage;
    });
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

