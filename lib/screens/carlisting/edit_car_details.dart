// import 'package:country_code_picker/country_code_picker.dart';
import 'dart:convert';

import 'package:carsilla/controllers/edit_car_controller.dart';
import 'package:carsilla/core/reusable_widgets/toast.dart';
import 'package:carsilla/core/reusable_widgets/utils.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:carsilla/const/assets.dart';
import 'package:carsilla/utils/theme.dart';
import 'package:get/get.dart';
import '../../utils/ui_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:faabul_color_picker/faabul_color_picker.dart';
import 'package:provider/provider.dart';
import '../../globel_by_callofcoding.dart';
import '../../const/endpoints.dart';
import '../../providers/car_listing_provider.dart';
import '../../providers/specification_provider.dart';
import '../../widgets/btn.dart';
import '../../widgets/header.dart';
import '../../widgets/textfeild.dart';
import '../GoogleMap/select_location_form_map.dart';

class EditCarDetails extends StatefulWidget {
  final dynamic carDetails;

  const EditCarDetails({super.key, required this.carDetails});

  @override
  State<EditCarDetails> createState() => _EditCarDetailsState();
}

class _EditCarDetailsState extends State<EditCarDetails> {
  final typecontroller = TextEditingController();
  final modelcontroller = TextEditingController();
  final yearcontroller = TextEditingController();
  final featuresController = TextEditingController();
  final speedController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final fuelController = TextEditingController();
  final selectLocationController = TextEditingController();

  final vinNumberController = TextEditingController();

  // added by callofcoding
  final whatsAppNbrController = TextEditingController();
  final contactNbrController = TextEditingController();

  List imagesList = [];
  List<XFile> images = [];
  List networkImageList = [];
  List featuresList = [];
  List<String> cities = [
    'Dubai',
    'Abu Dhabi',
    'Sharjah',
    'Ras Al Khaimah',
    'Fujairah',
    'Ajman',
    'Umm Al Quwain',
    'Al Ain'
  ];
  String? selectedCity;

  String gear = 'Select';
  String speed = 'Select';
  int colorIndex = 3;
  String climate = 'Select';
  String fuel = 'Select';
  String seats = 'Select';

  //String selectedType = 'Used';

  bool isLoading = false;

////////////
  String? selectedCar;
  String? selectedModel;
  String? selectedYear;
  String? selectedBody;
  String? selectedRegion;

////////////


  bool isDataGet = false;

  // whatsApp country code
  String waNmbrCountryCode = "+971";

  // contact number country code
  String conNmbrCountryCode = "+971";

  List<String> Cars = SpecificationProvider.carNames;

  //location data
/////////////


  LatLng? addressLatLng;
  LatLngProvider? latLngProvider;

  @override
  void initState() {
    super.initState();

    contactNbrController.addListener(() {
      String text = contactNbrController.text;

      if (text.isNotEmpty && text.startsWith('0') && text.length > 1) {
        // Remove leading zeros
        contactNbrController.text = text.replaceFirst(RegExp(r'^0+'), '');
        contactNbrController.selection = TextSelection.fromPosition(
          TextPosition(offset: contactNbrController.text.length),
        ); // Move the cursor to the end
      }
    });

    whatsAppNbrController.addListener(() {
      String text = whatsAppNbrController.text;

      if (text.isNotEmpty && text.startsWith('0') && text.length > 1) {
        // Remove leading zeros
        whatsAppNbrController.text = text.replaceFirst(RegExp(r'^0+'), '');
        whatsAppNbrController.selection = TextSelection.fromPosition(
          TextPosition(offset: whatsAppNbrController.text.length),
        ); // Move the cursor to the end
      }
    });

    // initializeEditData();
    // getData();
  }

  getData() async {
    await SpecificationProvider.getBrands();
    await SpecificationProvider.getBodyPart();
    await SpecificationProvider.getRegions();
  }


  // parsingcolor
  Color parseColor(String colorString) {
    try {
      // Remove non-hex characters and split the string to extract the hexadecimal value
      String hexString = colorString.replaceAll(RegExp(r'[^0-9a-fA-F]'), '');

      // Parse the hexadecimal value using BigInt
      int intValue = BigInt.parse(hexString, radix: 16).toUnsigned(32).toInt();

      return Color(intValue);
    } catch (e) {
      print("Error parsing color: $e");
      return Colors.black; // Default color if unable to parse
    }
  }

  EditCarListController editCarListController = Get.put(EditCarListController());

