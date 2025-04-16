import 'dart:convert';
import 'dart:developer';

import 'package:carsilla/const/assets.dart';
import 'package:carsilla/const/common_methods.dart';
import 'package:carsilla/providers/user_provider.dart';
import 'package:carsilla/utils/theme.dart';
import 'package:carsilla/screens/GoogleMap/view_location_on_map.dart';
import 'package:carsilla/screens/carlisting/edit_car_details.dart';
import 'package:carsilla/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart' as cs;
import 'package:money_formatter/money_formatter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../const/endpoints.dart';
import '../../models/user_model.dart';
import '../../utils/ui_utils.dart';
import '../../providers/car_listing_provider.dart';
import '../../widgets/btn.dart';
import '../../widgets/header.dart';
import 'package:faabul_color_picker/faabul_color_picker.dart';
import 'package:http/http.dart' as http;

class ViewCarDetails extends StatefulWidget {
  final Map? carListingDetails;
  const ViewCarDetails({super.key, this.carListingDetails});

  @override
  State<ViewCarDetails> createState() => _ViewCarDetailsState();
}

class _ViewCarDetailsState extends State<ViewCarDetails> {
  List carList = [];
  String degreeImage = '';
  List featuresList = [
    // {'img': IconAssets.features1, 'title': 'Gear', 'subtitle': 'Autometic'},
    // {
    //   'img': IconAssets.features2,
    //   'title': 'Acceleration',
    //   'subtitle': '1.2s 100km/hr'
    // },
    // {'img': IconAssets.features3, 'title': 'Cyl', 'subtitle': '12 Cyl'},
    // {
    //   'img': IconAssets.features4,
    //   'title': 'Climate Control',
    //   'subtitle': 'Autometic'
    // },
    // {'img': IconAssets.features5, 'title': 'open', 'subtitle': 'Gasoline'},
    // {
    //   'img': IconAssets.features6,
    //   'title': 'Seat Heating',
    //   'subtitle': 'Two Seat'
    // },
  ];

  UserModel? currentUser;
  bool isLoading = false;

  @override
  void initState() {
    currentUser = context.read<UserProvider>().getCurrentUser;

    // carList.add(Endpoints.imageUrl + widget.carListingDetails!['listing_img1']);
    // if (widget.carListingDetails!['listing_img2'] != "icons/carvector.jpg" &&
    //     widget.carListingDetails!['listing_img2'] != "")
    //   carList
    //       .add(Endpoints.imageUrl + widget.carListingDetails!['listing_img2']);
    // if (widget.carListingDetails!['listing_img3'] != "icons/carvector.jpg" &&
    //     widget.carListingDetails!['listing_img3'] != "")
    //   carList
    //       .add(Endpoints.imageUrl + widget.carListingDetails!['listing_img3']);
    // if (widget.carListingDetails!['listing_img4'] != "icons/carvector.jpg" &&
    //     widget.carListingDetails!['listing_img4'] != "")
    //   carList
    //       .add(Endpoints.imageUrl + widget.carListingDetails!['listing_img4']);
    // if (widget.carListingDetails!['listing_img5'] != "icons/carvector.jpg" &&
    //     widget.carListingDetails!['listing_img5'] != "")
    //   carList
    //       .add(Endpoints.imageUrl + widget.carListingDetails!['listing_img5']);
    carList.clear();
    List<dynamic> images = widget.carListingDetails!['images'];
    images.forEach((e){
      carList.add(e);
    });
    featuresList.add({
      'title': 'Type',
      'subtitle': widget.carListingDetails!['listing_type'] ?? "No Selection"
    });
    featuresList.add({
      'title': 'Model',
      'subtitle': widget.carListingDetails!['listing_model'] ?? "No Selection"
    });
    featuresList.add({
      'title': 'Year',
      'subtitle': widget.carListingDetails!['listing_year'] ?? "No Selection"
    });
    featuresList.add({
      'title': 'Regional Spec',
      'subtitle': widget.carListingDetails!['regional_specs'] ?? "No Selection"
    });
    featuresList.add({
      'title': 'Body Type',
      'subtitle': widget.carListingDetails!['body_type'] ?? "No Selection"
    });
    featuresList.add({
      'title': 'City',
      'subtitle': widget.carListingDetails!['city'] ?? "No Selection"
    });

    featuresList.add({
      'img': IconAssets.features1,
      'title': 'Gear',
      'subtitle': widget.carListingDetails!['features_gear'] ?? "No Selection"
    });
    featuresList.add({
      'img': IconAssets.features2,
      'title': 'Mileage',
      'subtitle': widget.carListingDetails!['features_speed'] ?? "No Selection"
    });
    featuresList.add({
      'img': IconAssets.features3,
      'title': 'Color',
      'subtitle': widget.carListingDetails!['car_color'] ?? "No Selection"
    });
    featuresList.add({
      'img': IconAssets.features4,
      'title': 'Warranty',
      'subtitle':
          widget.carListingDetails!['features_climate_zone'] ?? "No Selection"
    });
    featuresList.add({
      'img': IconAssets.features5,
      'title': 'Fuel Type',
      'subtitle':
          widget.carListingDetails!['features_fuel_type'] ?? "No Selection"
    });
    featuresList.add({
      'img': IconAssets.features6,
      'title': 'Seats',
      'subtitle': widget.carListingDetails!['features_seats'] ?? "No Selection"
    });
    featuresList.add({
      'title': 'Vin Number',
      'subtitle': widget.carListingDetails!['vin_number'] ?? "No Selection"
    });

    featuresList.add({
      'title': 'Car Features',
      'subtitle':''
          //displayCarFeaturesList(widget.carListingDetails!['features_others'])
    });

    if (widget.carListingDetails!['car_type'] == "Auction") {
      featuresList.add({
        'title': 'Auction Name',
        'subtitle': widget.carListingDetails!['auction_name'] ?? "No Selection"
      });
      featuresList.add({
        'img': IconAssets.features6,
        'title': 'Auction Date',
        'subtitle': widget.carListingDetails!['pickup_date'] ?? "No Selection"
      });
      featuresList.add({
        'title': 'Auction Time',
        'subtitle': widget.carListingDetails!['pickup_time'] ?? "No Selection"
      });
      featuresList.add({
        'title': 'Auction Location',
        'subtitle': widget.carListingDetails!['location'] ?? "No Selection"
      });
    }
    super.initState();
  }

