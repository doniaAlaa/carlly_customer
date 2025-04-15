import 'package:carsilla/utils/theme.dart';
import 'package:flutter/material.dart';

class SortButton extends StatelessWidget {
  final String? label;
  final double? width;
  final VoidCallback onclick;
  final Color? btnColor;
  final Color? labelColor;
  final double? radius;
  final bool? isLoading;

  const SortButton(
      {super.key,
        this.label = 'btn name',
        required this.onclick,
        this.width = 50,
        this.radius = 5,
        this.btnColor = MainTheme.primaryColor,
        this.labelColor = Colors.white, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.35 / 1,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(btnColor),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.only(top: 3, bottom: 3)),
              shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10))),
          ),
          onPressed: onclick,
          child: Text(
            label!,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: labelColor, fontSize: 12),
          ),
        ));
  }
}
