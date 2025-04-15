import 'package:carsilla/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{
  UserModel? _currentUser;


  //getters
  UserModel? get getCurrentUser => _currentUser;


  //setters
  set setCurrentUser(UserModel? userModel){
    _currentUser = userModel;
    notifyListeners();
  }
}