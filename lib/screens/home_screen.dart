import 'package:carsilla/const/assets.dart';
import 'package:carsilla/core/reusable_widgets/images_gallary.dart';
import 'package:carsilla/screens/repair_workshop/repair_workshop_screen.dart';
import 'package:carsilla/screens/spareparts/search_spare_part_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart' as cs;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:provider/provider.dart';
import 'package:carsilla/resources/user_data.dart';

import '../const/common_methods.dart';
import '../const/endpoints.dart';
import '../services/deep_linking_handler.dart';
import '../providers/car_listing_provider.dart';
import '../providers/specification_provider.dart';
import '../utils/theme.dart';
import '../widgets/bottomnavbar.dart';
import '../widgets/header.dart';
import 'carlisting/car_listing_screen.dart';
import 'carlisting/view_car_details.dart';
import 'carlisting/search_car_screen.dart';

import 'package:async/async.dart';

class HomeScreen extends StatefulWidget {
  final String origin;
  const HomeScreen({super.key, required this.origin});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AsyncMemoizer<String> addressMemoizer = AsyncMemoizer<String>();

  TextEditingController searchController = TextEditingController();

  List servicesList = [
    {
      "icon": IconAssets.menu4,
      "title": "Spare Parts",
    },
    {
      "icon": IconAssets.menu6,
      "title": "Car Listing",
    },
    {
      "icon": IconAssets.repairWorkshop,
      // "title": "Repair Workshop",
      "title": "Workshop",
    },
  ];

  int selectedservice = 888888;

  List<String> bannersPath = [
    'assets/images/1.jpg',
    'assets/images/2.jpg',
    'assets/images/3.jpg',
    'assets/images/4.jpg',
  ];

  bool isShowAllListing = false;

