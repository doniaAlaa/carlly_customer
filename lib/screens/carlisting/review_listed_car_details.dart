import 'dart:io';

import 'package:carsilla/const/assets.dart';
import 'package:carsilla/models/user_model.dart';
import 'package:carsilla/providers/user_provider.dart';
import 'package:carsilla/utils/theme.dart';
import 'package:carsilla/screens/home_screen.dart';
import 'package:faabul_color_picker/faabul_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/car_listing_provider.dart';
import '../../widgets/btn.dart';
import '../../widgets/header.dart';

class ReviewListedCarDetails extends StatefulWidget {
  final String? car;
  final String? region;
  final String? bodyType;
  final String? city;

  final String? title;
  final String? type;
  final String? desc;
  final String? price;
  final String? image;
  final String? gearF;
  final String? speedF;
  final int? cylF;
  final String? climatesF;
  final String? fuelF;
  final String? seatsF;
  final String? id;
  final String? model;
  final String? year;

  final LatLng? latLng;
  final String? locationAddress;

  final String? whatsAppContact;
  final String? contactNumber;
  final String? vinNumber;

  final List? imagesList;
  final List? featuresList;
  const ReviewListedCarDetails(
      {super.key,
        this.id,
        this.car,
        this.bodyType,
        this.region,
        this.city,
        this.model,
        this.year,
        this.imagesList,
        this.featuresList,
      this.gearF = '',
      this.title = '',
      this.type = '',
      this.desc = '',
      this.price = '',
      this.image = '',
      this.speedF = '',
      this.cylF = 3,
      this.climatesF = '',
      this.fuelF = '',
      this.seatsF = '', this.whatsAppContact, this.contactNumber, this.latLng, this.locationAddress, this.vinNumber});

  @override
  State<ReviewListedCarDetails> createState() => _ReviewListedCarDetailsState();
}

class _ReviewListedCarDetailsState extends State<ReviewListedCarDetails> {
  List featuresList = [];

  UserModel? currentUser;

  @override
  void initState() {

    currentUser = context.read<UserProvider>().getCurrentUser;

    featuresList.add({
      'title': 'Type',
      'subtitle': widget.car
    });
    featuresList.add({
      'title': 'Model',
      'subtitle': widget.model
    });
    featuresList.add({
      'title': 'Year',
      'subtitle': widget.year
    });
    featuresList.add({
      'title': 'Regional Spec',
      'subtitle': widget.region
    });
    featuresList.add({
      'title': 'Body Type',
      'subtitle': widget.bodyType
    });
    featuresList.add({
      'title': 'City',
      'subtitle': widget.city
    });

    featuresList.add({
      'img': IconAssets.features1,
      'title': 'Gear',
      'subtitle': widget.gearF
    });
    featuresList.add({
      'img': IconAssets.features2,
      'title': 'Mileage',
      'subtitle': widget.speedF,
    });
    featuresList.add({
      'img': IconAssets.features3,
      'title': 'Color',
      'subtitle': widget.cylF,
    });
    featuresList.add({
      'img': IconAssets.features4,
      'title': 'Warranty',
      'subtitle': widget.climatesF,
    });
    featuresList.add({
      'img': IconAssets.features5,
      'title': 'Fuel Type',
      'subtitle': widget.fuelF,
    });
    featuresList.add({
      'img': IconAssets.features6,
      'title': 'Seats',
      'subtitle': widget.seatsF,
    });
    featuresList.add({
      'title': 'Vin Number',
      'subtitle': widget.vinNumber,
    });
    super.initState();
  }

  static const _channel = MethodChannel("flutter_share_plus");

  bool isLoading = false;

// String _platformVersion = 'Unknown';
  // Future<void> initPlatformState() async {
  //   String platformVersion;
  //   try {
  //     platformVersion = await FlutterSharePlus.platformVersion;
  //   } on PlatformException {
  //     platformVersion = 'Failed to get platform version.';
  //   }
  //   if (!mounted) return;

  //   setState(() {
  //     _platformVersion = platformVersion;
  //   });
  // }

  Future<void> share_text(String message) async {
    await _channel
        .invokeMethod('share_text', <String, String>{'message': message});
  }

