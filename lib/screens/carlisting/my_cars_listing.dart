import 'package:carsilla/models/user_model.dart';
import 'package:carsilla/providers/user_provider.dart';
import 'package:carsilla/screens/carlisting/add_car_screen.dart';
import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:provider/provider.dart';

import '../../utils/theme.dart';
import '../../const/endpoints.dart';
import '../../providers/car_listing_provider.dart';
import '../../widgets/bottomnavbar.dart';
import '../../widgets/btn.dart';
import '../../widgets/header.dart';
import '../auth/login_by_phone_screen.dart';
import 'view_car_details.dart';

class MyCarsListing extends StatefulWidget {
  const MyCarsListing({super.key});

  @override
  State<MyCarsListing> createState() => _MyCarsListingState();
}

class _MyCarsListingState extends State<MyCarsListing> {

  List displayedCars = [];

  bool isLoading = false;


  @override
  void initState() {
    // TODO: implement initState
    Provider.of<CarListingProvider>(context, listen: false).getMyCarListingDataVmF(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (BuildContext context, UserProvider userProvider, Widget? child) {
      UserModel? currentUser = userProvider.getCurrentUser;
      return Header(
        enableBackButton: false,
        title: 'My Listing',
        floatingActionButton: currentUser == null ? null :FloatingActionButton(onPressed: (){},
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
          child: currentUser == null ? Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.01 / 1),
              Row(
                children: [
                  Text('My Cars',
                      style: textTheme.headlineLarge!.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 21)),
                ],
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.3),
              Text('Please Sign In to sell your car.',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: MainTheme.primaryColor),),
              SizedBox(
                height: 24,
              ),MainButton(onclick: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginByPhoneScreen(),));
              },label: 'Sign In',)
            ],
          ) : Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.01 / 1),
              Row(
                children: [
                  Text('My Cars',
                      style: textTheme.headlineLarge!.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 21)),
                ],
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.01 / 1),
              Consumer<CarListingProvider>(
                builder: (context, carListingValVm, child) {
                  displayedCars = List.from(carListingValVm.myCarListingDataList);
                  print('hhhhhhhhhhhhhhhhhhhh${displayedCars[0].toString()}');
                  return displayedCars.isNotEmpty
                      ? Align(
                    alignment: Alignment.topLeft,
                    child: Wrap(
                      children: displayedCars
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
                                    print('-----------(e) ${e.toString()}');
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
                                      e['images'].isNotEmpty?
                                      ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          child: Image.network(
                                              // Endpoints.imageUrl +
                                              //     e['listing_img1'],
                                               e['images'][0]['image'],
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
                                              fit: BoxFit.fitWidth)):Container(
                                          height: 80,
                                          width: MediaQuery.of(context).size.width,
                                          color: MainTheme.primaryColor.withOpacity(0.1),
                                          child: Icon(Icons.warning_rounded,size: 50,)),
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
                                          MainAxisAlignment.start,
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
                    ),
                  )
                      : Center(
                    child: Text('Car Listing Empty',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.grey)),
                  );
                },
              ),
              if(Provider.of<CarListingProvider>(context, listen: false).myListingPagination.isNotEmpty && Provider.of<CarListingProvider>(context, listen: false).myListingPagination['current_page'] < Provider.of<CarListingProvider>(context, listen: false).myListingPagination['last_page'] )  (!isLoading) ? TextButton(onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await  Provider.of<CarListingProvider>(context, listen: false).getMyCarListingDataVmF(context);
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
        navbar: const NavBarWidget(currentScreen: 'MyListing',),
      );
    },);
  }
}
