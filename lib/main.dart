import 'package:app_links/app_links.dart';
import 'package:carsilla/const/handel_deeplink.dart';
import 'package:carsilla/providers/user_provider.dart';
import 'package:carsilla/screens/GoogleMap/select_location_form_map.dart';
import 'package:carsilla/services/context_handler.dart';
import 'package:carsilla/services/deep_linking_handler.dart';
import 'package:carsilla/providers/otp_timer_provider.dart';
import 'package:carsilla/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/splash/splash.dart';
import 'providers/car_listing_provider.dart';
import 'providers/specification_provider.dart';
import 'providers/spare_part_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  appLinkUri = await AppLinks().getInitialLink();
  if(appLinkUri != null){
    HandelDeeplink().handleDeepLink(appLinkUri!,);

  }
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<CarListingProvider>(
        create: (_) => CarListingProvider()),
    ChangeNotifierProvider<SparePartProvider>(
        create: (_) => SparePartProvider()),
    ChangeNotifierProvider<SpecificationProvider>(
        create: (_) => SpecificationProvider()),

    // added by @callofcoding

    ChangeNotifierProvider.value(value: LatLngProvider()),
    ChangeNotifierProvider.value(value: UserProvider()),
    ChangeNotifierProvider.value(value: OtpTimerProvider()),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppLinksDeepLink _appLinksDeepLink = AppLinksDeepLink.instance;

  @override
  void initState() {
    // TODO: implement initState
    _appLinksDeepLink.initDeepLinks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: ContextHandler.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Carlly',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: MainTheme.primaryColor),
          dialogBackgroundColor: Colors.white,
          dialogTheme: const DialogTheme(backgroundColor: Colors.white),
          useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}


//  <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
//     <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>
