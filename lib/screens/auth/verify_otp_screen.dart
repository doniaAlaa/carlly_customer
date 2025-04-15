import 'dart:convert';
import 'dart:developer';

import 'package:carsilla/const/assets.dart';
import 'package:carsilla/screens/auth/registration.dart';
import 'package:carsilla/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../utils/theme.dart';
import '../../const/endpoints.dart';

import '../../utils/ui_utils.dart';
import '../../providers/car_listing_provider.dart';
import '../../widgets/btn.dart';
import '../../widgets/otpfeild.dart';
import 'package:http/http.dart' as http;

class VerifyOtpScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const VerifyOtpScreen({super.key, required this.verificationId, required this.phoneNumber});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  dynamic codeis = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const Text(''),
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.11 / 1),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85 / 1,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: Colors.grey.shade400.withOpacity(0.7)),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03 / 1,
                ),
                Text(
                  'Enter Your 6 digit code',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03 / 1,
                ),
                Image.asset(IconAssets.mailbox),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05 / 1,
                ),
                OTPField(
                  onFilled: (value) {
                    setState(() {
                      codeis = value;
                    });
                    debugPrint('🔐 ${value.toString()}');
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08 / 1,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Did you don’t get code?",
                            style: textTheme.labelMedium!
                                .copyWith(color: Colors.grey.shade700),
                          ),
                          const TextSpan(
                            text: " ",
                          ),
                          TextSpan(
                            text: "Resend",
                            style: textTheme.labelMedium!.copyWith(
                                color: MainTheme.primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03 / 1,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8 / 1,
                  child: MainButton(
                    isLoading: isLoading,
                      onclick: () {
                        if (codeis.length < 5) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Fill OTP Fields'),
                                  duration: Duration(seconds: 1)));
                        } else {
                          confirmotp(codeis);
                        }
                      },
                      label: 'Verify'),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02 / 1,
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  /////////verify f
  confirmotp(otp) async {
    try {
      setState(() {
        isLoading = true;
      });
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId, smsCode: otp);
      await _auth
          .signInWithCredential(credential)
          .then((value) async {
            await login();
      }).onError((error, stackTrace){
        ScaffoldMessenger.of(context)
            .showSnackBar( SnackBar(
            content: Text('Error: $error'),
            duration: const Duration(seconds: 2)));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          content: Text('Errors: $e'),
          duration: const Duration(seconds: 2)));
    }
  }
  /////////login

  Future<void> login()async {
    try {
      String apiEndPoint = "${Endpoints.baseUrl}login";
      // Replace the email and password with your actual credentials
      var request = http.MultipartRequest(
          'POST', Uri.parse(apiEndPoint));

      request.fields['phone'] = widget.phoneNumber;
      request.fields['firebase_auth'] = "true";

      var response = await request.send();
      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the JSON response
        var responseData = await http.Response.fromStream(response);
        var responseString = responseData.body;
        var jsonResponse = jsonDecode(responseString);
        //Map<String, dynamic> jsonResponse = json.decode(response.body);
        // Check if the login was successful
        log(jsonResponse.toString());
        if (jsonResponse['status'] == true) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            final authToken = jsonResponse['data']['auth_token'].toString();
            UserModel user = UserModel.fromJson(jsonResponse['data']['user']);

            await prefs.setString('auth_token', "Bearer $authToken");
            context.read<UserProvider>().setCurrentUser = user;

            await CarListingProvider().getCarListingDataVmF(context);
            setState(() {
              isLoading = false;
            });
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const HomeScreen(origin: 'verify',)), (route) => false);
          }else if(jsonResponse['status'] == false){
            setState(() {
              isLoading = false;
            });
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> RegistrationScreen(phone: widget.phoneNumber)));

          // Extract the authentication token
        } else {
          UiUtils(context).showSnackBar( jsonResponse['message']);
          setState(() {
            isLoading = false;
          });
        }
      } else {
        UiUtils(context).showSnackBar(
            "Server error");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      UiUtils(context).showSnackBar(
          e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

}
