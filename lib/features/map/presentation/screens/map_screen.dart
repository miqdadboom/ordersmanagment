import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../core/widgets/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation location;
  final bool isSelecting;

  const MapScreen({
    super.key,
    this.location = const PlaceLocation(
      latitude: 31.9522,
      longitude: 35.2332,
      address: '',
    ),
    this.isSelecting = true,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  void _selectLocation(TapPosition tapPosition, LatLng position) {
    if (!widget.isSelecting) return;
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    final initialLatLng = LatLng(widget.location.latitude, widget.location.longitude);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting ? 'Pick your location' : 'Your Location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
            ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          center: initialLatLng,
          zoom: 13.0,
          onTap: widget.isSelecting ? _selectLocation : null,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: (_pickedLocation == null && widget.isSelecting)
                ? []
                : [
              Marker(
                width: 80.0,
                height: 80.0,
                point: _pickedLocation ?? initialLatLng,
                child:  Icon(
                  Icons.location_pin,
                  color: AppColors.lableMap,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
