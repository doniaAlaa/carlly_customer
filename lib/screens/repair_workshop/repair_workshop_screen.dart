import 'package:carsilla/models/workshop_services_model.dart';
import 'package:carsilla/screens/repair_workshop/repair_workshop_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/theme.dart';
import '../../providers/specification_provider.dart';
import '../../widgets/btn.dart';
import '../../widgets/headerwithimg.dart';
import '../../const/assets.dart';

class RepairWorkshopScreen extends StatefulWidget {
  const RepairWorkshopScreen({super.key});

  @override
  State<RepairWorkshopScreen> createState() => _RepairWorkshopScreenState();
}

class _RepairWorkshopScreenState extends State<RepairWorkshopScreen> {
  String? selectedEmirate;
  String? selectedCar;
  WorkshopServicesModel? selectedCarData;

  //String? selectedModel;
  String? selectedServiceDepartment;

  int? selectedBrandId;
  int? selectedServiceId;
  // String? selectedCity;

  List<String> emirates = [
    'Dubai',
    'Abu Dhabi',
    'Sharjah',
    'Ajman',
    'Ras Al Khaimah',
    'Fujairah',
    'Umm Al Quwain',
    'Al Ain'
  ];
  // List<String> serviceDepartments = [
  //   'Mechanics',
  //   'Electrical services',
  //   'Oil change',
  //   'Windshield replacement',
  //   'Car cooling system repair',
  //   'Wheel alignment and brake services',
  //   'Exhaust and radiator services'
  // ];
  // List serviceDept = [
  //   {
  //     "name": "Mechanics",
  //     "imageUrl":
  //         "https://toyotacreek.com/wp-content/uploads/2024/05/The-Importance-of-Wheel-Alignment-and-Balancing-Featured-Image.png",
  //   },
  //   {
  //     "name": "Electrical services",
  //     "imageUrl":
  //         "https://www.universitytirecenter.com/Files/Images/Service/Electrical.jpg",
  //   },
  //   {
  //     "name": "Oil change",
  //     "imageUrl":
  //         "https://toyotacreek.com/wp-content/uploads/2024/02/The-Science-Behind-When-and-How-Often-to-Change-engine-oil-in-Kilometers-Featured-Image.png",
  //   },
  //   {
  //     "name": "Windshield replacement",
  //     "imageUrl":
  //         "https://www.bakerglassinc.com/wp-content/uploads/2020/03/Smaller-Windshield-replacement1-1920w.jpg",
  //   },
  //   {
  //     "name": "Car cooling system repair",
  //     "imageUrl":
  //         "http://blog.napacanada.com/wp-content/uploads/2023/06/Car-Air-Conditioning-Climatisation-des-vehicules-1.jpg",
  //   },
  //   {
  //     "name": "Wheel alignment and brake services",
  //     "imageUrl":
  //         "https://toyotacreek.com/wp-content/uploads/2024/05/The-Importance-of-Wheel-Alignment-and-Balancing-Featured-Image.png",
  //   },
  //   {
  //     "name": "Exhaust and radiator services",
  //     "imageUrl":
  //         "https://www.parkmuffler.com/wp-content/uploads/2019/11/shutterstock_1812125107-870x580.jpg",
  //   }
  // ];

  List<WorkshopServicesModel> serviceDept = [];

