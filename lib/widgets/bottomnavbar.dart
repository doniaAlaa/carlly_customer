import 'package:carsilla/screens/carlisting/my_cars_listing.dart';
import 'package:carsilla/screens/categories.dart';
import 'package:carsilla/screens/home_screen.dart';
import 'package:flutter/material.dart';

import '../screens/profile/profile.dart';
import '../utils/theme.dart';

class NavBarWidget extends StatefulWidget {

  final String currentScreen;

  const NavBarWidget({super.key, required this.currentScreen});

  @override
  State<NavBarWidget> createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBarWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      // margin: EdgeInsets.only(top: 816.v),
      padding: const EdgeInsets.symmetric(
        horizontal: 37,
        vertical: 15,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(top: BorderSide(width: 1, color: Colors.grey.shade100))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(origin: 'BottomNav',),
                ),
              );
            },
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.05 / 1,
                child: Icon(Icons.home_outlined,
                    size: 30, color: (widget.currentScreen == 'Home') ? MainTheme.primaryColor : Colors.grey.shade400)),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyCarsListing(),
                ),
              );
            },
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.05 / 1,
                child: Icon(Icons.store,
                    size: 30, color: (widget.currentScreen == 'MyListing') ? MainTheme.primaryColor : Colors.grey.shade400)),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Categories(),
                ),
              );
            },
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.05 / 1,
                child: Icon(Icons.category_outlined,
                    size: 30, color: (widget.currentScreen == 'Categories') ? MainTheme.primaryColor :Colors.grey.shade400)),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.05 / 1,
                child: Icon(Icons.person,
                    size: 30, color: (widget.currentScreen == 'Profile') ? MainTheme.primaryColor :Colors.grey.shade400)),
          ),
        ],
      ),
    );
  }
}
