

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:carsilla/const/common_methods.dart';
import 'package:carsilla/widgets/btn.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../utils/ui_utils.dart';
import '../../const/endpoints.dart';


import '../../widgets/textfeild.dart';

class EditProfile extends StatefulWidget {
  final UserModel userModel;
  const EditProfile({super.key, required this.userModel});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  String pickedImagePath ="";
  bool isLoading = false;






  @override
  void initState() {
    // TODO: implement initState
    fNameController.text = widget.userModel.firstName ?? '';
    lNameController.text = widget.userModel.lastName ?? '';
    emailController.text = widget.userModel.email ?? '';
    phoneController.text = widget.userModel.phone ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Update Profile'),),
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
                        fontSize: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.fontSize,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final pickedImage = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 50);
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
                        child: pickedImagePath.isNotEmpty ||
                            pickedImagePath != ''
                            ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(File(pickedImagePath),
                                fit: BoxFit.cover))
                            : Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Text(
                              'Add image',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: size.width * 0.03,
                                color: Colors.white,
                              ),
                            ),
                            Image.network(widget.userModel.image!,
                                height: size.height * 0.035),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5,),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 3.0),
                    child: Row(
                      children: [Text('First Name')],
                    ),
                  ),
                  CustomTextFormField(
                    controller: fNameController,
                    hintText: 'First Name',
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Enter First Name";
                      }
                      return null;

                    },
                  ),
                  const SizedBox(height: 5),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 3.0),
                    child: Row(
                      children: [Text('Last Name')],
                    ),
                  ),
                  CustomTextFormField(
                    controller: lNameController,
                    hintText: 'Last Name',
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Enter last name";
                      }
                      return null;

                    },
                  ),
                  const SizedBox(height: 5,),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 3.0),
                    child: Row(
                      children: [Text('Phone With Country Code')],
                    ),
                  ),
                  CustomTextFormField(
                    controller: phoneController,
                    textInputType: TextInputType.phone,
                    hintText: 'Phone',
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Enter phone";
                      }
                      return null;

                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01 / 1),
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
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Enter email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 5),

                  SizedBox(width: double.infinity, child: MainButton(
                    isLoading: isLoading,
                    onclick: () async {
                      if(_formKey.currentState!.validate() && pickedImagePath.isNotEmpty){
                         // log(pickedImagePath.toString() + fNameController.text + lNameController.text + widget.phone + emailController.text + passwordController.text);
                        await update();
                      }else{
                        UiUtils(context).showSnackBar( "Pack image and fill all fields");
                      }
                    }, label: "Update",))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<void> update() async {
    setState(() {
      isLoading = true;
    });

    try {
      String apiEndPoint = "${Endpoints.baseUrl}updateProfile";

      String? authToken = await getAuthToken();

      if(authToken == null){
        setState(() {
          isLoading = false;
        });
        return;
      }

      var request = http.MultipartRequest(
          'POST', Uri.parse(apiEndPoint));

      request.headers['Authorization'] = authToken;

      if (pickedImagePath.isNotEmpty) {
        request.files.add(
            await http.MultipartFile.fromPath('image', pickedImagePath));
      }

      request.fields['fname'] = fNameController.text;
      request.fields['lname'] = lNameController.text;
      request.fields['phone'] = phoneController.text;
      request.fields['email'] = emailController.text;

      var response = await request.send();

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the JSON response
        var responseData = await http.Response.fromStream(response);
        var responseString = responseData.body;
        var jsonResponse = jsonDecode(responseString);
        //Map<String, dynamic> jsonResponse = json.decode(response.body);
        // Check if the login was successful
        if (jsonResponse['status'] == true) {
          log(jsonResponse['data'].toString());
          // Extract the authentication token
          UserModel user = UserModel.fromJson(jsonResponse['data']);
          context.read<UserProvider>().setCurrentUser = user;
          Navigator.pop(context);
        } else {
          log(jsonResponse['message'].toString());
          UiUtils(context).showSnackBar( jsonResponse['message']);
        }
      } else {
        var responseData = await http.Response.fromStream(response);
        var responseString = responseData.body;
        var jsonResponse = jsonDecode(responseString);
        log(jsonResponse['message']);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      log(e.toString());
      UiUtils(context).showSnackBar(
          e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }
}
