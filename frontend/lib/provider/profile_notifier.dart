import 'package:covidpass/models/api_response.dart';
import 'package:covidpass/models/user.dart';
import 'package:covidpass/repository/data_repository.dart';
import 'package:covidpass/utils/user_role_serializer.dart';
import 'package:flutter/cupertino.dart';

class ProfileNotifier with ChangeNotifier {
  User _user;
  bool _isRequestFinished = false;

  User get user => _user;

  bool get isRequestFinished => _isRequestFinished;

  ProfileNotifier(int userId, String userType) {
    getProfile(userId, userType);
  }

  void getProfile(int userId, String userType) async {
    try {
      _isRequestFinished = false;
      notifyListeners();
      ApiResponse response = await DataRepository.instance
          .getProfileInfo(userId, UserRoleSerializer.getEnumFromRole(userType));
      _user = User.fromJson(response.data);
      _isRequestFinished = true;
      notifyListeners();
    } catch (e) {
      print(e.message);
      _isRequestFinished = true;
      notifyListeners();
    }
  }
}
