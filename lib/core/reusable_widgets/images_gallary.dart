import 'package:carsilla/core/reusable_widgets/verical_images_gallary.dart';
import 'package:carsilla/utils/theme.dart';
import 'package:flutter/material.dart';

class ImagesGallery{

  zoomIn(BuildContext context,List<dynamic> images){

    // List<String> img = images.map((item) => item.toString()).toList();
    List<String> img =[];
    images.forEach((e){
      img.add(e['image']);
    });

    int index = 0;
    showDialog<void>(
      context: context,
      // barrierColor: Colors.black.withOpacity(0.2),
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return
          AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            content:  StatefulBuilder(
                builder: (context,sett) {
                  return Container(
                      color: Colors.transparent,
                      height: MediaQuery.of(context).size.height*0.7,

                      width: MediaQuery.of(context).size.width*0.9,
                      child:Stack(
                        alignment: Alignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) =>  VericalGalleryImages(img: img,)),
                              );
                            },
                            child: Container(
                              // height: MediaQuery.of(context).size.height*0.5,
                              //
                              // width: MediaQuery.of(context).size.width*0.5,
                                child:img.isNotEmpty? Image.network(img[index],fit: BoxFit.contain,
                                  errorBuilder: ( context,  exception,  stackTrace) {
                                    return Container(
                                        height: 80,
                                        width: MediaQuery.of(context).size.width,
                                        color: MainTheme.primaryColor.withOpacity(0.1),
                                        child: Icon(Icons.warning_rounded,size: 50,));
                                  },
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child; // Image is fully loaded

                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                            (loadingProgress.expectedTotalBytes ?? 1)
                                            : null, // Show indeterminate if totalBytes unknown
                                      ),
                                    );
                                  },
                                ):Container(

                                )),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) =>  VericalGalleryImages(img: img,)),
                                    );
                                  },

                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: MainTheme.primaryColor,
                                            borderRadius: BorderRadius.all(Radius.circular(12))
                                          // shape: BoxShape.circle
                                        ),
                                        child: Icon(Icons.zoom_out_map_sharp,color: Colors.white,)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap:(){

                                        if(index != 0){
                                          sett((){
                                            index = index-1;
                                          });
                                        }

                                      },
                                      child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              color: MainTheme.primaryColor,
                                              shape: BoxShape.circle
                                          ),
                                          child: Icon(Icons.arrow_back_ios_new_sharp,color: Colors.white,)),
                                    ),
                                    InkWell(
                                      onTap: (){

                                        if(index != img.length - 1){
                                          sett((){
                                            index = index+1;
                                          });
                                        }
                                      },
                                      child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              color: MainTheme.primaryColor,
                                              shape: BoxShape.circle
                                          ),
                                          child: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,)),
                                    ),
                                  ],
                                ),
                              ),
                              Container()
                            ],
                          )
                        ],
                      )
                  );
                }
            ),
            // actions: <Widget>[
            //   TextButton(
            //     child: const Text('Approve'),
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //     },
            //   ),
            // ],
          );
      },
    );
  }
}