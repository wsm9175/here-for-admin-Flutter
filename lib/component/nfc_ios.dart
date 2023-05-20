import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../model/nfc_data.dart';

class IosSessionScreen extends StatelessWidget {
  final handleTag;
  final Function(String message) changeMessage;

  const IosSessionScreen({
    required this.handleTag,
    required this.changeMessage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NfcData? _result;

    return Scaffold(
      body: SafeArea(
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            NfcManager.instance.startSession(
              pollingOptions: {
                NfcPollingOption.iso14443,
                NfcPollingOption.iso15693,
              },
              alertMessage: "기기를 필터 가까이에 가져다주세요.",
              onDiscovered: (NfcTag tag) async {
                try {
                  _result = handleTag(tag);
                  changeMessage(_result!.message);
                } catch (e) {
                  setState(() {
                    null;
                  });
                } finally {
                  await NfcManager.instance
                      .stopSession(alertMessage: "완료되었습니다.");
                  Navigator.of(context).pop();
                }
              },
            );
            return Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  // id == null ? "취소" : "확인",
                  "확인",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
