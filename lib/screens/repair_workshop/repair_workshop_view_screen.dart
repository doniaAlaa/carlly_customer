import 'dart:io';

import 'package:carsilla/controllers/repair_workshop_view_screen_controller.dart';
import 'package:carsilla/models/workshops_model.dart';
import 'package:flutter/material.dart';
import 'package:carsilla/utils/theme.dart';
import 'package:carsilla/widgets/btn.dart';
import 'package:carsilla/widgets/header.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;


class RepairWorkshopViewScreen extends StatefulWidget {
  final String selectedEmirate;
  final String selectedCar;
  final String selectedServiceDepartment;
  final int selectedBrandId;
  final int selectedServiceId;

  const RepairWorkshopViewScreen({
    required this.selectedEmirate,
    required this.selectedCar,
    required this.selectedServiceDepartment,
    required this.selectedBrandId,
    required this.selectedServiceId,
    super.key,
  });

  @override
  _RepairWorkshopViewScreenState createState() =>
      _RepairWorkshopViewScreenState();
}

class _RepairWorkshopViewScreenState extends State<RepairWorkshopViewScreen> {
  bool isExpanded = true;

  // final List<Map<String, String>> nearbyWorkshops = [
  //   {
  //     'name': 'Dubai Auto Workshop',
  //     'location': 'Dubai',
  //     'address': '123 Main St, Dubai',
  //     'image': 'https://blog.bayiq.com/hubfs/shutterstock_138252137.jpg',
  //     'hours': 'Mon-Fri: 9am - 6pm',
  //   },
  //   {
  //     'name': 'Abu Dhabi Car Repair',
  //     'location': 'Abu Dhabi',
  //     'address': '456 Elm St, Abu Dhabi',
  //     'image': 'https://blog.bayiq.com/hubfs/shutterstock_138252137.jpg',
  //     'hours': 'Mon-Fri: 9am - 6pm',
  //   },
  //   {
  //     'name': 'Sharjah Vehicle Service',
  //     'location': 'Sharjah',
  //     'address': '789 Oak St, Sharjah',
  //     'image': 'https://blog.bayiq.com/hubfs/shutterstock_138252137.jpg',
  //     'hours': 'Mon-Fri: 9am - 6pm',
  //   },
  //   {
  //     'name': 'Ajman Auto Care',
  //     'location': 'Ajman',
  //     'address': '101 Pine St, Ajman',
  //     'image': 'https://blog.bayiq.com/hubfs/shutterstock_138252137.jpg',
  //     'hours': 'Mon-Fri: 9am - 6pm',
  //   },
  //   {
  //     'name': 'Ras Al Khaimah Repair Center',
  //     'location': 'Ras Al Khaimah',
  //     'address': '202 Maple St, Ras Al Khaimah',
  //     'image': 'https://blog.bayiq.com/hubfs/shutterstock_138252137.jpg',
  //     'hours': 'Mon-Fri: 9am - 6pm',
  //   },
  //   {
  //     'name': 'Fujairah Car Workshop',
  //     'location': 'Fujairah',
  //     'address': '303 Cedar St, Fujairah',
  //     'image': 'https://blog.bayiq.com/hubfs/shutterstock_138252137.jpg',
  //     'hours': 'Mon-Fri: 9am - 6pm',
  //   },
  //   {
  //     'name': 'Umm Al Quwain Auto Service',
  //     'location': 'Umm Al Quwain',
  //     'address': '404 Birch St, Umm Al Quwain',
  //     'image': 'https://blog.bayiq.com/hubfs/shutterstock_138252137.jpg',
  //     'hours': 'Mon-Fri: 9am - 6pm',
  //   },
  //   {
  //     'name': 'Al Ain Vehicle Repair',
  //     'location': 'Al Ain',
  //     'address': '505 Spruce St, Al Ain',
  //     'image': 'https://blog.bayiq.com/hubfs/shutterstock_138252137.jpg',
  //     'hours': 'Mon-Fri: 9am - 6pm',
  //   },
  // ];
  RepairWorkshopViewScreenController repairWorkshopViewScreenController = Get.put(RepairWorkshopViewScreenController());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Map<String,dynamic> data =
      {
        "city": widget.selectedEmirate,
        "category_id":widget.selectedServiceId,
        "brand_id":widget.selectedBrandId,
      };

