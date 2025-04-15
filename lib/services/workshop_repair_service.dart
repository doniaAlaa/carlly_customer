import 'package:carsilla/const/endpoints.dart';
import 'package:carsilla/services/NetworkApiService.dart';
import 'package:flutter/cupertino.dart';

class RepairWorkshopService {
  static getRepairWorkshopsRepoF(context,Map<String,dynamic> data) async{
    print('nnnnnnnnnnnnnnnnnnnnnn');
    print(data['city']);
    print(data['category_id']);
    print(data['brand_id']);
    try {
      final checkrepsonse =
          await ApiClass().postApiData(Endpoints.baseUrl + Endpoints.getWorkshops,
              {
                "city":data['city'],
                "category_id":data['category_id'],
                "brand_id":data['brand_id'],
             });
      print('dyyyyyyyyyyyyyyyyyyy$checkrepsonse');
      return checkrepsonse;
    } catch (e) {
      debugPrint(
          '$e-------- 🎈 try catch when getCarListingDataRepF api in repo ------------------------------');
    }
  }
}
