
import 'package:flutter/material.dart';
import '../services/spare_part_service.dart';
import '../utils/ui_utils.dart';

class SparePartProvider with ChangeNotifier {
  int maxSparePartsToShow = 4;
  bool allSparePartsToShow = false;
  List sparePartsList = [];
  List sparePartsShopsList = [];
  static List sparePartsShopsList2 = [];
  List repairingCarsList = [];
  static List sparePartCategories = [];

  changeMaxSparePartsToShowVmF() {
    allSparePartsToShow = !allSparePartsToShow;
    notifyListeners();
  }

  ///////////////////// add spare parts function

  ///////////////////// getSparePartsVmF
  getSparePartsVmF(context) async {
    final resdata = await SparePartService.getSparePartsRepoF(context);
    if (resdata['status'].toString() == 'true') {
      sparePartsList = resdata['data'];
    } else {
      UiUtils(context).showSnackBar( 'Try Later');
    }
    notifyListeners();
  }

  ///////////////////// getSparePartsShopsVmF
  Future<void> getSparePartsShopsVmF(context) async {
    print('getSparePartsShopsVmFhhhhhhhhhhhhhh');
    final resdata = await SparePartService.getSparePartsShopsepoF(context);
    print(resdata.toString());
    if (resdata['status'].toString() == 'true') {
      sparePartsShopsList2 = resdata['data'];
      print('####### ${sparePartsShopsList2.toString()}');
    } else {
      UiUtils(context).showSnackBar( 'Try Later');
    }

    notifyListeners();
  }
  Future<void> getFilteredSparePartsShopsVmF(context) async {
    print('getSparePartsShopsVmFhhhhhhhhhhhhhh');
    final resdata = await SparePartService.getSparePartsShopsepoF(context);
    print(resdata.toString());
    if (resdata['status'].toString() == 'true') {
      sparePartsShopsList2 = resdata['data'];
      print('####### ${sparePartsShopsList2.toString()}');
    } else {
      UiUtils(context).showSnackBar( 'Try Later');
    }

    notifyListeners();
  }

  ///////////////////// getSparePartsCategoriesVmF
  getSparePartsCategoriesVmF(context) async {
    final resdata = await SparePartService.getSparePartsCategorysepoF(context);
    if (resdata['status'].toString() == 'true') {
      sparePartCategories = resdata['data'];
    } else {
      UiUtils(context).showSnackBar( 'Try Later');
    }
    notifyListeners();
  }

  ///////////////////// getSparePartsVmF
  getRepairingVmF(context) async {
    final resdata = await SparePartService.getRepairingCarsRepoF(context);
    if (resdata['status'].toString() == 'true') {
      repairingCarsList = resdata['data'];
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(resdata['data'].toString()),
      //     duration: const Duration(seconds: 5),
      //     action: SnackBarAction(
      //       label: 'Undo',
      //       onPressed: () {},
      //     ),
      //   ),
      // );
    } else {
      UiUtils(context).showSnackBar( 'Try Later');
    }
    notifyListeners();
  }
}
