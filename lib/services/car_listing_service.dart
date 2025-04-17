import 'dart:convert';

import 'package:carsilla/const/common_methods.dart';
import 'package:carsilla/globel_by_callofcoding.dart';
import 'package:carsilla/resources/user_data.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../const/endpoints.dart';
import 'NetworkApiService.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dioPackage;

import 'exception.dart';

class CarListingService {
  static Future<dynamic> getCarListingDataRepF(context, String query) async {
    try {
      final checkrepsonse =
          await ApiClass().getApiData(query);
      print('dyyyyyyyyyyyyyyyyyyy$checkrepsonse');
      return checkrepsonse;
    } catch (e) {
      debugPrint(
          '$e-------- 🎈 try catch when getCarListingDataRepF api in repo ------------------------------');
    }
  }

  ////////
  static getMyCarListingDataRepF(context, String page) async {
    try {
      final checkrepsonse =
      await ApiClass().postApiData(Endpoints.baseUrl+Endpoints.getMyListing+page, []);
      return checkrepsonse;
    } catch (e) {
      debugPrint(
          '$e-------- 🎈 try catch when getMyCarListingDataRepF api in repo ------------------------------');
    }
  }

  ////////
  static getDealersDataRepF(context) async {
    try {
      final checkrepsonse =
          await ApiClass().getApiData(Endpoints.baseUrl + Endpoints.getdealers);
      return checkrepsonse;
    } catch (e) {
      debugPrint(
          '$e-------- 🎈 try catch when getDealersDataRepF api in repo ------------------------------');
    }
  }




  ////////

