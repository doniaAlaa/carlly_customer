
import 'package:carsilla/const/common_methods.dart';
import 'package:carsilla/const/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/car_listing_service.dart';
import '../services/userstorage.dart';
import '../utils/ui_utils.dart';

class CarListingProvider with ChangeNotifier {


  List carListingFavId = [];
  List recentListing = [];
  List carListingDataList = [];
  List myCarListingDataList = [];
  List carDealersDataList = [];
  Map pagination = {};
  Map myListingPagination = {};

  String _currentQuery = '';

  getCarListingDataVmF(context,
      {String query = Endpoints.baseUrl + Endpoints.getlisting}) async {
    print('carrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrs');
    if (query == _currentQuery &&
        pagination['current_page'] < pagination['last_page']) {
      final response = await CarListingService.getCarListingDataRepF(
          context, "$_currentQuery&page=${pagination['current_page'] + 1}");
      print("$_currentQuery?page=${pagination['current_page'] + 1}");
      if (response['status'].toString() == 'true') {
        carListingDataList = carListingDataList + response['data']['cars'];
        // print(carDealersDataList.first.toString());
        pagination = response['data']['pagination'];
      }
    } else {
      final response = await CarListingService.getCarListingDataRepF(
          context, query);
      if (response['status'].toString() == 'true') {
        pagination = response['data']['pagination'];
        carListingDataList = response['data']['cars'];
      }
      _currentQuery = query;
    }

    notifyListeners();
  }

  ///////
  getRecentCarListingDataVmF(context,{String query = Endpoints.baseUrl + Endpoints.getlisting}) async {
    final response = await CarListingService.getCarListingDataRepF(
        context, query);
    if (response['status'].toString() == 'true') {
      carListingDataList = response['data']['cars'];
      recentListing = response['data']['cars'];
    }
    print('recentListing${recentListing.toString()}');
    notifyListeners();
  }

  //////////
  getMyCarListingDataVmF(context) async {
    String? token = await getAuthToken();
    if(token == null){
      return;
    }
    if (myListingPagination.isNotEmpty && myListingPagination['current_page'] <
        myListingPagination['last_page']) {
      final response = await CarListingService.getMyCarListingDataRepF(
          context, "page=${pagination['current_page'] + 1}");
      if (response['status'].toString() == 'true') {
        myCarListingDataList = myCarListingDataList + response['data']['cars'];
        myListingPagination = response['data']['pagination'];
      }
    } else {
      final response = await CarListingService.getMyCarListingDataRepF(
          context, "page=1");
      if (response['status'].toString() == 'true') {
        myCarListingDataList = response['data']['cars'];
        myListingPagination = response['data']['pagination'];
      }
    }
    notifyListeners();
  }

  ///////////
  getDealersDataVmF(context) async {
    final response = await CarListingService.getDealersDataRepF(context);
    if (response['status'].toString() == 'true') {
      carDealersDataList = response['data'];
    }
    notifyListeners();
  }

  ////////////
  addCarListingDataVmF(context,
      {
        String? user_id,
        String? listing_car,
        String? listing_bodyType,
        String? listing_region,
        String? listing_city,
        String? wa_number,
        String? contact_number,
        String? car_type,
        String? listing_type,
        String? listing_year,
        String? listing_model,
        String? listing_desc,
        String? listing_title,
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
        String? locationAddress,
        String? vin_number,

        String? features_bluetooth}) async {
    final response = await CarListingService().addCarListingDataRepF(context,
        user_id: user_id,
        listing_car: listing_car,
        listing_bodyType: listing_bodyType,
        listing_region: listing_region,
        listing_city: listing_city,
        listing_type: listing_type,
        listing_model: listing_model,
        listing_year: listing_year,
        listing_title: listing_title,
        listing_desc: listing_desc,
        imagesList: imagesList,
        wa_number: wa_number,
        contact_number: contact_number,
        listing_price: listing_price,
        features_gear: features_gear,
        features_speed: features_speed,
        features_color: features_color,
        features_seats: features_seats,
        features_door: features_door,
        features_fuel_type: features_fuel_type,
        features_climate_zone: features_climate_zone,
        features_cylinders: features_cylinders,
        features_bluetooth: features_bluetooth,
        latLng: latLng,
        location: locationAddress,
        vin_number: vin_number,
        features_others: features_others);
    if (response['status'].toString() == 'true') {
      UiUtils(context).showSnackBar( 'Listing Added');
    } else {
      UiUtils(context).showSnackBar( 'Try Later');
    }
    notifyListeners();
  }

  /////////////// Edit car details

  Future<void> editCarDetails(context,
      {
        String? car_id,
        String? listing_car,
        String? listing_bodyType,
        String? listing_region,
        String? listing_city,
        String? wa_number,
        String? contact_number,
        String? car_type,
        String? listing_type,
        String? listing_year,
        String? listing_model,
        String? listing_desc,
        String? listing_title,
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
        String? vinNumber,

        String? features_bluetooth}) async {
    final response = await CarListingService().editCarListingDataRepF(context,
        car_id: car_id,
        listing_car: listing_car,
        listing_bodyType: listing_bodyType,
        listing_region: listing_region,
        listing_city: listing_city,
        listing_type: listing_type,
        listing_model: listing_model,
        listing_year: listing_year,
        listing_title: listing_title,
        listing_desc: listing_desc,
        imagesList: imagesList,
        wa_number: wa_number,
        contact_number: contact_number,
        listing_price: listing_price,
        features_gear: features_gear,
        features_speed: features_speed,
        features_color: features_color,
        features_seats: features_seats,
        features_door: features_door,
        features_fuel_type: features_fuel_type,
        features_climate_zone: features_climate_zone,
        features_cylinders: features_cylinders,
        features_bluetooth: features_bluetooth,
        latLng: latLng,
        location:location,
        vin_number: vinNumber,
        features_others: features_others);
    if (response['status'].toString() == 'true') {
      UiUtils(context).showSnackBar( 'Edit Successfully');
      await getRecentCarListingDataVmF(context);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      UiUtils(context).showSnackBar( 'Try Later');
    }
    notifyListeners();
  }


  ///////////////

  addCarListingFav(String id) async {
    await StorageClass.addCarListingFav(id);
    getCarListingFav();
  }

  getCarListingFav() async {
    carListingFavId = await StorageClass.getCarListingFav();
    notifyListeners();
  }

///////////////



}
