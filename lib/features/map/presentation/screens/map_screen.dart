import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:final_tasks_front_end/core/widgets/place.dart';
import '../cubit/map_controller.dart';

class MapScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final logic = MapLogicController(); // اسم جديد
    final flutterMapController = MapController(); // هذا خاص بـ flutter_map
    final initialLatLng = LatLng(location.latitude, location.longitude);

    return ChangeNotifierProvider<MapLogicController>.value(
      value: logic,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isSelecting ? 'Pick your location' : 'Your Location'),
          actions: [
            if (isSelecting)
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  Navigator.of(context).pop(logic.pickedLocation);
                },
              ),
          ],
        ),
        body: Consumer<MapLogicController>(
          builder: (context, controller, _) {
            return FlutterMap(
              mapController: flutterMapController,
              options: MapOptions(
                initialCenter: initialLatLng,
                initialZoom: 13.0,
                onTap: isSelecting
                    ? (tapPos, latlng) => controller.selectLocation(latlng)
                    : null,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.final_tasks_front_end',
                ),
                MarkerLayer(
                  markers: (controller.pickedLocation == null && isSelecting)
                      ? []
                      : [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: controller.pickedLocation ?? initialLatLng,
                      child: Icon(
                        Icons.location_pin,
                        color: AppColors.lableMap,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
