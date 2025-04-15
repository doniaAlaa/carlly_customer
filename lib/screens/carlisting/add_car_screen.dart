import 'dart:io';

import 'package:carsilla/const/assets.dart';
import 'package:carsilla/providers/user_provider.dart';
import 'package:carsilla/utils/theme.dart';
import '../../utils/ui_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:faabul_color_picker/faabul_color_picker.dart';
import '../../const/common_methods.dart';
import '../../globel_by_callofcoding.dart';
import '../../resources/user_data.dart';
import '../../providers/specification_provider.dart';
import '../../widgets/btn.dart';
import '../../widgets/header.dart';
import '../../widgets/textfeild.dart';
import '../GoogleMap/select_location_form_map.dart';
import 'review_listed_car_details.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
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

  // added by callofcoding
  final contactNbrController = TextEditingController();
  final whatsAppNbrController = TextEditingController();
  final vinNumberController = TextEditingController();


  // whatsApp country code
  String waNmbrCountryCode = "+971";
  // contact number country code
  String conNmbrCountryCode = "+971";


  List<XFile> imagesList = [];
  List featuresList = [];
  List<String> cities = ['Dubai', 'Abu Dhabi', 'Sharjah', 'Ras Al Khaimah', 'Fujairah', 'Ajman', 'Umm Al Quwain', 'Al Ain'];
  String? selectedCity;

  String gear = 'Select';
  String speed = 'Select';
  int colorIndex = 3;
  String climate = 'Select';
  String fuel = 'Select';
  String seats = 'Select';
  //String selectedType = 'Used';

////////////
  String? selectedCar;
  String? selectedModel;
  String? selectedYear;
  String? selectedBody;
  String? selectedRegion;

////////////

  //location data
