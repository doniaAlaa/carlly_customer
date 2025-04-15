import 'package:carsilla/utils/theme.dart';
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final String? label;
  final double? width;
  final VoidCallback? onclick;
  final Color? btnColor;
  final Color? labelColor;
  final double? radius;
  final bool? isLoading;

  const MainButton(
      {super.key,
      this.label = 'btn name',
      required this.onclick,
      this.width = 0.8,
      this.radius = 5,
      this.btnColor = MainTheme.primaryColor,
      this.labelColor = Colors.white, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * width! / 1,
      child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius!))),
              backgroundColor: MaterialStateProperty.all(btnColor)),
          onPressed: onclick,
          child: isLoading! == true ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Text(
            label!,
            style: textTheme.titleMedium!.copyWith(color: labelColor!),
          ), Transform.scale(scale:0.4, child: const CircularProgressIndicator(color: Colors.white,)),
          ],) : Text(
            label!,
            style: textTheme.titleMedium!.copyWith(color: labelColor!),
          )),
    );
  }
}
