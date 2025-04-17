

import 'package:carsilla/const/assets.dart';
import 'package:carsilla/core/reusable_widgets/images_gallary.dart';
import 'package:carsilla/utils/theme.dart';
import 'package:carsilla/widgets/btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../const/common_methods.dart';
import '../../const/endpoints.dart';
import '../../utils/ui_utils.dart';
import '../../providers/car_listing_provider.dart';
import '../../providers/specification_provider.dart';
import '../../widgets/header.dart';
import '../../widgets/srtbtn.dart';
import '../../widgets/textfeild.dart';
import '../GoogleMap/view_location_on_map.dart';
import 'view_car_details.dart';


class SearchCarScreen extends StatefulWidget {
  final String? searchVal;
  const SearchCarScreen({super.key, this.searchVal = ''});

  @override
  State<SearchCarScreen> createState() => _SearchCarScreenState();
}

class _SearchCarScreenState extends State<SearchCarScreen> {
  // final List carListing = [
  //   {
  //     'img': TempAssets.carlisting1,
  //     'title': 'White Suv Car',
  //     'price': '65.000'
  //   },
  //   {
  //     'img': TempAssets.carlisting2,
  //     'title': 'Blue Luxury Car',
  //     'price': '57.500'
  //   },
  //   {
  //     'img': TempAssets.carlisting3,
  //     'title': 'Red Sport Car',
  //     'price': '45.900'
  //   },
  //   {
  //     'img': TempAssets.carlisting4,
  //     'title': 'White Mini Car',
  //     'price': '43.000'
  //   },
  //   {
  //     'img': TempAssets.carlisting3,
  //     'title': 'Red Sport Car',
  //     'price': '45.900'
  //   },
  //   {
  //     'img': TempAssets.carlisting4,
  //     'title': 'White Mini Car',
  //     'price': '43.000'
  //   },
  // ];

  List<String> cities = ['Dubai', 'Abu Dhabi', 'Sharjah', 'Ras Al Khaimah', 'Fujairah', 'Ajman', 'Umm Al Quwain', 'Al Ain'];
  List<String> carType = ['Used', 'Imported', 'Auction'];
  String? selectedCity;
  String filterVal = '';
  String? sortBy;
  String? sortByPrice;
  String? sortByDate;
  String? sortBySpeed;
  String filterByType = "Used";
  String? selectedCar;
  String? selectedModel;
  String? selectedYear;
  String? searchVal;



  String? selectedBody;
  String? selectedRegion;
  String query = '';


  late List displayedList;
  late Map pagination;

  bool isLoading = false;

