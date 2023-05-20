import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:here_admin/component/nfc_module.dart';
import 'dart:math';

import 'package:here_admin/component/nfc_write_dialog.dart';

class NfcScreen extends StatefulWidget {
  const NfcScreen({Key? key}) : super(key: key);

  @override
  State<NfcScreen> createState() => _NfcScreenState();
}

class _NfcScreenState extends State<NfcScreen> {
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();
  String random = '';

  @override
  Widget build(BuildContext context) {
    final nfcModule = NfcModule();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('생성/복사 key:', style: TextStyle(fontSize: 20.0),),
            SizedBox(width: 10.0,),
            Text('$random',style: TextStyle(fontSize: 20.0),),
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
              renderButton(),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return WriteSessionDialog(
                        '태깅',
                        nfcModule.handleTag,
                        random,
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
          random = randomString;
        });
      },
      child: Text('태그 키 생성'),
    );
  }

  Widget renderCopyButton() {
    return ElevatedButton(
      onPressed: () {
        String randomString = getRandomString(16);
        setState(() {
          random = randomString;
        });
      },
      child: Text('태그 키 생성'),
    );
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
