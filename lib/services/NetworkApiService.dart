import 'dart:convert';
import 'dart:io';
import 'package:carsilla/const/common_methods.dart';
import 'package:carsilla/resources/user_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'exception.dart';

class ApiClass extends BaseApiServices {
// ///////////////////////////////
//
// ///////////////////////////////
// ///////////////////////////////
//   Future loginPostApiData(String url, data) async {
//     dynamic responseJson;
//     try {
//       Response response =
//           await post(Uri.parse(url), body: jsonEncode(data), headers: {
//         'Content-Type': 'application/json',
//       }).timeout(const Duration(seconds: 10));
//       responseJson = returnResponse(response);
//     } on SocketException {
//       throw FetchDataException('No Internet Connection');
//     }
//     return responseJson;
//   }
//
// ///////////////////////////////
// ///////////////////////////////
  @override
  Future getApiData(url) async {
    dynamic responseJson;
    try {
      print(url);
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        // 'Authorization': UserData.authToken
      }).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

///////////////////////////////
///////////////////////////////
  @override
  Future postApiData(String url, data) async {
    dynamic responseJson;
    String? token = await getAuthToken();
    print(data.toString());

    // if(token == null){
    //   return;
    //
    // }
    print(token);


    try {
      Response response =
          await post(Uri.parse(url),
              body:
              jsonEncode(data),

              headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': token??''
      }).timeout(const Duration(seconds: 10));
      print('responserrrrrrrrrrr');
      responseJson = returnResponse(response);
      print(responseJson);
    // } on SocketException {
    //   throw FetchDataException('No Internet Connection');
    // }
    } catch(e) {
      print(e);
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

///////////////////////////////
///////////////////////////////
  @override
  Future putApiData(String url, data, tokenid) async {
    dynamic responseJson;
    try {
      Response response = await put(Uri.parse(url),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $tokenid'
          }).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

///////////////////////////////
///////////////////////////////
  @override
  Future putApiNoData(String url, tokenid) async {
    dynamic responseJson;
    try {
      Response response = await put(Uri.parse(url),
          // body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $tokenid'
          }).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

///////////////////////////////
///////////////////////////////
  @override
  Future deleteApiData(String url, tokenid) async {
    dynamic responseJson;
    try {
      Response response = await delete(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokenid'
      }).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

///////////////////////////////
///////////////////////////////

// 'user_id': userid.toString(),
//         'user_name': username,
//         'user_email': useremail,
//         'offer_name': offername,
//         'offer_value': offervalue.toString(),
//         'offer_id': offerid,
//         'resturant_id': venueid,
//         'resturant_name': venuename,
//         'resturant_image': venueimage,
//         'card_name': cardname,
//         'card_image': cardimg,
//         'card_number': cardnumber.toString(),
//         ///// new
//         "sub_total": double.parse(subtotal.toString()),
//         "total_discount": double.parse(totaldiscount.toString()),
//         "latitude": double.parse(latitude.toString()),
//         "longitude": double.parse(longitude.toString()),
//         "bill_image": billimage,
//         "comment": comment
  Future<dynamic> postImageWithData(String url, dynamic data, withImage) async {
    dynamic responseJson;

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      // Set headers, including Content-Type and Authorization
      request.headers['Content-Type'] = 'application/json';

      if (withImage) {
        // Add the image file to the request
        var image =
            await http.MultipartFile.fromPath('profile', data['profile']);
        request.files.add(image);
      }

      // Add other form data fields
      request.fields['id'] = data['id'];
      request.fields['fname'] = data['fname'];
      request.fields['lname'] = data['lname'];
      request.fields['email'] = data['email'];

      // Send the request and get the response
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  ////// for registor cards 2
  Future<dynamic> postImageWithDataRegCard(
      String url, Map data, String tokenid) async {
    dynamic responseJson;
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Content-Type'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $tokenid';

      request.files
          .add(await http.MultipartFile.fromPath('image', data['image']));

      request.fields['user_id'] = data['user_id'].toString();
      request.fields['card_id'] = data['card_id'].toString();
      request.fields['ecard_no'] = data['ecard_no'].toString();
      request.fields['start_date'] = data['start_date'].toString();
      request.fields['validity'] = data['validity'].toString();
      // request.fields['end_date'] = data['end_date'].toString();

      // print('📈 step 1');
      dynamic streamedResponse = await request.send();
      // print('📈 step 2');
      dynamic response = await http.Response.fromStream(streamedResponse);
      // print('📈 step 3');

      // print('👉 ${response.toString()}');
      responseJson = await jsonDecode(response.body);
      // responseJson = returnResponse(response);
    } catch (e) {
      debugPrint("👉 ${e.toString()}");
    }

    return responseJson;
  }

  // Future postdatawithimage(String url, data, tokenid) async {
  //   dynamic responseJson;
  //   try {
  //     Response response = await post(Uri.parse(url),
  //         body: jsonEncode(data),
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Authorization': 'Bearer $tokenid'
  //         }).timeout(const Duration(seconds: 10));
  //     responseJson = returnResponse(response);
  //   } on SocketException {
  //     throw FetchDataException('No Internet Connection');
  //   }

  //   return responseJson;
  // }

///////////////////////////////
  ///------------  Respponse Here
///////////////////////////////

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 201:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 500:
      case 502:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 404:
        throw UnauthorisedException(response.body.toString());
      default:
        throw FetchDataException(
            'Error accured while communicating with serverwith status code${response.statusCode}');
    }
  }
}
// A 502 bad gateway message indicates that one server got an invalid response from another.

////////////////////////////
//  abstract class
////////////////////////////
abstract class BaseApiServices {
  Future<dynamic> getApiData(String url);
  Future<dynamic> postApiData(String url, dynamic data);
  Future<dynamic> putApiData(String url, dynamic data, String tokenid);
  Future<dynamic> putApiNoData(String url, String tokenid);
  Future<dynamic> deleteApiData(String url, String tokenid);
}
////////////////////////////
//  abstract class
////////////////////////////
