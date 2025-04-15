import 'package:flutter/material.dart';

class OtpTimerWidget extends StatelessWidget {
  final int remainingTime;
  final int timeDuration;
  const OtpTimerWidget({super.key, required this.remainingTime, this.timeDuration = 60});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 25,
          height: 25,
          child: CircularProgressIndicator(
            value: remainingTime / timeDuration,
            strokeWidth: 2,
          ),
        ),
        SizedBox(width: 8,),
        Text(
          remainingTime.toString(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
