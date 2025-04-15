
import 'package:carsilla/const/assets.dart';
import 'package:carsilla/utils/theme.dart';
import 'package:carsilla/screens/GoogleMap/view_location_on_map.dart';
import '../../utils/ui_utils.dart';
import 'package:carsilla/providers/spare_part_provider.dart';
import 'package:carsilla/widgets/btn.dart';
import 'package:carsilla/widgets/header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../const/common_methods.dart';
import '../../services/spare_part_service.dart';

class SparePartViewScreen extends StatefulWidget {
  final String selectedCar;
  final String selectedModel;
  final String selectedYear;
  final String selectedSparePart;
  final String subcategory;
  final String? vimNumber;

  const SparePartViewScreen(
      {super.key,
      this.selectedCar = '',
      this.selectedModel= '',
      this.selectedYear= '',
      this.selectedSparePart='', this.vimNumber, this.subcategory = ''});

  @override
  State<SparePartViewScreen> createState() => _SparePartViewScreenState();
}

class _SparePartViewScreenState extends State<SparePartViewScreen> {


  bool isExpanded = true;

  String filter = "New";

  late List displayedList;

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    Size size = getMediaSize(context);
    return Consumer<SparePartProvider>(builder: (context, vmVal, child) {

      return Header(
          enableBackButton: true,

          title: 'Auto Spare Parts',
          body: Column(
            children: [
              SizedBox(
                  width: double.infinity,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.02 / 1),
              widget.selectedCar == null || widget.selectedCar!.isEmpty
                  ? Center(
                  child: Text(
                    "All Category",
                    style: TextStyle(color: MainTheme.primaryColor.shade300),
                  ))
                  : ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ExpansionTile(
                  onExpansionChanged: (expanded) {
                    if (expanded) {
                      setState(() {
                        isExpanded = true;
                      });
                    } else {
                      setState(() {
                        isExpanded = false;
                      });
                    }
                  },
                  initiallyExpanded: true,
                  title: Stack(
                    alignment: Alignment.center,
                    children: [
                      const SizedBox(height: 1, child: Divider(color: Colors.black,)),
                      Container(
                          alignment: Alignment.center,
                          width: 110,
                          color: Colors.white,
                          child: Text('Your Car', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: (isExpanded)
                                  ? MainTheme.primaryColor
                                  : Colors.black),))
                    ],
                  ),
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Padding(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12,),
                              const Text('Car Type     :',
                                style: TextStyle(fontWeight: FontWeight.bold),),
                              const SizedBox(height: 16,),
                              const Text('Car Model   :', style: TextStyle(
                                  fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16,),
                              const Text('Car Year      :', style: TextStyle(
                                  fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16,),
                              const Text('Category   :',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                             //subcategory
                              const SizedBox(height: 16,),
                              const Text('Sub-category   :',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                             // vim number
                              widget.vimNumber != null
                              ? const Column(
                                children: [
                                  SizedBox(height: 16,),
                                  Text('Vin Number  :', style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                                ],
                              )
                                  : const SizedBox()
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
                                        Radius.circular(10))
                                ),
                                child: Text(widget.selectedCar.toString()
                                    .toUpperCase()),),
                              const SizedBox(height: 5,),

                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.25),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))
                                ),
                                child: Text(widget.selectedModel.toString()
                                    .toUpperCase()),),
                              const SizedBox(height: 5,),

                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.25),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))
                                ),
                                child: Text(widget.selectedYear.toString()
                                    .toUpperCase()),),
                              const SizedBox(height: 5,),

                              Container(
                                width: 200,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.25),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))
                                ),
                                child: Text(widget.selectedSparePart.toString()
                                    .toUpperCase(), overflow: TextOverflow.ellipsis,),),

                              // sub category
                              const SizedBox(height: 5,),

                              Container(
                                width: 200,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.25),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))
                                ),
                                child: Text(widget.subcategory.toString()
                                    .toUpperCase(), overflow: TextOverflow.ellipsis,),),

                              // vim number
                             widget.vimNumber != null
                              ? Column(
                               children: [
                                 const SizedBox(height: 5,),

                                 Container(
                                   padding: const EdgeInsets.all(5),
                                   decoration: BoxDecoration(
                                       color: Colors.grey.withOpacity(0.25),
                                       borderRadius: const BorderRadius.all(
                                           Radius.circular(10))
                                   ),
                                   child: Text(widget.vimNumber.toString()
                                       .toUpperCase()),),
                                 const SizedBox(height: 5,),
                               ],
                             ) : const SizedBox(),

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
                            Navigator.pop(context);

                          },
                          label: "Choose New",
                        )),
                  ],
                ),
              ),

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      'Nearby Services Providers',
                      style: Theme
                          .of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(color: Colors.grey.shade800),
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: SparePartProvider.sparePartsShopsList2
                    .map(
                        (e) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: size.width * 0.8,
                      width: size.width ,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(12)

                      ),
                      child: GestureDetector(
                        onTap: () {
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                e['dealer']['company_img'],
                                width: MediaQuery.of(context).size.width *
                                    04 /
                                    1,
                                height: size.width * 0.48,
                                fit: BoxFit.cover,
                                errorBuilder: (context, child, erorr) =>
                                    Image.asset(IconAssets.carvector),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                children: [
                                  const SizedBox(height: 12,),
                                  Row(
                                    children: [
                                      Text(
                                        e['dealer']['company_name']??'null',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .copyWith(
                                            fontSize: 18,
                                            color:
                                            MainTheme.primaryColor),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () async {

                                          if(e['dealer']['company_address']== null && e['lat'] == null && e['lng'] == null){
                                            UiUtils(context).showSnackBar( 'Location is not available');
                                            return;
                                          }

                                          Navigator.push(context, MaterialPageRoute(builder: (context) => ViewLocationOnMap(latitude: e['lat'], longitude: e['lng'], address: e['dealer']['company_address']),));

                                        },child: SizedBox(
                                          width: 80,
                                          child: Row(
                                            children: [
                                              const Icon(Icons.location_pin,color: MainTheme.primaryColor,size: 20,),
                                              const SizedBox(width: 4,),
                                              Expanded(child: Text(e['dealer']['company_address'],style: const TextStyle(fontSize: 14,color: Colors.black54),overflow: TextOverflow.ellipsis,))
                                            ],
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                  const SizedBox(height: 4,),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        IconAssets.yellowstar,
                                        width: 18,
                                      ),
                                      const SizedBox(width: 4,),
                                      Text('${e['dealer']['reviews']}',style: const TextStyle(fontSize: 14,color: Colors.black54),)

                                    ],
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            String encodedMessage = '';
                                            if(widget.vimNumber != null){
                                              String shareUrl = "https://carllymotors.com/spare-part/?shop_id=${Uri.encodeComponent(e['id'].toString())}&car_type=${Uri.encodeComponent(widget.selectedCar)}&car_model=${Uri.encodeComponent(widget.selectedModel)}&year=${Uri.encodeComponent(widget.selectedYear)}&category=${Uri.encodeComponent(widget.selectedSparePart)}&sub-category=${Uri.encodeComponent(widget.subcategory)}&vin-number=${Uri.encodeComponent(widget.vimNumber!)}";
                                              encodedMessage = Uri.encodeComponent("((Carlly Motors))\n\nI'm interested in buying your spare parts!\n\nCar Type : ${widget.selectedCar}\nCar Model : ${widget.selectedModel}\nCar Year : ${widget.selectedYear}\nCategory : ${widget.selectedSparePart}\nSub-category : ${widget.subcategory}\nVin Number : ${widget.vimNumber}\nSpare Part Url : $shareUrl");
                                            }else{
                                              String shareUrl = "https://carllymotors.com/spare-part/?shop_id=${Uri.encodeComponent(e['id'].toString())}&car_type=${Uri.encodeComponent(widget.selectedCar)}&car_model=${Uri.encodeComponent(widget.selectedModel)}&year=${Uri.encodeComponent(widget.selectedYear)}&category=${Uri.encodeComponent(widget.selectedSparePart)}&sub-category=${Uri.encodeComponent(widget.subcategory)}";
                                              encodedMessage =  Uri.encodeComponent("((Carlly Motors))\n\nI'm interested in buying your spare parts!\n\nCar Type : ${widget.selectedCar}\nCar Model : ${widget.selectedModel}\nCar Year : ${widget.selectedYear}\nCategory : ${widget.selectedSparePart}\nSub-category : ${widget.subcategory}\nSpare Part Url : $shareUrl");
                                            }
                                            String mapsUrl =
                                                "https://wa.me/${e['phone']}?text=$encodedMessage";
                                            final Uri url = Uri.parse(
                                                mapsUrl);
                                            if (!await launchUrl(
                                                url)) {
                                              throw Exception(
                                                  'Could not launch $url');
                                            }
                                          },
                                          child: Container(
                                            height: 30,
                                            padding: EdgeInsets.symmetric(horizontal: 12),
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
                                            String calUrl =  "tel: ${e['phone']}";
                                            final Uri url = Uri.parse(calUrl);
                                            if (!await launchUrl(url)) {
                                              throw Exception('Could not launch $url');
                                            }
                                          },
                                          child: Container(
                                            height: 30,
                                            padding: EdgeInsets.symmetric(horizontal: 12),
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
                                            String message = '';
                                            if (widget.vimNumber != null) {
                                              String shareUrl = "https://carllymotors.com/spare-part/?shop_id=${Uri.encodeComponent(e['id'].toString())}&car_type=${Uri.encodeComponent(widget.selectedCar)}&car_model=${Uri.encodeComponent(widget.selectedModel)}&year=${Uri.encodeComponent(widget.selectedYear)}&category=${Uri.encodeComponent(widget.selectedSparePart)}&sub-category=${Uri.encodeComponent(widget.subcategory)}&vin-number=${Uri.encodeComponent(widget.vimNumber!)}";
                                              message = "Check out my latest find on Carlly! Great deals await. Don’t miss out!\n$shareUrl";
                                            } else {
                                              String shareUrl = "https://carllymotors.com/spare-part/?shop_id=${Uri.encodeComponent(e['id'].toString())}&car_type=${Uri.encodeComponent(widget.selectedCar)}&car_model=${Uri.encodeComponent(widget.selectedModel)}&year=${Uri.encodeComponent(widget.selectedYear)}&category=${Uri.encodeComponent(widget.selectedSparePart)}&sub-category=${Uri.encodeComponent(widget.subcategory)}";
                                              message = "Check out my latest find on Carlly! Great deals await. Don’t miss out!\n$shareUrl";
                                            }

                                            await Share.share(message);
                                          },
                                          child: Container(
                                            height: 30,
                                            padding: EdgeInsets.symmetric(horizontal: 12),
                                            decoration: BoxDecoration(
                                                border: Border.all(color: MainTheme.primaryColor),
                                                borderRadius: BorderRadius.circular(16)
                                            ),
                                            child: const Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.share,color: MainTheme.primaryColor,size: 18,),
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
                  );}
                )
                    .toList(),
              ),
            ],
          ));
    });
  }


  }
