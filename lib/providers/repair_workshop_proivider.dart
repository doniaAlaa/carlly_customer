import 'package:carsilla/services/workshop_repair_service.dart';
import 'package:carsilla/utils/ui_utils.dart';
import 'package:flutter/material.dart';

class RepairWorkshopProvider with ChangeNotifier {
  bool allRepairWorkshopsToShow = false;
  int maxRepairWorkshopsToShow = 4;
  List repairWorkshopsList = [];
  static List repairWorkshopsList2 = [];

  changeMaxRepairWorkshopsToShowVmF() {
    allRepairWorkshopsToShow = !allRepairWorkshopsToShow;
    notifyListeners();
  }

  ///////////////////// getRepairWorkshopsVmF
  /// This function is used to get the list of repair workshops
  ///
  /// It calls the [getRepairWorkshopsRepoF] function from the [RepairWorkshopService] cl
  Future<dynamic> getRepairWorkshopsVmF(context,Map<String,dynamic> data) async {
    final resdata =
        await RepairWorkshopService.getRepairWorkshopsRepoF(context,data);
    if (resdata['status'].toString() == 'true') {
      return {
        "status":true,
        "data":resdata['data']
      };
    } else {
      return {
        "status":false,
      };
      UiUtils(context).showSnackBar('Try Later');
    }
    notifyListeners();
  }
}