  Future<dynamic> editCarImages( int carId , imagesList) async {
    String? token = await getAuthToken();
    if(token == null){
      return;
    }
    final dioo = dioPackage.Dio();

    List<dioPackage.MultipartFile> multipartImages = [];
    try{
      for (XFile image in imagesList) {
        print(image);
        multipartImages.add(await dioPackage.MultipartFile.fromFile(image.path, filename: image.name));
      }
    }catch(e){
      print('rrrrrrrrrrr$e');
    }
    final formData = dioPackage.FormData.fromMap({
      "carId": carId.toString(),
      "images[]":multipartImages
      // الصورة هنا

      // "workshop_logo":data.image != null? await dioPackage.MultipartFile.fromFile(
      //   data.image!.path??'',
      //   filename: data.image?.path.split('/').last,
      // ):null,
    });

    try {
      final response = await dioo.post(
        "${Endpoints.baseUrl}uploadImgs",
        data: formData,
        options: dioPackage.Options(
          followRedirects: false,
          // will not throw errors
          validateStatus: (status) => true,
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('Responseeeeeeeee: ${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201 ) {

        return response.data;

      } else {

        throw Exception("faild to load ");

      }
    } catch (e) {
      print('Errorrrrrrrr: $e');
    }
  }
  Future<dynamic> removeCarImages( int id ,) async {
    String? token = await getAuthToken();
    if(token == null){
      return;
    }
    final dioo = dioPackage.Dio();


    final formData = dioPackage.FormData.fromMap({

      // الصورة هنا

      // "workshop_logo":data.image != null? await dioPackage.MultipartFile.fromFile(
      //   data.image!.path??'',
      //   filename: data.image?.path.split('/').last,
      // ):null,
    });

    try {
      final response = await dioo.delete(
        "${Endpoints.baseUrl}delImg/$id",
        // data: formData,
        options: dioPackage.Options(
          followRedirects: false,
          // will not throw errors
          validateStatus: (status) => true,
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('Responseeeeeeeee: ${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201 ) {

        return response.data;

      } else {

        throw Exception("faild to load ");

      }
    } catch (e) {
      print('Errorrrrrrrr: $e');
    }
  }

  ////////
  addCarListingDataRepF(context,
      {String? user_id,
      String? listing_car,
      String? listing_bodyType,
      String? listing_region,
      String? listing_city,
      String? listing_type,
      String? listing_year,
      String? listing_model,
      String? listing_desc,
      String? listing_title,
        String? contact_number,
        String? wa_number,
      List? imagesList,
      String? listing_price,
      String? features_gear,
      String? features_speed,
      String? features_color,
      String? features_seats,
      String? features_fuel_type,
      String? features_door,
      String? features_climate_zone,
      String? features_cylinders,
      List? features_others,
        LatLng? latLng,
        String? location,
        String? vin_number,
      String? features_bluetooth}) async {
    try {
      String? token = await getAuthToken();
      if(token == null){
        return;
      }
      var request = http.MultipartRequest(
          'POST', Uri.parse(Endpoints.baseUrl + Endpoints.addlisting));
      // Set headers, including Content-Type and Authorization
      request.headers['Content-Type'] = 'application/json';
      request.headers['Authorization'] = token;

      // if (imagesList!.isNotEmpty) {
      //   for (int i = 0; i < imagesList.length; i++) {
      //     var image = await http.MultipartFile.fromPath(
      //       'listing_img${i + 1}', // Using i + 1 to match the keys "listing_img1", "listing_img2", ...
      //       imagesList[i].path,
      //     );
      //     request.files.add(image);
      //   }
      // }

      //IMAGES
      if (imagesList!.isNotEmpty) {
        for (int i = 0; i < imagesList.length; i++) {
          var image = await http.MultipartFile.fromPath(
            'images[]', // Using i + 1 to match the keys "listing_img1", "listing_img2", ...
            imagesList[i],
          );
          request.files.add(image);
        }
      }

      request.fields['user_id'] = user_id ?? '';
      request.fields['listing_type'] = listing_car ?? '';
      request.fields['listing_year'] = listing_year ?? '';
      request.fields['listing_model'] = listing_model ?? '';
      request.fields['listing_desc'] = listing_desc ?? '';
      request.fields['listing_title'] = listing_title ?? '';
      request.fields['listing_price'] = listing_price ?? '';
      request.fields['features_gear'] = features_gear ?? '';
      request.fields['features_speed'] = features_speed ?? '';
      request.fields['features_seats'] = features_seats ?? '';
      request.fields['features_fuel_type'] = features_fuel_type ?? '';
      request.fields['features_door'] = features_door ?? '';
      request.fields['features_climate_zone'] = features_climate_zone ?? '';
      request.fields['features_cylinders'] = features_cylinders ?? '';
      request.fields['features_bluetooth'] = features_bluetooth ?? '';
      request.fields['body_type'] = listing_bodyType ?? "";
      request.fields['regional_specs'] = listing_region ?? "";
      request.fields['city'] = listing_city ?? "";
      request.fields['car_color'] = features_color ?? "";
      request.fields['wa_number'] = wa_number ?? "";
      request.fields['contact_number'] = contact_number ??"";
      request.fields['lat'] = latLng?.latitude.toString() ??"";
      request.fields['lng'] = latLng?.longitude.toString() ??"";
      request.fields['location'] = location ??"";
      request.fields['vin_number'] = vin_number ?? '';

// Add features_others as a JSON string
      if (features_others != null && features_others.isNotEmpty) {
        request.fields['features_others'] = jsonEncode(features_others);
      } else {
        // If features_others is null or empty, you might want to set a default value or handle it accordingly
        request.fields['features_others'] =
            ''; // or any default value you prefer
      }

      // Send the request and get the response
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return returnResponse(response);
    } catch (e) {
      debugPrint(
          '$e-------- try catch when addCarListingDataRepF api in repo ------------------------------');
    }

    // try {
    //   final checkrepsonse = await ApiClass()
    //       .postImageWithData(ApiUrls.baseUrl + ApiUrls.addlisting, data);
    //   return checkrepsonse;
    // } catch (e) {
    //   debugPrint(
    //       '$e-------- try catch when addCarListingDataRepF api in repo ------------------------------');
    // }
  }


  /////////edit car details
  editCarListingDataRepF(context,
      {String? car_id,
        String? listing_car,
        String? listing_bodyType,
        String? listing_region,
        String? listing_city,
        String? listing_type,
        String? listing_year,
        String? listing_model,
        String? listing_desc,
        String? listing_title,
        String? contact_number,
        String? wa_number,
        List? imagesList,
        String? listing_price,
        String? features_gear,
        String? features_speed,
        String? features_color,
        String? features_seats,
        String? features_fuel_type,
        String? features_door,
        String? features_climate_zone,
        String? features_cylinders,
        List? features_others,
        LatLng? latLng,
        String? location,
        String? vin_number,
        String? features_bluetooth}) async {
    try {
      String? token = await getAuthToken();
      if(token == null){
        return;
      }
      var request = http.MultipartRequest(
          'POST', Uri.parse(Endpoints.baseUrl + Endpoints.editCarDetails));
      // Set headers, including Content-Type and Authorization
      request.headers['Content-Type'] = 'application/json';
      request.headers['Authorization'] = token;

      if (imagesList!.isNotEmpty) {
        for (int i = 0; i < imagesList.length; i++) {
          print('this is image $i---${imagesList[i]}');
          if(isNetworkImage(imagesList[i])){
           request.fields['listing_img${i + 1}'] = imagesList[i];
           print('url------listing_img${i + 1} = ${imagesList[i]}');
          }else{
           var image = await http.MultipartFile.fromPath(
             'listing_img${i + 1}', // Using i + 1 to match the keys "listing_img1", "listing_img2", ...
             imagesList[i],
           );
           request.files.add(image);
           print('image------listing_img${i + 1} = ${imagesList[i]}');

         }
         }
      }
      print(imagesList.toString());
      // if (imagesList!.isNotEmpty) {
      //   for (int i = 0; i < imagesList.length; i++) {
      //     var image = await http.MultipartFile.fromPath(
      //       // 'listing_img${i + 1}', // Using i + 1 to match the keys "listing_img1", "listing_img2", ...
      //       'images[]', // Using i + 1 to match the keys "listing_img1", "listing_img2", ...
      //       imagesList[i],
      //     );
      //     request.files.add(image);
      //   }
      // }


      request.fields['carId'] = car_id ?? '';
      request.fields['listing_type'] = listing_car ?? '';
      request.fields['listing_year'] = listing_year ?? '';
      request.fields['listing_model'] = listing_model ?? '';
      request.fields['listing_desc'] = listing_desc ?? '';
      request.fields['listing_title'] = listing_title ?? '';
      request.fields['listing_price'] = listing_price ?? '';
      request.fields['features_gear'] = features_gear ?? '';
      request.fields['features_speed'] = features_speed ?? '';
      request.fields['features_seats'] = features_seats ?? '';
      request.fields['features_fuel_type'] = features_fuel_type ?? '';
      request.fields['features_door'] = features_door ?? '';
      request.fields['features_climate_zone'] = features_climate_zone ?? '';
      request.fields['features_cylinders'] = features_cylinders ?? '';
      request.fields['features_bluetooth'] = features_bluetooth ?? '';
      request.fields['body_type'] = listing_bodyType ?? "";
      request.fields['regional_specs'] = listing_region ?? "";
      request.fields['city'] = listing_city ?? "";
      request.fields['car_color'] = features_color ?? "";
      request.fields['wa_number'] = wa_number ?? "";
      request.fields['contact_number'] = contact_number ??"";
      request.fields['lat'] = latLng?.latitude.toString() ??"";
      request.fields['lng'] = latLng?.longitude.toString() ??"";
      request.fields['location'] = location ??"";
      request.fields['vin_number'] = vin_number ?? '';

// Add features_others as a JSON string
      if (features_others != null && features_others.isNotEmpty) {
        request.fields['features_others'] = jsonEncode(features_others);
      } else {
        // If features_others is null or empty, you might want to set a default value or handle it accordingly
        request.fields['features_others'] =
        ''; // or any default value you prefer
      }

      // Send the request and get the response
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return returnResponse(response);
    } catch (e) {
      print('ppppppppppppppppppppppppppppppppppppppppp$e');
      debugPrint(
          '$e-------- try catch when editCarDetailsListingDataRepF api in repo ------------------------------');
    }
  }




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
