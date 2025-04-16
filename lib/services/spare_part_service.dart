import 'package:carsilla/models/spare_part_filter_request_model.dart';
import 'package:flutter/material.dart';

import '../const/endpoints.dart';
import 'NetworkApiService.dart';

class SparePartService {
  static String? searchSparePart;


///////////
  static getRepairingCarsRepoF(context) async {
    try {
      final checkrepsonse = await ApiClass()
          .getApiData(Endpoints.baseUrl + Endpoints.getrepairingcars);

      return checkrepsonse;
    } catch (e) {
      debugPrint(
          '$e-------- 🎈 try catch when getRepairingCarsRepoF api in repo ------------------------------');
    }
  }

///////////
  static getSparePartsRepoF(context) async {
    try {
      final checkrepsonse =
          await ApiClass().getApiData(Endpoints.baseUrl + Endpoints.getspareparts);
      return checkrepsonse;
    } catch (e) {
      debugPrint(
          '$e-------- 🎈 try catch when getSparePartsRepoF api in repo ------------------------------');
    }
  }

///////////
  static getSparePartsShopsepoF(context, {SparePartFilterRequestModel? data}) async {
    try {
      print('searchSparePart=====$searchSparePart');
      final checkrepsonse = await ApiClass()
          .getApiData(Endpoints.baseUrl+'$searchSparePart');
      return checkrepsonse;
    } catch (e) {
      debugPrint(
          '$e-------- 🎈 try catch when getSparePartsShopsepoF api in repo ------------------------------');
    }
  }
  /////////

  ///////////
  static getSparePartsCategorysepoF(context) async {
    try {
      final checkrepsonse = await ApiClass()
          .getApiData(Endpoints.baseUrl + Endpoints.getsparepartscategories);
      print('getSparePartsCategorysepoF${checkrepsonse.toString()}');
      return checkrepsonse;
    } catch (e) {
      debugPrint(
          '$e-------- 🎈 try catch when getSparePartsCategorysepoF api in repo ------------------------------');
    }
  }
/////////



  static Future<List<dynamic>> getSparePartsSubCategories(context,int categoryId) async {
    try {

      final checkedResponse =
      await ApiClass().getApiData("${Endpoints.baseUrl}getSubCategories?category_id=$categoryId");

      print('---------${checkedResponse["data"]}');

      // http.Response response = await http.get(
      //     Uri.parse("${ApiUrls.baseUrl}getSubCategories?category_id=$categoryId"),
      //     headers: {
      //   'Content-Type': 'application/json',
      //   'Authorization': UserData.authToken
      // }).timeout(const Duration(seconds: 10));
      //
      // if(response.statusCode == 200){
      //   // return response.;
      // }

      return checkedResponse["data"];


    } catch (e) {
      debugPrint(
          '$e-------- 🎈 try catch when getSparePartsCategorysepoF api in repo ------------------------------');
      return [];
    }
  }

}
