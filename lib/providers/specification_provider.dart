import 'dart:convert';
import 'dart:developer';

import 'package:carsilla/models/workshop_services_model.dart';
import 'package:flutter/material.dart';

import '../const/endpoints.dart';
import 'package:http/http.dart' as http;

class SpecificationProvider with ChangeNotifier {
  static List<String> carNames = [];
  static List<String> modelsByCar = [];
  static List<String> yearsByModel = [];
  static Map brandId = {};
  static Map modelId = {};
  static List<WorkshopServicesModel> workshopServices = [];
  static List<WorkshopServicesModel> carsModel = [];

  static List<String> sparePartCategories = [];
  static List<String> bodyParts = [];
  static List<String> regions = [];

  static getWorkshopServices() async {
    if (workshopServices.isEmpty) {
      workshopServices = [];
      final apiUrl = "${Endpoints.baseUrl}getWorkshopCategories";
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          // 'Authorization': 'Bearer 23|MyO7MGmke3F66QnYqEjPKYIC7hUdhYg2dOFmUwD196366126',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        //Successfully fetched data
        Map<String, dynamic> data = json.decode(response.body);
        List<WorkshopServicesModel> servicesList =
            (data['data'] as List).map((service) {
          return WorkshopServicesModel.fromJson(service);
        }).toList();
        log(servicesList.toString(), name: 'Workshop Services >>>>>>>>');
        //List<dynamic> dataList = json.decode(response.body)['data'];
        workshopServices = List.from(Set.from(servicesList));
      } else {
        // Error handling, you might want to check response.statusCode and response.body
        log("Error: ${response.statusCode}, ${response.body}");
      }
    }
    //notifyListeners();
  }

  static getBrands() async {
    if (carNames.isEmpty) {
      carNames = [];
      const apiUrl = "${Endpoints.baseUrl}getBrandsList";
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          // 'Authorization': 'Bearer 23|MyO7MGmke3F66QnYqEjPKYIC7hUdhYg2dOFmUwD196366126',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        //Successfully fetched data
        Map<String, dynamic> data = json.decode(response.body);
        List<String> brandList = (data['data'] as List).map((car) {
          brandId[car['name']] = car['id'];
          return car['name'] as String;
        }).toList();
        //List<dynamic> dataList = json.decode(response.body)['data'];

        carNames = List.from(Set.from(brandList));

        List<WorkshopServicesModel> cars =
        (data['data'] as List).map((service) {
          return WorkshopServicesModel.fromJson(service);
        }).toList();
        carsModel = List.from(Set.from(cars));
        print('carsModel${carsModel.first.id}');
        print('carsModel${carsModel.first.name}');
        print('carsModel${carsModel.length}');
        print('carsModel${carNames.length}');

      } else {
        // Error handling, you might want to check response.statusCode and response.body
        log("Error: ${response.statusCode}, ${response.body}");
      }
    }
    //notifyListeners();
  }

  static getModels(String car) async {
    modelsByCar = [];
    final apiUrl =
        "${Endpoints.baseUrl}getBrandModels?brand_id=${brandId[car]}";
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        // 'Authorization': 'Bearer 23|MyO7MGmke3F66QnYqEjPKYIC7hUdhYg2dOFmUwD196366126',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      //Successfully fetched data
      Map<String, dynamic> data = json.decode(response.body);
      List<String> modelList = (data['data'] as List).map((model) {
        modelId[model['name']] = model['id'];
        return model['name'] as String;
      }).toList();
      //List<dynamic> dataList = json.decode(response.body)['data'];
      modelsByCar = List.from(Set.from(modelList));
    } else {
      getModels(brandId[car]);
      // Error handling, you might want to check response.statusCode and response.body
      log("Error: ${response.statusCode}, ${response.body}");
    }
  }

  static getYears(String model) async {
    yearsByModel = [];
    int startYear = 1984;
    int endYear = DateTime.now().year;

    List<String> yearsList = [];

    for (int year = startYear; year <= endYear; year++) {
      yearsList.add(year.toString());
    }

    await Future.delayed(Duration(milliseconds: 600)).then(
      (value) {
        yearsByModel = yearsList.reversed.toList();
      },
    );
  }

  static getSparePartCateGories() async {
    if (sparePartCategories.isEmpty) {
      sparePartCategories = [];
      log('message');
      final apiUrl = "${Endpoints.baseUrl}getSparepartCategories";
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          //'Authorization': 'Bearer 23|MyO7MGmke3F66QnYqEjPKYIC7hUdhYg2dOFmUwD196366126',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        //Successfully fetched data
        Map<String, dynamic> data = json.decode(response.body);
        List<String> brandList = (data['data'] as List).map((part) {
          return part['name'] as String;
        }).toList();
        //List<dynamic> dataList = json.decode(response.body)['data'];
        sparePartCategories = List.from(Set.from(brandList));
        log(sparePartCategories.toString());
      } else {
        // Error handling, you might want to check response.statusCode and response.body
        log("Error: ${response.statusCode}, ${response.body}");
      }
    }
    //notifyListeners();
  }

  static getBodyPart() async {
    if (bodyParts.isEmpty) {
      bodyParts = [];
      final apiUrl = "${Endpoints.baseUrl}getBodyTypes";
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          // 'Authorization': 'Bearer 23|MyO7MGmke3F66QnYqEjPKYIC7hUdhYg2dOFmUwD196366126',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        //Successfully fetched data
        Map<String, dynamic> data = json.decode(response.body);
        List<String> brandList = (data['data'] as List).map((part) {
          return part['name'] as String;
        }).toList();
        //List<dynamic> dataList = json.decode(response.body)['data'];
        bodyParts = List.from(Set.from(brandList));
      } else {
        // Error handling, you might want to check response.statusCode and response.body
        log("Error: ${response.statusCode}, ${response.body}");
      }
    }
    //notifyListeners();
  }

  static getRegions() async {
    if (regions.isEmpty) {
      regions = [];
      final apiUrl = "${Endpoints.baseUrl}getRegionalSpecs";
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          // 'Authorization': 'Bearer 23|MyO7MGmke3F66QnYqEjPKYIC7hUdhYg2dOFmUwD196366126',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        //Successfully fetched data
        Map<String, dynamic> data = json.decode(response.body);
        List<String> brandList = (data['data'] as List).map((part) {
          return part['name'] as String;
        }).toList();
        //List<dynamic> dataList = json.decode(response.body)['data'];
        regions = List.from(Set.from(brandList));
      } else {
        // Error handling, you might want to check response.statusCode and response.body
        log("Error: ${response.statusCode}, ${response.body}");
      }
    }
    //notifyListeners();
  }
}
