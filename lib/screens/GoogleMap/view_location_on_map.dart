import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewLocationOnMap extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String address;
  const ViewLocationOnMap({super.key, required this.latitude, required this.longitude, required this.address});

  @override
  State<ViewLocationOnMap> createState() => _ViewLocationOnMapState();
}

class _ViewLocationOnMapState extends State<ViewLocationOnMap> {

  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  Future<void> openMap(double latitude, double longitude) async {
    String mapUrl = '';
    if (Platform.isIOS) {
      mapUrl =
      'https://maps.apple.com/?daddr=$latitude,$longitude';
    } else {
      mapUrl =
      'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=driving';
    }

    if (await canLaunchUrl(Uri.parse(mapUrl))) {
      await launchUrl(Uri.parse(mapUrl),mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.future.then((value) => value.dispose());
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Stack(
              children: [
                GoogleMap(
                    initialCameraPosition: CameraPosition(target: LatLng(widget.latitude, widget.longitude),zoom: 14,),
                    onMapCreated: (controller) {
                      _controller.complete(controller);
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    compassEnabled: false,
                    markers: <Marker>{
                      Marker(
                          markerId: MarkerId('current#1'),
                          icon: BitmapDescriptor.defaultMarker,
                          // infoWindow: InfoWindow(title: 'Current location'),
                          position: LatLng(widget.latitude, widget.longitude)
                      )
                    }


                ),
                SafeArea(
                  child: IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: Icon(Icons.arrow_back,color: Colors.black,size: 28,)),
                )
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () async {
                      await openMap(widget.latitude,widget.longitude);
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      height: 40,
                      width: 130,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Direction',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.white,fontFamily: 'Poppins'),),
                          Icon(Icons.directions,size: 26,color:Colors.white,)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8,),
                  Container(
                    height: 100,
                    width: size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 12,),
                              Text('Address',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                        // SizedBox(width: 12,),
                        Padding(
                          padding: const EdgeInsets.only(left: 20,right: 10),
                          child: Text(widget.address,),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
