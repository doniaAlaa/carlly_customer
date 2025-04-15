import 'package:carsilla/const/endpoints.dart';
import 'package:carsilla/models/user_model.dart';
import 'package:carsilla/providers/user_provider.dart';
import 'package:carsilla/services/network_service_handler.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



Future<void> checkLocationPermission(context) async {
  LocationPermission permission = await Geolocator.checkPermission();
  if(permission == LocationPermission.whileInUse || permission == LocationPermission.always){
  }
  if (permission == LocationPermission.denied) {
    print("No permission, requesting one");
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please Enable Location'),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {},
          ),
        ),
      );
      return Future.error('Location Not Available');
    }
  }
}



Size getMediaSize(BuildContext context){
  return MediaQuery.of(context).size;
}

String removeLeadingZeros(String number) {
  if (number.isEmpty) {
    return number; // Return empty if the string is empty
  }

  // Parse the string as an integer, which will automatically remove leading zeros
  int parsedNumber = int.parse(number);

  // Return the parsed number back as a string
  return parsedNumber.toString();
}

String removeCountryCode(String phoneNumber) {
  // Regular expression to match country code at the beginning (e.g., +123)
  final RegExp regExp = RegExp(r'^\+\d{1,3}');

  // Replace the country code with an empty string if it exists
  return phoneNumber.replaceFirst(regExp, '');
}
Future<String?> getAuthToken()async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('auth_token');
}


Future<void> getCurrentUser(BuildContext context)async{
  String url = Endpoints.baseUrl + Endpoints.getCurrentUser;
  await NetworkServiceHandler(context).getDataHandler(url,useNonAuthHeaders: false,onSuccess: (response) {
    context.read<UserProvider>().setCurrentUser = UserModel.fromJson(response['data']);
  },);
}