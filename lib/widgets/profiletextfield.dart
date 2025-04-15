import 'package:flutter/material.dart';

class ProfileFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final Widget? prefix;
  final Widget? suffix;
  final bool? hidetext;
  const ProfileFieldWidget(
      {Key? key,
      required this.controller,
      this.label = '',
      this.hint = '',
      this.suffix,
      this.prefix,
      this.hidetext = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: controller,
        obscureText: hidetext!,
        // style: TextStyle(height: 6),
        decoration: InputDecoration(
          labelText: label!,
          labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          hintText: hint!,
          prefixIcon: prefix ?? const SizedBox(width: 0),
          suffixIcon: suffix ?? const SizedBox(width: 0),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 6.0),
        ),
      ),
    );
  }
}
