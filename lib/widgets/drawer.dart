import 'package:carsilla/const/assets.dart';
import 'package:carsilla/models/user_model.dart';
import 'package:carsilla/providers/user_provider.dart';
import 'package:carsilla/screens/carlisting/search_car_screen.dart';
import 'package:carsilla/screens/carlisting/my_cars_listing.dart';
import 'package:carsilla/screens/home_screen.dart';
import 'package:carsilla/screens/privacy_policy_page.dart';
import 'package:carsilla/screens/repair_workshop/repair_workshop_screen.dart';
import 'package:carsilla/screens/spareparts/search_spare_part_screen.dart';
import 'package:carsilla/screens/support_page.dart';
import 'package:carsilla/screens/terms_&_condition_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/theme.dart';
import '../screens/profile/profile.dart';

class DrawerWidget extends StatefulWidget {
  final Widget? body;
  final AdvancedDrawerController? drawerController;

  const DrawerWidget({super.key, this.body, this.drawerController});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MainTheme.primaryColor.shade900,
        body: AdvancedDrawer(
            backdrop: Container(
              width: double.infinity,
              height: double.infinity,
              color: MainTheme.primaryColor.shade900,
            ),
            controller: widget.drawerController,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 300),
            animateChildDecoration: true,
            rtlOpening: false,
            openRatio: 0.65,
            // openScale: 1.0,
            disabledGestures: false,
            childDecoration: const BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(24)),
            ),
            child: widget.body!,
            drawer: MenuDrawer())

        // ZoomDrawer(
        //   controller: widget.drawerController,
        //   menuScreen: const MenuDrawer(),
        //   mainScreen: widget.body!,
        //   borderRadius: 24.0,
        //   showShadow: true,
        //   angle: 0.0,
        //   drawerShadowsBackgroundColor: MainTheme.primaryColor.shade200,
        //   slideWidth: MediaQuery.of(context).size.width * 0.75,
        // ),
        );
  }
}

///////////////////

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  String tabedmenu = '';
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder:
          (BuildContext context, UserProvider userProvider, Widget? child) {
        UserModel? currentUser = userProvider.getCurrentUser;
        return Container(
          color: MainTheme.primaryColor.shade900,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08 / 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border:
                              Border.all(width: 2, color: Colors.red.shade100),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.redAccent.withOpacity(0.5),
                                offset: const Offset(1, 1),
                                blurRadius: 10)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: currentUser?.image == null
                              ? CircleAvatar(
                                  backgroundColor: Colors.grey.shade100,
                                  radius: 22,
                                  child: Icon(Icons.person_2),
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.grey.shade100,
                                  radius: 22,
                                  backgroundImage: NetworkImage(
                                    currentUser!.image!,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    currentUser == null
                        ? "Guest"
                        : "${currentUser.firstName ?? ''} ${currentUser.lastName ?? ''}",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
              // const Divider(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7 / 1,
                child: ListView(
                  controller: ScrollController(),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                              origin: 'drawer',
                            ),
                          ),
                        );
                      },
                      leading: Transform.scale(
                          scale: 1.2,
                          child: Icon(
                            Icons.home,
                            color: Colors.white38,
                          )),
                      title: Text(
                        'Home',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.grey.shade200),
                      ),
                    ),
                    Divider(
                      thickness: 0.3,
                      color: Colors.grey.shade300,
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchSparePartScreen(),
                          ),
                        );
                      },
                      leading: ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                          child: Transform.scale(
                              scale: 1.2,
                              child: Image.asset(IconAssets.menu4,
                                  width: 25, height: 25))),
                      title: Text(
                        'Spare Parts',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.grey.shade200),
                      ),
                    ),
                    Divider(
                      thickness: 0.3,
                      color: Colors.grey.shade300,
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RepairWorkshopScreen(),
                          ),
                        );
                      },
                      leading: ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                          child: Transform.scale(
                              scale: 1.2,
                              child: Image.asset(IconAssets.menu4,
                                  width: 25, height: 25))),
                      title: Text(
                        'Repair Workshop',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.grey.shade200),
                      ),
                    ),
                    Divider(
                      thickness: 0.3,
                      color: Colors.grey.shade300,
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchCarScreen(),
                          ),
                        );
                      },
                      leading: ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                          child: Transform.scale(
                              scale: 1.2,
                              child: Image.asset(IconAssets.menu6,
                                  width: 25, height: 25))),
                      title: Text(
                        'Car Listing',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.grey.shade200),
                      ),
                    ),
                    Divider(
                      thickness: 0.3,
                      color: Colors.grey.shade300,
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyCarsListing(),
                          ),
                        );
                      },
                      leading: Transform.scale(
                          scale: 1.2,
                          child: Icon(
                            Icons.store,
                            color: Colors.white38,
                          )),
                      title: Text(
                        'My Listing',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.grey.shade200),
                      ),
                    ),
                    Divider(
                      thickness: 0.3,
                      color: Colors.grey.shade300,
                    ),
                    // Privacy policy
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrivacyPolicyPage(),
                            ));
                      },
                      leading: Transform.scale(
                          scale: 1.2,
                          child: Icon(
                            Icons.privacy_tip_outlined,
                            color: Colors.white38,
                          )),
                      title: Text(
                        'Privacy Policy',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.grey.shade200),
                      ),
                    ),
                    Divider(
                      thickness: 0.3,
                      color: Colors.grey.shade300,
                    ),
                    // Terms and Conditions
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TermsConditionPage(),
                            ));
                      },
                      leading: Transform.scale(
                          scale: 1.2,
                          child: Icon(
                            Icons.description,
                            color: Colors.white38,
                          )),
                      title: Text(
                        'Terms & Conditions',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.grey.shade200),
                      ),
                    ),
                    Divider(
                      thickness: 0.3,
                      color: Colors.grey.shade300,
                    ),
                    // support and help
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SupportPage(),
                            ));
                      },
                      leading: Transform.scale(
                          scale: 1.2,
                          child: Icon(
                            Icons.support_agent,
                            color: Colors.white38,
                          )),
                      title: Text(
                        'Support',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.grey.shade200),
                      ),
                    ),
                    Divider(
                      thickness: 0.3,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04 / 1,
              ),
              if (currentUser != null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9 / 1,
                    child: Column(
                      children: [
                        const SizedBox(height: 1, child: Divider()),
                        TextButton.icon(
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Logout'),
                                      content: Text('Do you want to logout?'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('No')),
                                        TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              final prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              await prefs.clear();
                                              userProvider.setCurrentUser =
                                                  null;
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomeScreen(
                                                              origin:
                                                                  'drawer')),
                                                  (route) => false);
                                            },
                                            child: Text('Yes')),
                                      ],
                                    );
                                  });
                            },
                            icon: const Icon(
                              Icons.exit_to_app_outlined,
                              color: Colors.white,
                            ),
                            label: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Logout',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(color: Colors.white),
                              ),
                            )),
                      ],
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
