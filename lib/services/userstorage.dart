import 'package:shared_preferences/shared_preferences.dart';

class StorageClass {



  static addCarListingFav(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> getcarlistingfavid =
        prefs.getStringList('carlistingfavid') ?? [];
    if (getcarlistingfavid.contains(id)) {
      getcarlistingfavid.remove(id);
    } else {
      getcarlistingfavid.add(id);
    }
    await prefs.setStringList('carlistingfavid', getcarlistingfavid);
    // getCarListingFav();
  }

  static getCarListingFav() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final carlistingfavid = prefs.getStringList('carlistingfavid');
    return carlistingfavid ?? [];
  }
}
