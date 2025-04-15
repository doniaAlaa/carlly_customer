



import 'package:app_links/app_links.dart';
import 'package:carsilla/screens/repair_workshop/repair_workshop_view_screen.dart';
import 'package:flutter/material.dart';

class HandelDeeplink {
  
  void handleDeepLink(Uri uri) {
    print('jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj');

    AppLinks().uriLinkStream.listen((Uri uri) {
       print(uri.path);
       print('jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj');
     });
    // if (uri.pathSegments.contains('workshop') && uri.queryParameters.containsKey('workshop')) {
    //   final id = uri.queryParameters['id'];
    //   print('jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj');
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => const RepairWorkshopViewScreen()),
    //   );
    //
    //   navigatorKey.currentState?.pushNamed('/item', arguments: id);
    // }
  }
}