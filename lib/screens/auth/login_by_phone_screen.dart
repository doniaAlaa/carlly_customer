import 'package:carsilla/screens/auth/verify_otp_screen.dart';
import 'package:carsilla/providers/otp_timer_provider.dart';
import 'package:carsilla/widgets/otp_timer_widget.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/theme.dart';
import '../../widgets/btn.dart';
import '../../widgets/textfeild.dart';


class LoginByPhoneScreen extends StatefulWidget {
  const LoginByPhoneScreen({super.key});

  @override
  State<LoginByPhoneScreen> createState() => _LoginByPhoneScreenState();
}

class _LoginByPhoneScreenState extends State<LoginByPhoneScreen> {



  TextEditingController phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  String countryCode = '+971';

  @override
  void initState() {
    // TODO: implement initState
    phoneController.addListener(() {
      String text = phoneController.text;

      if (text.isNotEmpty && text.startsWith('0') && text.length > 1) {
        // Remove leading zeros
        phoneController.text = text.replaceFirst(RegExp(r'^0+'), '');
        phoneController.selection = TextSelection.fromPosition(
          TextPosition(offset: phoneController.text.length),
        ); // Move the cursor to the end
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Welcome Back !',
                style: textTheme.headlineLarge!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02 / 1),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.65 / 1,
                child: Text(
                  'Stay signed in with your account to make searching easier',
                  style: textTheme.titleLarge!
                      .copyWith(color: Colors.grey.shade800),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03 / 1,
              ),
              const ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                title: Text('Phone without country code'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.26 / 1,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade400,
                          ),
                          borderRadius: BorderRadius.circular(8)),
                      child: CountryCodePicker(
                        enabled: false,
                        padding: EdgeInsets.zero,
                        flagWidth: 40,
                        onChanged: (value) {
                          setState(() {
                            countryCode = value.dialCode ?? '+971';
                          });
                          print('-----countrycode $countryCode');
                        },
                        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                        initialSelection: '+971',
                        favorite: ['+971','+92','+39'],
                        // optional. Shows only country name and flag
                        showCountryOnly: false,
                        // optional. Shows only country name and flag when popup is closed.
                        showOnlyCountryWhenClosed: false,
                        // optional. aligns the flag and the Text left
                        alignLeft: false,
                      ),

                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.61 / 1,
                        child: CustomTextFormField(
                          hintText: '50 1234567',
                          controller: phoneController,
                          textInputType: TextInputType.phone,
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04 / 1,
              ),
              Consumer<OtpTimerProvider>(builder: (BuildContext context, OtpTimerProvider value, Widget? child) {
                return Column(
                  children: [
                    value.isTimerActive ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('You can request new OTP in '),
                        OtpTimerWidget(remainingTime: value.remainingTime)
                      ],
                    ) : SizedBox(),
                   value.isTimerActive ? SizedBox() : MainButton(
                      width: 0.9,
                      onclick: () async {
                        if(isLoading){
                          return;
                        }

                        if (phoneController.text.length < 4) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Enter Valid Phone Number'),
                              duration: Duration(seconds: 2)));
                        } else {
                          setState(() {
                            isLoading = true;
                          });
                          await _verifyPhoneNumber("$countryCode${phoneController.text}", otpTimerProvider: value);
                        }
                      },
                      label: isLoading ? "OTP Sending" :'Confirm',
                      isLoading: isLoading,
                    ),
                  ],
                );
              },),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3 / 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //////////////// phone otp f
  Future<void> _verifyPhoneNumber(String phoneNumber,{required OtpTimerProvider otpTimerProvider}) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatically handle verification if using a physical device
        // await _auth.signInWithCredential(credential);
        // print(
        //     '👉Phone number automatically verified and signed in ------------------------');
        // setState(() {
        //   isLoading = false;
        // });
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
            content: Text(e.code),
            duration: Duration(seconds: 2)));
        debugPrint(
            '💥Phone number verification failed: $e -------------------------');
      },
      codeSent: (String verificationId, int? resendToken) async {
        setState(() {
          isLoading = false;
        });
        debugPrint('🔐 token id: $resendToken');
        debugPrint('🔐 verification id: $verificationId');
        otpTimerProvider.startTimer(60);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VerifyOtpScreen(
                    verificationId: verificationId.toString(),
                    phoneNumber: phoneNumber)));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          isLoading = false;
        });
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //     content: Text('Time Out'), duration: Duration(seconds: 2)));
        print('Auto retrieval timeout ---------------$verificationId---------');
      },
    );
    // Future.delayed(const Duration(seconds: 3), () {
    //   setState(() {
    //     isLoading = false;
    //   });
    // });
  }
}
