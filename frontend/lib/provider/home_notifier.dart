import 'package:covidpass/models/api_response.dart';
import 'package:covidpass/models/merchant.dart';
import 'package:covidpass/repository/data_repository.dart';
import 'package:covidpass/utils/location_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';

class HomeNotifier with ChangeNotifier {
  List<dynamic> _merchants;
  bool _isRequestFinished = false;
  Address _address;

  List<dynamic> get merchants => _merchants;

  bool get isRequestFinished => _isRequestFinished;
  Address get currentAddress => _address;

  HomeNotifier(double lat, double long) {
    getAllMerchants(lat.toString(), long.toString());
    getLocationByLatLong(lat, long);
    // getAllMerchants("61.243423", "130.2324");
    // getAllMerchants("17.5028847", "78.5435476");
  }

  void getAllMerchants(String lat, String long) async {
    try {
      _isRequestFinished = false;
      notifyListeners();
      ApiResponse response =
          await DataRepository.instance.getAllMerchants(lat, long);
      _merchants = response.data.map((it) => Merchant.fromJson(it)).toList();
      _isRequestFinished = true;
      notifyListeners();
    } catch (e) {
      print(e.message);
      _isRequestFinished = true;
      notifyListeners();
    }
  }

  void getLocationByLatLong(double lat, double long) async {
    List<Address> addresses =
        await LocationUtils.getLocationFromCoordinates(lat, long);
    _address = addresses.first;
    notifyListeners();
  }
}