  var _currentRangeValues =  const RangeValues(0, 500000);
  var mileageRange =  const RangeValues(0, 500000);
  TextEditingController _startPrice = TextEditingController();
  TextEditingController _endPrice = TextEditingController();
  TextEditingController startMileage = TextEditingController();
  TextEditingController endMileage = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final vmIntVal = Provider.of<CarListingProvider>(context, listen: false);
    getData();
    displayedList = List.from(vmIntVal.carListingDataList);
    if (widget.searchVal != '') {
      filterList(widget.searchVal!);
    }
  }

  String moneyFormator(value){
    double price = double.parse(value);
    MoneyFormatter fmf = MoneyFormatter(
        amount: price
    );

    return fmf.output.nonSymbol.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), '');
  }

  getData() async {
    await SpecificationProvider.getBodyPart();
    await SpecificationProvider.getRegions();
    if(context.mounted){
      getListing();

    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = getMediaSize(context);
    return Consumer<CarListingProvider>(builder: (context, vmVal, child) {
      return Header(
        enableBackButton: true,

        // title: 'Filter',
        title: 'Cars',
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.02 / 1),



              const SizedBox(height: 10),

              SizedBox(
                height: 25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: SortButton(onclick: () {
                        filterByType="Used";
                        getListing();
                      }, label: 'Used/New',btnColor: (filterByType=="Used") ? MainTheme.primaryColor : Colors.white, labelColor: (filterByType=="Used") ? Colors.white : Colors.black54),
                    ),
                    const SizedBox(width: 5,),
                    Expanded(
                      child: SortButton(onclick: (){
                        filterByType="Imported";
                        getListing();
                      }, label: 'IMPORTED', btnColor: (filterByType=="Imported") ? MainTheme.primaryColor : Colors.white, labelColor: (filterByType=="Imported") ? Colors.white : Colors.black54),
                    ),
                    const SizedBox(width: 5,),
                    Expanded(
                      child: SortButton(onclick: () async {
                        filterByType="Auction";
                        getListing();
                      }, label: 'AUCTION', btnColor: (filterByType=="Auction") ? MainTheme.primaryColor : Colors.white, labelColor: (filterByType=="Auction") ? Colors.white : Colors.black54),
                    ),
                    const SizedBox(width: 5,),
                    // Expanded(
                    //   child: SortButton(onclick: (){
                    //     setState(() {
                    //       filterByType="All";
                    //     });
                    //
                    //   }, label: 'All', btnColor: (filterByType=="All") ? MainTheme.primaryColor : Colors.white, labelColor: (filterByType=="All") ? Colors.white : Colors.black54),
                    // ),

                    // MainButton(onclick: (){}, label: 'Sorted By', btnColor: Colors.white, labelColor: Colors.grey, width: 0.22, fontSize: 8,)
                  ],
                ),
              ),
              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: SizedBox(
                          child: CustomTextFormField(
                            controller: searchController,
                            hintText: 'Search...',
                              onChange: (value){
                                searchVal = value;
                                getListing();
                              },
                            suffix: IconButton(
                                onPressed: () {
                                  searchVal = searchController.text;
                                  getListing();
                                },
                                icon: const Icon(Icons.search),
                                color: Colors.grey),
                          )),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  SizedBox( height: 43, width:100, child: SortButton(onclick: (){
                    filterByType = 'Used';
                    selectedCar = null;
                    selectedModel = null;
                    selectedYear = null;
                    selectedBody = null;
                    selectedRegion = null;
                    selectedCity = null;
                    sortByDate = null;
                    sortBySpeed = null;
                    sortBy = null;
                    searchVal = null;
                    _currentRangeValues =  const RangeValues(50, 500000);
                    mileageRange =  const RangeValues(0, 500000);
                    _startPrice.text = moneyFormator(_currentRangeValues.start.floor().toString());
                    _endPrice.text = moneyFormator(_currentRangeValues.end.floor().toString());
                    startMileage.text = moneyFormator(mileageRange.start.floor().toString());
                    endMileage.text = moneyFormator(mileageRange.end.floor().toString());
                    getListing();
                  }, label: 'Reset',)),
                ]
              ),

              const SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: Container(
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
                                  value: selectedCity,
                                  hint: const Text(
                                      'City'),
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
                                    selectedCity = newValue!;
                                    getListing();
                                  },
                                  items: cities.map((String city) {
                                    return DropdownMenuItem<String>(
                                      value: city,
                                      child: Text(city),
                                    );
                                  }).toList(),
                                ),
                              ))),
                    ),
                    const SizedBox(width: 5,),
                    SizedBox(
                      width: 150,
                      child: Container(
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
                                  value: selectedCar,
                                  hint: const Text(
                                      'Make'),
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
                                  onChanged: (String? newValue) async {
                                    await SpecificationProvider.getModels(newValue!);
                                    selectedCar = newValue;
                                    selectedModel = null;
                                    selectedYear = null;
                                    getListing();
                                  },
                                  items: SpecificationProvider.carNames.map((String type) {
                                    return DropdownMenuItem<String>(
                                      value: type,
                                      child: Text(type),
                                    );
                                  }).toList(),
                                ),
                              ))),
                    ),
                    const SizedBox(width: 5,),
                    SizedBox(
                      width: 150,
                      child: Container(
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
                                  value: selectedModel,
                                  hint: const Text(
                                      'Model'),
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
                                  onChanged: (String? newValue) async {
                                    await SpecificationProvider.getYears(newValue!);
                                    selectedModel = newValue;
                                    selectedYear = null;
                                    getListing();
                                    //filterList(newValue!);
                                  },
                                  items: (selectedCar == null) ? [] : SpecificationProvider.modelsByCar.map((String type) {
                                    return DropdownMenuItem<String>(
                                      value: type,
                                      child: Text(type),
                                    );
                                  }).toList(),
                                ),
                              ))),
                    ),
                    const SizedBox(width: 5,),
                    SizedBox(
                      width: 150,
                      child: Container(
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
                                  value: selectedYear,
                                  hint: const Text(
                                      'Year'),
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
                                  onChanged: (String? newValue) async {
                                    selectedYear = newValue;
                                    getListing();
                                    //filterList(newValue!);
                                  },
                                  items: (selectedModel == null) ? [] : SpecificationProvider.yearsByModel.map((String type) {
                                    return DropdownMenuItem<String>(
                                      value: type,
                                      child: Text(type),
                                    );
                                  }).toList(),
                                ),
                              ))),
                    ),
                    const SizedBox(width: 5,),
                    SizedBox(
                      width: 150,
                      child: Container(
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
                                  value: selectedBody,
                                  hint: const Text(
                                      'Body Type'),
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
                                      selectedBody = newValue!;
                                      getListing();
                                  },
                                  items: SpecificationProvider.bodyParts.map((String sparepart) {
                                    return DropdownMenuItem<String>(
                                      value: sparepart,
                                      child: Text(sparepart),
                                    );
                                  }).toList(),
                                ),
                              ))),
                    ),
                    const SizedBox(width: 5,),
                    SizedBox(
                      width: 150,
                      child: Container(
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
                                  value: selectedRegion,
                                  hint: const Text(
                                      'Regional Spec'),
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
                                      selectedRegion = newValue!;
                                      getListing();
                                  },
                                  items:SpecificationProvider.regions.map((String sparepart) {
                                    return DropdownMenuItem<String>(
                                      value: sparepart,
                                      child: Text(sparepart),
                                    );
                                  }).toList(),
                                ),
                              ))),
                    ),
                    const SizedBox(width: 5,),
                    SizedBox(
                      width: 150,
                      child: GestureDetector(
                        onTap : (){
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState){
                                return SizedBox(
                                  height: 250,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const Text('Price'),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal:24, vertical: 16.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: TextField(
                                                    textAlign: TextAlign.center,
                                                    readOnly: true,
                                                    controller: _startPrice,
                                                  )
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                                child: Text('to'),
                                              ),
                                              Expanded(
                                                  child: TextField(
                                                    textAlign: TextAlign.center,
                                                    readOnly: true,
                                                    controller: _endPrice,
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                        RangeSlider(
                                          values: _currentRangeValues,
                                          max: 1000000,
                                          onChanged: (values) {
                                           setState((){
                                             _startPrice.text = moneyFormator(values.start.floor().toString());
                                             _endPrice.text = moneyFormator(values.end.floor().toString());
                                             _currentRangeValues = values;
                                           });
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                          child: SizedBox(width: double.infinity,
                                            child: MainButton(
                                              label: 'Filter',
                                              onclick: (){
                                                getListing();
                                                Navigator.pop(context);
                                              },
                                            ),),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                            },
                          );
                        },
                        child: Container(
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
                                    value: sortByPrice,
                                    hint: const Text(
                                        'Price'),
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
                                      sortByPrice = newValue!;
                                      //filterList(newValue!);
                                    },
                                    items: const [

                                    ],
                                  ),
                                ))),
                      ),
                    ),
                    const SizedBox(width: 5,),
                    SizedBox(
                      width: 150,
                      child: GestureDetector(
                        onTap: (){
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState){
                                return SizedBox(
                                  height: 250,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const Text('Range'),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal:24, vertical: 16.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: TextField(
                                                    textAlign: TextAlign.center,
                                                    readOnly: true,
                                                    controller: startMileage,
                                                  )
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                                child: Text('to'),
                                              ),
                                              Expanded(
                                                  child: TextField(
                                                    textAlign: TextAlign.center,
                                                    readOnly: true,
                                                    controller: endMileage,
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                        RangeSlider(
                                          values: mileageRange,
                                          max: 500000,
                                          onChanged: (values) {
                                            setState((){
                                              startMileage.text = moneyFormator(values.start.floor().toString());
                                              endMileage.text = moneyFormator(values.end.floor().toString());
                                              mileageRange = values;
                                            });
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                          child: SizedBox(width: double.infinity,
                                            child: MainButton(
                                              label: 'Filter',
                                              onclick: (){
                                                getListing();
                                                Navigator.pop(context);
                                              },
                                            ),),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                            },
                          );
                        },
                        child: Container(
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
                                    value: sortBySpeed,
                                    hint: const Text(
                                        'Mileage'),
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
                                      sortBySpeed = newValue!;
                                      setState(() {

                                      });
                                      //filterList(newValue!);
                                    },
                                    items: const [

                                    ],
                                  ),
                                ))),
                      ),

                    ),
                    const SizedBox(width: 5,),
                    SizedBox(
                      width: 150,
                      child: Container(
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
                                  value: sortByDate,
                                  hint: const Text(
                                      'Date'),
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
                                    sortByDate = newValue!;
                                    getListing();
                                    //filterList(newValue!);
                                  },
                                  items : const [
                                    DropdownMenuItem(
                                      alignment: Alignment.center,
                                      value: 'asc',
                                      child: Text('Ascending'),
                                    ),
                                    DropdownMenuItem(
                                      alignment: Alignment.center,
                                      value: 'desc',
                                      child: Text('Descending'),

                                    ),
                                  ],
                                ),
                              ))),
                    ),
                    const SizedBox(width: 5,),
                    SizedBox(
                      width: 150,
                      child: Container(
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
                                  value: sortBy,
                                  hint: const Text(
                                      'Sort'),
                                  underline: Container(),
                                  style: const TextStyle(fontSize: 14, color: Colors.black),
                                  onChanged: (String? newValue) {
                                    sortList(newValue!);
                                    setState(() {
                                      sortBy = newValue;
                                    });
                                  },
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
                                  items: const [
                                    DropdownMenuItem<String>(
                                      value: 'az',
                                        child: Text('AZ')),
                                    DropdownMenuItem<String>(
                                        value: 'za',
                                        child: Text('ZA')),

                                  ],
                                ),
                              ))),
                    ),
                  ],
                ),
              ),
              // Assuming you have a TextEditingController for your search field
