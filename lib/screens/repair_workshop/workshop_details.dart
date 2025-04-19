import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:carsilla/core/reusable_widgets/images_gallary.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:carsilla/const/common_methods.dart';
import 'package:carsilla/models/workshops_model.dart';
import 'package:carsilla/utils/theme.dart';
import 'package:carsilla/screens/GoogleMap/view_location_on_map.dart';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../models/user_model.dart';
import '../../utils/ui_utils.dart';
import '../../widgets/btn.dart';
import '../../widgets/header.dart';
import 'package:http/http.dart' as http;

class WorkshopDetails extends StatefulWidget {
  final String selectedServiceDepartment;
  final WorkshopsModel workshopsModel;
  const WorkshopDetails({super.key, required this.selectedServiceDepartment,required this.workshopsModel});

  @override
  State<WorkshopDetails> createState() => _WorkshopDetailsState();
}

class _WorkshopDetailsState extends State<WorkshopDetails> {


  UserModel? currentUser;
  bool isLoading = false;

  @override
  void initState() {

    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    Size size = getMediaSize(context);


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
                widget.workshopsModel.workshop_name??'',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.black),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(size.height * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 10),


                    Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(12.0),
                        border:Border.all(color: Colors.black.withOpacity(0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 5.0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.circular(12.0),
                        child:
                        (widget.workshopsModel.images != null &&
                            widget.workshopsModel.images!.isNotEmpty)

                            ? Stack(
                              children: [
                                Image.network(
                                // widget.workshopDataModel?.images?.first??'',
                                widget.workshopsModel?.images?.first['image']??'',
                                // height: 120
                               width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                                errorBuilder: ( context,  exception,  stackTrace) {
                                return Container(
                                    height: 140,
                                    color: MainTheme.primaryColor.withOpacity(0.1),
                                    child: Image.asset('assets/images/no_image.png'));
                                                          },
                                                          loadingBuilder:
                                  (context, child, progress) {
                                if (progress == null) return child;
                                return const Center(
                                    child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child:
                                        CircularProgressIndicator()));
                                                          },
                                                        ),
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
                                          ImagesGallery().zoomIn(context,widget.workshopsModel.images!);
                                        },
                                        child: Icon(Icons.zoom_in,color: Colors.white,)),
                                  ),
                                )

                              ],
                            ):Container(
                            height: 140,
                            color: MainTheme.primaryColor.withOpacity(0.1),
                            child: Image.asset('assets/images/no_image.png')),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Text('Workshop Name',
                        style: textTheme.labelSmall!.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600)),
                    Text(widget.workshopsModel?.workshop_name??"",
                        style: textTheme.labelSmall!.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),

                    SizedBox(height: 20,),
                    Text('Owner',
                        style: textTheme.labelSmall!.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600)),
                    Text(widget.workshopsModel?.owner??'',
                        style: textTheme.labelSmall!.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    SizedBox(height: 20,),
                    Text('Brand',
                        style: textTheme.labelSmall!.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600)),
                    widget.workshopsModel != null && widget.workshopsModel!.brands != null?
                    Wrap(
                      direction: Axis.horizontal,
                      children:
                      widget.workshopsModel!.brands!.map((i){
                        return  Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black.withOpacity(0.2)),
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                              child: Text(i.name??'',
                                  style: textTheme.labelSmall!.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                            ),
                          ),
                        );
                      }).toList(),

                    ):Text('No Brands'),
                    SizedBox(height: 20,),
                    Text('Categories',
                        style: textTheme.labelSmall!.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600)),

                    widget.workshopsModel != null && widget.workshopsModel!.categories != null?
                    Wrap(
                      direction: Axis.horizontal,
                      children: widget.workshopsModel!.categories!.map((i) =>
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black.withOpacity(0.2)),
                                  borderRadius: BorderRadius.circular(30)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                                child: Text(i.name??'',
                                    style: textTheme.labelSmall!.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                              ),
                            ),
                          ),
                      ).toList(),
                    ):Text('No Categories'),
                    SizedBox(height: 20,),
                    Text('Branch',
                        style: textTheme.labelSmall!.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600)),
                    Text(widget.workshopsModel?.city??'',
                        style: textTheme.labelSmall!.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    SizedBox(height: 20,),
                    Text('Location',
                        style: textTheme.labelSmall!.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600)),
                    Text(widget.workshopsModel?.location??'',
                        style: textTheme.labelSmall!.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    SizedBox(height: 20,),
                    Text('Employee Number',
                        style: textTheme.labelSmall!.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600)),
                    Text(widget.workshopsModel?.employee??'',
                        style: textTheme.labelSmall!.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),



                    SizedBox(height: 20,),
                    Text('Working Hours',
                        style: textTheme.labelSmall!.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600)),
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                        itemCount:widget.workshopsModel?.days?.length ,
                        itemBuilder: (context,index){
                      return Row(
                        children: [
                          Text('${widget.workshopsModel?.days?[index].day??' '} : ',
                              style: textTheme.labelSmall!.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                          Text('${widget.workshopsModel?.days?[index].from??' '} ${widget.workshopsModel?.days?[index].to??' '}',
                              style: textTheme.labelSmall!.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black.withOpacity(0.8))),
                        ],
                      );
                    }),

                    SizedBox(height: 20,),





                  ],
                ),
              ),
            ),
            Column(
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

                                  String calUrl =
                                      "tel: ${widget.workshopsModel.phone.toString().replaceAll(',', '')}";
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
                                if (widget.workshopsModel.location ==
                                    null &&
                                    widget.workshopsModel.lat ==
                                        null &&
                                    widget.workshopsModel.lng ==
                                        null) {
                                  UiUtils(context).showSnackBar(
                                      'Location is not available');
                                  return;
                                }

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewLocationOnMap(
                                          latitude:widget.workshopsModel.lat??0.0,
                                          longitude: widget.workshopsModel.lng??0.0,
                                          address: widget.workshopsModel.location??''),
                                    ));


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
                                // var data = widget.carListingDetails;
                                final whatsappUrl = Uri.parse(
                                    "https://wa.me/${widget.workshopsModel.whatsapp_number}  ?text=${Uri.encodeComponent(
                                        '''
                                                   السلام عليكم، شفت ورشتكم ${widget.workshopsModel.workshop_name} في شركة Carlly Motors ، وعندي شغل ${widget.selectedServiceDepartment} بسيارتي. متى أقدر آييبها؟
                                                    \n Hello, I saw your ${widget.workshopsModel.workshop_name} workshop on the Carlly app. I need some ${widget.selectedServiceDepartment} work done on my car. When can I bring it in?
                                                  \n https://carllymotors.page.link/workshop
                                                
                                                    '''

                                    )}"
                                );
                                launchUrlString(whatsappUrl.toString());
                              },
                              label: 'WhatsApp Chat'),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: MainButton(
                              onclick: () async {
                                if(widget.workshopsModel.images!.isNotEmpty){
                                  final uri = Uri.parse(widget.workshopsModel.images?[0]['image']??'');
                                  final response = await http.get(uri);
                                  final bytes =  response.bodyBytes;
                                  final temp =  await getTemporaryDirectory();
                                  final file = File('${temp.path}/shared_workshop_image.jpg');

                                  await file.writeAsBytes(bytes);
                                  Share.shareXFiles(
                                    [XFile(file.path)],
                                    // text: 'workshop name : ${workshopsModel.workshop_name}\nphone : ${workshopsModel.phone}\nHello, I saw your ${repairWorkshopViewScreenController.workshopsModel[index].workshop_name} workshop  on the Carlly app. I need some ${widget.selectedServiceDepartment} work done on my car. When can I bring it in?\n السلام عليكم، شفت ورشتكم${repairWorkshopViewScreenController.workshopsModel[index].workshop_name} في شركة Carlly Motors ، وعندي شغل ${widget.selectedServiceDepartment} بسيارتي. متى أقدر آجيبها؟\nhttps://carllymotors.page.link/workshop',
                                    text: 'workshop name : ${widget.workshopsModel.workshop_name}\nphone : ${widget.workshopsModel.phone}\nhttps://carllymotors.page.link/workshop',

                                  );

                                }else{
                                  final byteData = await rootBundle.load('assets/images/no_image.png'); // asset path

                                  final tempDir = await getTemporaryDirectory();
                                  final file = File('${tempDir.path}/no_image.png');
                                  await file.writeAsBytes(byteData.buffer.asUint8List());

                                  Share.shareXFiles(
                                    [XFile(file.path)],
                                    text: 'workshop name : ${widget.workshopsModel.workshop_name}\nphone : ${widget.workshopsModel.phone}\nhttps://carllymotors.page.link/workshop',



                                  );

                                }

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
