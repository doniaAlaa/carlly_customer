
import 'package:carsilla/const/assets.dart';
import 'package:carsilla/const/common_methods.dart';
import 'package:carsilla/models/user_model.dart';
import 'package:carsilla/providers/user_provider.dart';
import 'package:carsilla/utils/theme.dart';
import 'package:carsilla/screens/carlisting/search_car_screen.dart';
import 'package:carsilla/widgets/headerwithimg.dart';
import 'package:carsilla/widgets/srtbtn.dart';
import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:provider/provider.dart';

import '../../const/endpoints.dart';
import '../../providers/car_listing_provider.dart';
import 'add_car_screen.dart';
import 'view_car_details.dart';

class CarListingScreen extends StatefulWidget {
   const CarListingScreen({super.key,});

  @override
  State<CarListingScreen> createState() => _CarListingScreenState();
}

class _CarListingScreenState extends State<CarListingScreen> {

  String selectedFilter = "Used";
  bool isLoading = false;



  @override
  void initState() {
    super.initState();
    getListing();
  }

  getListing() async{
    await Provider.of<CarListingProvider>(context, listen: false)
        .getCarListingDataVmF(context, query: "${Endpoints.baseUrl}${Endpoints.getlisting}car_type=$selectedFilter");
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = getMediaSize(context);
    return Consumer<CarListingProvider>(builder: (context, vmVal, child) {
      return Consumer<UserProvider>(builder: (BuildContext context, UserProvider userProvider, Widget? child) {
        UserModel? currentUser = userProvider.getCurrentUser;
        return HeaderWithImage(
          title: 'Car Listing',
          headeimg: ImageAssets.insurnceimg1,
          marginToTopHeadeImg: -0.0,
          marginbodyfrombottom: 0.03,
          onTopOfheImage: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9 / 1,
                  height: MediaQuery.of(context).size.height * 0.055 / 1,
                  child: SearchBar(
                      hintText: 'Search',
                      hintStyle: MaterialStateProperty.all(
                          TextStyle(color: Colors.grey.shade500, fontSize: 14)),
                      leading: Icon(Icons.search, color: Colors.grey.shade600),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const SearchCarScreen()));
                      }))),
          floatingActionButton: currentUser == null ? null : FloatingActionButton(onPressed: (){},
            backgroundColor: Colors.white,
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(MainTheme.primaryColor),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.only(top: 3, bottom: 3)),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(15)))),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddCarScreen(),
                    ),
                  );
                },
                child: const Icon(Icons.add, color: Colors.white, size: 40,),
              ),
            ),),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Car Listing',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 25,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: SortButton(onclick: () {
                          selectedFilter="Used";
                          getListing();
                        }, label: 'USED',btnColor: (selectedFilter=="Used") ? MainTheme.primaryColor : Colors.white, labelColor: (selectedFilter=="Used") ? Colors.white : Colors.black54),
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        child: SortButton(onclick: (){
                          selectedFilter="Imported";
                          getListing();
                        }, label: 'IMPORTED', btnColor: (selectedFilter=="Imported") ? MainTheme.primaryColor : Colors.white, labelColor: (selectedFilter=="Imported") ? Colors.white : Colors.black54),
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        child: SortButton(onclick: () async {
                          selectedFilter="Auction";
                          getListing();
                        }, label: 'AUCTION', btnColor: (selectedFilter=="Auction") ? MainTheme.primaryColor : Colors.white, labelColor: (selectedFilter=="Auction") ? Colors.white : Colors.black54),
                      ),
                      SizedBox(width: 5,),
                      // Expanded(
                      //   child: SortButton(onclick: (){
                      //     setState(() {
                      //       selectedFilter="All";
                      //     });
                      //
                      //   }, label: 'All', btnColor: (selectedFilter=="All") ? MainTheme.primaryColor : Colors.white, labelColor: (selectedFilter=="All") ? Colors.white : Colors.black54),
                      // ),

                      // MainButton(onclick: (){}, label: 'Sorted By', btnColor: Colors.white, labelColor: Colors.grey, width: 0.22, fontSize: 8,)
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Row(
                    children: [

                      Text(
                        'We have compiled all the cars for you',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(color: Colors.grey.shade600),
                      )
                    ],
                  ),
                ),

                vmVal.carListingDataList.isNotEmpty
                    ? Wrap(
                  children: vmVal.carListingDataList
                      .map((e) {
                    double price = double.parse(e['listing_price'].toString());
                    MoneyFormatter fmf = MoneyFormatter(
                        amount: price
                    );

                    String carPrice = fmf.output.nonSymbol.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), '');

                    return (
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.42 /
                                1,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewCarDetails(
                                      carListingDetails: e,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      child: Image.network(
                                          Endpoints.imageUrl +
                                              e['listing_img1'],
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.4 /
                                              1,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height *
                                              0.1 /
                                              1,
                                          fit: BoxFit.fitWidth)),
                                  Text(
                                    e['listing_title'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                        color: Colors.grey.shade900),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context)
                                        .size
                                        .width *
                                        0.4 /
                                        1,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "AED $carPrice",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge!
                                              .copyWith(
                                              color: MainTheme
                                                  .primaryColor),
                                        ),
                                        // SizedBox(
                                        //     width: 15,
                                        //     child: GestureDetector(
                                        //       onTap: () {
                                        //         vmVal.addCarListingFav(
                                        //             e['id'].toString());
                                        //       },
                                        //       child: vmVal.carListingFavId
                                        //           .contains(e['id']
                                        //           .toString())
                                        //           ? const Icon(
                                        //         Icons.bookmark,
                                        //         color: Colors.grey,
                                        //       )
                                        //           : Image.asset(
                                        //           IconAssets.fav),
                                        //     ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                    );
                  } )
                      .toList(),
                )
                    : Center(
                  child: Text('Car Listing Empty',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.grey)),
                ),
                if(Provider.of<CarListingProvider>(context, listen: false).pagination.isNotEmpty && Provider.of<CarListingProvider>(context, listen: false).pagination['current_page'] < Provider.of<CarListingProvider>(context, listen: false).pagination['last_page'] )  (!isLoading) ? TextButton(onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await  getListing();
                  setState(() {
                    isLoading = false;
                  });

                }, child: Text('See More...', style: TextStyle(color: MainTheme.primaryColor, fontWeight: FontWeight.bold),)) : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(height: 20, width:20, child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),

        );
      },);
    });
  }
}
