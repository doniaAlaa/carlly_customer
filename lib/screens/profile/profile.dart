import 'package:carsilla/providers/user_provider.dart';
import 'package:carsilla/screens/auth/login_by_phone_screen.dart';
import 'package:carsilla/screens/home_screen.dart';
import 'package:carsilla/widgets/bottomnavbar.dart';
import 'package:carsilla/widgets/btn.dart';
import 'package:carsilla/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_model.dart';
import '../../utils/theme.dart';
import '../../const/endpoints.dart';
import '../../services/network_service_handler.dart';
import 'edit_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Provider.of<ProfileVmC>(context, listen: false).checkProfileVmF(context);
  }



  Future<bool> deleteAccount(String userId)async{
    String url = Endpoints.baseUrl + Endpoints.deleteAccount;
    var body = {'id' : userId};
    bool success = false;
    await NetworkServiceHandler(context).postDataHandler(
      url : url,
      body:  body,
      onSuccess: (response) {
        success = true;
      },);
   return success;
  }
  @override
  Widget build(BuildContext context) {
    return Header(
      navbar: NavBarWidget(currentScreen: "Profile"),
      body: Consumer<UserProvider>(builder: (context, userProvider, child) {
        UserModel? currentUser = userProvider.getCurrentUser;
        if(currentUser ==null){
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25),
                  Text('Please Sign In to manage your profile.',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: MainTheme.primaryColor),),
                  SizedBox(
                    height: 24,
                  ),
                  MainButton(onclick: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginByPhoneScreen(),));
                  },label: "Sign In",)

                ],
              ),
            ],
          );
        }else{
          return Column(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03 / 1),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfile(userModel: currentUser,),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Stack(
                    children: [

                      currentUser.image == null
                          ? CircleAvatar(
                        backgroundColor: Colors.grey.shade100,
                        radius: 22,
                        child: Icon(Icons.person_2),
                      )
                          : CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade800,
                        backgroundImage:  NetworkImage(currentUser.image!),

                      ),
                      Positioned(
                          bottom: 2,
                          right: 2,
                          child: CircleAvatar(
                              backgroundColor:
                              Colors.deepPurpleAccent.shade200,
                              radius: 17,
                              child: const Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.edit_outlined,
                                  color: Colors.white,
                                  size: 17,
                                ),
                              )))
                    ],
                  ),
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02 / 1),
              Text(
                "${currentUser.firstName ?? ''} ${currentUser.lastName ?? ''}",
                style: textTheme.headlineLarge!.copyWith(
                    color: Colors.grey.shade900,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01 / 1),
              ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(const StadiumBorder()),
                    backgroundColor:
                    MaterialStateProperty.all(MainTheme.primaryColor),
                  ),
                  onPressed: () async {},
                  child: Text(
                    currentUser.email ?? '',
                    style: textTheme.titleMedium!
                        .copyWith(color: Colors.white),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02 / 1,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04 / 1,
                ),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 10,
                              offset: const Offset(0, 2))
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ListTile(

                            title: Text('First Name', style: TextStyle( fontSize: 12),),
                            subtitle: Text(currentUser.firstName ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),

                          ),
                          SizedBox(
                              height: 1,
                              child: Divider(
                                indent: 15,
                                endIndent: 15,
                                color: Colors.grey.shade300,
                              )),
                          ListTile(

                            title: Text('Last Name', style: TextStyle( fontSize: 12),),
                            subtitle: Text(currentUser.lastName ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),

                          ),
                          SizedBox(
                              height: 1,
                              child: Divider(
                                indent: 15,
                                endIndent: 15,
                                color: Colors.grey.shade300,
                              )),
                          ListTile(
                            title: Text('Phone', style: TextStyle( fontSize: 12),),
                            subtitle: Text(currentUser.phone ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),),

                          SizedBox(
                              height: 1,
                              child: Divider(
                                indent: 15,
                                endIndent: 15,
                                color: Colors.grey.shade300,
                              )),
                          ListTile(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfile(userModel: currentUser,)));
                            },
                            leading: Icon(
                              Icons.settings_outlined,
                              color: Colors.grey.shade700,
                            ),
                            title: const Text('Update'),
                            trailing: const Icon(
                              Icons.arrow_forward_outlined,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                              height: 1,
                              child: Divider(
                                indent: 15,
                                endIndent: 15,
                                color: Colors.grey.shade300,
                              )),
                          ListTile(
                            onTap: (){
                              showDialog(context: context, builder: (BuildContext context){
                                return  AlertDialog(
                                  title: Text('Logout'),
                                  content: Text('Do you want to logout?'),
                                  actions: [
                                    TextButton(onPressed: (){
                                      Navigator.pop(context);
                                    }, child: Text('No')),

                                    TextButton(onPressed: () async {
                                      Navigator.pop(context);
                                      final prefs = await SharedPreferences.getInstance();
                                      await prefs.clear();
                                      userProvider.setCurrentUser = null;
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> HomeScreen(origin: 'profile')), (route) => false);

                                    }, child: Text('Yes')),
                                  ],
                                );
                              });

                            },
                            leading: const Icon(
                              Icons.exit_to_app_outlined,
                              color: MainTheme.primaryColor,
                            ),
                            title: const Text('Logout'),
                            trailing: const Icon(
                              Icons.arrow_forward_outlined,
                              color: MainTheme.primaryColor,
                            ),
                          ),
                          SizedBox(
                              height: 1,
                              child: Divider(
                                indent: 15,
                                endIndent: 15,
                                color: Colors.grey.shade300,
                              )),
                          ListTile(
                            onTap: (){
                              showDialog(context: context, builder: (BuildContext context){
                                bool isLoading = false;
                                return StatefulBuilder(builder: (context, setState) {
                                  return  AlertDialog(
                                    title: Text('Delete Account',style: TextStyle(color: MainTheme.primaryColor),),
                                    content: Text("Permanently delete your account and all associated data. Are you sure you want to delete your account. Once deleted, your account and data cannot be recovered."),
                                    actions: [
                                      TextButton(onPressed: (){
                                        Navigator.pop(context);
                                      }, child: Text('Cancel'.toUpperCase())),

                                      TextButton(onPressed: () async {
                                        setState(()=>isLoading = true);
                                        bool success = await deleteAccount(currentUser.id!.toString());
                                        if(success){
                                          final prefs = await SharedPreferences.getInstance();
                                          await prefs.clear();
                                          userProvider.setCurrentUser = null;
                                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> HomeScreen(origin: 'profile')), (route) => false);
                                        }
                                        setState(()=>isLoading = false);

                                      }, child: isLoading ? Container(height: 25,width: 25,child: CircularProgressIndicator(strokeWidth: 3,),) : Text('Confirm'.toUpperCase())),
                                    ],
                                  );
                                },);
                              });

                            },
                            leading: const Icon(
                              Icons.delete,
                              color: MainTheme.primaryColor,
                            ),
                            title: const Text('Delete Account',style: TextStyle(color: MainTheme.primaryColor),),
                            trailing: const Icon(
                              Icons.arrow_forward_outlined,
                              color: MainTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    )),
              )
            ],
          );
        }
      }),
    );
  }
}