  @override
  void initState() {
    super.initState();
    //SpecificationProvider.getCarManufacturers();
    serviceDept = SpecificationProvider.workshopServices;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    List<DropdownMenuItem<WorkshopServicesModel>> serviceDropdownItems = SpecificationProvider.carsModel.map((cars) {
      return DropdownMenuItem(
        value: cars,
        child: Text(cars.name??''),
      );
    }).toList();
    return Scaffold(
      body: HeaderWithImage(
        // title: 'Car Repair Workshops',
        title: 'Car Workshops',
        headeimg: ImageAssets.workshop,
        marginToTopHeadeImg: 0.0,
        marginbodyfrombottom: 0.06,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.02),
              Row(
                children: [
                  Text('Choose Your City',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: MainTheme.primaryColor)),
                ],
              ),
              SizedBox(height: size.height * 0.01),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    border: Border.all(width: 0.8, color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedEmirate,
                  hint: const Text('Select City'),
                  underline: Container(),
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
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedEmirate = newValue;
                    });
                  },
                  items: emirates.map((String emirate) {
                    return DropdownMenuItem<String>(
                      value: emirate,
                      child: Text(emirate),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Row(
                children: [
                  Text('Choose Your Car',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: MainTheme.primaryColor)),
                ],
              ),
              SizedBox(height: size.height * 0.01),
              // Container(
              //   decoration: BoxDecoration(
              //       border: Border.all(width: 0.8, color: Colors.grey.shade400),
              //       borderRadius: BorderRadius.circular(10)),
              //   child: ButtonTheme(
              //     alignedDropdown: true,
              //     child: DropdownButton<String>(
              //       isExpanded: true,
              //       value: selectedCar,
              //       hint: const Text('Select Car'),
              //       underline: Container(),
              //       icon: Align(
              //         alignment: Alignment.centerRight,
              //         child: Transform.rotate(
              //             angle: 4.7,
              //             child: Padding(
              //               padding: const EdgeInsets.only(left: 3.0),
              //               child: Icon(
              //                 Icons.arrow_back_ios_outlined,
              //                 color: Colors.grey.shade500,
              //                 size: 15,
              //               ),
              //             )),
              //       ),
              //       style: const TextStyle(fontSize: 14, color: Colors.black),
              //       onChanged: (String? newValue) async {
              //         await SpecificationProvider.getModels(newValue!);
              //         setState(() {
              //           selectedCar = newValue;
              //           // selectedModel = null;
              //         });
              //       },
              //       items: SpecificationProvider.carNames.map((String car) {
              //         return DropdownMenuItem<String>(
              //           value: car,
              //           child: Text(car),
              //         );
              //       }).toList(),
              //
              //
              //     ),
              //   ),
              // ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 0.8, color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(10)),
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<WorkshopServicesModel>(
                    isExpanded: true,
                      icon: Align(
                                alignment: Alignment.centerRight,
                                child: Transform.rotate(
                                    angle: 4.7,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 6.0,right: 6),
                                      child: Icon(
                                        Icons.arrow_back_ios_outlined,
                                        color: Colors.grey.shade500,
                                        size: 15,
                                      ),
                                    )),
                              ),
                    underline: Container(),
                    value: selectedCarData,
                     hint: const Text('Select Car'),
                    items: serviceDropdownItems,
                    style: const TextStyle(fontSize: 14, color: Colors.black),

                    onChanged: (value) async{
                      await SpecificationProvider.getModels(value?.name??'');
                              setState(() {
                                selectedCar = value?.name;
                                selectedCarData = value;
                              });
                              selectedBrandId = value?.id??0;


                    },
                  )

                ),
              ),
              SizedBox(height: size.height * 0.02),
              // Row(
              //   children: [
              //     Text('Choose Your Car Model',
              //         style: Theme.of(context).textTheme.titleSmall!.copyWith(
              //             fontSize: 13,
              //             fontWeight: FontWeight.w500,
              //             color: MainTheme.primaryColor)),
              //   ],
              // ),
              // SizedBox(height: size.height * 0.01),
              // Container(
              //   decoration: BoxDecoration(
              //       border: Border.all(width: 0.8, color: Colors.grey.shade400),
              //       borderRadius: BorderRadius.circular(10)),
              //   child: ButtonTheme(
              //     alignedDropdown: true,
              //     child: DropdownButton<String>(
              //       isExpanded: true,
              //       value: selectedModel,
              //       hint: const Text('Select Model'),
              //       underline: Container(),
              //       icon: Align(
              //         alignment: Alignment.centerRight,
              //         child: Transform.rotate(
              //             angle: 4.7,
              //             child: Padding(
              //               padding: const EdgeInsets.only(left: 3.0),
              //               child: Icon(
              //                 Icons.arrow_back_ios_outlined,
              //                 color: Colors.grey.shade500,
              //                 size: 15,
              //               ),
              //             )),
              //       ),
              //       style: const TextStyle(fontSize: 14, color: Colors.black),
              //       onChanged: (String? newValue) {
              //         setState(() {
              //           selectedModel = newValue;
              //         });
              //       },
              //       items: selectedCar != null
              //           ? SpecificationProvider.modelsByCar.map((String model) {
              //               return DropdownMenuItem<String>(
              //                 value: model,
              //                 child: Text(model),
              //               );
              //             }).toList()
              //           : [],
              //     ),
              //   ),
              // ),
              //SizedBox(height: size.height * 0.02),
              Row(
                children: [
                  Text('Choose a Service',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: MainTheme.primaryColor)),
                ],
              ),
              SizedBox(height: size.height * 0.01),

              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 4.0,
                  runSpacing: 8.0,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: serviceDept.map((e) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedServiceDepartment = e.name;
                        });
                        selectedServiceId = e.id??0;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: (selectedServiceDepartment == e.name)
                              ? MainTheme.primaryColor
                              : Colors.white.withOpacity(0.25),
                        ),
                        height: 90,
                        width: MediaQuery.of(context).size.width / 3.5,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 50,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(e.image??''),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // Image(
                                //   image: NetworkImage(e['imageUrl']),
                                //   height: 50,
                                //   width: 60,
                                // ),
                                Text(
                                  e.name??'',
                                  style: const TextStyle(fontSize: 10),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: size.height * 0.02),
              MainButton(
                width: 0.9,
                onclick: () {
                  if (selectedEmirate == null ||
                      selectedCar == null ||
                      selectedServiceDepartment == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              const Text('Please select all required fields')),
                    );
                  } else {
                    // Navigate to the next screen or perform the search
                    // For example:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RepairWorkshopViewScreen(
                                  selectedEmirate: selectedEmirate ?? '',
                                  selectedCar: selectedCar ?? '',
                                  selectedServiceDepartment:selectedServiceDepartment ?? '',
                                  selectedBrandId: selectedBrandId??0,
                                  selectedServiceId: selectedServiceId??0,
                                )));
                  }
                },
                label: 'Search',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//  Container(
//                 decoration: BoxDecoration(
//                     border: Border.all(width: 0.8, color: Colors.grey.shade400),
//                     borderRadius: BorderRadius.circular(10)),
//                 child: DropdownButton<String>(
//                   isExpanded: true,
//                   value: selectedServiceDepartment,
//                   hint: const Text('Select Service Department'),
//                   underline: Container(),
//                   icon: Align(
//                     alignment: Alignment.centerRight,
//                     child: Transform.rotate(
//                         angle: 4.7,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 3.0),
//                           child: Icon(
//                             Icons.arrow_back_ios_outlined,
//                             color: Colors.grey.shade500,
//                             size: 15,
//                           ),
//                         )),
//                   ),
//                   style: const TextStyle(fontSize: 14, color: Colors.black),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       selectedServiceDepartment = newValue;
//                     });
//                   },
//                   items: serviceDepartments.map((String department) {
//                     return DropdownMenuItem<String>(
//                       value: department,
//                       child: Text(department),
//                     );
//                   }).toList(),
//                 ),
//               ),