  @override
  Widget build(BuildContext context) {
    return Header(
      enableBackButton: true,
      title: 'Car Listed',
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 14.0, left: 14, right: 14, bottom: 4),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      'Your Car is going to listed.',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: MainTheme.primaryColor),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.008 / 1),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.title!,
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade900)),
                  Text('AED ${widget.price!}',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: MainTheme.primaryColor)),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('type',
                      // widget.type!,
                      style: textTheme.labelSmall!.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade500)),
                  Row(
                    children: [
                      Icon(
                        Icons.visibility_outlined,
                        color: Colors.grey.shade400,
                        size: 17,
                      ),
                      Text('1 views',
                          style: textTheme.labelSmall!.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade500)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01 / 1),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Image.file(File(widget.image!),
                  errorBuilder: (context, c, error) =>
                      Image.asset(IconAssets.carvector)),
              // child: Image.asset(ImageAssets.femalecar),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Features',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade900)),
                  // GestureDetector(
                  //   onTap: () async {
                  //     share_text('https://google.com');
                  //   },
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       Text('Share',
                  //           style: Theme.of(context)
                  //               .textTheme
                  //               .titleSmall!
                  //               .copyWith(
                  //                   fontWeight: FontWeight.w500,
                  //                   color: Colors.grey.shade900)),
                  //       SizedBox(
                  //           width: 34, child: Image.asset(IconAssets.share)),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01 / 1),
            Center(
              child: Wrap(
                  children: featuresList
                      .map((e) => Container(
                            decoration: const BoxDecoration(color: Colors.white),
                            width: MediaQuery.of(context).size.width * 0.46 / 1,
                            child: ListTile(
                              //leading: Image.asset(e['img']),
                              title: Text(e['title'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade500)),
                              subtitle: e['title'] == 'Color'
                                  ? FaabulColorSample(
                                      size: 10, color: colors[e['subtitle']])
                                  : Text(e['subtitle'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade900)),
                              // subtitle: Text(e['subtitle'],
                              //     style: Theme.of(context)
                              //         .textTheme
                              //         .labelLarge!
                              //         .copyWith(
                              //             fontWeight: FontWeight.w500,
                              //             color: Colors.grey.shade900)),
                            ),
                          ))
                      .toList()),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01 / 1),
            ListTile(
              contentPadding:
                  const EdgeInsets.only(left: 10, top: 0, bottom: 0),
              title: Text(
                'Overview',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.grey.shade700),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  widget.desc!,
                  // widget.desc!,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01 / 1),
            MainButton(
              btnColor: Colors.grey,
              labelColor: Colors.white,
              width: 0.9,
              onclick: ()  {
              Navigator.pop(context);
              },
              label: 'Edit',
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.007/ 1),
            MainButton(
              isLoading: isLoading,
              width: 0.9,
              onclick: ()  async {
                setState(() {
                  isLoading = true;
                });
               await Provider.of<CarListingProvider>(context, listen: false)
                    .addCarListingDataVmF(context,
                    user_id: currentUser?.id?.toString(),
                    listing_car:widget.car,
                    listing_bodyType: widget.bodyType,
                    listing_region : widget.region,
                    listing_city : widget.city,
                    listing_type: widget.type ?? ' ',
                    listing_model: widget.model ?? ' ',
                    listing_year: widget.year ?? ' ',
                    listing_title: widget.title ?? ' ',
                    listing_desc: widget.desc ?? '',
                    contact_number: widget.contactNumber,
                    wa_number: widget.whatsAppContact,
                    //'Something About This',
                    imagesList: widget.imagesList,
                    listing_price: widget.price ?? '00',
                    features_gear: widget.gearF,
                    features_speed: widget.speedF,
                    features_color: widget.cylF.toString(),
                    features_seats: widget.seatsF,
                    features_door: widget.seatsF,
                    features_fuel_type: widget.fuelF,
                    features_climate_zone: widget.climatesF,
                    features_cylinders: widget.cylF.toString(),
                    features_bluetooth: 'yes',
                    latLng: widget.latLng,
                    locationAddress: widget.locationAddress,
                    vin_number: widget.vinNumber,
                    features_others: widget.featuresList ?? ['Extra features']
               );

               _home();

              },
              label: 'Submit',
            )


          ],
        ),
      ),
    );
  }

  _home(){
    setState(() {
      isLoading = false;
    });
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const HomeScreen(origin: 'carListedPage',)), (route) => false);
    Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen(origin: 'carListedPage1',)));
  }
}
