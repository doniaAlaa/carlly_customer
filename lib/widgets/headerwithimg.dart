import 'package:carsilla/const/assets.dart';
import 'package:carsilla/models/user_model.dart';
import 'package:carsilla/providers/user_provider.dart';
import 'package:carsilla/utils/theme.dart';
import 'package:carsilla/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';

class HeaderWithImage extends StatelessWidget {
  final String? title;
  final String? profile;
  final String? headeimg;
  final Widget? body;
  final bool? showAppBar;
  final double? marginbodyfrombottom;
  final double? bodyheight;
  final bool? isScrollable;
  final Widget? navbar;
  final double? marginToTopHeadeImg;
  final bool enableBackButton;
  final Widget? onTopOfheImage;
  final double? ontopimagecontentleft;
  final FloatingActionButton? floatingActionButton;
  const HeaderWithImage({
    super.key,
    this.title = '',
    this.enableBackButton = true,
    this.profile = ImageAssets.profile,
    this.headeimg = ImageAssets.notfound,
    this.marginToTopHeadeImg = 0.01,
    this.body = const Text('add List'),
    this.showAppBar = true,
    this.marginbodyfrombottom = 0.02,
    this.bodyheight = 0.6,
    this.isScrollable = true,
    this.navbar,
    this.onTopOfheImage = const Text(''),
    this.ontopimagecontentleft = 15.0,
    this.floatingActionButton
  });

  @override
  Widget build(BuildContext context) {
    return DrawerWidget(
      body: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: floatingActionButton,
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
                            ZoomDrawer.of(context)!.open();
                          },
                        );
                      },
                    ),
                    enableBackButton == true ?IconButton(onPressed: (){
                      Navigator.pop(context);
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

                  Consumer<UserProvider>(builder: (BuildContext context, UserProvider value, Widget? child) {
                    UserModel? currentUser = value.getCurrentUser;
                    if(currentUser?.image == null){
                      return CircleAvatar(
                        backgroundColor: Colors.grey.shade100,
                        radius: 22,
                        child: Icon(Icons.person_2),
                      );
                    }else{
                      return CircleAvatar(
                        backgroundImage: NetworkImage(currentUser!.image!),
                      );
                    }
                  },),


                  const SizedBox(
                    width: 15,
                  )
                ],
              )
            : AppBar(
                backgroundColor: MainTheme.primaryColor,
                leading: const Text(''),
              ),
        // extendBodyBehindAppBar: showAppBar == true ? false : true,
        body: SingleChildScrollView(
          controller: ScrollController(),
          physics: isScrollable == true
              ? const ScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              // Container(
              //   height: MediaQuery.of(context).size.height * 0.01 / 1,
              //   decoration: const BoxDecoration(color: MainTheme.primaryColor),
              // ),
              Stack(
                children: [
                  Container(
                      decoration:
                          const BoxDecoration(color: MainTheme.primaryColor),
                      child: Transform.translate(
                          offset: Offset(
                              0,
                              -MediaQuery.of(context).size.height *
                                  marginToTopHeadeImg! /
                                  1),
                          child: Image.asset(headeimg!))),
                  Positioned(
                      top: 45,
                      left: ontopimagecontentleft,
                      child: onTopOfheImage!)
                ],
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
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
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
        bottomNavigationBar: navbar ??
            const SizedBox(
              height: 0,
            ),
      ),
    );
  }
}
