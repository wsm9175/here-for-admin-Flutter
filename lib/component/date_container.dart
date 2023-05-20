import 'package:flutter/material.dart';

class DateContainer extends StatelessWidget {
  final DateTime selectDate;
  final VoidCallback onPressed;

  const DateContainer({
    required this.selectDate,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('선택 날짜 : ', style: TextStyle(fontSize: 20.0)),
              SizedBox(
                width: 8.0,
              ),
              Text('${selectDate.year}년', style: TextStyle(fontSize: 20.0)),
              SizedBox(
                width: 8.0,
              ),
              Text('${selectDate.month}월', style: TextStyle(fontSize: 20.0)),
              SizedBox(
                width: 8.0,
              ),
              Text('${selectDate.day}월', style: TextStyle(fontSize: 20.0)),
            ],
          ),
        ),
      ),
    );
  }
}
