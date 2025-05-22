import 'dart:convert';
import 'package:final_tasks_front_end/core/widgets/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import '../constants/app_colors.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  Future<void> _savePlace(double latitude, double longitude) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude',
      );

      final response = await http.get(url, headers: {
        'User-Agent': 'flutter-app' // ضروري لنظام OSM
      });

      final resData = json.decode(response.body);
      final address = resData['display_name'] ?? 'Unknown location';

      setState(() {
        _pickedLocation = PlaceLocation(
          latitude: latitude,
          longitude: longitude,
          address: address,
        );
        _isGettingLocation = false;
      });

      widget.onSelectLocation(_pickedLocation!);
    } catch (e) {
      setState(() {
        _isGettingLocation = false;
      });
    }
  }

  void _selectMap() async {
    final pickedLocation = await Navigator.pushNamed(context, '/mapScreen',) as LatLng?;;

    if (pickedLocation == null) return;

    await _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }


  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    await location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
    );

    setState(() {
      _isGettingLocation = true;
    });

    final locationData = await location.getLocation();

    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) return;

    await _savePlace(lat, lng);
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    Widget previewContent = const Text(
      'No Location Chosen',
      textAlign: TextAlign.center,
    );

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    } else if (_pickedLocation != null) {
      previewContent = Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(
                _pickedLocation!.latitude,
                _pickedLocation!.longitude,
              ),
              zoom: 13,
              interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(_pickedLocation!.latitude, _pickedLocation!.longitude),
                    width: 60,
                    height: 60,
                    child:  Icon(Icons.location_pin, size: 40, color: AppColors.lableMap),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 4,
            left: 4,
            right: 4,
            child: Container(
              color: AppColors.background,
              padding: const EdgeInsets.all(4),
              child: Text(
                _pickedLocation!.address,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          )
        ],
      );
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: AppColors.border,
            ),
          ),
          alignment: Alignment.center,
          child: previewContent,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: TextButton.icon(
                icon:  Icon(Icons.location_on, color: AppColors.icon),
                label: FittedBox(
                  child: Text(
                    'Current Location',
                    style: TextStyle(color: AppColors.textDark, fontSize: screenWidth * 0.035),
                  ),
                ),
                onPressed: _getCurrentLocation,
              ),
            ),
            Flexible(
              child: TextButton.icon(
                icon:  Icon(Icons.map, color: AppColors.icon),
                label: FittedBox(
                  child: Text(
                    'Select on Map',
                    style: TextStyle(color: AppColors.textDark, fontSize: screenWidth * 0.035),
                  ),
                ),
                onPressed: _selectMap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
