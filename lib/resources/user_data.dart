// import 'package:shared_preferences/shared_preferences.dart';
//
// class UserData {
//
//   static List<String> data = [];
//   static  String authToken = "";
//   static  String userType = "";
//   static  String userImage = ""; // get
//   static  String fName = ""; // get
//   static  String lName = ""; // get
//   static  String phone = "";
//   static  String email = "";
//   static  String id = "";
//
//   static getData() async {
//     final pref = await SharedPreferences.getInstance();
//     data = pref.getStringList('user') ?? [];
//     if(data.isNotEmpty){
//       authToken = "Bearer ${data[0]}";
//       userType = data[1];
//       userImage = data[2]; // get
//       fName = data[3]; // get
//       lName = data[4]; // get
//       phone = data[5];
//       email = data[6];
//       id = data[7];
//     }
//   }
//
//   static clearData(){
//     data.clear();
//     authToken = "";
//     userType = "";
//     userImage = "";
//     fName = "";
//     lName = "";
//     phone = "";
//     email = "";
//     id = "";
//   }
//
//
// // get
// }