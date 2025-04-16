


import 'package:carsilla/const/assets.dart';
import 'package:carsilla/widgets/btn.dart';
import 'package:carsilla/widgets/headerwithimg.dart';
import 'package:carsilla/widgets/textfeild.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../utils/theme.dart';
import '../../const/common_methods.dart';
import '../../services/spare_part_service.dart';
import '../../utils/ui_utils.dart';
import '../../providers/specification_provider.dart';
import '../../providers/spare_part_provider.dart';
import 'spare_part_view_screen.dart';

class SearchSparePartScreen extends StatefulWidget {
  const SearchSparePartScreen({super.key});

  @override
  State<SearchSparePartScreen> createState() => _SearchSparePartScreenState();
}

class _SearchSparePartScreenState extends State<SearchSparePartScreen> {
  TextEditingController pickupcontroller = TextEditingController();
  TextEditingController timecontroller = TextEditingController();
  TextEditingController vimNumberController = TextEditingController();

////////////
  String? selectedCar;
  String? selectedModel;
  String? selectedYear;
  String? selectedCity;
  String? subCategory;
  String? condition;

  List<String> sparePartsNames = [
    'Brake Pads',
    'Oil Filter',
    'Air Filter',
    'Spark Plugs',
    'Battery'
  ];


  List<String> Cars = SpecificationProvider.carNames;

  String? selectedSparePart;

  bool isExpanded = true;
  bool isDataselected = false;
  List<String> cities = ['Dubai', 'Abu Dhabi', 'Sharjah', 'Ras Al Khaimah', 'Fujairah', 'Ajman', 'Umm Al Quwain', 'Al Ain'];
  List<dynamic> subcategories = [];

  ////////////
  @override
  void initState() {
    super.initState();
    Provider.of<SparePartProvider>(context, listen: false).getSparePartsCategoriesVmF(context);
    SpecificationProvider.getSparePartCateGories();
  }


  @override
  Widget build(BuildContext context) {
    pickupcontroller.text = 'Car';
    timecontroller.text = 'Car';
    var size = getMediaSize(context);
    return Builder(builder: (context) {
      return Consumer<SparePartProvider>(builder: (context, vmVal, child) {
        // vmVal.getRepairingVmF(context);
        return HeaderWithImage(
          title: 'Auto Spare Parts',
          headeimg: ImageAssets.workshop,
          marginToTopHeadeImg: 0.0,
          marginbodyfrombottom: 0.06,
          // comment by @CallofCoding
          // onTopOfheImage: Container(
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10)),
          //     child: SizedBox(
          //         width: MediaQuery.of(context).size.width * 0.9 / 1,
          //         height: MediaQuery.of(context).size.height * 0.055 / 1,
          //         child: SearchBar(
          //           hintText: 'Search ...',
          //           hintStyle: MaterialStateProperty.all(
          //               TextStyle(color: Colors.grey.shade500, fontSize: 14)),
          //           leading: IconButton(
          //               onPressed: () {
          //                 Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                     builder: (context) =>
          //                         BreakPads(data: vmVal.sparePartsList.first),
          //                   ),
          //                 );
          //               },
          //               icon: Icon(Icons.search, color: Colors.grey.shade600)),
          //         ))),
          //navbar: const NavBarWidget(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: Column(
              children: [
                (isDataselected) ?
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ExpansionTile(
                    onExpansionChanged: (expanded){
                      if(expanded){
                        setState(() {
                          isExpanded = true;
                        });
                      }else{
                        setState(() {
                          isExpanded = false;
                        });
                      }
                    },
                    initiallyExpanded: true,
                    title:  Stack(
                      alignment: Alignment.center,
                      children: [
                        const SizedBox(height: 1, child: Divider(color: Colors.black,)),
                        Container(
                            alignment: Alignment.center,
                            width: 110,
                            color: Colors.white,
                            child: Text('Your Car', style: TextStyle(fontWeight: FontWeight.bold, color: (isExpanded) ? MainTheme.primaryColor : Colors.black),))
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
                                SizedBox(height: 12,),
                                Text('Cart Type     :', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 16,),
                                Text('Car Model   :',style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 16,),
                                Text('Car Year      :', style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 16,),
                                Text('Category   :', style: TextStyle(fontWeight: FontWeight.bold))
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
                                      borderRadius: const BorderRadius.all(Radius.circular(10))
                                  ),
                                  child: Text(selectedCar.toString().toUpperCase()),),
                                const SizedBox(height: 5,),

                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.25),
                                      borderRadius: const BorderRadius.all(Radius.circular(10))
                                  ),
                                  child: Text(selectedModel.toString().toUpperCase()),),
                                const SizedBox(height: 5,),

                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.25),
                                      borderRadius: const BorderRadius.all(Radius.circular(10))
                                  ),
                                  child: Text(selectedYear.toString().toUpperCase()),),
                                const SizedBox(height: 5,),

