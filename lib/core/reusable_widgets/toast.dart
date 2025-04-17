import 'package:flutter/material.dart';

showtoastF(context, msg , {int? duration}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg.toString()),
      duration:  Duration(seconds:duration?? 2),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {},
      ),
    ),
  );
}