  String displayCarFeaturesList(dynamic data) {
    print('ccccccccccccccc');
    print(data);
    print('ccccccccccccccc');

    String carFeatures = '';
    if (data != null) {
      if (data is String) {
        List<String> featuresList = List.from(jsonDecode(data));
        carFeatures = featuresList.join(', ');
      } else {
        List<String> featureList = List.from(data);
        carFeatures = featureList.join(', ');
      }
    }
    return carFeatures;
  }

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

  Future<void> _deleteCar() async {
    try {
      setState(() {
        isLoading = true;
      });
      String apiEndPoint = "${Endpoints.baseUrl}delCar";

      String? token = await getAuthToken();

      if (token == null) {
        return;
      }

      var request = http.MultipartRequest('POST', Uri.parse(apiEndPoint));
      // Add headers
      request.headers['Authorization'] = token;
      request.fields['list_id'] = widget.carListingDetails!['id'].toString();

      var response = await request.send();
      log(response.toString());
      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var responseString = responseData.body;
        var bodydata = jsonDecode(responseString);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(bodydata['message'])));

        await Provider.of<CarListingProvider>(context, listen: false)
            .getMyCarListingDataVmF(context);
        await Provider.of<CarListingProvider>(context, listen: false)
            .getRecentCarListingDataVmF(context);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const HomeScreen(
                      origin: 'details',
                    )),
            (route) => false);
        // Provider.of<SparePartsVmC>(context, listen: false).getSparePartsVmF(context);
      } else {
        print(
            '💥 Error deleting car : status code:${response.statusCode} response:${await response.stream.bytesToString()}');
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      UiUtils(context).showSnackBar("$e");
      print('💥 ${e.toString()}----try catch----');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = getMediaSize(context);

    double carPrice =
        double.parse(widget.carListingDetails!['listing_price'].toString());
    MoneyFormatter fmf = MoneyFormatter(amount: carPrice);
    String price = fmf.output.nonSymbol
        .toString()
        .replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), '');
    return Header(
      enableBackButton: true,
      title: 'Details',
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.03 / 1),
            Center(
              child: Text(
                widget.carListingDetails!['listing_title'],
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: cs.FlutterCarousel(
                  items: carList.map((e) {


                    return ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Stack(
                          children: [
                            Image.network(e['image'].toString(),
                                width: MediaQuery.of(context).size.width *
                                    0.95 /
                                    1,
                                height: MediaQuery.of(context).size.height *
                                    0.25 /
                                    1,
                                fit: BoxFit.fitWidth,
                      errorBuilder: (context, child, erorr) =>
                          Image.asset(IconAssets.carvector,fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width ,
                            height: size.width * 0.43,
                            )),
                            Positioned.fill(
                                bottom: 30,
                                child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      height: 50,
                                      width: 70,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/water_mark.png"),
                                      )),
                                    )))
                          ],
                        ));
                  }).toList(),
                  options: cs.CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.28 / 1,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1.0,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: false,
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
            widget.carListingDetails!['listing_desc'] != null
                ? Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05 / 1,
                      ),
                      ListTile(
                        title: Text(
                          widget.carListingDetails!['listing_desc'] ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(color: Colors.grey.shade600),
                        ),
                      ),
                      SizedBox(
                          height:
                              MediaQuery.of(context).size.height * 0.02 / 1),
                    ],
                  )
                : SizedBox(),
            Wrap(
                children: featuresList
                    .map((e) => Container(
                          decoration: const BoxDecoration(color: Colors.white),
                          width: MediaQuery.of(context).size.width * 0.46 / 1,
                          child: ListTile(
                            //leading: Image.asset(e['img']),
                            title: Text("${e['title']} ",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade500)),
                            subtitle: e['title'] == 'Color'
                                ? FaabulColorSample(
                                    size: 10,
                                    color: colors[int.tryParse(e['subtitle']) ??
                                        3] /*parseColor(e['subtitle'])*/)
                                : Text(
                                    e['subtitle'].toString(),
                                  ),
                          ),
                        ))
                    .toList()),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01 / 1),
            ListTile(
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.carListingDetails!['car_type'] == "Auction")
                    Text("Staring Price",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade500)),
                  Text(
                    'AED ${price}',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: MainTheme.primaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            ((widget.carListingDetails?['user']?['id']?.toString() ?? '') ==
                    currentUser?.id?.toString())
                ? SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          MainButton(
                              isLoading: isLoading,
                              onclick: () async {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Delete Car'),
                                        content: Text(
                                            'Do you want to delete this car?'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('No')),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _deleteCar();
                                              },
                                              child: Text('Yes')),
                                        ],
                                      );
                                    });
                              },
                              label: 'Delete Car'),
                          MainButton(
                            btnColor: Colors.grey,
                            labelColor: Colors.white,
                            onclick: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditCarDetails(
                                        carDetails: widget.carListingDetails),
                                  ));
                            },
                            label: 'Edit Details',
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: MainButton(
                                      label: 'Call',
                                      onclick: () async {
                                        print(
                                            '_DetailsCarsPageState.build---------${widget.carListingDetails.toString()}');

                                        String calUrl =
                                            "tel: ${widget.carListingDetails!['contact_number'].toString().replaceAll(',', '')}";
                                        final Uri _url = Uri.parse(calUrl);
                                        if (!await launchUrl(_url)) {
                                          throw Exception(
                                              'Could not launch $_url');
                                        }
                                      })),
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                  child: MainButton(
                                label: 'Open Map',
                                onclick: () async {
                                  if (widget.carListingDetails!['location'] ==
                                          null &&
                                      widget.carListingDetails!['lat'] ==
                                          null &&
                                      widget.carListingDetails!['lng'] ==
                                          null) {
                                    UiUtils(context).showSnackBar(
                                        'Location is not available');
                                    return;
                                  }

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewLocationOnMap(
                                            latitude: widget
                                                .carListingDetails!['lat'],
                                            longitude: widget
                                                .carListingDetails!['lng'],
                                            address: widget.carListingDetails![
                                                'location']),
                                      ));

                                  // String encodedAddress = Uri.encodeQueryComponent(widget.carListingDetails!['location']);
                                  // // Create the Google Maps URL
                                  // String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$encodedAddress";
                                  // final Uri _url = Uri.parse(googleMapsUrl);
                                  // if (!await launchUrl(_url)) {
                                  //   throw Exception('Could not launch $_url');
                                  //   }
                                },
                              ))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: MainButton(
                                    btnColor: Colors.teal,
                                    onclick: () async {
                                      var data = widget.carListingDetails;
                                      String message = Uri.encodeComponent(
                                          "((Carlly Motors))\n\n"
                                          "مرحبًا، أتواصل معك للاستفسار عن *السيارة* المعروضة للبيع، ${data!['listing_title'].toString()}، في Carlly Motors. هل لا تزال متوفرة؟\n\n"
                                          "Hello, We are contacting you about the *car* for sale, ${data['listing_title'].toString()}, at Carlly Motors. Is it available?\n\n"
                                          "*Car Model* : ${data['listing_model']}\n"
                                          "*Car Type* : ${data['listing_type']}\n"
                                          "*Year Of Manufacture* : ${data['listing_year']}\n"
                                          "*Car Price* : ${data['listing_price']} AED\n"
                                          "*Car URL* : https://carllymotors.com/car-listing/?id=${data['id']}");

                                      String mapsUrl =
                                          "https://wa.me/${widget.carListingDetails!['wa_number'].toString().replaceAll(',', '')}?text=$message";
                                      final Uri _url = Uri.parse(mapsUrl);
                                      if (!await launchUrl(_url)) {
                                        throw Exception(
                                            'Could not launch $_url');
                                      }
                                    },
                                    label: 'WhatsApp Chat'),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: MainButton(
                                    onclick: () async {
                                      var data = widget.carListingDetails;
                                      String shareUrl =
                                          "https://carllymotors.com/car-listing/?id=${data?['id'] ?? ''}";
                                      String message =
                                          "Check out my latest find on Carlly! Great deals await. Don’t miss out!\n$shareUrl";
                                      await Share.share(message);
                                    },
                                    label: 'Share'),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