                                Container(
                                  width: 160,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.25),
                                      borderRadius: const BorderRadius.all(Radius.circular(10))
                                  ),
                                  child: Text(selectedSparePart.toString().toUpperCase(), overflow: TextOverflow.ellipsis,),),

                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 1, horizontal: 5),
                          child: MainButton(
                            width: 0.9,
                            onclick: () {
                              setState(() {
                                isDataselected = false;
                              });
                            },
                            label: "Choose New",
                          )),
                    ],
                    //Text("____________ Your Car ___________", style: TextStyle(color: (isExpanded) ? MainTheme.primaryColor : Colors.black)),
                    // children: [
                    //   Padding(
                    //       padding: const EdgeInsets.symmetric(
                    //           vertical: 1, horizontal: 5),
                    //       child: CupertinoListTile(
                    //           backgroundColor: Colors.blueGrey.shade50,
                    //           title: Text("Car Type",
                    //               style: TextStyle(
                    //                   color: Colors.blueGrey.shade300)),
                    //           trailing:
                    //               Text(widget.selectedCar.toString()))),
                    //   Padding(
                    //     padding: const EdgeInsets.symmetric(
                    //         vertical: 1, horizontal: 5),
                    //     child: CupertinoListTile(
                    //         backgroundColor: Colors.blueGrey.shade50,
                    //         title: Text(
                    //           "Car Model",
                    //           style: TextStyle(
                    //               color: Colors.blueGrey.shade300),
                    //         ),
                    //         trailing:
                    //             Text(widget.selectedModel.toString())),
                    //   ),
                    //   Padding(
                    //     padding: const EdgeInsets.symmetric(
                    //         vertical: 1, horizontal: 5),
                    //     child: CupertinoListTile(
                    //         backgroundColor: Colors.blueGrey.shade50,
                    //         title: Text(
                    //           "Car Year",
                    //           style: TextStyle(
                    //               color: Colors.blueGrey.shade300),
                    //         ),
                    //         trailing: Text(widget.selectedYear.toString())),
                    //   ),
                    //   Padding(
                    //     padding: const EdgeInsets.symmetric(
                    //         vertical: 1, horizontal: 5),
                    //     child: CupertinoListTile(
                    //         backgroundColor: Colors.blueGrey.shade50,
                    //         title: Text(
                    //           "Category",
                    //           style: TextStyle(
                    //               color: Colors.blueGrey.shade300),
                    //         ),
                    //         trailing:
                    //             Text(widget.selectedSparePart.toString())),
                    //   ),
                    //   Padding(
                    //       padding: const EdgeInsets.symmetric(
                    //           vertical: 1, horizontal: 5),
                    //       child: Opacity(
                    //         opacity: 0.5,
                    //         child: MainButton(
                    //           width: 0.9,
                    //           onclick: () {
                    //             Navigator.pop(context);
                    //           },
                    //           label: "Choose New",
                    //         ),
                    //       )),
                    // ],
                  ),
                )
                    :Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02 / 1),
                    Row(
                      children: [
                        Text('Choose Your Vehicle',
                            style: textTheme.titleSmall!.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: MainTheme.primaryColor)),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01 / 1),
                    //Type
                    SizedBox(
                      // width: MediaQuery.of(context).size.width * 0.28 / 1,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Make',
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
                                      hint: const Text(
                                          'Select Car'),
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
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black),
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01 / 1),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: SizedBox(
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
                                                          ' Model'),
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
                                                          .map((String model) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                            value: model,
                                                            child: Text(
                                                                model));
                                                      }).toList()
                                                          : []),
                                                )))
                                      ])),
                            ),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('YEAR ',
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
                                            onChanged: (String? newValue) async {
                                              await  SpecificationProvider.getSparePartCateGories();
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
                                                .map((String year) {
                                              return DropdownMenuItem<
                                                  String>(
                                                value: year,
                                                child: Text(year),
                                              );
                                            }).toList()
                                                : [],
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(height: MediaQuery.of(context).size.height * 0.01 / 1),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02 / 1),
                    Row(
                      children: [
                        Text('City'.toUpperCase(),
                            style: textTheme.labelSmall!.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600)),
                      ],
                    ),
                    // Text(selectedSparePart.toString()),
                    Container(
                        decoration: BoxDecoration(
                            border:
                            Border.all(width: 0.8, color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(10)),
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedCity,
                            hint: const Text(
                                'Select City'),
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
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCity = newValue;
                              });
                            },
                            items: cities.map((String car) {
                              return DropdownMenuItem<String>(
                                value: car,
                                child: Text(car),
                              );
                            }).toList(),
                          ),
                        )),

                  ],
                ),

                SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Category of spare parts'.toUpperCase(), style: textTheme.labelSmall!.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600)),
              ],
            ),

            SizedBox(height: 5,),

