class Endpoints {

  // static const String baseUrl = "https://backend.carllymotors.com/api/";
  static const String baseUrl = "https://livebackend.carllymotors.com/public/api/";
  // static const String baseUrl = "https://livebackend.carllymotors.com/api";

  static const String imageUrl = "https://backend.carllymotors.com/";
  static const String adduser = "adduser"; // post
  static const String getprofile = "getusers"; // get
  static const String updateprofile = "updateprofile"; // post
  static const String addDataToHomeAssis = "addhomeassis"; // post
  static const String addDataToRoadAssis = "addroadassis"; // post
  static const String emailupdate = "emailupdate"; // post
  static const String passwordupdate = "passwordupdate"; // post
  static const String checkuserbyphone =
      "checkuserbyphone/"; // get /checkuserbyphone/0301234567
  static const String getInvoices = "getinvoices"; // get
  static const String getdealers = "getdealers"; // get
  static const String getlisting = "getAllCarsListing?"; // get
  static const String getMyListing = "myCarsListing?"; // get
  static const String addlisting = "addCarListing"; // get
  static const String getWorkshops = "workshops"; // get


  static const String getCarById = "getCarListingById/";
  static const String getSparePartById = "getSparePartsById/";
  static const String editCarDetails = 'editCarListing';
  static const String deleteAccount = "deleteUser";
  static const String getCurrentUser = "getCurrentUser";

  /////// workshop
  static const String addworkshop = "addworkshop"; // post
  /////// spare parts
  static const String addrepairingcars = "addrepairingcars"; // post
  static const String getrepairingcars = "getrepairingcars"; // get
  static const String getspareparts = "getspareparts"; // get
  static const String getsparepartsshops = "getsparepartsshops"; // get
  static const String getsparepartscategories = "getSparepartCategories"; // get
  /////// insurance
  static const String addinsranceorder = "addinsranceorder"; // post
  static const String getallinsuranceorders = "getallinsuranceorders"; // get
  static const String getinsuranceordersbyuserid =
      "getinsuranceordersbyuserid/"; // get
  static const String getinsurancecompanies = "getinsurancecompanies"; // get
  /////// admin chats
  static const String addchats = "addchats"; // post
  static const String getallchats = "getallchats"; // get
  static const String getchatsbyid = "getchatsbyid/"; // get
  /////// vhicle_trans_home_assis
  static const String addvthomeassis = "addvthomeassis"; // post
  static const String getallvthomeassis = "getallvthomeassis"; // get
  static const String getvthomeassisbyuserid = "getvthomeassisbyuserid"; // get
}
