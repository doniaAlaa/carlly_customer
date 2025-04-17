import 'package:carsilla/const/assets.dart';
import 'package:carsilla/models/user_model.dart';
import 'package:carsilla/providers/user_provider.dart';
import 'package:carsilla/utils/theme.dart';
import 'package:carsilla/resources/user_data.dart';
import 'package:carsilla/screens/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:provider/provider.dart';
import 'drawer.dart';

class Header extends StatelessWidget {
  final String? title;
  final String? profile;
  final String? headeimg;
  final Widget? body;
  final bool? showAppBar;
  final double? marginbodyfrombottom;
  final double? bodyheight;
  final bool? isScrollable;
  final bool? enableBackButton;
  final Widget? navbar;
  final FloatingActionButton? floatingActionButton;
  final Function()? backAction;

  Header({
    super.key,
    this.title = '',
    this.profile = ImageAssets.profile,
    this.headeimg = ImageAssets.notfound,
    this.body = const Text('add List'),
    this.showAppBar = true,
    this.marginbodyfrombottom = 0.05,
    this.bodyheight = 0.6,
    this.isScrollable = true,
    this.navbar,
    this.backAction,
    this.floatingActionButton, this.enableBackButton = true,
  });


  final AdvancedDrawerController  drawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return DrawerWidget(
      drawerController: drawerController,
      body: Scaffold(
        backgroundColor: Colors.white,
        appBar: showAppBar! == true
            ? AppBar(
                leadingWidth: 100,
                backgroundColor: MainTheme.primaryColor,
                leading: Row(
                  children: [
                    Builder(
                      builder: (context) {
                        return IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () {
                            drawerController.showDrawer();
                          },
                        );
                      },
                    ),
                    enableBackButton == true ?IconButton(onPressed: backAction?? (){
                      backAction?? Navigator.pop(context);
                    }, icon: Icon(Icons.arrow_back,color: Colors.white,)):SizedBox()
                  ],
                ),
                title: Text(title!,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white)),
                centerTitle: true,
                actions: [
                  Consumer<UserProvider>(builder: (context, userProvider, child) {
                    UserModel? currentUser = userProvider.getCurrentUser;
                    return GestureDetector(
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
                            border: Border.all(
                                width: 1,
                                color: Colors.red.shade100.withOpacity(0.4)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.redAccent.withOpacity(0.5),
                                  offset: const Offset(1, 1),
                                  blurRadius: 10)
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child:
                            currentUser?.image == null
                                ?CircleAvatar(
                              backgroundColor: Colors.grey.shade100,
                              radius: 22,
                              child: Icon(Icons.person_2),
                            )
                            : CircleAvatar(
                                backgroundColor: Colors.grey.shade100,
                                radius: 22,
                                backgroundImage: NetworkImage(currentUser!.image!,),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  // CircleAvatar(
                  //   child: Image.asset(
                  //     profile!,
                  //   ),
                  // ),
                  const SizedBox(width: 15)
                ],
              )
            : AppBar(
                backgroundColor: Colors.transparent, leading: const Text('')),
        extendBodyBehindAppBar: showAppBar == true ? false : true,
        bottomNavigationBar: navbar,
        // const SizedBox(
        //   height: 0,
        // ),
        floatingActionButton: floatingActionButton,
        body: SingleChildScrollView(
          controller: ScrollController(),
          physics: isScrollable == true
              ? const ScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.06 / 1,
                decoration: const BoxDecoration(color: MainTheme.primaryColor),
              ),
              Transform.translate(
                offset: Offset(
                    0,
                    -MediaQuery.of(context).size.height *
                        marginbodyfrombottom! /
                        1),
                child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height *
                                bodyheight! /
                                1),
                        child: body)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