  Future<bool> initializeEditData() async {
    // image list
    print('objectttttttttttttttttttttttttt');

    // imagesList.add(Endpoints.imageUrl + widget.carDetails!['listing_img1']);
    // if (widget.carDetails!['listing_img2'] != "icons/carvector.jpg" && widget.carDetails!['listing_img2'] != "") {
    //   imagesList
    //     .add(Endpoints.imageUrl + widget.carDetails!['listing_img2']);
    // }
    // if (widget.carDetails!['listing_img3'] != "icons/carvector.jpg"&& widget.carDetails!['listing_img3'] != "") {
    //   imagesList
    //     .add(Endpoints.imageUrl + widget.carDetails!['listing_img3']);
    // }
    // if (widget.carDetails!['listing_img4'] != "icons/carvector.jpg"&& widget.carDetails!['listing_img4'] != "") {
    //   imagesList
    //     .add(Endpoints.imageUrl + widget.carDetails!['listing_img4']);
    // }
    // if (widget.carDetails!['listing_img5'] != "icons/carvector.jpg"&& widget.carDetails!['listing_img5'] != "") {
    //   imagesList
    //     .add(Endpoints.imageUrl + widget.carDetails!['listing_img5']);
    // }
    // List img = widget.carDetails['images'];
    // img.forEach((e){
    //   images.add(e);
    //   imagesList.add(e['image']);
    // });

    /////////////images
    List<dynamic> imagesData = widget.carDetails!['images'];

    editCarListController.imagesList.clear();
    editCarListController.imagesData.clear();
    for(var e in imagesData){
      editCarListController.imagesList.add(e['image']);
    }
    for(var e in imagesData){
      editCarListController.imagesData.add(e);
    }
    editCarListController.uploadedImagesNum.value = editCarListController.imagesData.length;
    /////////////
    selectedCar = widget.carDetails['listing_type'].toString();
    selectedModel = widget.carDetails['listing_model'].toString();
    selectedYear = widget.carDetails['listing_year'].toString();
    selectedBody = widget.carDetails['body_type'].toString();
    selectedRegion = widget.carDetails['regional_specs'].toString();
    selectedCity = widget.carDetails['city'].toString();
    featuresList = widget.carDetails['features_others'] != null ? List.from(
        jsonDecode(widget.carDetails['features_others'].toString())) : [];
    gear = widget.carDetails['features_gear'].toString();
    speed = widget.carDetails['features_speed'].toString();
    colorIndex = int.tryParse(widget.carDetails['car_color']) ?? 3;
    climate = widget.carDetails['features_climate_zone'].toString();
    fuel = widget.carDetails['features_fuel_type'].toString();
    seats = widget.carDetails['features_seats'].toString();
    titleController.text = widget.carDetails['listing_title'].toString();
    descriptionController.text = widget.carDetails['listing_desc'] ?? '';
    priceController.text = widget.carDetails['listing_price'].toString();
    whatsAppNbrController.text = widget.carDetails['wa_number']
        .toString()
        .split(",")
        .last ?? '';
    contactNbrController.text = widget.carDetails['contact_number']
        .toString()
        .split(",")
        .last ?? '';
    vinNumberController.text = widget.carDetails['vin_number'] ?? '';
    // conNmbrCountryCode = widget.carDetails['contact_number'].toString().split(",").first??'+971';
    // waNmbrCountryCode = widget.carDetails['wa_number'].toString().split(",").first  ?? '+971';

    print('%%%%%% ${widget.carDetails['contact_number']}');

    double? latitude = double.tryParse(widget.carDetails['lat'].toString());
    double? longitude = double.tryParse(widget.carDetails['lng'].toString());

    if (latitude != null && longitude != null) {
      addressLatLng = LatLng(latitude, longitude);
    }

    if (widget.carDetails['location'] != null) {
      selectLocationController.text = widget.carDetails['location'];
    }

    print('--------${SpecificationProvider.regions.contains('UK Specs')}');

    await SpecificationProvider.getModels(
        widget.carDetails['listing_type'].toString());
    await SpecificationProvider.getYears(
        widget.carDetails['listing_model'].toString());
    await getData();

    print('################## ${widget.carDetails.toString()}');

    // setState(() {
    //
    // });
    return true;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    latLngProvider = context.read<LatLngProvider>();
    super.didChangeDependencies();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    latLngProvider!.disposeVariables();
    selectedModel = null;
    selectedCity = null;
    selectedRegion = null;
    selectedBody = null;
    selectedYear = null;
    selectedCar = null;

    priceController.dispose();
    descriptionController.dispose();
    titleController.dispose();
    featuresController.dispose();
    fuelController.dispose();
    speedController.dispose();
    modelcontroller.dispose();
    typecontroller.dispose();
    yearcontroller.dispose();

    cities.clear();
    Cars.clear();
    SpecificationProvider.regions.clear();
    SpecificationProvider.bodyParts.clear();
    SpecificationProvider.yearsByModel.clear();
    SpecificationProvider.modelsByCar.clear();


    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    typecontroller.text = 'Car';
    modelcontroller.text = 'X4';
    yearcontroller.text = '2016';

    print('-----$conNmbrCountryCode');
    print('-----$isDataGet ');

    return Header(
      title: 'Edit Car Details',
      body: FutureBuilder(future: isDataGet ? null : initializeEditData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100,),
                  CircularProgressIndicator()
                ],
              ),
            );
          }
          if (snapshot.hasData && !snapshot.hasError) {
            isDataGet = snapshot.data!;
            return StatefulBuilder(builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    ///////////
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            'Vehicle Details',
                            style: Theme
                                .of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: MainTheme.primaryColor),
                          ),
                        ),
                      ],
                    ),
                    // GestureDetector(
                    //   onTap: () async {
                    //     if (imagesList.length < 5) {
                    //       await ImagePicker()
                    //           .pickMultiImage(imageQuality: 40).then((image) {
                    //         if (image.isNotEmpty) {
                    //           int elementsToAdd = image.length >= 5 ? 5 : image
                    //               .length;
                    //
                    //           for (int i = 0; i < elementsToAdd; i++) {
                    //             imagesList.add(image[i].path);
                    //           }
                    //           setState(() {});
                    //         }
                    //       },);
                    //     } else {
                    //       UiUtils(context).showSnackBar( "Image limit exceed.");
                    //     }
                    //   },
                    //   child: Container(
                    //     height: MediaQuery
                    //         .of(context)
                    //         .size
                    //         .height * 0.25 / 1,
                    //     decoration: BoxDecoration(
                    //         color: Colors.grey,
                    //         borderRadius: BorderRadius.circular(13),
                    //         image: imagesList.isNotEmpty
                    //         // check if the image is from network or not
                    //
                    //             ? isNetworkImage(imagesList.first)
                    //             ? DecorationImage(
                    //             image: NetworkImage(imagesList.first),
                    //             fit: BoxFit.cover,
                    //             opacity: 0.3) : DecorationImage(
                    //             image: FileImage(File(imagesList.first)),
                    //             fit: BoxFit.cover,
                    //             opacity: 0.3)
                    //             : DecorationImage(
                    //             image: AssetImage(
                    //               IconAssets.camera,
                    //             ),
                    //             fit: BoxFit.fill,
                    //             opacity: 0)),
                    //     child: Center(
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: [
                    //           const Text(
                    //             'Add Image',
                    //             style: TextStyle(color: Colors.white),
                    //           ),
                    //           Image.asset(
                    //             IconAssets.camera,
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    //
                    // imagesList.isNotEmpty
                    //     ? SizedBox(
                    //   height: MediaQuery
                    //       .of(context)
                    //       .size
                    //       .height * 0.1 / 1,
                    //   child: ListView.builder(
                    //     shrinkWrap: true,
                    //     scrollDirection: Axis.horizontal,
                    //     controller: ScrollController(),
                    //     itemCount: imagesList.length,
                    //     itemBuilder: (BuildContext context, int index) {
                    //       return Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: GestureDetector(
                    //           onTap: () {
                    //             imagesList.removeAt(index);
                    //             setState(() {});
                    //           },
                    //           child: Badge(
                    //             label: const Icon(
                    //               Icons.delete_outlined,
                    //               color: Colors.white,
                    //               size: 13,
                    //             ),
                    //             child: Container(
                    //               width:
                    //               MediaQuery
                    //                   .of(context)
                    //                   .size
                    //                   .width * 0.2 / 1,
                    //               height:
                    //               MediaQuery
                    //                   .of(context)
                    //                   .size
                    //                   .height * 0.1 / 1,
                    //               decoration: BoxDecoration(
                    //                   border: Border.all(
                    //                       width: 0.5,
                    //                       color: MainTheme.primaryColor)),
                    //               child: Padding(
                    //                 padding: const EdgeInsets.all(2.0),
                    //                 child: isNetworkImage(imagesList[index])
                    //                     ? Image.network(imagesList[index])
                    //                     : Image.file(File(imagesList[index]),
                    //                     width: MediaQuery
                    //                         .of(context)
                    //                         .size
                    //                         .width *
                    //                         0.2 /
                    //                         1,
                    //                     height: MediaQuery
                    //                         .of(context)
                    //                         .size
                    //                         .height *
                    //                         0.1 /
                    //                         1,
                    //                     fit: BoxFit.cover),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // )
                    //     : const SizedBox(height: 0),
                    ////////////////////////////////////////////////
                    GestureDetector(
                      onTap: () async {
                        if (editCarListController.imagesData.length < 5) {
                          await ImagePicker()
                              .pickMultiImage(imageQuality: 40)
                              .then(
                                (image) {
                              // editCarListController.getImages();

                              if (image.isNotEmpty) {
                                int elementsToAdd =
                                image.length >= 5 ? 5 : image.length;

                                if(image.length + editCarListController.imagesData.length > 5){
                                  int remainingImagesNumber = 5 - (editCarListController.imagesData.length) ;
                                  // List<XFile> reversedImages = image.reversed.toList();

                                  // List<XFile> remainingImages = reversedImages.sublist(0, remainingImagesNumber);
                                  List<XFile> remainingImages = image.sublist(0, remainingImagesNumber);
                                  editCarListController.getImages(widget.carDetails['id'],remainingImages);

                                  showtoastF(context,"You can't have more than 5 images for the car!",duration: 5);

                                }else{

                                  editCarListController.getImages(widget.carDetails['id'],image);

                                }
                                setState(() {});
                              }
                            },
                          );
                        } else {
                          showtoastF(context, "Image limit exceed.");
                        }
                      },
                      child:


                      Container(
                        height: MediaQuery.of(context).size.height * 0.25 / 1,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(13),
                            // image: editCarListController.imagesList.isNotEmpty
                            image: editCarListController.imagesData.isNotEmpty
                            // check if the image is from network or not

                            // ? Utils.isNetworkImage(editCarListController.imagesList.last)
                                ? Utils.isNetworkImage(editCarListController.imagesData.last['image'])
                                ? DecorationImage(
                              // image: NetworkImage(editCarListController.imagesList.last),
                                image: NetworkImage(editCarListController.imagesData.last['image']),
                                fit: BoxFit.cover,
                                opacity: 0.3)
                                : DecorationImage(
                                image:
                                // FileImage(File(editCarListController.imagesList.last)),
                                FileImage(File(editCarListController.imagesList.last['image'])),
                                fit: BoxFit.cover,
                                opacity: 0.3)
                                : DecorationImage(
                                image: AssetImage(
                                  IconAssets.camera,
                                ),
                                fit: BoxFit.fill,
                                opacity: 0)),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Add Image',
                                style: TextStyle(color: Colors.white),
                              ),
                              Image.asset(
                                IconAssets.camera,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 6,),
                    Obx((){
                      return Align(
                          alignment: Alignment.topRight,
                          child: Text('${editCarListController.uploadedImagesNum.value}/5'));
                    }),

                    SizedBox(height: 10,),
                    // Obx((){
                    //   return
                    //   editCarListController.imagesLoading.value == true?
                    //   Shimmer.fromColors(
                    //     baseColor: Colors.grey.shade300,
                    //     highlightColor: Colors.grey.shade100,
                    //     child: Container(
                    //       width: MediaQuery.of(context)
                    //           .size
                    //           .width *
                    //           0.2 /
                    //           1,
                    //       height: 60,
                    //       decoration: BoxDecoration(
                    //           color: Color(0x94D2D2D2),
                    //
                    //           border: Border.all(color: MainTheme.primaryColor)
                    //       ),
                    //       // child: Padding(
                    //       //   padding: const EdgeInsets.all(10.0),
                    //       //   child: CircularProgressIndicator(color: MainTheme.primaryColor,),
                    //       // ),
                    //     ),
                    //   ):
                    //   Container(
                    //     width: MediaQuery.of(context)
                    //         .size
                    //         .width *
                    //         0.2 /
                    //         1,
                    //     height: 60,
                    //     decoration: BoxDecoration(
                    //         border: Border.all(color: MainTheme.primaryColor)
                    //     ),
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(10.0),
                    //       child: Icon(Icons.add,color: MainTheme.primaryColor,),
                    //     ),
                    //   );
                    // }),
                    Obx((){
                      return

                        Row(
                          children: [
                            editCarListController.imagesLoading.value == true?
                            // Shimmer.fromColors(
                            // baseColor: Colors.grey.shade300,
                            //   highlightColor: Colors.grey.shade100,
                            //   child: Container(
                            //     width: MediaQuery.of(context)
                            //         .size
                            //         .width *
                            //         0.2 /
                            //         1,
                            //     height: 60,
                            //     decoration: BoxDecoration(
                            //         color: Colors.black,
                            //
                            //         border: Border.all(color: MainTheme.primaryColor)
                            //     ),
                            //     // child: Padding(
                            //     //   padding: const EdgeInsets.all(10.0),
                            //     //   child: CircularProgressIndicator(color: MainTheme.primaryColor,),
                            //     // ),
                            //   ),
                            // )
                            Container(
                              width: MediaQuery.of(context)
                                  .size
                                  .width *
                                  0.2 /
                                  1,
                              height: 60,
                              decoration: BoxDecoration(
                                // color: Colors.black,

                                  border: Border.all(color: MainTheme.primaryColor)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 50.0),
                                child: Container(
                                  height:5,
                                  child: LinearProgressIndicator(
                                    value:editCarListController.loadingImage.value, // 0.0 to 1.0
                                    // minHeight: 5,
                                    borderRadius: BorderRadius.circular(20),

                                    color: MainTheme.primaryColor,),
                                ),
                              ),
                            )
                                :
                            InkWell(
                              onTap:() async{
                                if (editCarListController.imagesData.length < 5) {
                                  await ImagePicker()
                                      .pickMultiImage(imageQuality: 40)
                                      .then(
                                        (image) {
                                      // editCarListController.getImages();

                                      if (image.isNotEmpty) {
                                        int elementsToAdd =
                                        image.length >= 5 ? 5 : image.length;


                                        if(image.length + editCarListController.imagesData.length > 5){
                                          int remainingImagesNumber = 5 - (editCarListController.imagesData.length) ;
                                          // List<XFile> reversedImages = image.reversed.toList();

                                          // List<XFile> remainingImages = reversedImages.sublist(0, remainingImagesNumber);
                                          List<XFile> remainingImages = image.sublist(0, remainingImagesNumber);
                                          print('jjjjjjjjjjjjjjjj');
                                          editCarListController.getImages(widget.carDetails['id'],remainingImages);

                                          showtoastF(context,"You can't have more than 5 images for the car!",duration: 5);

                                        }else{

                                          editCarListController.getImages(widget.carDetails['id'],image);

                                        }
                                        setState(() {});
                                      }
                                    },
                                  );
                                } else {
                                  showtoastF(context, "Image limit exceed.");
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.2 /
                                    1,
                                height: 60,
                                decoration: BoxDecoration(
                                    border: Border.all(color: MainTheme.primaryColor)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(Icons.add,color: MainTheme.primaryColor,),
                                ),
                              ),
                            ),

                            // editCarListController.imagesList.isNotEmpty
                            editCarListController.imagesData.isNotEmpty
                                ?

                            Expanded(
                              child: SizedBox(
                                height:
                                MediaQuery.of(context).size.height * 0.1 / 1,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  controller: ScrollController(),
                                  itemCount: editCarListController.imagesData.length ,
                                  itemBuilder: (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () async{
                                        // imagesList.removeAt(index);
                                        if(editCarListController.imagesData.length > 1){
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false, // Prevent closing by tapping outside
                                            builder: (context) {
                                              return Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            },
                                          );

                                          await editCarListController.removeImage(editCarListController.imagesData[index]['id'],index);
                                          Navigator.of(context).pop(); // Make sure dialog closes on error too



                                        }else{
                                          showDialog<void>(
                                            context: context,

                                            barrierDismissible: false, // user must tap button!
                                            builder: (BuildContext context) {
                                              return
                                                AlertDialog(
                                                  insetPadding: EdgeInsets.zero,
                                                  contentPadding: EdgeInsets.zero,
                                                  backgroundColor:  Colors.white,
                                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                                  // title: Center(child: const Text('Delete Image',style: TextStyle(fontSize: 18,color: Colors.red,fontWeight: FontWeight.w600),)),
                                                  content:  Container(
                                                    height: 280,
                                                    width: MediaQuery.of(context).size.width *0.9,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        SizedBox(height: 30,),
                                                        Center(child: const Text('Delete Image',style: TextStyle(fontSize: 18,color: Colors.red,fontWeight: FontWeight.w600),)),
                                                        SizedBox(height: 16,),

                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 16.0),
                                                          child: Align(
                                                            alignment: Alignment.topRight,
                                                            child: Container(
                                                              width: MediaQuery.of(context).size.width*0.8,
                                                              child: Text('you must have at least one image for the car , add another image before deleting the last one',
                                                                  textAlign: TextAlign.start,
                                                                  style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400)),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 16,),
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 16.0),
                                                          child: Align(
                                                            alignment: Alignment.topRight,
                                                            child: Container(
                                                              width: MediaQuery.of(context).size.width*0.8,
                                                              child: Text('Are you sure you want to delete it?',
                                                                  textAlign: TextAlign.start,
                                                                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 16,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            MainButton(
                                                              width: 0.34,
                                                              label: 'Cancel',
                                                              onclick: () {
                                                                Navigator.pop(context);
                                                                editCarListController.deleteLoading.value = false;
                                                              },

                                                            ),
                                                            SizedBox(width: 20,),
                                                            Obx((){
                                                              return MainButton(
                                                                isLoading: editCarListController.deleteLoading.value,
                                                                width: 0.34,
                                                                btnColor:Colors.red,
                                                                label: 'Delete',
                                                                onclick: () async {
                                                                  bool lastOne = await editCarListController.removeImage(editCarListController.imagesData[index]['id'],index,lastOne: true);
                                                                  if(lastOne == true){
                                                                    Navigator.pop(context);
                                                                  }

                                                                },
                                                              );
                                                            })
                                                          ],
                                                        ),
                                                        SizedBox(height: 30,),


                                                      ],
                                                    ),
                                                  ),
                                                  // actions: <Widget>[
                                                  //   TextButton(
                                                  //     child: const Text('Approve'),
                                                  //     onPressed: () {
                                                  //       Navigator.of(context).pop();
                                                  //     },
                                                  //   ),
                                                  // ],
                                                );
                                            },
                                          );

                                        }
                                        setState(() {});
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Badge(
                                          label: const Icon(
                                            Icons.delete_outlined,
                                            color: Colors.white,
                                            size: 13,
                                          ),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.2 /
                                                1,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height *
                                                0.1 /
                                                1,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 0.5,
                                                    color:
                                                    MainTheme.primaryColor)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: Utils.isNetworkImage(
                                                  editCarListController.imagesData[index]['image'])
                                                  ? Image.network(
                                                  loadingBuilder: (context, child, loadingProgress) {
                                                    if (loadingProgress == null) return child; // Image is fully loaded

                                                    return Center(
                                                      child: CircularProgressIndicator(
                                                        value: loadingProgress.expectedTotalBytes != null
                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                            (loadingProgress.expectedTotalBytes ?? 1)
                                                            : null, // Show indeterminate if totalBytes unknown
                                                      ),
                                                    );
                                                  },
                                                  editCarListController.imagesData[index]['image'])
                                                  : Image.file(
                                                  File(editCarListController.imagesData[index]['image']),
                                                  width:
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.2 /
                                                      1,
                                                  height:
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                      0.1 /
                                                      1,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                                : const SizedBox(height: 0)
                          ],
                        );


                    }),
                    ////////////////////////////////////////////////
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.01 / 1),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.01 / 1),
                    //Type
                    SizedBox(
                      // width: MediaQuery.of(context).size.width * 0.28 / 1,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('MAKE',
                                  style: textTheme.labelSmall!.copyWith(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade600)),
                              Container(

                                  decoration: BoxDecoration(
                                      border:
                                      Border.all(width: 0.8,
                                          color: Colors.grey.shade400),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: selectedCar,
                                      hint: const Text('Select Car'),
                                      underline: Container(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black),
                                      icon: Align(
                                        alignment: Alignment.centerRight,
                                        child: Transform.rotate(
                                            angle: 4.7,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3.0),
                                              child: Icon(
                                                Icons.arrow_back_ios_outlined,
                                                color: Colors.grey.shade500,
                                                size: 15,
                                              ),
                                            )),
                                      ),
                                      onChanged: (String? newValue) async {
                                        await SpecificationProvider.getModels(
                                            newValue!);
                                        setState(() {
                                          selectedCar = newValue;
                                          selectedModel = null;
                                          selectedYear = null;
                                        });
                                      },
                                      items: Cars.map((String car) {
                                        return DropdownMenuItem<String>(
                                          value: car,
                                          child: Text(car),
                                        );
                                      }).toList(),
                                    ),
                                  )),
                              // GestureDetector(
                              //   onTap: () {
                              //     showCustomDropDownBottomSheet(context);
                              //   },
                              //   child: Container(
                              //       // width: MediaQuery.of(context).size.width * 0.32 / 1,
                              //       decoration: BoxDecoration(
                              //           border: Border.all(
                              //               width: 0.8, color: Colors.grey.shade400),
                              //           borderRadius: BorderRadius.circular(10)),
                              //       child: Padding(
                              //           padding: const EdgeInsets.symmetric(
                              //               horizontal: 10, vertical: 13),
                              //           child: Row(
                              //               mainAxisAlignment:
                              //                   MainAxisAlignment.spaceBetween,
                              //               children: [
                              //                 Text(selectedCar.toString().isEmpty ||
                              //                         selectedCar == null
                              //                     ? "Choose"
                              //                     : selectedCar.toString()),
                              //                 Transform.rotate(
                              //                     angle: 4.7,
                              //                     child: Padding(
                              //                         padding: const EdgeInsets.only(
                              //                             left: 3.0),
                              //                         child: Icon(
                              //                             Icons.arrow_back_ios_outlined,
                              //                             color: Colors.grey.shade500,
                              //                             size: 15)))
                              //               ]))),
                              // )
                            ])),
                    //SizedBox(height: MediaQuery.of(context).size.height * 0.01 / 1),
                    SizedBox(
                      //height: MediaQuery.of(context).size.height * 0.089 / 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.47 / 1,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text('MODEL',
                                          style: textTheme.labelSmall!.copyWith(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade600)),
                                      Container(

                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width *
                                              0.46 /
                                              1,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 0.8,
                                                  color: Colors.grey.shade400),
                                              borderRadius:
                                              BorderRadius.circular(10)),
                                          child: Center(
                                              child: ButtonTheme(
                                                alignedDropdown: true,
                                                child: DropdownButton<String>(
                                                    isExpanded: true,
                                                    value: selectedModel,
                                                    hint: Text(
                                                        'Model'),
                                                    underline: Container(),
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                    icon: Transform.rotate(
                                                        angle: 4.7,
                                                        child: Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 3.0),
                                                            child:
                                                            Icon(Icons
                                                                .arrow_back_ios_outlined,
                                                                color: Colors
                                                                    .grey
                                                                    .shade500,
                                                                size: 17))),
                                                    onChanged:
                                                        (
                                                        String? newValue) async {
                                                      await SpecificationProvider
                                                          .getYears(newValue!);
                                                      setState(() {
                                                        selectedModel =
                                                            newValue;
                                                        selectedYear = null;
                                                      });
                                                    },
                                                    items: /*selectedCar != null
                                                ?*/ SpecificationProvider
                                                        .modelsByCar.map((
                                                        String model) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                          value: model,
                                                          child: Text(
                                                              model));
                                                    }).toList()
                                                  /*: []*/),
                                              )))
                                    ])),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: SizedBox(
                              //width: MediaQuery.of(context).size.width * 0.43 / 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('YEAR',
                                      style: textTheme.labelSmall!.copyWith(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade600)),
                                  Container(

                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 0.8,
                                              color: Colors.grey.shade400),
                                          borderRadius: BorderRadius.circular(
                                              10)),
                                      child: Center(
                                        child: ButtonTheme(
                                          alignedDropdown: true,
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            underline: Container(),
                                            value: selectedYear,
                                            hint: const Text(' Year'),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                selectedYear = newValue;
                                              });
                                            },
                                            icon: Transform.rotate(
                                                angle: 4.7,
                                                child: Padding(
                                                    padding: const EdgeInsets
                                                        .only(
                                                        left: 3.0),
                                                    child: Icon(
                                                        Icons
                                                            .arrow_back_ios_outlined,
                                                        color: Colors.grey
                                                            .shade500,
                                                        size: 17))),
                                            items: selectedModel != null
                                                ? SpecificationProvider
                                                .yearsByModel
                                                ?.map((String year) {
                                              return DropdownMenuItem<
                                                  String>(
                                                value: year,
                                                child: Text(year),
                                              );
                                            }).toList() ??
                                                []
                                                : [],
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: MediaQuery.of(context).size.height * 0.01 / 1),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 14),
                    //   child: Row(
                    //     children: [
                    //       Text('Type'.toUpperCase(),
                    //           style: textTheme.labelSmall!.copyWith(
                    //               fontSize: 11,
                    //               fontWeight: FontWeight.w500,
                    //               color: Colors.grey.shade500)),
                    //     ],
                    //   ),
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     Row(
                    //       children: [
                    //         Radio(
                    //           value: 'Used',
                    //           groupValue: selectedType,
                    //           onChanged: (value) {
                    //             setState(() {
                    //               selectedType = value.toString();
                    //             });
                    //             log(selectedType!);
                    //           },
                    //         ),
                    //         Text('Used', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    //       ],
                    //     ),
                    //     Row(
                    //       children: [
                    //         Radio(
                    //           value: 'Imported',
                    //           groupValue: selectedType,
                    //           onChanged: (value) {
                    //             setState(() {
                    //               selectedType = value.toString();
                    //             });
                    //           },
                    //         ),
                    //         Text('Imported', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    //       ],
                    //     ),
                    //     Row(
                    //       children: [
                    //         Radio(
                    //           value: 'Auction',
                    //           groupValue: selectedType,
                    //           onChanged: (value) {
                    //             setState(() {
                    //               selectedType = value.toString();
                    //             });
                    //           },
                    //         ),
                    //         Text('Auction', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.01 / 1),
                    Row(
                      children: [
                        Text('Body Type'.toUpperCase(),
                            style: textTheme.labelSmall!.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600)),
                      ],
                    ),
                    Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.98 / 1,
                        decoration: BoxDecoration(
                            border:
                            Border.all(width: 0.8, color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                onTap: () async {
                                  await SpecificationProvider.getBodyPart();
                                },
                                value: selectedBody,
                                hint: const Text(
                                    'Select Body Type'),
                                underline: Container(),
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                                icon: Align(
                                  alignment: Alignment.centerRight,
                                  child: Transform.rotate(
                                      angle: 4.7,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 3.0),
                                        child: Icon(
                                          Icons.arrow_back_ios_outlined,
                                          color: Colors.grey.shade500,
                                          size: 15,
                                        ),
                                      )),
                                ),
                                onChanged: (String? newValue) async {
                                  await SpecificationProvider.getRegions();
                                  setState(() {
                                    selectedBody = newValue;
                                  });
                                },
                                items: SpecificationProvider.bodyParts.map((
                                    String sparepart) {
                                  return DropdownMenuItem<String>(
                                    value: sparepart,
                                    child: Text(sparepart),
                                  );
                                }).toList(),
                              ),
                            ))),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Text('Regional Spec'.toUpperCase(),
                            style: textTheme.labelSmall!.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600)),
                      ],
                    ),
                    Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.98 / 1,
                        decoration: BoxDecoration(
                            border:
                            Border.all(width: 0.8, color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                onTap: () async {
                                  await SpecificationProvider.getRegions();
                                },
                                value: selectedRegion,
                                hint: const Text(
                                    'Select Region'),
                                underline: Container(),
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                                icon: Align(
                                  alignment: Alignment.centerRight,
                                  child: Transform.rotate(
                                      angle: 4.7,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 3.0),
                                        child: Icon(
                                          Icons.arrow_back_ios_outlined,
                                          color: Colors.grey.shade500,
                                          size: 15,
                                        ),
                                      )),
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedRegion = newValue;
                                  });
                                },
                                items: SpecificationProvider.regions.map((
                                    String sparepart) {
                                  return DropdownMenuItem<String>(
                                    value: sparepart,
                                    child: Text(sparepart),
                                  );
                                }).toList(),
                              ),
                            ))),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Text('CITY'.toUpperCase(),
                            style: textTheme.labelSmall!.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600)),
                      ],
                    ),
                    Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.98 / 1,
                        decoration: BoxDecoration(
                            border:
                            Border.all(width: 0.8, color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                onTap: () async {
                                  await SpecificationProvider.getRegions();
                                },
                                value: selectedCity,
                                hint: const Text(
                                    'Select City'),
                                underline: Container(),
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                                icon: Align(
                                  alignment: Alignment.centerRight,
                                  child: Transform.rotate(
                                      angle: 4.7,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 3.0),
                                        child: Icon(
                                          Icons.arrow_back_ios_outlined,
                                          color: Colors.grey.shade500,
                                          size: 15,
                                        ),
                                      )),
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedCity = newValue;
                                  });
                                },
                                items: cities.map((String city) {
                                  return DropdownMenuItem<String>(
                                    value: city,
                                    child: Text(city),
                                  );
                                }).toList(),
                              ),
                            ))),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        Text('Features'.toUpperCase(),
                            style: textTheme.labelSmall!.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade500)),
                      ],
                    ),

                    CustomTextFormField(
                      hintText: ' ',
                      controller: featuresController,
                      suffix: Transform.rotate(
                          angle: 4.65,
                          child: IconButton(
                            onPressed: () {
                              if (featuresController.text
                                  .trim()
                                  .isNotEmpty) {
                                featuresList.add(featuresController.text);
                                featuresController.clear();
                                setState(() {});
                              }
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.grey.shade500,
                            ),
                          )),
                    ),

                    featuresList.isNotEmpty
                        ? SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.07 / 1,
                      child: ListView.builder(
                        shrinkWrap: true,
                        controller: ScrollController(),
                        scrollDirection: Axis.horizontal,
                        itemCount: featuresList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Opacity(
                            opacity: 0.5,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0),
                              child: Chip(
                                label: Text(featuresList[index].toString()),
                                deleteIconColor: Colors.grey,
                                onDeleted: () {
                                  featuresList.removeAt(index);
                                  setState(() {});
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    )
                        : const SizedBox(height: 0),
                    // Padding(
                    //   padding: const EdgeInsets.all(14.0),
                    //   child: Image.asset(IconAssets.Features),
                    // ),

                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        Text('vin number'.toUpperCase(),
                            style: textTheme.labelSmall!.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade500)),
                      ],
                    ),

                    CustomTextFormField(
                      hintText: 'Vin Number',
                      controller: vinNumberController,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text('Specifications'.toUpperCase(),
                            style: textTheme.labelSmall!.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade500)),
                      ],
                    ),
                    /////////// added features from selection satrt
                    Wrap(children: [
                      GestureDetector(
                        onTap: () {
                          showGearDialogF(setState);
                        },
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.white),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.46 / 1,
                          child: ListTile(
                            leading: Image.asset(IconAssets.features1),
                            title: Text('Gear',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade500)),
                            subtitle: Text(gear,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade900)),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showSpeedDialogF(setState);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width *
                              0.46 /
                              1,
                          child: ListTile(
                            leading:
                            Image.asset(IconAssets.features2),
                            title: Text('Mileage',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade500)),
                            subtitle: Text("$speed KM",
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade900)),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          showCylDialogF(setState);
                          // showCylDialogF();
                        },
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.white),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.46 / 1,
                          child: ListTile(
                            leading: Image.asset(IconAssets.features3),
                            title: Text('Color',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade500)),
                            subtitle: FaabulColorSample(
                                color: colors[colorIndex], size: 10),
                            // subtitle: Text(cyl,
                            //     style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            //         fontWeight: FontWeight.w500,
                            //         color: Colors.grey.shade900)),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showClimateF(setState);
                        },
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.white),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.46 / 1,
                          child: ListTile(
                            leading: Image.asset(IconAssets.features4),
                            title: Text('Warranty',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade500)),
                            subtitle: Text(climate,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade900)),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showFuelF(setState);
                        },
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.white),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.46 / 1,
                          child: ListTile(
                            leading: Image.asset(IconAssets.features5),
                            title: Text('Fuel Type',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade500)),
                            subtitle: Text(fuel,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade900)),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showSeatsF(setState);
                        },
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.white),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.46 / 1,
                          child: ListTile(
                            leading: Image.asset(IconAssets.features6),
                            title: Text('Seats',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade500)),
                            subtitle: Text(seats,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade900)),
                          ),
                        ),
                      ),
                    ]),
                    /////////// added features from selection end
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.015 / 1),
                    CustomTextFormField(
                      hintText: 'Name',
                      controller: titleController,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                            padding: EdgeInsets.all(8),
                            height: size.width * 0.13,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.28 / 1,
                            decoration: BoxDecoration(
                              // color: Colors.red,
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey.shade400,
                                ),
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  'assets/images/uae_flag.png', height: 30,),
                                Text(conNmbrCountryCode, style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Poppins"),)
                              ],
                            )
                          //TODO: comment by callofcoding
                        ),
                        // Container(
                        //   width: MediaQuery.of(context).size.width * 0.28 / 1,
                        //   decoration: BoxDecoration(
                        //       border: Border.all(
                        //         width: 1,
                        //         color: Colors.grey.shade400,
                        //       ),
                        //       borderRadius: BorderRadius.circular(8)),
                        //   child: CountryCodePicker(
                        //     padding: EdgeInsets.zero,
                        //     flagWidth: 40,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         conNmbrCountryCode = value.dialCode ?? '+971';
                        //       });
                        //     },
                        //     // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                        //     initialSelection: conNmbrCountryCode,
                        //     favorite: ['+971','+92','+39'],
                        //     // optional. Shows only country name and flag
                        //     showCountryOnly: false,
                        //     // optional. Shows only country name and flag when popup is closed.
                        //     showOnlyCountryWhenClosed: false,
                        //     // optional. aligns the flag and the Text left
                        //     alignLeft: false,
                        //   ),
                        //
                        //   //TODO: comment by callofcoding
                        // ),
                        SizedBox(width: 18,),
                        Expanded(
                          child: CustomTextFormField(
                            textInputType: TextInputType.number,
                            hintText: 'Contact Number',
                            controller: contactNbrController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                            padding: EdgeInsets.all(8),
                            height: size.width * 0.13,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.28 / 1,
                            decoration: BoxDecoration(
                              // color: Colors.red,
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey.shade400,
                                ),
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  'assets/images/uae_flag.png', height: 30,),
                                Text(waNmbrCountryCode, style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Poppins"),)
                              ],
                            )
                          //TODO: comment by callofcoding
                        ),
                        // Container(
                        //   width: MediaQuery.of(context).size.width * 0.28 / 1,
                        //   decoration: BoxDecoration(
                        //       border: Border.all(
                        //         width: 1,
                        //         color: Colors.grey.shade400,
                        //       ),
                        //       borderRadius: BorderRadius.circular(8)),
                        //   child: CountryCodePicker(
                        //     padding: EdgeInsets.zero,
                        //     flagWidth: 40,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         waNmbrCountryCode = value.dialCode ?? '+971';
                        //       });
                        //     },
                        //     // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                        //     initialSelection: waNmbrCountryCode,
                        //     favorite: ['+971','+92','+39'],
                        //     // optional. Shows only country name and flag
                        //     showCountryOnly: false,
                        //     // optional. Shows only country name and flag when popup is closed.
                        //     showOnlyCountryWhenClosed: false,
                        //     // optional. aligns the flag and the Text left
                        //     alignLeft: false,
                        //   ),
                        // ),
                        SizedBox(width: 18,),
                        Expanded(
                          child: CustomTextFormField(
                            // width: size.width * 0.7,
                            textInputType: TextInputType.number,
                            hintText: 'WhatsApp Number',
                            controller: whatsAppNbrController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      maxLines: 3,
                      hintText: 'Description',
                      controller: descriptionController,
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      textInputType: TextInputType.number,
                      hintText: 'Price',
                      controller: priceController,
                    ),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.015 / 1),
                    Consumer<LatLngProvider>(
                      builder: (BuildContext context, LatLngProvider value,
                          Widget? child) {
                        if (value.getAddress != null) {
                          selectLocationController.text =
                              value.getAddress ?? '';
                        }

                        if (value.getLatLng != null) {
                          addressLatLng = value.getLatLng;
                        }
                        return CustomTextFormField(
                          onTap: () {
                            print('called');
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  SelectLocationFromMap(
                                    coordinates: addressLatLng,),));
                          },
                          textInputType: TextInputType.none,
                          // enabled: false,
                          hintText: 'Select Location',
                          controller: selectLocationController,
                        );
                      },),
                    TextField(),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.015 / 1),
                    SizedBox(
                      width: double.infinity,
                      child: MainButton(
                        isLoading: isLoading,
                        width: 0.9,
                        onclick: () async {
                          if (editCarListController.imagesList.isEmpty) {
                            UiUtils(context).showSnackBar( 'Choose Images');
                          } else if (selectedCar!.isEmpty) {
                            UiUtils(context).showSnackBar( 'Choose Type');
                          } else if (selectedModel!.isEmpty) {
                            UiUtils(context).showSnackBar( 'Choose Model');
                          } else if (selectedYear!.isEmpty) {
                            UiUtils(context).showSnackBar( 'Choose Year');
                          } else if (selectedBody!.isEmpty) {
                            UiUtils(context).showSnackBar( 'Choose Body Type');
                          } else if (selectedRegion!.isEmpty) {
                            UiUtils(context).showSnackBar( 'Choose Regional Spec');
                          } else if (selectedCity!.isEmpty) {
                            UiUtils(context).showSnackBar( 'Choose City');
                          }
                          // else if (vinNumberController.text.isEmpty) {
                          //   UiUtils(context).showSnackBar( 'Enter Vin Number');
                          // }
                          else if (titleController.text.isEmpty) {
                            UiUtils(context).showSnackBar( 'Enter Name');
                          } else if (priceController.text.isEmpty) {
                            UiUtils(context).showSnackBar( 'Enter Price');
                          } else if (gear == 'Select') {
                            UiUtils(context).showSnackBar( 'Choose Gear Fetures');
                          } else if (speed == 'Select') {
                            UiUtils(context).showSnackBar( 'Choose Speed Fetures');
                          } else if (colorIndex == 'Select') {
                            UiUtils(context).showSnackBar( 'Choose Cylinders Fetures');
                          } else if (gear == 'Select') {
                            UiUtils(context).showSnackBar('Choose Gear Fetures');
                          } else if (fuel == 'Select') {
                            UiUtils(context).showSnackBar( 'Choose Fuel Fetures');
                          } else if (seats == 'Select') {
                            UiUtils(context).showSnackBar( 'Choose Seats Fetures');
                          } else if (addressLatLng == null &&
                              selectLocationController.text.isEmpty) {
                            UiUtils(context).showSnackBar( 'Select Location');
                          } else {
                            print('called--------${widget.carDetails
                                .toString()}');
                             //TODO
                            // setState(() {
                            //   isLoading = true;
                            // });

//

                            await Provider.of<CarListingProvider>(
                                context, listen: false).editCarDetails(context,
                                car_id: widget.carDetails['id'].toString(),
                                contact_number: "$conNmbrCountryCode,${removeZeroFromNumber(
                                    contactNbrController.text.toString())}",
                                features_bluetooth: widget
                                    .carDetails['features_bluetooth'],
                                features_climate_zone: climate,
                                features_color: colorIndex.toString(),
                                features_cylinders: colorIndex.toString(),
                                features_door: seats,
                                features_fuel_type: fuel,
                                features_gear: gear,
                                features_others: featuresList,
                                features_seats: seats,
                                features_speed: speed,
                                // imagesList: imagesList,
                                imagesList: editCarListController.imagesList,
                                listing_bodyType: selectedBody,
                                listing_car: selectedCar,
                                listing_city: selectedCity,
                                listing_desc: descriptionController.text
                                    .toString(),
                                listing_model: selectedModel,
                                listing_price: priceController.text.toString(),
                                listing_region: selectedRegion,
                                listing_title: titleController.text.toString(),
                                listing_type: typecontroller.text.toString(),
                                listing_year: selectedYear,
                                wa_number: "$waNmbrCountryCode,${removeZeroFromNumber(
                                    whatsAppNbrController.text.toString())}",
                                car_type: widget.carDetails['car_type'],
                                latLng: addressLatLng,
                                location: selectLocationController.text
                                    .toString(),
                                vinNumber: vinNumberController.text.toString()
                            );

                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        label: 'SAVE CHANGES',
                      ),
                    )
                  ],
                ),
              );
            },);
          }
          return Container();
        },),
    );
  }

  ///////////////////////////////////////

  ///////////////////////////////////////
  updateGear(val, void Function(void Function()) setState) {
    setState(() {
      gear = val;
    });
  }

  showGearDialogF(void Function(void Function()) setState) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Gear'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoListTile(
                onTap: () {
                  updateGear('Auto', setState);
                  Navigator.pop(context);
                },
                title: const Text('Auto'),
              ),
              const SizedBox(height: 1, child: Divider()),
              CupertinoListTile(
                onTap: () {
                  updateGear('Manual', setState);
                  Navigator.pop(context);
                },
                title: const Text('Manual'),
              ),
              const SizedBox(height: 1, child: Divider()),
            ],
          ),
          insetAnimationCurve: Curves.slowMiddle,
          insetAnimationDuration: const Duration(seconds: 2),
        );
      },
    );
  }

  ///////////////////////////////////////
  ///////////////////////////////////////
  // showSpeedDialogF() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(builder: (BuildContext context, setState) {
  //         return AlertDialog(
  //           backgroundColor: Colors.white,
  //           title: const Text('Mileage'),
  //           content: TextField(
  //             controller: speedController,
  //           ),
  //           actions: [
  //             TextButton(
  //                 onPressed: () {
  //                   updateSpeedF(speedController.text.isEmpty
  //                       ? '00'
  //                       : speedController.text);
  //                   Navigator.pop(context);
  //                 },
  //                 child: const Text('Save'))
  //           ],
  //         );
  //       });
  //     },
  //   );
  // }

  showSpeedDialogF(void Function(void Function()) setState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return AlertDialog(
            surfaceTintColor: Colors.white,
            title: const Text('Mileage'),
            content: TextField(
              controller: speedController,
              keyboardType: TextInputType.number,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    updateSpeedF(speedController.text.isEmpty
                        ? '00'
                        : speedController.text, setState);
                    Navigator.pop(context);
                  },
                  child: const Text('Save'))
            ],
          );
        });
      },
    );
  }

  updateSpeedF(val, void Function(void Function()) setState) {
    setState(() {
      speed = val;
    });
  }

  ///////////////////////////////////////

  ///////////////////////////////////////
  showCylDialogF(void Function(void Function()) setState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, innerSetState) {
          return CupertinoAlertDialog(
            title: const Text('Pick Color'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: colors
                  .asMap()
                  .entries
                  .map((e) {
                return Column(
                  children: [
                    _colorTile(colorNames[e.key], e.value, setState, e.key),
                    const SizedBox(height: 1, child: Divider()),
                  ],
                );
              },).toList(),
            ),
            insetAnimationCurve: Curves.slowMiddle,
            insetAnimationDuration: const Duration(seconds: 2),
          );
        });
      },
    );
  }

  updateCylF(int val, void Function(void Function()) setState) {
    setState(() {
      colorIndex = val;
    });
  }

  Widget _colorTile(String title, Color color,
      void Function(void Function()) setState, int index) {
    return CupertinoListTile(
      onTap: () {
        updateCylF(index, setState);
        Navigator.pop(context);
      },
      title: Text(title),
      leading: CircleAvatar(
        backgroundColor: color,
        radius: 10,
      ),
    );
  }

  ///////////////////////////////////////
  ///////////////////////////////////////
  updateClimateF(val, void Function(void Function()) setState) {
    setState(() {
      climate = val;
    });
  }

  showClimateF(void Function(void Function()) setState) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return CupertinoAlertDialog(
            title: const Text('Warranty'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoListTile(
                  onTap: () {
                    updateClimateF('Under Warranty', setState);
                    Navigator.pop(context);
                  },
                  title: const Text('Under Warranty'),
                ),
                const SizedBox(height: 1, child: Divider()),
                CupertinoListTile(
                  onTap: () {
                    updateClimateF('Not Available', setState);
                    Navigator.pop(context);
                  },
                  title: const Text('Not Availble'),
                ),
                const SizedBox(height: 1, child: Divider()),
              ],
            ),
            insetAnimationCurve: Curves.slowMiddle,
            insetAnimationDuration: const Duration(seconds: 2),
          );
        });
      },
    );
  }

  ///////////////////////////////////////
  ///////////////////////////////////////
  updateFuelF(val, void Function(void Function()) setState) {
    setState(() {
      fuel = val;
    });
  }

  showFuelF(void Function(void Function()) setState) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return CupertinoAlertDialog(
            title: const Text('Climate Control'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoListTile(
                  onTap: () {
                    updateFuelF('Single', setState);
                    Navigator.pop(context);
                  },
                  title: const Text('Single'),
                ),
                const SizedBox(height: 1, child: Divider()),
                CupertinoListTile(
                  onTap: () {
                    updateFuelF('Gasoline (Petrol)', setState);
                    Navigator.pop(context);
                  },
                  title: const Text('Gasoline (Petrol)'),
                ),
                const SizedBox(height: 1, child: Divider()),
                CupertinoListTile(
                  onTap: () {
                    updateFuelF('Diesel', setState);
                    Navigator.pop(context);
                  },
                  title: const Text('Diesel'),
                ),
                const SizedBox(height: 1, child: Divider()),
                CupertinoListTile(
                  onTap: () {
                    updateFuelF('Hybrid', setState);
                    Navigator.pop(context);
                  },
                  title: const Text('Hybrid'),
                ),
                const SizedBox(height: 1, child: Divider()),
                CupertinoListTile(
                  onTap: () {
                    updateFuelF('Electric', setState);
                    Navigator.pop(context);
                  },
                  title: const Text('Electric'),
                ),
                const SizedBox(height: 1, child: Divider()),
                CupertinoListTile(
                  onTap: () {
                    updateFuelF('Flex Fuel', setState);
                    Navigator.pop(context);
                  },
                  title: const Text('Flex Fuel'),
                ),
                const SizedBox(height: 1, child: Divider()),
                SizedBox(height: 10,),

                CupertinoTextField(
                  controller: fuelController,
                  placeholder: 'Enter Custom Fuel',
                  keyboardType: TextInputType.text,
                  onEditingComplete: () {
                    updateFuelF(fuelController.text, setState);
                    Navigator.pop(context);
                  },
                  decoration: BoxDecoration(
                      color: Colors.white70
                  ),
                ),
              ],
            ),
            insetAnimationCurve: Curves.slowMiddle,
            insetAnimationDuration: const Duration(seconds: 2),
          );
        });
      },
    );
  }

  ///////////////////////////////////////
  ///////////////////////////////////////
  updateSeatsF(val, void Function(void Function()) setState) {
    setState(() {
      seats = val;
    });
  }

  showSeatsF(void Function(void Function()) setState) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Climate Control'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoListTile(
                onTap: () {
                  updateSeatsF('Single', setState);
                  Navigator.pop(context);
                },
                title: const Text('Single'),
              ),
              const SizedBox(height: 1, child: Divider()),
              CupertinoListTile(
                onTap: () {
                  updateSeatsF('2', setState);
                  Navigator.pop(context);
                },
                title: const Text('2'),
              ),
              const SizedBox(height: 1, child: Divider()),
              CupertinoListTile(
                onTap: () {
                  updateSeatsF('4', setState);
                  Navigator.pop(context);
                },
                title: const Text('4'),
              ),
              const SizedBox(height: 1, child: Divider()),
              CupertinoListTile(
                onTap: () {
                  updateSeatsF('6', setState);
                  Navigator.pop(context);
                },
                title: const Text('6'),
              ),
              const SizedBox(height: 1, child: Divider()),
              CupertinoListTile(
                onTap: () {
                  updateSeatsF('8', setState);
                  Navigator.pop(context);
                },
                title: const Text('8'),
              ),
              const SizedBox(height: 1, child: Divider()),
              CupertinoListTile(
                onTap: () {
                  updateSeatsF('10', setState);
                  Navigator.pop(context);
                },
                title: const Text('10'),
              ),
              const SizedBox(height: 1, child: Divider()),
              CupertinoListTile(
                onTap: () {
                  updateSeatsF('12', setState);
                  Navigator.pop(context);
                },
                title: const Text('12'),
              ),
              const SizedBox(height: 1, child: Divider()),
              CupertinoListTile(
                onTap: () {
                  updateSeatsF('14', setState);
                  Navigator.pop(context);
                },
                title: const Text('14'),
              ),
              const SizedBox(height: 1, child: Divider()),
            ],
          ),
          insetAnimationCurve: Curves.slowMiddle,
          insetAnimationDuration: const Duration(seconds: 2),
        );
      },
    );
  }

///////////////////////////////////////

}
