import 'package:flutter/material.dart';
import 'package:here_admin/component/nfc_module.dart';
import 'dart:math';

import 'package:here_admin/component/nfc_write_dialog_android.dart';

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
      children: [
        Row(
          children: [
            Text('$random'),
            SizedBox(
              width: 16.0,
            ),
            renderButton(),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) {
                return AndroidWriteSessionDialog(
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
      child: Text('태그 생성'),
    );
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
