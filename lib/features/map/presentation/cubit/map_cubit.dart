import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MapLogicCubit extends ChangeNotifier {
  LatLng? _pickedLocation;

  LatLng? get pickedLocation => _pickedLocation;

  void selectLocation(LatLng position) {
    _pickedLocation = position;
    notifyListeners();
  }

  void clearLocation() {
    _pickedLocation = null;
    notifyListeners();
  }
}