// ...
              // GridView.builder(
              //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 2),
              //   itemCount: displayedList.length,
              //   shrinkWrap: true,
              //   controller: ScrollController(),
              //   itemBuilder: (context, index) {
              //     final e = displayedList[index];

              //     if (!(e['listing_title']!
              //             .toLowerCase()
              //             .contains(filterVal.toLowerCase()) ||
              //         e['listing_desc']!
              //             .toLowerCase()
              //             .contains(filterVal.toLowerCase().toLowerCase()) ||
              //         e['listing_price']!
              //             .toLowerCase()
              //             .contains(filterVal.toLowerCase().toLowerCase()) ||
              //         e['features_gear']!
              //             .toLowerCase()
              //             .contains(filterVal.toLowerCase().toLowerCase()) ||
              //         e['listing_type']!
              //             .toLowerCase()
              //             .contains(filterVal.toLowerCase().toLowerCase()))) {
              //       // Item doesn't match the filter, return an empty container
              //       // return Center(
              //       //   child: Padding(
              //       //     padding: const EdgeInsets.only(top: 100.0),
              //       //     child: Text(
              //       //       'No items found',
              //       //       style: Theme.of(context)
              //       //           .textTheme
              //       //           .headline6!
              //       //           .copyWith(color: Colors.grey.shade900),
              //       //     ),
              //       //   ),
              //       // );
              //       return null;
              //       // return const SizedBox(width: 0, height: 0);
              //     }

              //     return Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: SizedBox(
              //         width: MediaQuery.of(context).size.width * 0.42 / 1,
              //         child: GestureDetector(
              //           onTap: () {
              //             Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) => DetailsCarsPage(
              //                   carListingDetails: e,
              //                 ),
              //               ),
              //             );
              //           },
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               ClipRRect(
              //                 borderRadius: BorderRadius.circular(10),
              //                 child: Image.network(
              //                   ApiUrls.imageUrl + e['listing_img1'],
              //                   width:
              //                       MediaQuery.of(context).size.width * 0.4 / 1,
              //                   height: MediaQuery.of(context).size.height *
              //                       0.12 /
              //                       1,
              //                   fit: BoxFit.cover,
              //                   errorBuilder: (context, child, error) =>
              //                       Image.asset(IconAssets.carvector),
              //                 ),
              //               ),
              //               Text(
              //                 e['listing_title'] ?? '',
              //                 style: Theme.of(context)
              //                     .textTheme
              //                     .labelSmall!
              //                     .copyWith(color: Colors.grey.shade900),
              //               ),
              //               SizedBox(
              //                 width:
              //                     MediaQuery.of(context).size.width * 0.4 / 1,
              //                 child: Row(
              //                   mainAxisAlignment:
              //                       MainAxisAlignment.spaceBetween,
              //                   children: [
              //                     Text(
              //                       "\$${e['listing_price']}",
              //                       style: Theme.of(context)
              //                           .textTheme
              //                           .labelLarge!
              //                           .copyWith(
              //                               color: MainTheme.primaryColor),
              //                     ),
              //                     SizedBox(
              //                       width: 13,
              //                       child: Image.asset(IconAssets.fav),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     );
              //   },
              // ),
              SingleChildScrollView(
                child: Column(
                  children: displayedList
                      //     .where((e) =>
                      //         e['listing_title']!.toLowerCase().contains(filterVal.toLowerCase()) ||
                      //         e['listing_desc']!.toLowerCase().contains(
                      //             filterVal.toLowerCase().toLowerCase()) ||
                      //         e['listing_price']!.toLowerCase().contains(
                      //             filterVal.toLowerCase().toLowerCase()) ||
                      //         e['features_gear']!.toLowerCase().contains(
                      //             filterVal.toLowerCase().toLowerCase()) ||
                      //         e['listing_type']!.toLowerCase().contains(
                      //             filterVal.toLowerCase().toLowerCase()))
                      //     .isEmpty)
                      // ? [
                      //     // Display a message when no items are found
                      //     Center(
                      //       child: Padding(
                      //         padding: const EdgeInsets.only(top: 100.0),
                      //         child: Text(
                      //           'No items found',
                      //           style: Theme.of(context)
                      //               .textTheme
                      //               .headline6!
                      //               .copyWith(color: Colors.grey.shade900),
                      //         ),
                      //       ),
                      //     ),
                      //   ]
                      // : vmVal.carListingDataList
                      //     .where((e) =>
                      //         e['listing_title']!
                      //             .toLowerCase()
                      //             .contains(filterVal.toLowerCase()) ||
                      //         e['listing_desc']!.toLowerCase().contains(
                      //             filterVal.toLowerCase().toLowerCase()) ||
                      //         e['listing_price']!.toLowerCase().contains(
                      //             filterVal.toLowerCase().toLowerCase()) ||
                      //         e['features_gear']!.toLowerCase().contains(
                      //             filterVal.toLowerCase().toLowerCase()) ||
                      //         e['listing_type']!
                      //             .toLowerCase()
                      //             .contains(filterVal.toLowerCase().toLowerCase()))

                      .map((e){
                    print('${e['car_type']}');
                    double price = double.parse(e['listing_price'].toString());
                    MoneyFormatter fmf = MoneyFormatter(
                        amount: price
                    );

                    String carPrice = fmf.output.nonSymbol.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), '');

                    return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: size.width * 0.85,
                            width: size.width ,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(12)

                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ViewCarDetails(carListingDetails: e),
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //TODO:
                                  // Text(e['images'].toString()),
                                  Stack(
                                    children: [

                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child:  e['images'].isNotEmpty?
                                        Image.network(
                                          // Endpoints.imageUrl + e['listing_img1'],
                                          e['images'][0]['image'],
                                          // width: MediaQuery.of(context).size.width *
                                          //     04 /
                                          //     1,
                                          width: MediaQuery.of(context).size.width ,
                                          height: size.width * 0.43,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child; // Image is fully loaded

                                            return Padding(
                                              padding: const EdgeInsets.all(20.0),
                                              child: Center(
                                                child: CircularProgressIndicator(
                                                  value: loadingProgress.expectedTotalBytes != null
                                                      ? loadingProgress.cumulativeBytesLoaded /
                                                      (loadingProgress.expectedTotalBytes ?? 1)
                                                      : null, // Show indeterminate if totalBytes unknown
                                                ),
                                              ),
                                            );
                                          },
                                          errorBuilder: (context, child, erorr) =>
                                              Image.asset(IconAssets.carvector,fit: BoxFit.cover,
                                                width: MediaQuery.of(context).size.width ,
                                                height: size.width * 0.43,

                                              ),
                                        ):Image.asset(IconAssets.carvector,fit: BoxFit.cover,
                                          width: MediaQuery.of(context).size.width ,
                                          height: size.width * 0.43,

                                        ),
                                      ),
                                      e['images'].isNotEmpty?
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: 40,width: 40,
                                          decoration: BoxDecoration(
                                              color: MainTheme.primaryColor,
                                              borderRadius: BorderRadius.circular(12)

                                          ),
                                          child: InkWell(
                                              onTap: (){
                                                ImagesGallery().zoomIn(context,e['images']);
                                              },
                                              child: Icon(Icons.zoom_in,color: Colors.white,)),
                                        ),
                                      ):Container()
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 12,),
                                        Row(
                                          children: [
                                            Text(
                                              "AED $carPrice",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                fontSize: 16,
                                                  color:
                                                  MainTheme.primaryColor),
                                            ),
                                            const Spacer(),
                                            InkWell(
                                              onTap: (){

                                                if(e['location']== null && e['lat'] == null && e['lng'] == null){
                                                  UiUtils(context).showSnackBar( 'Location is not available');
                                                  return;
                                                }
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewLocationOnMap(latitude: e['lat'], longitude: e['lng'], address: e['location']),));

                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(4),
                                                child: Row(
                                                  children: [
                                                    const Icon(Icons.location_pin,color: MainTheme.primaryColor,size: 20,),
                                                    Text(e['city']??'',style: const TextStyle(fontSize: 14),)
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 4,),
                                        Row(
                                          children: [
                                            Container(
                                              width:MediaQuery.of(context).size.width*0.8,
                                              child: Text(
                                                overflow: TextOverflow.ellipsis,
                                                e['listing_title'] ?? '',
                                                // '${e['id'].toString()}${e['images'].toString()}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium!
                                                    .copyWith(color: Colors.grey.shade900,fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Text('Make: ',style: TextStyle(fontSize: 14,color: Colors.black),),
                                                    Text(e['listing_type'] ?? '',style: const TextStyle(fontSize: 14,color: Colors.black54),)
                                                  ],
                                                ),
                                                const SizedBox(width: 20,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    const Text('Year:  ',style: TextStyle(fontSize: 14,color: Colors.black),),
                                                    Text(e['listing_year'] ?? '',style: const TextStyle(fontSize: 14,color: Colors.black54),)
                                                  ],
                                                ),
                                              ],
                                            ),

                                            SizedBox(width: size.width * 0.1,),

                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Text('Model: ',style: TextStyle(fontSize: 14,color: Colors.black),),
                                                    Text('${e['listing_model']}',style: const TextStyle(fontSize: 14,color: Colors.black54),)
                                                  ],
                                                ),
                                                const SizedBox(width: 20,),
                                                Row(
                                                  children: [
                                                    const Text('Mileage:  ',style: TextStyle(fontSize: 14,color: Colors.black),),
                                                    Text('${e['features_speed']} Kms',style: const TextStyle(fontSize: 14,color: Colors.black54),overflow: TextOverflow.ellipsis,)
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  String message = Uri.encodeComponent(
                                                      "((Carlly Motors))\n\n"
                                                          "مرحبًا، أتواصل معك للاستفسار عن *السيارة* المعروضة للبيع، ${e!['listing_title'].toString()}، في Carlly Motors. هل لا تزال متوفرة؟\n\n"

                                                          "Hello, We are contacting you about the *car* for sale, ${e['listing_title'].toString()}, at Carlly Motors. Is it available?\n\n"

                                                          "*Car Model* : ${e['listing_model']}\n"
                                                          "*Car Type* : ${e['listing_type']}\n"
                                                          "*Year Of Manufacture* : ${e['listing_year']}\n"
                                                          "*Car Price* : ${e['listing_price']} AED\n"
                                                          "*Car URL* : https://carllymotors.com/car-listing/?id=${e['id']}"
                                                  );

                                                  String mapsUrl =
                                                      "https://wa.me/${e['wa_number'].toString().replaceAll(',', '')}?text=$message";
                                                  final Uri url = Uri.parse(mapsUrl);
                                                  if (!await launchUrl(url)) {
                                                    throw Exception('Could not launch $url');
                                                  }
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: MainTheme.primaryColor),
                                                      borderRadius: BorderRadius.circular(16)
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Image.asset('assets/images/whatsapp1.png',color: Colors.green.shade800,height: 17,width: 17,),
                                                      const SizedBox(width: 4,),
                                                      const Text('WhatsApp',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),)
                                                    ],),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  String calUrl =  "tel: ${e['contact_number'].toString().replaceAll(',', '')}";
                                                  final Uri url = Uri.parse(calUrl);
                                                  if (!await launchUrl(url)) {
                                                    throw Exception('Could not launch $url');
                                                  }
                                                },
                                                child: Container(
                                                  height: 30,
                                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: MainTheme.primaryColor),
                                                    borderRadius: BorderRadius.circular(16)
                                                  ),
                                                  child: const Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                    Icon(Icons.phone,color: MainTheme.primaryColor,size: 20,),
                                                    SizedBox(width: 4,),
                                                    Text('Call',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),)
                                                  ],),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  var data = e;
                                                  String shareUrl = "https://carllymotors.com/car-listing/?id=${data?['id'] ?? ''}";
                                                  String message = "Check out my latest find on Carlly! Great deals await. Don’t miss out!\n$shareUrl";
                                                  await Share.share(message);
                                                },
                                                child: Container(
                                                  height: 30,
                                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: MainTheme.primaryColor),
                                                      borderRadius: BorderRadius.circular(16)
                                                  ),
                                                  child: const Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.share_sharp,color: MainTheme.primaryColor, size: 18,),
                                                      SizedBox(width: 4,),
                                                      Text('Share',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),)
                                                    ],),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                  })
                      .toList(),
                ),
              ),
              if(Provider.of<CarListingProvider>(context, listen: false).pagination.isNotEmpty && Provider.of<CarListingProvider>(context, listen: false).pagination['current_page'] < Provider.of<CarListingProvider>(context, listen: false).pagination['last_page'] )  (!isLoading) ? TextButton(onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await getListing();
                setState(() {
                  isLoading = false;
                });
                final vmIntVal = Provider.of<CarListingProvider>(context, listen: false);
                displayedList = List.from(vmIntVal.carListingDataList);
              }, child: const Text('See More...', style: TextStyle(color: MainTheme.primaryColor, fontWeight: FontWeight.bold),)) : const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(height: 20, width:20, child: CircularProgressIndicator())),
            ],
          ),
        ),
      );
    });
  }

  void sortList(String sortBy) {
    setState(() {
      displayedList.sort((a, b) {
        // Sorting logic based on sortBy parameter
        if (sortBy == 'az') {
          return a['listing_title'].toString().toLowerCase().compareTo(b['listing_title'].toString().toLowerCase());
        } else {
          return b['listing_title'].toString().toLowerCase().compareTo(a['listing_title'].toString().toLowerCase());
        }
      });
    });
  }

  Future<void> getListing() async {

    query = "car_type=$filterByType";
    if(_startPrice.text.isNotEmpty) query += "&priceFrom=${_currentRangeValues.start.floor()}";
    if(_endPrice.text.isNotEmpty) query += "&priceTo=${_currentRangeValues.end.floor()}";
    if(startMileage.text.isNotEmpty) query += "&speedFrom=${mileageRange.start.floor()}";
    if(endMileage.text.isNotEmpty) query += "&speedTo=${mileageRange.end.floor()}";
    if (selectedCar != null) query += "&brand=$selectedCar";
    if (selectedModel != null) query += "&model=$selectedModel";
    if (selectedYear != null) query += "&year=$selectedYear";
    if (selectedBody != null) query += "&body_type=$selectedBody";
    if (selectedRegion != null) query += "&regional_specs=$selectedRegion";
    if (selectedCity != null) query += "&city=$selectedCity";
    if (sortByDate != null) query += "&sort_by=date&sort=$sortByDate";
    if (searchVal != null) query += "&search=$searchVal";
    //query = "car_type=$filterByType&brand=$selectedCar&model=$selectedModel&year=$selectedYear&body_type=$selectedBody&regional_specs=$selectedRegion&city=$selectedCity&priceFrom=${_currentRangeValues.start.floor()}&priceTo=${_currentRangeValues.end.floor()}&speedFrom=${mileageRange.start.floor()}&speedTo=${mileageRange.end.floor()}&sort_by=date&sort=asc";
   await Provider.of<CarListingProvider>(context, listen: false)
        .getCarListingDataVmF(context, query: Endpoints.baseUrl+Endpoints.getlisting + query);
   final vmIntVal = Provider.of<CarListingProvider>(context, listen: false);
   displayedList = List.from(vmIntVal.carListingDataList);

  }

  void filterList(String filterValue) {
    filterVal = filterValue;
    final vmIntVal = Provider.of<CarListingProvider>(context, listen: false);
    setState(() {
      displayedList = List.from(vmIntVal.carListingDataList.where((car) =>
          car['body_type'].toString().toLowerCase() == filterVal.toString().toLowerCase() ||
          car['regional_specs'].toString().toLowerCase() == filterVal.toString().toLowerCase() ||
          car['listing_title'].toString().toLowerCase() == filterVal.toString().toLowerCase() ||
          car['car_type'].toString().toLowerCase() == filterVal.toString().toLowerCase() ||
          car['listing_price'].toString().toLowerCase() == filterVal.toString().toLowerCase() ||
          car['features_gear'].toString().toLowerCase() == filterVal.toString().toLowerCase() ||
          car['listing_type'].toString().toLowerCase() == filterVal.toString().toLowerCase()
      ));
      // displayedList = List.from(vmIntVal.carListingDataList
      //     .where((e) => !(e['listing_title']!
      //     .toLowerCase() == filterValue.toLowerCase() ||
      //     e['car_type']
      //         .toLowerCase()
      //         == filterValue.toLowerCase().toLowerCase() ||
      //     e['body_type'].toString()
      //         .toLowerCase()
      //         == filterValue.toLowerCase().toLowerCase() ||
      //     e['regional_specs'].toString()
      //         .toLowerCase()
      //         == filterValue.toLowerCase().toLowerCase() ||
      //     e['listing_desc']!
      //         .toLowerCase()
      //        == filterValue.toLowerCase().toLowerCase() ||
      //     e['listing_price']!
      //         .toLowerCase()
      //         == filterValue.toLowerCase().toLowerCase() ||
      //     e['features_gear']!
      //         .toLowerCase()
      //         == filterValue.toLowerCase().toLowerCase() ||
      //     e['listing_type']!
      //         .toLowerCase()
      //         == filterValue.toLowerCase().toLowerCase()))
      //     .toList());
    });
  }

}

