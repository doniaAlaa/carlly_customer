import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:carsilla/main.dart';
import 'package:carsilla/models/user_model.dart';
import 'package:carsilla/screens/home_screen.dart';
import 'package:carsilla/widgets/btn.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../const/assets.dart';
import '../../const/endpoints.dart';
import '../../providers/user_provider.dart';
import '../../utils/ui_utils.dart';
import '../../providers/car_listing_provider.dart';

import '../../widgets/textfeild.dart';

class RegistrationScreen extends StatefulWidget {
  final String phone;
  const RegistrationScreen({super.key, required this.phone});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final compNameController = TextEditingController();
  final compAddController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final confPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  bool passwordVisible = true;
  bool confPasswordVisible = true;

  String pickedImagePath = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      'Profile Image',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize:
                            Theme.of(context).textTheme.titleSmall?.fontSize,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final pickedImage = await ImagePicker().pickImage(
                          source: ImageSource.gallery, imageQuality: 50);
                      if (pickedImage != null) {
                        pickedImagePath = pickedImage.path;
                        setState(() {});
                      }
                    },
                    onLongPress: () async {
                      final pickedImage = await ImagePicker().pickImage(
                          source: ImageSource.camera, imageQuality: 50);
                      if (pickedImage != null) {
                        pickedImagePath = pickedImage.path;
                        setState(() {});
                      }
                    },
                    child: Center(
                      child: Container(
                        height: size.height * 0.25,
                        width: size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:
                            pickedImagePath.isNotEmpty || pickedImagePath != ''
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.file(File(pickedImagePath),
                                        fit: BoxFit.cover))
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Add image',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: size.width * 0.03,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Image.asset(IconAssets.camera,
                                          height: size.height * 0.035),
                                    ],
                                  ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 3.0),
                    child: Row(
                      children: [Text('First Name')],
                    ),
                  ),
                  CustomTextFormField(
                    controller: fNameController,
                    hintText: 'First Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter First Name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 5),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 3.0),
                    child: Row(
                      children: [Text('Last Name')],
                    ),
                  ),
                  CustomTextFormField(
                    controller: lNameController,
                    hintText: 'Last Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter last name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01 / 1),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 3.0),
                    child: Row(
                      children: [Text('Email')],
                    ),
                  ),
                  CustomTextFormField(
                    textInputType: TextInputType.emailAddress,
                    controller: emailController,
                    hintText: 'Enter Your Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01 / 1),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 3.0),
                    child: Row(
                      children: [Text('Password')],
                    ),
                  ),
                  CustomTextFormField(
                    textInputType: TextInputType.visiblePassword,
                    obscureText: passwordVisible,
                    controller: passwordController,
                    hintText: 'Enter your password',
                    suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                        icon: Icon(
                            !(passwordVisible)
                                ? Icons.visibility
                                : Icons.visibility_off_outlined,
                            color: Colors.grey)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01 / 1),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 3.0),
                    child: Row(
                      children: [Text('Confirm Password')],
                    ),
                  ),
                  CustomTextFormField(
                    obscureText: confPasswordVisible,
                    controller: confPasswordController,
                    hintText: 'Confirm Password',
                    suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            confPasswordVisible = !confPasswordVisible;
                          });
                        },
                        icon: Icon(
                            !(confPasswordVisible)
                                ? Icons.visibility
                                : Icons.visibility_off_outlined,
                            color: Colors.grey)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please confirm password";
                      } else if (value != passwordController.text) {
                        return "Password miss match";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: MainButton(
                        isLoading: isLoading,
                        onclick: () async {
                          if (_formKey.currentState!.validate() &&
                              pickedImagePath.isNotEmpty) {
                            // log(pickedImagePath.toString() + fNameController.text + lNameController.text + widget.phone + emailController.text + passwordController.text);
                            await register();
                          } else {
                            UiUtils(context)
                                .showSnackBar("Pack image and fill all fields");
                          }
                        },
                        label: "Register",
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> register() async {
    setState(() {
      isLoading = true;
    });

    try {
      String apiEndPoint = "${Endpoints.baseUrl}register";

      var request = http.MultipartRequest('POST', Uri.parse(apiEndPoint));

      request.files.add(
          await http.MultipartFile.fromPath('company_img', pickedImagePath));

      request.fields['fname'] = fNameController.text;
      request.fields['lname'] = lNameController.text;
      request.fields['phone'] = widget.phone;
      request.fields['email'] = emailController.text;
      request.fields['password'] = passwordController.text;
      request.fields['lat'] = '12.9348349';
      request.fields['lng'] = '27.9348349';

      await request.send().then(
        (value) async {
          http.Response.fromStream(value).then(
            (response) async {
              // Check if the request was successful (status code 200)
              print(
                  'status code : ${response.statusCode}\n body : ${response.body}');
              if (response.statusCode == 200) {
                print('called');
                // Parse the JSON response
                // var responseData = await http.Response.fromStream(response);
                // var responseString = response.body;
                var jsonResponse = json.decode(response.body);
                log(jsonResponse.toString(), name: "Registration Response");
                //Map<String, dynamic> jsonResponse = json.decode(response.body);
                // Check if the login was successful
                if (jsonResponse['status'] == true) {
                  // Extract the authentication token
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  final authToken =
                      jsonResponse['data']['auth_token'].toString();
                  UserModel userModel =
                      UserModel.fromJson(jsonResponse['data']['user']);

                  prefs.setString('auth_token', "Bearer $authToken");
                  context.read<UserProvider>().setCurrentUser = userModel;

                  await CarListingProvider().getCarListingDataVmF(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen(
                                origin: 'registration',
                              )),
                      (route) => false);
                } else {
                  log(jsonResponse['message'].toString());
                  UiUtils(context).showSnackBar(jsonResponse['message']);
                }
              } else {
                // var responseData = await http.Response.fromStream(response);
                // var responseString = responseData.body;
                var jsonResponse = json.decode(response.body);
                UiUtils(context).showSnackBar(jsonResponse['message']);
                setState(() {
                  isLoading = false;
                });
              }
            },
          );
        },
      );
    } catch (e) {
      log(e.toString());
      // UiUtils(context).showSnackBar(
      //     "Registration Failed");
      setState(() {
        isLoading = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
