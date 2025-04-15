import 'dart:convert';

import 'package:carsilla/resources/user_data.dart';
import 'package:carsilla/screens/auth/login_by_phone_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/ui_utils.dart';


class NetworkServiceHandler{
  BuildContext context;
  NetworkServiceHandler(this.context);


  dynamic _decodeResponse(http.Response response){
    dynamic data ;
    if(response.statusCode == 200){
      var jsonResponse = jsonDecode(response.body);
      if(jsonResponse['status'] == true){
        debugPrint('-------Successfully hit Api-----------');
      }else{
        // show error for status is not ture but status code is 200
        if((jsonResponse as Map<String,dynamic>).containsKey('message')){
          UiUtils(context).showSnackBar(jsonResponse['message']);
          debugPrint('--------Exception Occur-------\nStatus Code : ${response.statusCode}\nStatus : ${jsonResponse['status']}\nMessage : ${jsonResponse['message']} ');
        }else{
          UiUtils(context).showSnackBar('Something went wrong!');
          debugPrint('--------Exception Occur-------\nStatus Code : ${response.statusCode}\nStatus : ${jsonResponse['status']}');
        }
      }
      data = jsonResponse;
    }else if(response.statusCode == 401){
      var jsonResponse = jsonDecode(response.body);
      if((jsonResponse as Map<String,dynamic>).containsKey('message')){
        UiUtils(context).showSnackBar(jsonResponse['message']);
        debugPrint('--------Exception Occur-------\nStatus Code : ${response.statusCode}\nMessage : ${jsonResponse['message']} ');
      }else{
        UiUtils(context).showSnackBar('Something went wrong!');
        debugPrint('--------Exception Occur-------\nStatus Code : ${response.statusCode}');
      }

      data = jsonResponse;
      SharedPreferences.getInstance().then((value) {
        value.remove('access_token');
      },).then((value) {
        if(context.mounted){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginByPhoneScreen(),), (route) => false,);
        }
      },);

    }else{
      // show error for status code is not 200 and print message also
      var jsonResponse = jsonDecode(response.body);

      if((jsonResponse as Map<String,dynamic>).containsKey('message')){
        UiUtils(context).showSnackBar(jsonResponse['message']);
        debugPrint('--------Exception Occur-------\nStatus Code : ${response.statusCode}\nMessage : ${jsonResponse['message']} ');
      }else{
        UiUtils(context).showSnackBar('Something went wrong!');
        debugPrint('--------Exception Occur-------\nStatus Code : ${response.statusCode}');
      }

      data = jsonResponse;
    }
    return data;
  }

  Future<Map<String, String>> _headers() async {
    var pref = await SharedPreferences.getInstance();
    String? token = await pref.getString('auth_token');
    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token ?? ''
    };
  }

  Map<String,String> _nonAuthHeaders(){
    return {
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
  }

  dynamic postDataHandler({
    required String url,
    required Map<String, dynamic> body,
    void Function(dynamic response)? onSuccess,
    bool useNonAuthHeaders = false,
    bool showSuccessSnackBar = false
  }) async {
    // Check if the body contains an XFile or File
    bool containsFile = body.values.any((value) => value is XFile || value is List<XFile>);

    http.Response response;

    if (containsFile) {
      // Create a MultipartRequest for file upload
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers

      if(useNonAuthHeaders){
        request.headers.addAll(_nonAuthHeaders());
      }else{
        request.headers.addAll(await _headers());
      }

      // Add other fields (non-file fields) to the request
      body.forEach((key, value) async {

        if(value is List){

          if(value is List<XFile>){
            for (var i = 0; i < value.length; i++) {
              var file = value[i];
              request.files.add(await http.MultipartFile.fromPath(
                '$key[$i]',
                file.path,
              ));
            }
          }else{
            if(value is List<Map<String,dynamic>>){
              for(var i = 0; i < value.length; i++){
                Map<String,dynamic> data = value[i];
                data.forEach((subKey, value) {
                  request.fields['$key[$i][$subKey]'] = value.toString();
                },);
              }
            }else{

              for(var i = 0; i<value.length;i++){
                request.fields['$key[$i]'] = value[i].toString();
              }
            }
          }
        }else{
          if (value is XFile) {
            // Handle file (either XFile or File)
            var file = value;

            request.files.add(
                await http.MultipartFile.fromPath(
                  key,
                  file.path,
                )
            );
          } else {
            request.fields[key] = value.toString();
          }
        }
      });
      // Send the request
      var streamedResponse = await request.send();
      response = await http.Response.fromStream(streamedResponse);

    } else {
      // Handle regular JSON data (no files)
      response = await http.post(
        Uri.parse(url),
        headers: useNonAuthHeaders ? _nonAuthHeaders() : await _headers(),
        body: jsonEncode(body),
      );
    }

    // Decode and return the response
    var decodedResponse = _decodeResponse(response);

    if(decodedResponse['status'] == true){
      if(onSuccess!=null){
        onSuccess(decodedResponse);
      }
      if(showSuccessSnackBar && context.mounted && decodedResponse['message'] != null){
        UiUtils(context).showSnackBar(decodedResponse['message']);
      }
    }

    return decodedResponse;
  }

  Future<dynamic> getDataHandler(String url,{void Function(dynamic response)? onSuccess,bool useNonAuthHeaders = true})async {
    var response = await http.get(
        Uri.parse(url), headers: useNonAuthHeaders ? _nonAuthHeaders() : await _headers());

    var decodedResponse = _decodeResponse(response);
    if (decodedResponse['status'] == true) {
      if (onSuccess != null) {
        onSuccess(decodedResponse);
      }
      return decodedResponse;
    }
  }

  Future<dynamic> deleteDataHandler(String url,{void Function(dynamic response)? onSuccess})async{
    var response = await http.delete(Uri.parse(url),headers: await _headers());
    var decodedJson = _decodeResponse(response);
    if(decodedJson['status'] == true){
      if(context.mounted){
        if(onSuccess != null){
          onSuccess(decodedJson);
        }
        UiUtils(context).showSnackBar(decodedJson['message']);
      }
    }
  }


}