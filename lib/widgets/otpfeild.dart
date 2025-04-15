import 'package:carsilla/utils/theme.dart';
import 'package:flutter/material.dart';

class OTPField extends StatefulWidget {
  final ValueChanged<String>? onFilled;

  const OTPField({Key? key, this.onFilled}) : super(key: key);

  @override
  OTPFieldState createState() => OTPFieldState();
}

class OTPFieldState extends State<OTPField> {
  List<TextEditingController> controllers = [];
  List<FocusNode> focusNodes = [];


  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 6; i++) {
      controllers.add(TextEditingController());
      focusNodes.add(FocusNode());
    }

    // Add listener to the last controller to trigger a callback when the fourth box is filled.
    controllers[5].addListener(_onFourthBoxChanged);
  }

  void _onFourthBoxChanged() {
    // Handle the OTP code when all four boxes are filled
    String otpCode = controllers.map((controller) => controller.text).join();
    debugPrint("OTP Code: $otpCode");

    // Call the callback function with the OTP code
    if (widget.onFilled != null) {
      widget.onFilled!(otpCode);
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < 6; i++) {
      controllers[i].dispose();
      focusNodes[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        6,
        (index) => _buildOTPBox(index),
      ),
    );
  }

  Widget _buildOTPBox(int index) {
    return SizedBox(
      width: 40.0,
      height: 50,
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        maxLength: 1,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          counterText: "",
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13.0),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13.0),
            borderSide: const BorderSide(color: MainTheme.primaryColor),
          ),
        ),
        onChanged: (value) {
          // Move focus to the next box when a digit is entered
          if (value.isNotEmpty) {
            _moveToNextBox(index);
          }
        },
      ),
    );
  }

  void _moveToNextBox(int currentIndex) {
    if (currentIndex < 5) {
      FocusScope.of(context).requestFocus(focusNodes[currentIndex + 1]);
    }
  }
 
}
