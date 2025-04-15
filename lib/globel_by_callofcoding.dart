import 'package:flutter/material.dart';



bool isNetworkImage(String imageUrl) {
  Uri uri = Uri.parse(imageUrl);
  return uri.scheme == 'http' || uri.scheme == 'https';
}


Color customColor(String hexColor) {
return Color(int.parse(hexColor.substring(1, 7), radix: 16) + 0xFF000000);
}

String removeZeroFromNumber(String number) {
  if (number.startsWith('0')) {
    // Remove the leading '0'
    number = number.substring(1);
  }
  if (number.isEmpty) {
    return '';
  }
  return number;
}
