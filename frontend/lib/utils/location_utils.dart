import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:location/location.dart';

class LocationUtils {
  static Location _location = Location();

  static Future<LocationData> getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await _location.getLocation();
    return _locationData;
  }

  static Future<List<Address>> getLocationFromCoordinates(
      double lat, double long) async {
    Coordinates coordinates = Coordinates(lat, long);
    return await Geocoder.local.findAddressesFromCoordinates(coordinates);
  }
}
