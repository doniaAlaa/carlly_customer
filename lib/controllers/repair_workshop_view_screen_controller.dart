import 'package:carsilla/models/workshops_model.dart';
import 'package:carsilla/providers/repair_workshop_proivider.dart';
import 'package:carsilla/utils/ui_utils.dart';
import 'package:get/get.dart';


class RepairWorkshopViewScreenController extends GetxController{

  RxBool loadingWorkshops = false.obs;
  RxBool openDays = false.obs;
  RxInt selectedIndex = (-1).obs;
  List<WorkshopsModel> workshopsModel = [];

  getWorkshopsData(context,Map<String,dynamic> data) async {
    loadingWorkshops.value = true;
    final response = await RepairWorkshopProvider().getRepairWorkshopsVmF(context,data);
    if (response['status'].toString() == 'true') {
      loadingWorkshops.value = false;
      List<dynamic> workshops =  response['data'];



      try{
       workshopsModel = workshops.map((item) => WorkshopsModel.fromJson(item))
            .toList();

      }catch(e){
        print(e);
      }


    }else{
      loadingWorkshops.value = false;
      UiUtils(context).showSnackBar( 'Something Went Wrong , Try Again');

    }
    // notifyListeners();
  }
}