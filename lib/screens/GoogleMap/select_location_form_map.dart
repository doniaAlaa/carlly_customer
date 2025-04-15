import 'dart:async';

import 'package:carsilla/widgets/btn.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class SelectLocationFromMap extends StatefulWidget {

  final LatLng? coordinates;

  const SelectLocationFromMap({super.key, this.coordinates});

  @override
  State<SelectLocationFromMap> createState() => _SelectLocationFromMapState();
}

class _SelectLocationFromMapState extends State<SelectLocationFromMap> {

  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  LatLng? latLng;
  String address = '';

  // .......Get user current location.......
  Future<void> getCurrentLocation() async {
    print('getting location.....');
    final GoogleMapController controller = await _controller.future;
    if(widget.coordinates!=null){
      String gettingAddress = await getAddress(widget.coordinates!);

      setState(()  {
        latLng = widget.coordinates;
        address = gettingAddress;
      });
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: widget.coordinates!, zoom: 13)));
    }else{
      Geolocator.requestPermission()
          .then((LocationPermission locationPermission) async {
        if (locationPermission == LocationPermission.whileInUse) {
          await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
              .then((Position position) async {
            double lat = position.latitude;
            double lng = position.longitude;

            String gettingAddress = await getAddress(LatLng(lat, lng));

            setState(()  {
              latLng = LatLng(lat, lng);
              address = gettingAddress;
            });
            controller.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: LatLng(lat, lng), zoom: 13)));
          });
          if (locationPermission == LocationPermission.denied ||
              locationPermission == LocationPermission.deniedForever ||
              locationPermission == LocationPermission.unableToDetermine) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Permission Denied')));
          }
        }
      });

    }
   }


  Future<String> getAddress(LatLng latLng)async{
    String address = '';
      await placemarkFromCoordinates(latLng.latitude,
          latLng.longitude)
          .then((value) {
        List<Placemark> placeMarks = value;
        // for(final v in value){
        //   print(v);
        //   print('');
        // }
        final firstElement = placeMarks.first;

        List<Placemark>? filteredPlaceMarks = placeMarks
            .where((element) =>
        element.name != null &&
            element.name!.contains('Street'))
            .toList();

        if (filteredPlaceMarks.isNotEmpty) {
           address =
              '${filteredPlaceMarks.last.name}, ${firstElement.subLocality}, ${firstElement.locality}, ${firstElement.country}';
          print('address : $address');
        } else {
           address =
              '${firstElement.street}, ${firstElement.subLocality}, ${firstElement.locality}, ${firstElement.country}';

          print('address : $address');
        }
      });
      return address;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.future.then((value) => value.dispose());
    super.dispose();
  }


  @override
  void initState() {
    // TODO: implement initState
    getCurrentLocation();
    super.initState();
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
                    initialCameraPosition: CameraPosition(target: LatLng(25.16917282185334, 55.33374801278114),zoom: 11,),
                  onMapCreated: (controller) {
                    _controller.complete(controller);
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  compassEnabled: false,
                  onTap: (argument) async {

                      setState(() {
                        latLng = LatLng(argument.latitude, argument.longitude);
                        address = 'Searching.....';
                      });

                      String gettingAddress = await getAddress(LatLng(argument.latitude, argument.longitude));
                      setState(() {
                        address = gettingAddress;
                      });
                      print(latLng);
                    },
                  markers: <Marker>{
                    Marker(
                        markerId: MarkerId('current#1'),
                        icon: BitmapDescriptor.defaultMarker,
                        // infoWindow: InfoWindow(title: 'Current location'),
                        position: latLng??LatLng(0.0, 0.0)
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
              child: Container(
                height: 150,
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
                      child: Text(address,),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MainButton(onclick: (){
                          if(latLng!=null){
                            context.read<LatLngProvider>().addLatLng(latLng!,address);
                            Navigator.pop(context);
                          }
                        },
                        label:'CONFIRM',)
                        // ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //     fixedSize: Size(300, 30)
                        //   ),
                        //     onPressed: (){
                        //     if(latLng!=null){
                        //       context.read<LatLngProvider>().addLatLng(latLng!,address);
                        //       Navigator.pop(context);
                        //     }
                        // }, child: Text('Confirm')),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class LatLngProvider extends ChangeNotifier{
  double? _latitude;
  double? _longitude;
  LatLng? _latLng;
  String? _address;

  void addLatLng(LatLng latLng,String address){
    _latLng = latLng;
    _latitude = latLng.latitude;
    _longitude = latLng.longitude;
    _address = address;
    notifyListeners();
  }

  void disposeVariables(){
    _address = null;
    _longitude = null;
    _latitude = null;
    _latLng = null;
  }

  double? get getLongitude => _longitude;
  double? get getLatitude => _latitude;
  LatLng? get getLatLng => _latLng;
  String? get getAddress => _address;

}