/////////////

  LatLng? addressLatLng;


  List<String> Cars = SpecificationProvider.carNames;

  LatLngProvider? latLngProvider;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    latLngProvider =  context.read<LatLngProvider>();
    super.didChangeDependencies();
  }


  @override
  void initState() {
    // TODO: implement initState
    String phoneNumber = context.read<UserProvider>().getCurrentUser?.phone ?? '';
    contactNbrController.text = removeCountryCode(phoneNumber);
    whatsAppNbrController.text = removeCountryCode(phoneNumber);
    getData();

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
    super.initState();
  }


  @override
  void dispose() {
    latLngProvider!.disposeVariables();
    // TODO: implement dispose
    super.dispose();
  }
  getData() async {
    await SpecificationProvider.getBrands();
    await SpecificationProvider.getBodyPart();
    await SpecificationProvider.getRegions();
  }

  @override
  Widget build(BuildContext context) {
    typecontroller.text = 'Car';
    modelcontroller.text = 'X4';
    yearcontroller.text = '2016';

    Size size = getMediaSize(context);

    return Header(
      enableBackButton: true,
      title: 'Add Your Car',
      body: Padding(
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
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: MainTheme.primaryColor),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                if(imagesList.length < 5){
                  await ImagePicker()
                       .pickMultiImage(imageQuality: 40).then((image) {
                    if (image.isNotEmpty) {

                      int elementsToAdd = image.length >= 5 ? 5 : image.length;

                      for (int i = 0; i < elementsToAdd; i++) {
                        imagesList.add(image[i]);
                      }
                      setState(() {
                      });
                    }
                       },);
                }else{
                  UiUtils(context).showSnackBar( "Image limit exceed.");
                }
                
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.25 / 1,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(13),
                    image: imagesList.isNotEmpty
                        ? DecorationImage(
                            image: FileImage(File(imagesList.last.path)),
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

            imagesList.isNotEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1 / 1,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      controller: ScrollController(),
                      itemCount: imagesList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              imagesList.removeAt(index);
                              setState(() {});
                            },
                            child: Badge(
                              label: const Icon(
                                Icons.delete_outlined,
                                color: Colors.white,
                                size: 13,
                              ),
                              child: Container(
                                width:
                                    MediaQuery.of(context).size.width * 0.2 / 1,
                                height:
                                    MediaQuery.of(context).size.height * 0.1 / 1,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.5,
                                        color: MainTheme.primaryColor)),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Image.file(File(imagesList[index].path),
                                      width: MediaQuery.of(context).size.width *
                                          0.2 /
                                          1,
                                      height: MediaQuery.of(context).size.height *
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
                  )
                : const SizedBox(height: 0),

            // SizedBox(height: MediaQuery.of(context).size.height * 0.02 / 1),
            // Row(
            //   children: [
            //     Text('Choose Your Vehicle',
            //         style: textTheme.titleSmall!.copyWith(
            //             fontSize: 13,
            //             fontWeight: FontWeight.w500,
            //             color: MainTheme.primaryColor)),
            //   ],
            // ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01 / 1),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01 / 1),
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
                              Border.all(width: 0.8, color: Colors.grey.shade400),
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
                                      padding: const EdgeInsets.only(left: 3.0),
                                      child: Icon(
                                        Icons.arrow_back_ios_outlined,
                                        color: Colors.grey.shade500,
                                        size: 15,
                                      ),
                                    )),
                              ),
                              onChanged: (String? newValue) async {
                                await SpecificationProvider.getModels(newValue!);
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
                        width: MediaQuery.of(context).size.width * 0.47 / 1,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('MODEL',
                                  style: textTheme.labelSmall!.copyWith(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade600)),
                              Container(

                                  width: MediaQuery.of(context).size.width *
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
                                            hint: const Text(
                                                'Model'),
                                            underline: Container(),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                            icon: Transform.rotate(
                                                angle: 4.7,
                                                child: Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 3.0),
                                                    child:
                                                    Icon(Icons.arrow_back_ios_outlined,
                                                        color: Colors
                                                            .grey
                                                            .shade500,
                                                        size: 17))),
                                            onChanged:
                                                (String? newValue) async {
                                              await SpecificationProvider.getYears(newValue!);
                                              setState(() {
                                                selectedModel = newValue;
                                                selectedYear = null;
                                              });
                                            },
                                            items: selectedCar != null
                                                ? SpecificationProvider
                                                .modelsByCar
                                                ?.map((String model) {
                                              return DropdownMenuItem<
                                                  String>(
                                                  value: model,
                                                  child: Text(
                                                      model));
                                            }).toList() ??
                                                []
                                                : []),
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
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    underline: Container(),
                                    value: selectedYear,
                                    hint: const Text(' Year'),
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedYear = newValue;
                                      });
                                    },
                                    icon: Transform.rotate(
                                        angle: 4.7,
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 3.0),
                                            child: Icon(
                                                Icons
                                                    .arrow_back_ios_outlined,
                                                color: Colors.grey.shade500,
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.01 / 1),
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
                width: MediaQuery.of(context).size.width * 0.98 / 1,
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
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                        icon: Align(
                          alignment: Alignment.centerRight,
                          child: Transform.rotate(
                              angle: 4.7,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: Icon(
                                  Icons.arrow_back_ios_outlined,
                                  color: Colors.grey.shade500,
                                  size: 15,
                                ),
                              )),
                        ),
                        onChanged: (String? newValue) async{
                          await SpecificationProvider.getRegions();
                          setState(() {
                            selectedBody = newValue;
                          });
                        },
                        items: SpecificationProvider.bodyParts.map((String sparepart) {
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
                width: MediaQuery.of(context).size.width * 0.98 / 1,
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
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                        icon: Align(
                          alignment: Alignment.centerRight,
                          child: Transform.rotate(
                              angle: 4.7,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 3.0),
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
                        items: SpecificationProvider.regions.map((String sparepart) {
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
                width: MediaQuery.of(context).size.width * 0.98 / 1,
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
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                        icon: Align(
                          alignment: Alignment.centerRight,
                          child: Transform.rotate(
                              angle: 4.7,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 3.0),
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
                      if (featuresController.text.trim().isNotEmpty) {
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
                    height: MediaQuery.of(context).size.height * 0.07 / 1,
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: ScrollController(),
                      scrollDirection: Axis.horizontal,
                      itemCount: featuresList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Opacity(
                          opacity: 0.5,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
              hintText: 'Vin number',
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
                  showGearDialogF();
                },
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  width: MediaQuery.of(context).size.width * 0.46 / 1,
                  child: ListTile(
                    leading: Image.asset(IconAssets.features1),
                    title: Text('Gear',
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500)),
                    subtitle: Text(gear,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade900)),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showSpeedDialogF();
                },
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white),
                  width: MediaQuery.of(context).size.width *
                      0.46 /
                      1,
                  child: ListTile(
                    leading:
                    Image.asset(IconAssets.features2),
                    title: Text('Mileage',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500)),
                    subtitle: Text("$speed KM",
                        style: Theme.of(context)
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
                  showCylDialogF();
                  // showCylDialogF();
                },
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  width: MediaQuery.of(context).size.width * 0.46 / 1,
                  child: ListTile(
                    leading: Image.asset(IconAssets.features3),
                    title: Text('Color',
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500)),
                    subtitle: FaabulColorSample(color: colors[colorIndex], size: 10),
                    // subtitle: Text(cyl,
                    //     style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    //         fontWeight: FontWeight.w500,
                    //         color: Colors.grey.shade900)),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showClimateF();
                },
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  width: MediaQuery.of(context).size.width * 0.46 / 1,
                  child: ListTile(
                    leading: Image.asset(IconAssets.features4),
                    title: Text('Warranty',
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500)),
                    subtitle: Text(climate,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade900)),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showFuelF();
                },
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  width: MediaQuery.of(context).size.width * 0.46 / 1,
                  child: ListTile(
                    leading: Image.asset(IconAssets.features5),
                    title: Text('Fuel Type',
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500)),
                    subtitle: Text(fuel,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade900)),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showSeatsF();
                },
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  width: MediaQuery.of(context).size.width * 0.46 / 1,
                  child: ListTile(
                    leading: Image.asset(IconAssets.features6),
                    title: Text('Seats',
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500)),
                    subtitle: Text(seats,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade900)),
                  ),
                ),
              ),
            ]),
            /////////// added features from selection end
            SizedBox(height: MediaQuery.of(context).size.height * 0.015 / 1),
            CustomTextFormField(
              hintText: 'Name',
              controller: titleController,
            ),
            const SizedBox(height:10),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  height: size.width * 0.13,
                  width: MediaQuery.of(context).size.width * 0.28 / 1,
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
                      Image.asset('assets/images/uae_flag.png',height: 30,),
                      Text(conNmbrCountryCode,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,fontFamily: "Poppins"),)
                    ],
                  )
                  //TODO: comment by callofcoding
                ),
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
            const SizedBox(height:10),
            Row(
              children: [
                Container(
                    padding: EdgeInsets.all(8),
                    height: size.width * 0.13,
                    width: MediaQuery.of(context).size.width * 0.28 / 1,
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
                        Image.asset('assets/images/uae_flag.png',height: 30,),
                        Text(waNmbrCountryCode,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,fontFamily: "Poppins"),)
                      ],
                    )
                  //TODO: comment by callofcoding
                ),
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
            const SizedBox(height:10),
            CustomTextFormField(
              maxLines: 3,
              hintText: 'Description',
              controller: descriptionController,
            ),
            const SizedBox(height:10),
            CustomTextFormField(
              textInputType: TextInputType.number,
              hintText: 'Price',
              controller: priceController,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.015 / 1),
            Consumer<LatLngProvider>(builder: (BuildContext context, LatLngProvider value, Widget? child) {

              if(value.getAddress!=null){
                selectLocationController.text = value.getAddress??'';
              }
              addressLatLng = value.getLatLng;
                return CustomTextFormField(
                onTap: (){
                  print('called');
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SelectLocationFromMap(),));
                },
                textInputType: TextInputType.none,
                // enabled: false,
                hintText: 'Select Location',
                controller: selectLocationController,
              );

            },),
            SizedBox(height: MediaQuery.of(context).size.height * 0.015 / 1),
            SizedBox(
              width: double.infinity,
              child: MainButton(
                width: 0.9,
                onclick: () async {
                  print("$waNmbrCountryCode,${whatsAppNbrController.text.toString()}");
                  print('${removeZeroFromNumber(whatsAppNbrController.text.toString())}');
                  if(imagesList.isEmpty){
                    UiUtils(context).showSnackBar( 'Choose Images');
                  }else if (selectedCar!.isEmpty) {
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
                  } else if (vinNumberController.text.isEmpty) {
                    UiUtils(context).showSnackBar( 'Enter Vin Number');
                  }else if (titleController.text.isEmpty) {
                    UiUtils(context).showSnackBar( 'Enter Name');
                  } else if (contactNbrController.text.isEmpty){
                    UiUtils(context).showSnackBar( 'Enter Contact Number');
                  }else if (whatsAppNbrController.text.isEmpty){
                    UiUtils(context).showSnackBar( 'Enter WhatsApp Number');
                  }else if (priceController.text.isEmpty) {
                    UiUtils(context).showSnackBar( 'Enter Price');
                  } else if (gear == 'Select') {
                    UiUtils(context).showSnackBar( 'Choose Gear Features');
                  } else if (speed == 'Select') {
                    UiUtils(context).showSnackBar( 'Choose Speed Features');
                  } else if (colorIndex == 'Select') {
                    UiUtils(context).showSnackBar( 'Choose Cylinders Features');
                  } else if (gear == 'Select') {
                    UiUtils(context).showSnackBar('Choose Gear Feature');
                  } else if (fuel == 'Select') {
                    UiUtils(context).showSnackBar( 'Choose Fuel Features');
                  } else if (seats == 'Select') {
                    UiUtils(context).showSnackBar( 'Choose Seats Features');
                  }else if(addressLatLng == null && selectLocationController.text.isEmpty){
                    UiUtils(context).showSnackBar( 'Select Location');
                  } else {
                    // Provider.of<CarListingVmC>(context, listen: false)
                    //     .addCarListingDataVmF(context,
                    //         user_id:
                    //             await StorageClass.getuseridf() ?? 1.toString(),
                    //         // dealer_id: 'your_dealer_id_value',
                    //         // total_views: 'your_total_views_value',
                    //
                    //         listing_type: selectedCar ?? ' ',
                    //         listing_model: selectedModel ?? ' ',
                    //         listing_year: selectedYear ?? ' ',
                    //         listing_title: titleController.text ?? ' ',
                    //         listing_desc: descriptionController.text ?? '',
                    //
                    //             //'Something About This',
                    //         imagesList: imagesList,
                    //         listing_price: priceController.text ?? '00',
                    //         features_gear: gear,
                    //         features_speed: speed,
                    //         features_seats: seats,
                    //         features_door: seats,
                    //         features_fuel_type: fuel,
                    //         features_climate_zone: climate,
                    //         features_cylinders: cyl.toString(),
                    //         features_bluetooth: 'yes',
                    //         features_others: featuresList ?? ['Extra features']);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewListedCarDetails(
                          imagesList: imagesList,
                          car: selectedCar,
                          model: selectedModel,
                          year:  selectedYear,
                          region: selectedRegion,
                          bodyType: selectedBody,
                          city: selectedCity,
                          featuresList: featuresList,
                          whatsAppContact: "$waNmbrCountryCode,${removeZeroFromNumber(whatsAppNbrController.text.toString())}",
                          contactNumber : "$conNmbrCountryCode,${removeZeroFromNumber(contactNbrController.text.toString())}",
                          title: titleController.text ?? '',
                          type: typecontroller.text ?? '',
                          desc: descriptionController.text ?? '',
                          price: priceController.text ?? '',
                          image: imagesList.isNotEmpty ? imagesList[0].path.toString() : '',
                          gearF: gear,
                          speedF: speed,
                          cylF: colorIndex,
                          climatesF: climate,
                          fuelF: fuel,
                          seatsF: seats,
                          latLng: addressLatLng,
                          locationAddress: selectLocationController.text.toString(),
                          vinNumber: vinNumberController.text.toString(),
                        ),
                      ),
                    );

                  }
                },
                label: 'DONE',
              ),
            )
          ],
        ),
      ),
    );
  }

  ///////////////////////////////////////

  ///////////////////////////////////////
  updateGear(val) {
    setState(() {
      gear = val;
    });
  }

  showGearDialogF() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return CupertinoAlertDialog(
            title: const Text('Gear'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoListTile(
                  onTap: () {
                    updateGear('Auto');
                    Navigator.pop(context);
                  },
                  title: const Text('Auto'),
                ),
                const SizedBox(height: 1, child: Divider()),
                CupertinoListTile(
                  onTap: () {
                    updateGear('Manual');
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
        });
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

  showSpeedDialogF() {
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
                        : speedController.text);
                    Navigator.pop(context);
                  },
                  child: const Text('Save'))
            ],
          );
        });
      },
    );
  }

  updateSpeedF(val) {
    setState(() {
      speed = val;
    });
  }

  ///////////////////////////////////////

  ///////////////////////////////////////
  showCylDialogF() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return CupertinoAlertDialog(
            title: const Text('Pick Color'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: colors.asMap().entries.map((e) {
                return Column(
                  children: [
                    _colorTile(colorNames[e.key], e.value,e.key),
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

  updateCylF(int val) {
    setState(() {
      colorIndex = val;
    });
  }

  Widget _colorTile(String title, Color color,int index){
    return CupertinoListTile(
      onTap: () {
        updateCylF(index);
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
  updateClimateF(val) {
    setState(() {
      climate = val;
    });
  }

  showClimateF() {
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
                    updateClimateF('Under Warranty');
                    Navigator.pop(context);
                  },
                  title: const Text('Under Warranty'),
                ),
                const SizedBox(height: 1, child: Divider()),
                CupertinoListTile(
                  onTap: () {
                    updateClimateF('Not Available');
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
  updateFuelF(val) {
    setState(() {
      fuel = val;
    });
  }

  showFuelF() {
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
                    updateFuelF('Single');
                    Navigator.pop(context);
                  },
                  title: const Text('Single'),
                ),
                const SizedBox(height: 1, child: Divider()),
                CupertinoListTile(
                  onTap: () {
                    updateFuelF('Gasoline (Petrol)');
                    Navigator.pop(context);
                  },
                  title: const Text('Gasoline (Petrol)'),
                ),
                const SizedBox(height: 1, child: Divider()),
                CupertinoListTile(
                  onTap: () {
                    updateFuelF('Diesel');
                    Navigator.pop(context);
                  },
                  title: const Text('Diesel'),
                ),
                const SizedBox(height: 1, child: Divider()),
                CupertinoListTile(
                  onTap: () {
                    updateFuelF('Hybrid');
                    Navigator.pop(context);
                  },
                  title: const Text('Hybrid'),
                ),
                const SizedBox(height: 1, child: Divider()),
                CupertinoListTile(
                  onTap: () {
                    updateFuelF('Electric');
                    Navigator.pop(context);
                  },
                  title: const Text('Electric'),
                ),
                const SizedBox(height: 1, child: Divider()),
                CupertinoListTile(
                  onTap: () {
                    updateFuelF('Flex Fuel');
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
                  onEditingComplete: (){
                    updateFuelF(fuelController.text);
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
  updateSeatsF(val) {
    setState(() {
      seats = val;
    });
  }

  showSeatsF() {
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
                    updateSeatsF('Single');
                    Navigator.pop(context);
                  },
                  title: const Text('Single'),
                ),
                const SizedBox(height: 1, child: Divider()),
                CupertinoListTile(
                  onTap: () {
                    updateSeatsF('2');
                    Navigator.pop(context);
                  },
                  title: const Text('2'),
                ),
                const SizedBox(height: 1, child: Divider()),
                CupertinoListTile(
                  onTap: () {
                    updateSeatsF('4');
                    Navigator.pop(context);
                  },
                  title: const Text('4'),
                ),
                const SizedBox(height: 1, child: Divider()),
                CupertinoListTile(
                  onTap: () {
                    updateSeatsF('6');
                    Navigator.pop(context);
                  },
                  title: const Text('6'),
                ),
                const SizedBox(height: 1, child: Divider()),
                CupertinoListTile(
                  onTap: () {
                    updateSeatsF('8');
                    Navigator.pop(context);
                  },
                  title: const Text('8'),
                ),
                const SizedBox(height: 1, child: Divider()),
                CupertinoListTile(
                  onTap: () {
                    updateSeatsF('10');
                    Navigator.pop(context);
                  },
                  title: const Text('10'),
                ),
                const SizedBox(height: 1, child: Divider()),
                CupertinoListTile(
                  onTap: () {
                    updateSeatsF('12');
                    Navigator.pop(context);
                  },
                  title: const Text('12'),
                ),
                const SizedBox(height: 1, child: Divider()),
                CupertinoListTile(
                  onTap: () {
                    updateSeatsF('14');
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
        });
      },
    );
  }

  ///////////////////////////////////////
}