/////////////////////////
                (SparePartProvider.sparePartCategories.isEmpty) ? Center(child: Text('Category List Is Empty'),)
                : Wrap(
                  spacing: 4.0,
                  runSpacing: 8.0,
                  children: SparePartProvider.sparePartCategories
                  .map((e){
                    return GestureDetector(
                      onTap: () async {
                        await SparePartService.getSparePartsSubCategories(context, e['id']).then((value){
                          print('----map ${e['image']}');
                                subcategories = value;
                              });

                        setState(() {
                          selectedSparePart = e['name'];
                          subCategory = null;
                        });
                      },
                      child: Container(
                      decoration: BoxDecoration(
                        color: (selectedSparePart == e['name']) ? MainTheme.primaryColor : Colors.white.withOpacity(0.25),
                      ),
                      height: 90,
                      width: MediaQuery.of(context).size.width/3.5,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(image: NetworkImage(e['image']), height: 50, width: 60,),
                              Text(e['name'], style: const TextStyle(fontSize: 10), textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                                        ),
                    );} ).toList()
              ),
                SizedBox(height: 15,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Sub-Categories'.toUpperCase(), style: textTheme.labelSmall!.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600)),
                  ],
                ),
                Container(
                    decoration: BoxDecoration(
                        border:
                        Border.all(width: 0.8, color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10)),
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: subCategory,
                        hint: const Text(
                            'Select Sub-Category'),
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
                        onChanged: (String? newValue) {
                          setState(() {
                            subCategory = newValue;
                          });
                        },
                        items:
                        subcategories.map((dynamic subCategory) {
                          return DropdownMenuItem<String>(
                            value: subCategory['name'],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(subCategory['name']),
                                SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Image.network(subCategory['image'],fit: BoxFit.fitWidth,))
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    )),

                SizedBox(height:10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Condition'.toUpperCase(), style: textTheme.labelSmall!.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600)),
                  ],
                ),

                SizedBox(
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MainButton(
                        btnColor: condition == 'New' ? MainTheme.primaryColor : Colors.white,
                        labelColor: condition == 'New' ? Colors.white : Colors.black87,
                        width: 0.4,
                          onclick: (){
                        if(condition == 'Used' || condition == null){
                          setState(() {
                            condition = 'New';
                          });
                        }
                      },
                      label: 'New',),
                      MainButton(
                        btnColor: condition == 'Used' ? MainTheme.primaryColor : Colors.white,
                        labelColor: condition == 'Used' ? Colors.white : Colors.black87,
                        width: 0.4,
                        onclick: (){
                        if(condition == 'New' || condition == null){
                          setState(() {
                            condition = 'Used';
                          });
                        }
                      },
                      label: 'Used',)
                    ],
                  ),
                ),

                SizedBox(height: 10,),

              condition == 'New' ? Column(
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       Text('Vin Number'.toUpperCase(), style: textTheme.labelSmall!.copyWith(
                           fontSize: 11,
                           fontWeight: FontWeight.w500,
                           color: Colors.grey.shade600)),
                     ],
                   ),
                   CustomTextFormField(
                     hintStyle: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),
                     hintText: 'Enter Vin Number',
                     controller: vimNumberController,
                   ),
                 ],
               ): SizedBox(),





                SizedBox(height: MediaQuery.of(context).size.height * 0.02 / 1),
                MainButton(
                  width: 0.9,
                  onclick: () async {
                    if(selectedYear==null || selectedModel== null || selectedCar == null || selectedSparePart == null||condition == null || subCategory == null || selectedCity == null){
                      UiUtils(context).showSnackBar( 'Select all required fields');
                    }else{

                      if(condition == 'New' && vimNumberController.text.isEmpty){
                        UiUtils(context).showSnackBar( 'Please enter vin number');
                        return;
                      }

                      // SparePartService.searchSparePart = "searchSpareParts?search=${selectedSparePart.toString()}&brand=${selectedCar.toString()}&model=${selectedModel.toString()}&year=${selectedYear.toString()}&part_type=$condition&city=$selectedCity";
                      SparePartService.searchSparePart = "searchSpareParts?&brand=${selectedCar.toString()}&model=${selectedModel.toString()}&year=${selectedYear.toString()}&part_type=$condition";
                      await SparePartProvider().getSparePartsShopsVmF(context).then((value) {
                        if(context. mounted){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SparePartViewScreen(
                                    subcategory: subCategory ??'',
                                    selectedCar: selectedCar ?? '',
                                    selectedModel: selectedModel ?? '',
                                    selectedYear: selectedYear ?? '',
                                    vimNumber: condition == "New" ? vimNumberController.text.toString() : null,
                                    selectedSparePart: selectedSparePart ?? '',)));
                        }

                      },);

                      setState(() {
                        isDataselected = true;
                      });

                    }


                  },
                  label: 'Search',
                ),

              ],
            ),
          ),
        );
      });
    });
  }

  // updateTypef() {}

  void showCustomDropDownBottomSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Choose a Car',
              style: TextStyle(
                  color: MainTheme.primaryColor, fontWeight: FontWeight.bold)),
          actions: [
            Container(
              height: 300.0,
              color: Colors.blueGrey.shade200,
              child: ListView(
                children:
                    SpecificationProvider.carNames.mapIndexed((index, car) {
                  final opacity = (selectedCar == car) ? 1.0 : 0.4;
                  return Opacity(
                    opacity: opacity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: CupertinoListTile(
                          onTap: () {
                            selectedCar = car;
                            selectedModel = null;
                            selectedYear = null;
                            setState(() {});
                            Navigator.pop(context);
                          },
                          backgroundColor: (selectedCar == car)
                              ? Colors.blueGrey.shade200.withOpacity(0.3)
                              : Colors.blueGrey.shade100,
                          title: Text(car,
                              style: TextStyle(
                                  fontSize: (index == 2) ? 22 : 18.0)),
                          trailing: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.08,
                              child: Image.asset(IconAssets.kiyaIcon))),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
          cancelButton: SizedBox(
            height: MediaQuery.of(context).size.height * 0.06 / 1,
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      side: BorderSide(width: 0.3, color: Colors.red.shade800),
                      borderRadius: BorderRadius.circular(12))),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.blueGrey.shade50)),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style:
                    TextStyle(color: MainTheme.primaryColor.withOpacity(0.4)),
              ),
            ),
          ),
        );
      },
    );
  }
}

extension IterableExtension<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E e) f) sync* {
    var index = 0;
    for (final element in this) {
      yield f(index++, element);
    }
  }
}
