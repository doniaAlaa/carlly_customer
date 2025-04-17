import 'package:flutter/material.dart';

class Utils {
  static bool isNetworkImage(String imageUrl) {
    Uri uri = Uri.parse(imageUrl);
    return uri.scheme == 'http' || uri.scheme == 'https';
  }

  static String removeZeroFromNumber(String number) {
    if (number.startsWith('0')) {
      // Remove the leading '0'
      number = number.substring(1);
    }
    if (number.isEmpty) {
      return '';
    }
    return number;
  }

  static Size getMediaSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
}
