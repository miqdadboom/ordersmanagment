// lib/features/map/presentation/cubit/map_logic_controller.dart
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MapLogicController extends ChangeNotifier {
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
