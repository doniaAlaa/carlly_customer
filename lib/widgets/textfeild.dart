import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    this.onChange,
    this.onTap,
    this.alignment,
    this.readOnly,
    this.width,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.textStyle,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = true,
    this.validator, this.enabled,
  }) : super(key: key);

  final Function(String)? onChange;
  final VoidCallback? onTap;
  final bool? enabled;
  final bool? readOnly;

  final Alignment? alignment;
  final double? width;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? autofocus;
  final TextStyle? textStyle;
  final bool? obscureText;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final int? maxLines;
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final Widget? suffix;
  final BoxConstraints? suffixConstraints;
  final EdgeInsets? contentPadding;
  final InputBorder? borderDecoration;
  final Color? fillColor;
  final bool? filled;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment!,
            child: textFormFieldWidget,
          )
        : textFormFieldWidget;
  }

  Widget get textFormFieldWidget => SizedBox(
        width: width ?? double.maxFinite,
        child: TextFormField(
          onTap: onTap,
          enabled: enabled,
          onChanged: onChange,
          controller: controller,
          // focusNode: focusNode ?? FocusNode(),
          readOnly: readOnly??false,
          autofocus: autofocus!,
          style: textStyle ?? const TextStyle(),
          obscureText: obscureText!,
          textInputAction: textInputAction!,
          keyboardType: textInputType!,
          maxLines: maxLines ?? 1,
          decoration: decoration,
          validator: validator,
        ),
      );

  InputDecoration get decoration => InputDecoration(
        hintText: hintText ?? "",
        hintStyle: hintStyle ?? const TextStyle(color: Colors.grey),
        prefixIcon: prefix,
        prefixIconConstraints: prefixConstraints,
        suffixIcon: suffix,
        suffixIconConstraints: suffixConstraints,
        isDense: true,

        contentPadding: contentPadding ?? const EdgeInsets.all(11),
        fillColor: fillColor ?? Colors.white70,
        filled: filled ?? true, // Use filled ?? true to handle null
        border: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: 1,
              ),
            ),
        enabledBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: 1,
              ),
            ),
        focusedBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: 1,
              ),
            ),
      );
}

extension TextFormFieldStyleHelper on CustomTextFormField {
  static OutlineInputBorder get outlineBlueGray30 => OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      );
  static OutlineInputBorder get outlineBlueGray20 => OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
          color: Colors.blueGrey.shade100,
          width: 1,
        ),
      );
  static OutlineInputBorder get outlineBlueGray8 => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Colors.blueGrey.shade100,
          width: 1,
        ),
      );
  static OutlineInputBorder get outlineGray10 => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey.shade100,
          width: 1,
        ),
      );
  static OutlineInputBorder get fillGray => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      );
  static OutlineInputBorder get outlineGray8 => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Colors.grey.shade400,
          width: 1,
        ),
      );
  static OutlineInputBorder get underLinePrimary => const OutlineInputBorder(
        borderSide: BorderSide.none,
      );
  static OutlineInputBorder get custom => const OutlineInputBorder(
        borderSide: BorderSide.none,
      );
}
