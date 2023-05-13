import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';


class AndroidSessionDialog extends StatefulWidget {
  final String alertMessage;
  final String Function(NfcTag tag) handleTag;
  final String text;

  const AndroidSessionDialog(this.alertMessage, this.handleTag, this.text);


  @override
  State<StatefulWidget> createState() => _AndroidSessionDialogState();
}

class _AndroidSessionDialogState extends State<AndroidSessionDialog> {
  String? _alertMessage;
  String? _errorMessage;

  String? _result;

  @override
  void initState() {
    super.initState();

    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        try {
          _result = widget.handleTag(tag);

          var ndef = Ndef.from(tag);
          if(ndef == null || !ndef.isWritable){
            print('쓰기가 불가능합니다.');
          }

          NdefMessage message = NdefMessage(<NdefRecord>[
            NdefRecord.createText(widget.text)
          ]);

          await ndef?.write(message);
          await NfcManager.instance.stopSession();

          setState(() => _alertMessage = "NFC 태그를 인식하였습니다.");
        } catch (e) {
          await NfcManager.instance.stopSession();

          setState(() => _errorMessage = '$e');
        }
      },
    ).catchError((e) => setState(() => _errorMessage = '$e'));
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _errorMessage?.isNotEmpty == true
            ? "오류"
            : _alertMessage?.isNotEmpty == true
                ? "성공"
                : "준비",
      ),
      content: Text(
        _errorMessage?.isNotEmpty == true
            ? _errorMessage!
            : _alertMessage?.isNotEmpty == true
                ? _alertMessage!
                : widget.alertMessage,
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            _errorMessage?.isNotEmpty == true
                ? "확인"
                : _alertMessage?.isNotEmpty == true
                    ? "완료"
                    : "취소",
          ),
          onPressed: () => Navigator.of(context).pop(_result),
        ),
      ],
    );
  }
}