    repairWorkshopViewScreenController.getWorkshopsData(context, data);
    return Header(
      enableBackButton: true,
      title: "Repair Workshop",
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: size.height * 0.02 / 1,
            ),
            widget.selectedCar == null || widget.selectedCar == ""
                ? Container()
                : ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ExpansionTile(
                      onExpansionChanged: (expanded) {
                        setState(() {
                          isExpanded = expanded;
                        });
                      },
                      initiallyExpanded: true,
                      title: Stack(
                        alignment: Alignment.center,
                        children: [
                          const SizedBox(
                              height: 1,
                              child: Divider(
                                color: Colors.black,
                              )),
                          Container(
                              alignment: Alignment.center,
                              width: 110,
                              color: Colors.white,
                              child: Text(
                                'Your Car',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: (isExpanded)
                                        ? MainTheme.primaryColor
                                        : Colors.black),
                              ))
                        ],
                      ),
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 14.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    'Car Type     :',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  // SizedBox(
                                  //   height: 16,
                                  // ),
                                  // Text('Car Model   :',
                                  //     style: TextStyle(
                                  //         fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text('City      :',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text('Service   :',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  //subcategory
                                  SizedBox(
                                    height: 16,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.25),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Text(widget.selectedCar
                                        .toString()
                                        .toUpperCase()),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),

                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.25),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Text(widget.selectedEmirate
                                        .toString()
                                        .toUpperCase()),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 200,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.25),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Text(
                                      widget.selectedServiceDepartment
                                          .toString()
                                          .toUpperCase(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
            SizedBox(height: size.height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Text(
                    'Nearby Repair Shop',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: MainTheme.primaryColor),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.01),
            ///////////////////////////////////////
            // Wrap(
            //   spacing: 8.0,
            //   runSpacing: 8.0,
            //   children: nearbyWorkshops.map((workshop) {
            //     return Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Container(
            //         // height: size.width * 0.8,
            //         width: size.width,
            //         decoration: BoxDecoration(
            //             color: Colors.black12,
            //             borderRadius: BorderRadius.circular(12)),
            //         child: GestureDetector(
            //           onTap: () {
            //             // Handle tap event
            //           },
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               ClipRRect(
            //                 borderRadius: BorderRadius.circular(12),
            //                 child: Image.network(
            //                   workshop['image']!,
            //                   width: MediaQuery.of(context).size.width * 0.9,
            //                   height: size.width * 0.48,
            //                   fit: BoxFit.cover,
            //                   errorBuilder: (context, error, stackTrace) =>
            //                       Image.asset('assets/images/carvector.png'),
            //                 ),
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.symmetric(horizontal: 8),
            //                 child: Column(
            //                   children: [
            //                     const SizedBox(height: 12),
            //                     Row(
            //                       children: [
            //                         Text(
            //                           workshop['name']!,
            //                           style: Theme.of(context)
            //                               .textTheme
            //                               .labelLarge!
            //                               .copyWith(
            //                               fontSize: 18,
            //                               color: MainTheme.primaryColor),
            //                         ),
            //                         Spacer(),
            //                         GestureDetector(
            //                           onTap: () {
            //                             // Handle location tap
            //                           },
            //                           child: SizedBox(
            //                             width: 80,
            //                             child: Row(
            //                               children: [
            //                                 const Icon(
            //                                   Icons.location_pin,
            //                                   color: MainTheme.primaryColor,
            //                                   size: 20,
            //                                 ),
            //                                 const SizedBox(width: 4),
            //                                 Expanded(
            //                                   child: Text(
            //                                     workshop['location']!,
            //                                     style: const TextStyle(
            //                                         fontSize: 14,
            //                                         color: Colors.black54),
            //                                     overflow: TextOverflow.ellipsis,
            //                                   ),
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                     const SizedBox(height: 4),
            //                     Row(
            //                       mainAxisAlignment: MainAxisAlignment.start,
            //                       children: [
            //                         Icon(
            //                           Icons.star,
            //                           color: MainTheme.primaryColor,
            //                           size: 20,
            //                         ),
            //                         const SizedBox(width: 4),
            //                         Text(
            //                           '4.5', // Dummy rating
            //                           style: const TextStyle(
            //                               fontSize: 14, color: Colors.black54),
            //                         ),
            //                       ],
            //                     ),
            //                     const SizedBox(height: 4),
            //                     Row(
            //                       children: [
            //                         const Icon(
            //                           Icons.location_on,
            //                           color: MainTheme.primaryColor,
            //                           size: 20,
            //                         ),
            //                         const SizedBox(width: 4),
            //                         Expanded(
            //                           child: Text(
            //                             workshop['address']!,
            //                             style: const TextStyle(
            //                                 fontSize: 14,
            //                                 color: Colors.black54),
            //                             overflow: TextOverflow.ellipsis,
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                     const SizedBox(height: 4),
            //                     Row(
            //                       children: [
            //                         const Icon(
            //                           Icons.access_time,
            //                           color: MainTheme.primaryColor,
            //                           size: 20,
            //                         ),
            //                         const SizedBox(width: 4),
            //                         Text(
            //                           workshop['hours']!,
            //                           style: const TextStyle(
            //                               fontSize: 14, color: Colors.black54),
            //                         ),
            //                       ],
            //                     ),
            //                     Padding(
            //                       padding: const EdgeInsets.all(8.0),
            //                       child: Row(
            //                         mainAxisAlignment:
            //                         MainAxisAlignment.spaceBetween,
            //                         children: [
            //                           GestureDetector(
            //                             onTap: () {
            //                               // Handle WhatsApp tap
            //                             },
            //                             child: Container(
            //                               height: 30,
            //                               padding: EdgeInsets.symmetric(
            //                                   horizontal: 12),
            //                               decoration: BoxDecoration(
            //                                   border: Border.all(
            //                                       color:
            //                                       MainTheme.primaryColor),
            //                                   borderRadius:
            //                                   BorderRadius.circular(16)),
            //                               child: Row(
            //                                 mainAxisAlignment:
            //                                 MainAxisAlignment.center,
            //                                 children: [
            //                                   Image.asset(
            //                                     'assets/images/whatsapp1.png',
            //                                     color: Colors.green.shade800,
            //                                     height: 17,
            //                                     width: 17,
            //                                   ),
            //                                   const SizedBox(width: 4),
            //                                   const Text(
            //                                     'WhatsApp',
            //                                     style: TextStyle(
            //                                         fontSize: 12,
            //                                         fontWeight:
            //                                         FontWeight.w500),
            //                                   ),
            //                                 ],
            //                               ),
            //                             ),
            //                           ),
            //                           GestureDetector(
            //                             onTap: () {
            //                               // Handle Call tap
            //                             },
            //                             child: Container(
            //                               height: 30,
            //                               padding: EdgeInsets.symmetric(
            //                                   horizontal: 12),
            //                               decoration: BoxDecoration(
            //                                   border: Border.all(
            //                                       color:
            //                                       MainTheme.primaryColor),
            //                                   borderRadius:
            //                                   BorderRadius.circular(16)),
            //                               child: const Row(
            //                                 mainAxisAlignment:
            //                                 MainAxisAlignment.center,
            //                                 children: [
            //                                   Icon(
            //                                     Icons.phone,
            //                                     color: MainTheme.primaryColor,
            //                                     size: 20,
            //                                   ),
            //                                   SizedBox(width: 4),
            //                                   Text(
            //                                     'Call',
            //                                     style: TextStyle(
            //                                         fontSize: 12,
            //                                         fontWeight:
            //                                         FontWeight.w500),
            //                                   ),
            //                                 ],
            //                               ),
            //                             ),
            //                           ),
            //                           GestureDetector(
            //                             onTap: () {
            //                               // Handle Share tap
            //                             },
            //                             child: Container(
            //                               height: 30,
            //                               padding: EdgeInsets.symmetric(
            //                                   horizontal: 12),
            //                               decoration: BoxDecoration(
            //                                   border: Border.all(
            //                                       color:
            //                                       MainTheme.primaryColor),
            //                                   borderRadius:
            //                                   BorderRadius.circular(16)),
            //                               child: const Row(
            //                                 mainAxisAlignment:
            //                                 MainAxisAlignment.center,
            //                                 children: [
            //                                   Icon(
            //                                     Icons.share,
            //                                     color: MainTheme.primaryColor,
            //                                     size: 18,
            //                                   ),
            //                                   SizedBox(width: 4),
            //                                   Text(
            //                                     'Share',
            //                                     style: TextStyle(
            //                                         fontSize: 12,
            //                                         fontWeight:
            //                                         FontWeight.w500),
            //                                   ),
            //                                 ],
            //                               ),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     );
            //   }).toList(),
            // ),

            ///////////////////////////////////////
            // Wrap(
            //   spacing: 8.0,
            //   runSpacing: 8.0,
            //   children: nearbyWorkshops.map((workshop) {
            //     return Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Container(
            //         // height: size.width * 0.8,
            //         width: size.width,
            //         decoration: BoxDecoration(
            //             color: Colors.black12,
            //             borderRadius: BorderRadius.circular(12)),
            //         child: GestureDetector(
            //           onTap: () {
            //             // Handle tap event
            //           },
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               ClipRRect(
            //                 borderRadius: BorderRadius.circular(12),
            //                 child: Image.network(
            //                   workshop['image']!,
            //                   width: MediaQuery.of(context).size.width * 0.9,
            //                   height: size.width * 0.48,
            //                   fit: BoxFit.cover,
            //                   errorBuilder: (context, error, stackTrace) =>
            //                       Image.asset('assets/images/carvector.png'),
            //                 ),
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.symmetric(horizontal: 8),
            //                 child: Column(
            //                   children: [
            //                     const SizedBox(height: 12),
            //                     Row(
            //                       children: [
            //                         Text(
            //                           workshop['name']!,
            //                           style: Theme.of(context)
            //                               .textTheme
            //                               .labelLarge!
            //                               .copyWith(
            //                                   fontSize: 18,
            //                                   color: MainTheme.primaryColor),
            //                         ),
            //                         Spacer(),
            //                         GestureDetector(
            //                           onTap: () {
            //                             // Handle location tap
            //                           },
            //                           child: SizedBox(
            //                             width: 80,
            //                             child: Row(
            //                               children: [
            //                                 const Icon(
            //                                   Icons.location_pin,
            //                                   color: MainTheme.primaryColor,
            //                                   size: 20,
            //                                 ),
            //                                 const SizedBox(width: 4),
            //                                 Expanded(
            //                                   child: Text(
            //                                     workshop['location']!,
            //                                     style: const TextStyle(
            //                                         fontSize: 14,
            //                                         color: Colors.black54),
            //                                     overflow: TextOverflow.ellipsis,
            //                                   ),
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                     const SizedBox(height: 4),
            //                     Row(
            //                       mainAxisAlignment: MainAxisAlignment.start,
            //                       children: [
            //                         Icon(
            //                           Icons.star,
            //                           color: MainTheme.primaryColor,
            //                           size: 20,
            //                         ),
            //                         const SizedBox(width: 4),
            //                         Text(
            //                           '4.5', // Dummy rating
            //                           style: const TextStyle(
            //                               fontSize: 14, color: Colors.black54),
            //                         ),
            //                       ],
            //                     ),
            //                     const SizedBox(height: 4),
            //                     Row(
            //                       children: [
            //                         const Icon(
            //                           Icons.location_on,
            //                           color: MainTheme.primaryColor,
            //                           size: 20,
            //                         ),
            //                         const SizedBox(width: 4),
            //                         Expanded(
            //                           child: Text(
            //                             workshop['address']!,
            //                             style: const TextStyle(
            //                                 fontSize: 14,
            //                                 color: Colors.black54),
            //                             overflow: TextOverflow.ellipsis,
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                     const SizedBox(height: 4),
            //                     Row(
            //                       children: [
            //                         const Icon(
            //                           Icons.access_time,
            //                           color: MainTheme.primaryColor,
            //                           size: 20,
            //                         ),
            //                         const SizedBox(width: 4),
            //                         Text(
            //                           workshop['hours']!,
            //                           style: const TextStyle(
            //                               fontSize: 14, color: Colors.black54),
            //                         ),
            //                       ],
            //                     ),
            //                     Padding(
            //                       padding: const EdgeInsets.all(8.0),
            //                       child: Row(
            //                         mainAxisAlignment:
            //                             MainAxisAlignment.spaceBetween,
            //                         children: [
            //                           GestureDetector(
            //                             onTap: () {
            //                               // Handle WhatsApp tap
            //                             },
            //                             child: Container(
            //                               height: 30,
            //                               padding: EdgeInsets.symmetric(
            //                                   horizontal: 12),
            //                               decoration: BoxDecoration(
            //                                   border: Border.all(
            //                                       color:
            //                                           MainTheme.primaryColor),
            //                                   borderRadius:
            //                                       BorderRadius.circular(16)),
            //                               child: Row(
            //                                 mainAxisAlignment:
            //                                     MainAxisAlignment.center,
            //                                 children: [
            //                                   Image.asset(
            //                                     'assets/images/whatsapp1.png',
            //                                     color: Colors.green.shade800,
            //                                     height: 17,
            //                                     width: 17,
            //                                   ),
            //                                   const SizedBox(width: 4),
            //                                   const Text(
            //                                     'WhatsApp',
            //                                     style: TextStyle(
            //                                         fontSize: 12,
            //                                         fontWeight:
            //                                             FontWeight.w500),
            //                                   ),
            //                                 ],
            //                               ),
            //                             ),
            //                           ),
            //                           GestureDetector(
            //                             onTap: () {
            //                               // Handle Call tap
            //                             },
            //                             child: Container(
            //                               height: 30,
            //                               padding: EdgeInsets.symmetric(
            //                                   horizontal: 12),
            //                               decoration: BoxDecoration(
            //                                   border: Border.all(
            //                                       color:
            //                                           MainTheme.primaryColor),
            //                                   borderRadius:
            //                                       BorderRadius.circular(16)),
            //                               child: const Row(
            //                                 mainAxisAlignment:
            //                                     MainAxisAlignment.center,
            //                                 children: [
            //                                   Icon(
            //                                     Icons.phone,
            //                                     color: MainTheme.primaryColor,
            //                                     size: 20,
            //                                   ),
            //                                   SizedBox(width: 4),
            //                                   Text(
            //                                     'Call',
            //                                     style: TextStyle(
            //                                         fontSize: 12,
            //                                         fontWeight:
            //                                             FontWeight.w500),
            //                                   ),
            //                                 ],
            //                               ),
            //                             ),
            //                           ),
            //                           GestureDetector(
            //                             onTap: () {
            //                               // Handle Share tap
            //                             },
            //                             child: Container(
            //                               height: 30,
            //                               padding: EdgeInsets.symmetric(
            //                                   horizontal: 12),
            //                               decoration: BoxDecoration(
            //                                   border: Border.all(
            //                                       color:
            //                                           MainTheme.primaryColor),
            //                                   borderRadius:
            //                                       BorderRadius.circular(16)),
            //                               child: const Row(
            //                                 mainAxisAlignment:
            //                                     MainAxisAlignment.center,
            //                                 children: [
            //                                   Icon(
            //                                     Icons.share,
            //                                     color: MainTheme.primaryColor,
            //                                     size: 18,
            //                                   ),
            //                                   SizedBox(width: 4),
            //                                   Text(
            //                                     'Share',
            //                                     style: TextStyle(
            //                                         fontSize: 12,
            //                                         fontWeight:
            //                                             FontWeight.w500),
            //                                   ),
            //                                 ],
            //                               ),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     );
            //   }).toList(),
            // ),
            Obx((){
              return repairWorkshopViewScreenController.loadingWorkshops.value?
                  CircularProgressIndicator():
              repairWorkshopViewScreenController.workshopsModel.isNotEmpty?
              ListView.builder(
                shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: repairWorkshopViewScreenController.workshopsModel.length,
                  itemBuilder: (context,index){
                    List<SelectedDays>? shopDays = repairWorkshopViewScreenController.workshopsModel[index].days;
                    WorkshopsModel workshopsModel = repairWorkshopViewScreenController.workshopsModel[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        // height: size.width * 0.8,
                        width: size.width,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(12)),
                        child: GestureDetector(
                          onTap: () {
                            // Handle tap event
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: repairWorkshopViewScreenController.workshopsModel[index].logo != null &&

                                    repairWorkshopViewScreenController.workshopsModel[index].images!.isNotEmpty?
                                    Image.network(
                                  // repairWorkshopViewScreenController.workshopsModel[index].logo??'',
                                  repairWorkshopViewScreenController.workshopsModel[index].images?[0]['image']??'',
                                  // width: MediaQuery.of(context).size.width * 0.9,
                                  width: MediaQuery.of(context).size.width ,
                                  height: size.width * 0.48,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        height: 140,
                                        decoration: BoxDecoration(
                                            border:Border(bottom: BorderSide(color: Colors.black))
                                        ),
                                        child: Center(child: Icon(Icons.warning_rounded,size: 90,)),)
                                )

                                    : Container(
                                    height: 140,
                                    decoration: BoxDecoration(

                                        border:Border(bottom: BorderSide(color: Colors.white,width: 2))
                                    ),
                                    child: Center(child: Image.asset('assets/images/no_image.png'))),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Text(
                                          // workshop['name']!,
                                          repairWorkshopViewScreenController.workshopsModel[index].workshop_name??'workshop name',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge!
                                              .copyWith(
                                              fontSize: 18,
                                              color: MainTheme.primaryColor),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            // Handle location tap
                                          },
                                          child: SizedBox(
                                            width: 80,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  Icons.location_pin,
                                                  color: MainTheme.primaryColor,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    repairWorkshopViewScreenController.workshopsModel[index].city??'city',

                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black54),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: MainTheme.primaryColor,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '4.5', // Dummy rating
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: MainTheme.primaryColor,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            // workshop['address']!,
                                            repairWorkshopViewScreenController.workshopsModel[index].location??'location',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // const SizedBox(height: 4),
                                    shopDays != null &&
                                        shopDays!.isNotEmpty?
                                    InkWell(
                                      onTap: (){
                                        if(shopDays!.length > 1) {
                                          repairWorkshopViewScreenController.selectedIndex.value = index ;
                                          repairWorkshopViewScreenController.openDays.value = !repairWorkshopViewScreenController.openDays.value ;
                                        }
                                      },
                                      child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            const Icon(
                                              Icons.access_time,
                                              color: MainTheme.primaryColor,
                                              size: 20,
                                            ),
                                            SizedBox(width: 4),
                                            Container(
                                              // width:190,
                                              child: Text(
                                                // workshop['hours']!,
                                                '${shopDays[0].day}:${shopDays[0].from} to ${shopDays[0].to}',
                                                style: const TextStyle(
                                                    fontSize: 14, color: Colors.black54),
                                              ),
                                            ),
                                            SizedBox(width: 12,),
                                            shopDays.length > 1?
                                            Obx((){
                                              return Icon(repairWorkshopViewScreenController.openDays.value? Icons.keyboard_arrow_up_rounded:Icons.keyboard_arrow_down);
                                            })

                                                :Container()

                                          ],
                                        ),
                                    ):Container(),
                                    Obx((){

                                      List<SelectedDays>? days = shopDays!.skip(1).toList();

                                      return
                                        repairWorkshopViewScreenController.selectedIndex.value == index &&
                                      repairWorkshopViewScreenController.openDays.value == true  ?
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: days.length,
                                          itemBuilder: (context,indexx){

                                            return Row(
                                              children: [
                                                const Icon(
                                                  Icons.access_time,
                                                  color: MainTheme.primaryColor,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  // workshop['hours']!,
                                                  '${days[indexx].day}:${days[indexx].from} to ${days[indexx].to}',
                                                  // '${repairWorkshopViewScreenController.workshopsModel[index].days?[indexx].day}:${repairWorkshopViewScreenController.workshopsModel[index].days?[indexx].from} to ${repairWorkshopViewScreenController.workshopsModel[indexx].days?[0].to}',
                                                  style: const TextStyle(
                                                      fontSize: 14, color: Colors.black54),
                                                ),
                                              ],
                                            );
                                          }):Container();
                                    }),
                                    SizedBox(height: 8,),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              // Handle WhatsApp tap
                                              // launchUrlString('${repairWorkshopViewScreenController.workshopsModel[index].phone}');
                                              launchUrlString('https://wa.me/${repairWorkshopViewScreenController.workshopsModel[index].whatsapp_number}');

                                            },
                                            child: Container(
                                              height: 30,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                      MainTheme.primaryColor),
                                                  borderRadius:
                                                  BorderRadius.circular(16)),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'assets/images/whatsapp1.png',
                                                    color: Colors.green.shade800,
                                                    height: 17,
                                                    width: 17,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  const Text(
                                                    'WhatsApp',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              // Handle Call tap
                                              launchUrlString('tel:${repairWorkshopViewScreenController.workshopsModel[index].phone}');

                                            },
                                            child: Container(
                                              height: 30,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                      MainTheme.primaryColor),
                                                  borderRadius:
                                                  BorderRadius.circular(16)),
                                              child: const Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.phone,
                                                    color: MainTheme.primaryColor,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    'Call',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async{
                                              // Handle Share tap
                                              // final box = context.findRenderObject() as RenderBox?;
                                              print('uuuuuuuuuuuuuu');
                                              // repairWorkshopViewScreenController.workshopsModel[index].images?[0]['image'];
//                                               final uri = Uri.parse(repairWorkshopViewScreenController.workshopsModel[index].logo??'');
//                                               final response = await http.get(uri);
//                                               final bytes =  response.bodyBytes;
//                                               final temp =  await getTemporaryDirectory();
//                                               final file = File('${temp.path}/shared_workshop_image.jpg');
//
//                                               await file.writeAsBytes(bytes);
//                                               print(file.path);
// \                                              final result = await http.head(Uri.parse(repairWorkshopViewScreenController.workshopsModel[index].logo??''));
//                                               print(result.statusCode);

                                             if(repairWorkshopViewScreenController.workshopsModel[index].images!.isNotEmpty){
                                               final uri = Uri.parse(repairWorkshopViewScreenController.workshopsModel[index].images?[0]['image']??'');
                                              final response = await http.get(uri);
                                              final bytes =  response.bodyBytes;
                                              final temp =  await getTemporaryDirectory();
                                              final file = File('${temp.path}/shared_workshop_image.jpg');

                                              await file.writeAsBytes(bytes);
                                               Share.shareXFiles(
                                                 [XFile(file.path)],
                                                 text: 'workshop name : ${workshopsModel.workshop_name}\nphone : ${workshopsModel.phone}\nhttps://carllymotors.page.link/workshop',

                                               );

                                             }else{
                                               final byteData = await rootBundle.load('assets/images/no_image.png'); // asset path

                                               final tempDir = await getTemporaryDirectory();
                                               final file = File('${tempDir.path}/no_image.png');
                                               await file.writeAsBytes(byteData.buffer.asUint8List());

                                               Share.shareXFiles(
                                                 [XFile(file.path)],
                                                 text: 'workshop name : ${workshopsModel.workshop_name}\nphone : ${workshopsModel.phone}\nhttps://carllymotors.page.link/workshop',

                                               );

                                             }



                                            },
                                            child: Container(
                                              height: 30,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                      MainTheme.primaryColor),
                                                  borderRadius:
                                                  BorderRadius.circular(16)),
                                              child: const Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.share,
                                                    color: MainTheme.primaryColor,
                                                    size: 18,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    'Share',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }):
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Text('There Is No Data',style: TextStyle(fontSize: 16),),
              );
            })

          ],
        ),
      ),
    );
  }
}
