import 'package:carsilla/utils/theme.dart';
import 'package:flutter/material.dart';

class VericalGalleryImages extends StatelessWidget {
  final List<String> img;
  VericalGalleryImages({super.key,required this.img});

  final ScrollController _scrollController = ScrollController();
  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, // scrolls to bottom
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView.builder(
          controller: _scrollController,

          shrinkWrap: true,
          itemCount: img.length,
          itemBuilder: (context,index){
            return Container(
              height: MediaQuery.of(context).size.height,
              child: Image.network(img[index],fit: BoxFit.contain,
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
                errorBuilder: ( context,  exception,  stackTrace) {
                  return Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      color: MainTheme.primaryColor.withOpacity(0.1),
                      child: Icon(Icons.warning_rounded,size: 50,));
                },
              ),
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: InkWell(
        onTap: _scrollDown,
        child: Container(
            height: 60,width: 60,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MainTheme.primaryColor
            ),
            child: Icon(Icons.arrow_downward,color: Colors.white,)),
      ),
    );
  }
}

