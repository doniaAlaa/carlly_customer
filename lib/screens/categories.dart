import 'package:carsilla/screens/repair_workshop/repair_workshop_screen.dart';
import 'package:carsilla/screens/spareparts/search_spare_part_screen.dart';
import 'package:flutter/material.dart';

import '../const/assets.dart';
import '../utils/theme.dart';
import '../widgets/bottomnavbar.dart';
import '../widgets/header.dart';
import 'carlisting/search_car_screen.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List servicesList = [
    // {
    //   "icon": IconAssets.menu1,
    //   "title": "Workshop",
    // },
    // {
    //   "icon": IconAssets.menu2,
    //   "title": "Roadside \nAssitance",
    // },
    // {
    //   "icon": IconAssets.menu3,
    //   "title": "Car \nInsurance",
    // },
    {
      "icon": IconAssets.menu4,
      "title": "Spare Parts",
    },
    // {
    //   "icon": IconAssets.menu5,
    //   "title": "Vehicle \nTransportat",
    // },
    {
      "icon": IconAssets.menu6,
      "title": "Car Listing",
    },
    {
      "icon": IconAssets.repairWorkshop,
      "title": "Repair Workshop",
    },

    {
      "title": "Soon",
    },
  ];

  var selectedservice;

  @override
  Widget build(BuildContext context) {
    return Header(
      enableBackButton: false,
      title: 'Category',
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Categories",
                  textAlign: TextAlign.left,
                  style: textTheme.titleSmall!.copyWith(
                      color: MainTheme.primaryColor,
                      fontWeight: FontWeight.w500),
                ),
                // Text(
                //   "See All",
                //   textAlign: TextAlign.left,
                //   style: textTheme.titleSmall!.copyWith(
                //       color: Colors.grey.shade700,
                //       fontWeight: FontWeight.w400),
                // ),
              ],
            ),
          ),
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 6),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedservice = 0;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SearchSparePartScreen()));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: selectedservice == 0
                        ? BoxDecoration(
                            color: MainTheme.primaryColor,
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(
                                color: Colors.grey.shade800, width: 1),
                            boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 0.7,
                                    offset: const Offset(0, 1))
                              ])
                        : BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(color: Colors.grey, width: 0),
                            boxShadow: [
                                BoxShadow(
                                    color:
                                        Colors.grey.shade300.withOpacity(0.8),
                                    blurRadius: 4,
                                    offset: const Offset(0, 7))
                              ]),
                    width: MediaQuery.of(context).size.width / 2.3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Center(
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.blue.shade200,
                              child: CircleAvatar(
                                  radius: 23,
                                  backgroundColor: selectedservice == 0
                                      ? Colors.white
                                      : Colors.grey.shade300,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Image.asset(IconAssets.menu4),
                                  )),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('Spare Parts',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                    color: selectedservice == 0
                                        ? Colors.white
                                        : Colors.grey.shade500,
                                    fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 6),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedservice = 1;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchCarScreen()));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: selectedservice == 1
                        ? BoxDecoration(
                            color: MainTheme.primaryColor,
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(
                                color: Colors.grey.shade800, width: 1),
                            boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 0.7,
                                    offset: const Offset(0, 1))
                              ])
                        : BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(color: Colors.grey, width: 0),
                            boxShadow: [
                                BoxShadow(
                                    color:
                                        Colors.grey.shade300.withOpacity(0.8),
                                    blurRadius: 4,
                                    offset: const Offset(0, 7))
                              ]),
                    width: MediaQuery.of(context).size.width / 2.3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Center(
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.blue.shade200,
                              child: CircleAvatar(
                                  radius: 23,
                                  backgroundColor: selectedservice == 1
                                      ? Colors.white
                                      : Colors.grey.shade300,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Image.asset(IconAssets.menu6),
                                  )),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('Car Listing',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                    color: selectedservice == 1
                                        ? Colors.white
                                        : Colors.grey.shade500,
                                    fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 6),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedservice = 2;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const RepairWorkshopScreen()));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: selectedservice == 2
                        ? BoxDecoration(
                            color: MainTheme.primaryColor,
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(
                                color: Colors.grey.shade800, width: 1),
                            boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 0.7,
                                    offset: const Offset(0, 1))
                              ])
                        : BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(color: Colors.grey, width: 0),
                            boxShadow: [
                                BoxShadow(
                                    color:
                                        Colors.grey.shade300.withOpacity(0.8),
                                    blurRadius: 4,
                                    offset: const Offset(0, 7))
                              ]),
                    width: MediaQuery.of(context).size.width / 2.3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Center(
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.blue.shade200,
                              child: CircleAvatar(
                                  radius: 23,
                                  backgroundColor: selectedservice == 2
                                      ? Colors.white
                                      : Colors.grey.shade300,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child:
                                        Image.asset(IconAssets.repairWorkshop),
                                  )),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('Repair Workshop',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                    color: selectedservice == 2
                                        ? Colors.white
                                        : Colors.grey.shade500,
                                    fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 6),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(color: Colors.grey, width: 0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300.withOpacity(0.8),
                            blurRadius: 4,
                            offset: const Offset(0, 7))
                      ]),
                  width: MediaQuery.of(context).size.width / 2.3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: const Center(
                            child: Row(
                          children: [
                            Text(
                              'S',
                              style: TextStyle(
                                  color: MainTheme.primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text('oon..',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ],
                        )),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
      navbar: const NavBarWidget(
        currentScreen: 'Categories',
      ),
    );
  }
}