  @override
  void initState() {
    // print('_HomePageState.initState ------ origin ${widget.origin}');
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        AppLinksDeepLink.instance.getInitialRoute(appLinkUri);
      },
    );
    getData(context);
    SpecificationProvider.getBrands();
    SpecificationProvider.getWorkshopServices();
    checkLocationPermission(context);
    super.initState();
  }

  getData(BuildContext context) async {
    if (context.mounted) {
      await Provider.of<CarListingProvider>(context, listen: false)
          .getRecentCarListingDataVmF(context,
              query:
                  '${Endpoints.baseUrl}${Endpoints.getlisting}car_type=Used');
      if (context.mounted) {
        await Provider.of<CarListingProvider>(context, listen: false)
            .getCarListingDataVmF(context,
                query:
                    '${Endpoints.baseUrl}${Endpoints.getlisting}car_type=Used');
      }
    }
  }

  String locName = "";
  double currentLat = 31.511900543125236;
  double currentLon = 74.43805270740967;
  bool isLoading = false;

  ///// get locatiion
  Future<String> getLocationAddress() async {
    Position currentLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    currentLat = currentLocation.latitude;
    currentLon = currentLocation.longitude;
    List<Placemark> placemarks = await placemarkFromCoordinates(
      currentLat,
      currentLon,
    );
    if (placemarks.isNotEmpty) {
      dynamic cityName = placemarks[0].locality ?? "Unknown";
      dynamic street = placemarks[0].country ?? "Unknown";
      locName = '$cityName, $street';
    }

    return locName.toUpperCase();
  }

  List<dynamic> displayedCars = [];
  String selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    return Header(
      enableBackButton: false,
      title: 'Home',
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.01 / 1),
            Row(
              children: [
                Text('Welcome to Carlly',
                    style: textTheme.headlineLarge!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 21)),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: Colors.grey.shade500.withOpacity(0.9),
                ),
                FutureBuilder<String>(
                    future: addressMemoizer.runOnce(
                      () => getLocationAddress(),
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done)
                        return Text('${snapshot.data}',
                            style: textTheme.labelMedium!.copyWith(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w400,
                            ));
                      return const SizedBox();
                    }),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02 / 1),

            // comment by @CallofCoding
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.06 / 1,
            //   child: CustomTextFormField(
            //     width: MediaQuery.of(context).size.width * 0.92 / 1,
            //     hintText: 'Search',
            //     prefix: IconButton(
            //         onPressed: () {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => CarFilterPage(
            //                       searchVal: searchController.text)));
            //         },
            //         icon: Icon(Icons.search,
            //             color: Colors.grey.shade700, size: 23)),
            //   ),
            // ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02 / 1),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: cs.FlutterCarousel(
                  items: bannersPath
                      .map(
                        (e) => ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                              width:
                                  MediaQuery.of(context).size.width * 0.91 / 1,
                              height: MediaQuery.of(context).size.height *
                                  0.185 /
                                  1,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.white,
                                        blurRadius: 0.7,
                                        offset: Offset(0, 1))
                                  ]),
                              child: Image.asset(e)),
                        ),
                      )
                      .toList()

                  /* [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.91 / 1,
                          height: MediaQuery.of(context).size.height * 0.185 / 1,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.white,
                                    blurRadius: 0.7,
                                    offset: Offset(0, 1))
                              ]),
                          child: Image.asset('assets/images/banneer1.jpg')),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.91 / 1,
                          height: MediaQuery.of(context).size.height * 0.185 / 1,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.white,
                                    blurRadius: 0.7,
                                    offset: Offset(0, 1))
                              ]),
                          child: Image.asset('assets/images/banneer2.jpg')),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.91 / 1,
                        height: MediaQuery.of(context).size.height * 0.185 / 1,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 0.7,
                                  offset: const Offset(0, 1))
                            ]),
                        child: Stack(
                          children: [
                            Image.asset(ImageAssets.homebanner),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Text(
                                'BEST CAR \nREPAIR \nSERVICES',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ],
                        )),
                  ]*/
                  ,
                  options: cs.CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.185 / 1,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1.0,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 2),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    controller: cs.CarouselController(),
                    pageSnapping: true,
                    scrollDirection: Axis.horizontal,
                    pauseAutoPlayOnTouch: true,
                    pauseAutoPlayOnManualNavigate: true,
                    pauseAutoPlayInFiniteScroll: false,
                    enlargeStrategy: cs.CenterPageEnlargeStrategy.scale,
                    disableCenter: false,
                    floatingIndicator: true,
                    showIndicator: true,
                    slideIndicator: cs.CircularSlideIndicator(
                        slideIndicatorOptions: cs.SlideIndicatorOptions(
                            indicatorRadius: 4,
                            indicatorBorderWidth: 2,
                            currentIndicatorColor: MainTheme.primaryColor,
                            indicatorBackgroundColor: Colors.grey.shade300)),
                  )),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02 / 1),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Services",
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
            _buildList1(context),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01 / 1),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Most Recent",
                    textAlign: TextAlign.left,
                    style: textTheme.titleSmall!.copyWith(
                        color: MainTheme.primaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01 / 1),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.205 / 1,
              child: Consumer<CarListingProvider>(
                  builder: (context, carListingValVm, child) {
                List<dynamic> filteredList =
                    List.from(carListingValVm.recentListing
                        .where(
                          (element) => element['car_type'] == "Used",
                        )
                        .toList());

                if (filteredList.isEmpty) {
                  return const SizedBox(height: 10);
                }

                return ListView.builder(
                  itemCount:
                      (filteredList.length < 8) ? filteredList.length : 8,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  controller: ScrollController(),
                  itemBuilder: (BuildContext context, int index) {
                    final data = filteredList[index];
                    double price =
                        double.parse(data['listing_price'].toString());
                    MoneyFormatter fmf = MoneyFormatter(amount: price);

                    String carPrice = fmf.output.nonSymbol
                        .toString()
                        .replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), '');
                    return data == null
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewCarDetails(
                                        carListingDetails: data,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.47 /
                                      1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: MainTheme.primaryColor,
                                        width: 1),
                                  ),
                                  child: Padding(
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
                                              builder: (context) =>
                                                  ViewCarDetails(
                                                carListingDetails: data,
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
                                                child:
                                                data['images'].isNotEmpty?
                                                Stack(
                                                  children: [
                                                    Image.network(
                                                        // Endpoints.imageUrl +
                                                        //     (data['listing_img1'] ??
                                                        //         ''),
                                                      data['images'][0]['image'].toString(),
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.4 /
                                                                1,
                                                        height:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .height *
                                                                0.1 /
                                                                1,
                                                        fit: BoxFit.fitWidth),
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
                                                              ImagesGallery().zoomIn(context,data['images']);
                                                            },
                                                            child: Icon(Icons.zoom_in,color: Colors.white,)),
                                                      ),
                                                    )
                                                  ],
                                                )

                                                    :Image.asset('assets/images/no_image.png',
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.4 /
                                                        1,
                                                    height:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                        0.1 /
                                                        1,
                                                    fit: BoxFit.contain
                                                )),
                                            Text(
                                              data['listing_title'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall!
                                                  .copyWith(
                                                      color:
                                                          Colors.grey.shade900),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4 /
                                                  1,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );

                    // : Center(
                    //     child: Text('Have No Insurance Company',
                    //         style: Theme.of(context)
                    //             .textTheme
                    //             .titleLarge!
                    //             .copyWith(color: Colors.grey)),
                    //   );
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CarListingScreen()));
                    },
                    child: const Text('See All'),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Top Brands",
                    textAlign: TextAlign.left,
                    style: textTheme.titleSmall!.copyWith(
                        color: MainTheme.primaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        getListing("search=Jeep");
                        setState(() {
                          selectedFilter = "Jeep";
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/images/jeep-logo.webp',
                            height: 30,
                          ),
                          if (selectedFilter == "Jeep")
                            const SizedBox(
                                height: 8,
                                child: Divider(
                                  color: MainTheme.primaryColor,
                                  thickness: 3,
                                ))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        getListing("search=Hyundai");
                        setState(() {
                          selectedFilter = "Hyundai";
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/images/hyundai-logo.webp',
                            height: 30,
                          ),
                          if (selectedFilter == "Hyundai")
                            const SizedBox(
                                height: 8,
                                child: Divider(
                                    color: MainTheme.primaryColor,
                                    thickness: 3))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        getListing("search=Honda");
                        setState(() {
                          selectedFilter = "Honda";
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/images/honda-logo.webp',
                            height: 30,
                            width: 40,
                          ),
                          if (selectedFilter == "Honda")
                            const SizedBox(
                                height: 8,
                                child: Divider(
                                  color: MainTheme.primaryColor,
                                  thickness: 3,
                                ))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          getListing("search=BMW");
                          selectedFilter = "BMW";
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/images/bmw-logo.webp',
                            height: 30,
                          ),
                          if (selectedFilter == "BMW")
                            const SizedBox(
                                height: 8,
                                child: Divider(
                                  color: MainTheme.primaryColor,
                                  thickness: 3,
                                ))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        getListing("search=Ferrari");
                        setState(() {
                          selectedFilter = "Ferrari";
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset('assets/images/ferrari-logo.webp',
                              height: 30, width: 40),
                          if (selectedFilter == "Ferrari")
                            const SizedBox(
                                height: 8,
                                child: Divider(
                                  color: MainTheme.primaryColor,
                                  thickness: 3,
                                ))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        getListing("search=Tesla");
                        setState(() {
                          selectedFilter = "Tesla";
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/images/tesla-logo.webp',
                            height: 30,
                          ),
                          if (selectedFilter == "Tesla")
                            const SizedBox(
                                height: 8,
                                child: Divider(
                                  color: MainTheme.primaryColor,
                                  thickness: 3,
                                ))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        getListing("");
                        setState(() {
                          selectedFilter = "All";
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'All',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          if (selectedFilter == "All")
                            const SizedBox(
                                height: 8,
                                child: Divider(
                                  color: MainTheme.primaryColor,
                                  thickness: 3,
                                ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CarListingScreen()));
                    },
                    child: const Text('See All'),
                  )
                ],
              ),
            ),

            Consumer<CarListingProvider>(
              builder: (context, carListingValVm, child) {
                displayedCars = List.from(carListingValVm.carListingDataList
                    .where((element) => element['car_type'] == "Used")
                    .toList());
                return (isLoading)
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : displayedCars.isNotEmpty
                        ? GridView.builder(
                            itemCount: displayedCars.length >= 8
                                ? 8
                                : displayedCars.length,
                            controller: ScrollController(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (BuildContext context, int index) {
                              final e = displayedCars[index];
                              // print('888888888888888888888${e['images'][0]['image'].toString()}');
                              double price =
                                  double.parse(e['listing_price'].toString());
                              MoneyFormatter fmf =
                                  MoneyFormatter(amount: price);

                              String carPrice = fmf.output.nonSymbol
                                  .toString()
                                  .replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), '');
                              return Padding(
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
                                            child:
                                            e['images'].isNotEmpty?
                                            Stack(
                                              children: [
                                                Image.network(
                                                    // Endpoints.imageUrl +
                                                    //     (e['listing_img1'] ?? ''),
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
                                                    fit: BoxFit.fitWidth),
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
                                                )
                                              ],
                                            ):Center(child: Image.asset('assets/images/no_image.png'))),
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
                                              SizedBox(
                                                  width: 15,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      carListingValVm
                                                          .addCarListingFav(
                                                              e['id']
                                                                  .toString());
                                                    },
                                                    child: carListingValVm
                                                            .carListingFavId
                                                            .contains(e['id']
                                                                .toString())
                                                        ? const Icon(
                                                            Icons.bookmark,
                                                            color: Colors.grey,
                                                          )
                                                        : Image.asset(
                                                            IconAssets.fav),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })
                        : Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Text('Car Listing Empty',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(color: Colors.grey)),
                            ),
                          );
              },
            ),
            // if(displayedCars.length > 6)Center(
            //   child: TextButton(
            //       onPressed: () {
            //
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => CarListingPage(),
            //           ),
            //         );
            //       },
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: [
            //           Text(
            //             'See More...',
            //             style: Theme.of(context)
            //                 .textTheme
            //                 .labelLarge!
            //                 .copyWith(color: MainTheme.primaryColor),
            //           ),
            //           const Icon(Icons.visibility_outlined)
            //         ],
            //       )),
            // ),

            // Wrap(
            //   children: carListing
            //       .map((e) => Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: SizedBox(
            //               width: MediaQuery.of(context).size.width * 0.42 / 1,
            //               child: GestureDetector(
            //                 onTap: () {},
            //                 child: Column(
            //                   mainAxisAlignment: MainAxisAlignment.start,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     ClipRRect(
            //                         borderRadius: BorderRadius.circular(10),
            //                         child: Image.asset(e['img'])),
            //                     Text(
            //                       e['title'],
            //                       style: Theme.of(context)
            //                           .textTheme
            //                           .labelSmall!
            //                           .copyWith(color: Colors.grey.shade900),
            //                     ),
            //                     SizedBox(
            //                       width: MediaQuery.of(context).size.width *
            //                           0.4 /
            //                           1,
            //                       child: Row(
            //                         mainAxisAlignment:
            //                             MainAxisAlignment.spaceBetween,
            //                         children: [
            //                           Text(
            //                             "\$${e['price']}",
            //                             style: Theme.of(context)
            //                                 .textTheme
            //                                 .labelLarge!
            //                                 .copyWith(
            //                                     color: MainTheme.primaryColor),
            //                           ),
            //                           SizedBox(
            //                               width: 13,
            //                               child: Image.asset(IconAssets.fav))
            //                         ],
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ))
            //       .toList(),
            // ),
          ],
        ),
      ),
      navbar: const NavBarWidget(
        currentScreen: 'Home',
      ),
    );
  }

  /// Section Widget
  Widget _buildList1(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.separated(
        itemCount: servicesList.length,
        // ),
        padding: const EdgeInsets.only(right: 6),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 4);
        },
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 6),
            child: GestureDetector(
              onTap: () {
                if (index == 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchSparePartScreen()));
                } else if (index == 1) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchCarScreen()));
                } else if (index == 2) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RepairWorkshopScreen()));
                }

                setState(() {
                  selectedservice = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                width: MediaQuery.of(context).size.width * 0.36,
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
                              backgroundColor: selectedservice == index
                                  ? Colors.white
                                  : Colors.grey.shade300,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Image.asset(servicesList[index]['icon']),
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(servicesList[index]['title'],
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: /*selectedservice == index
                                ? Colors.white
                                :*/
                                Colors.grey.shade500,
                            fontSize: 12)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> getListing(String filter) async {
    setState(() {
      isLoading = true;
    });
    await Provider.of<CarListingProvider>(context, listen: false)
        .getCarListingDataVmF(context,
            query: Endpoints.baseUrl + Endpoints.getlisting + filter);
    final vmIntVal = Provider.of<CarListingProvider>(context, listen: false);
    displayedCars = List.from(vmIntVal.carListingDataList);
    setState(() {
      isLoading = false;
    });
  }
  ////////////////
}
