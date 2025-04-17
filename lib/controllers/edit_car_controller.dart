import 'package:carsilla/services/car_listing_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditCarListController extends GetxController{

  RxBool imagesLoading = false.obs;
  RxBool deleteLoading = false.obs;
  RxDouble loadingImage = 0.0.obs;
  RxList imagesList = [].obs;
  RxList<dynamic> imagesData = [].obs;
  RxInt uploadedImagesNum = 0.obs;

  getImages(int id,List<XFile> image) async{
    loadingImage.value = 0.1;
    imagesLoading.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      loadingImage.value = 0.3;
    });
    try{
      final response = await CarListingService().editCarImages(id,image);
      print(response['status']);
      if(response['status'] == true){
        List imgs = response['data'];
        imagesList.clear();
        imagesData.clear();
        imgs.forEach((e){
          imagesList.add(e['image']);
          imagesData.add(e);
        });
        uploadedImagesNum.value = imagesData.length;
        loadingImage.value = 0.0;
        imagesLoading.value = false;
      }else{
        loadingImage.value = 0.0;
        imagesLoading.value = false;
      }
    }catch(e){
      loadingImage.value = 0.0;
      imagesLoading.value = false;
    }



  }


  Future<bool> removeImage(int id,int index,{bool lastOne = false}) async{
    print(id);
    deleteLoading.value = true;
    final response = await CarListingService().removeCarImages(id);
    print(response['status']);
    if(response['status'] == true){
      // imagesList.removeAt(index);
      imagesData.removeAt(index);
      uploadedImagesNum.value = imagesData.length;
      deleteLoading.value = false;

      return lastOne;

    }

    return false;
  }



}