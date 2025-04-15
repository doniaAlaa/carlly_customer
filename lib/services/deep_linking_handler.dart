import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:carsilla/screens/carlisting/deep_link_car_details.dart';
import 'package:carsilla/screens/repair_workshop/repair_workshop_screen.dart';
import 'package:carsilla/screens/repair_workshop/repair_workshop_view_screen.dart';
import 'package:carsilla/screens/spareparts/deep_link_spare_part_view.dart';
import 'package:carsilla/services/context_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


Uri? appLinkUri;

class AppLinksDeepLink extends GetxController{
  AppLinksDeepLink._privateConstructor();

  static final AppLinksDeepLink _instance = AppLinksDeepLink._privateConstructor();

  static AppLinksDeepLink get instance => _instance;


  final AppLinks _appLinks = AppLinks(); // Initialized here directly
  StreamSubscription<Uri>? _linkSubscription;



  Future<void> getInitialRoute(Uri? appLink)async{
    // Check initial link if app was in cold state (terminated)
    // var appLink = await _appLinks.getInitialLink();
    if (appLink != null) {
      var uri = Uri.parse(appLink.toString());
      print(' Check initial link if app was in cold state (terminated) ${uri}');
      BuildContext? context = ContextHandler.context;
      if(context == null){
        print('-------------context is null');
        return;
      }
      if(context.mounted){

        if(uri.path == '/car-listing/'){
          String? carId = uri.queryParameters['id'];
          if(carId != null){
            appLinkUri = null;
            Navigator.push(context, MaterialPageRoute(builder: (context) => DeepLinkCarDetails(carId: carId),));
          }
        }
        
        if(uri.path == '/spare-part/'){
          String? shopId = uri.queryParameters['shop_id'];
          String carType = uri.queryParameters['car_type'] ?? '';
          String carModel = uri.queryParameters['car_model'] ?? '';
          String year = uri.queryParameters['year'] ?? '';
          String category = uri.queryParameters['category'] ?? '';
          String subCategory = uri.queryParameters['sub-category'] ?? '';
          String? vinNumber = uri.queryParameters['vin-number'];

          if(shopId != null){
            appLinkUri = null;
            Navigator.push(context, MaterialPageRoute(builder: (context) => DeepLinkSparePartView(shopId: shopId,selectedCar: carType,selectedModel: carModel,selectedSparePart: category,subcategory: subCategory,selectedYear: year,vimNumber: vinNumber,),));
          }
        }
        
      }

    }


  }

  Future<void> initDeepLinks() async {
    // Handle link when app is in warm state (front or background)


    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {

      if(appLinkUri != null){
        return;
      }

      print(' Handle link when app is in warm state (front or background) ');
      print(' here you can redirect from url as per your need ');
      BuildContext? context = ContextHandler.context;
      if(context == null){
        print('-------------context is null');
          return;
      }
      if(context.mounted){

        if(uri.path == '/car-listing/'){
          String? carId = uri.queryParameters['id'];
          if(carId != null){
            Navigator.push(context, MaterialPageRoute(builder: (context) => DeepLinkCarDetails(carId: carId),));
          }
        }

        if(uri.path == '/car-listing/'){
          String? carId = uri.queryParameters['id'];
          if(carId != null){
            Navigator.push(context, MaterialPageRoute(builder: (context) => DeepLinkCarDetails(carId: carId),));
          }
        }

        if (uri.pathSegments.contains('workshop') && uri.queryParameters.containsKey('workshop')) {
          final id = uri.queryParameters['id'];
          print('jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  RepairWorkshopScreen()),
          );

        }
        if(uri.path == '/spare-part/'){
          String? shopId = uri.queryParameters['shop_id'];
          String carType = uri.queryParameters['car_type'] ?? '';
          String carModel = uri.queryParameters['car_model'] ?? '';
          String year = uri.queryParameters['year'] ?? '';
          String category = uri.queryParameters['category'] ?? '';
          String subCategory = uri.queryParameters['sub-category'] ?? '';
          String? vinNumber = uri.queryParameters['vin-number'];

          if(shopId != null){
            Navigator.push(context, MaterialPageRoute(builder: (context) => DeepLinkSparePartView(shopId: shopId,selectedCar: carType,selectedModel: carModel,selectedSparePart: category,subcategory: subCategory,selectedYear: year,vimNumber: vinNumber,),));
          }
        }

      }
    },onError: (err){
      debugPrint('====>>> error : $err');
    },onDone: () {
      _linkSubscription?.cancel();
    },);
  }
}