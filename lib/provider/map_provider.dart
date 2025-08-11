import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapProvider extends ChangeNotifier{

  LatLng? _searchedLocation;
  LatLng? get searchedLocation => _searchedLocation;


  Future<void> searchLocation(String address) async {
    try {
      var locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        _searchedLocation = LatLng(locations.first.latitude, locations.first.longitude);
        notifyListeners();
      }
    } catch (e) {
      print('Error: $e');
    }
  }

}