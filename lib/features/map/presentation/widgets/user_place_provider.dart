import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/widgets/place.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {

  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
        return db.execute('CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, lat REAL, lng REAL, address TEXT)');
      },
      version: 1
  );
  return db;
}

class UserPlaceNotifier extends StateNotifier<List<Place>> {
  UserPlaceNotifier() : super(const []);

  void loadPlaces() async {
    final db = await _getDatabase();
    final data = await  db.query('user_places');
    final places =  data.map((row) => Place(
      id: row['id'] as String,
      title: row['title'] as String,
      location: PlaceLocation(
        latitude: row['lat'] as double,
        longitude: row['lng'] as double,
        address: row['address'] as String,
      ),
    ),
    ).toList();
    state = places;
  }

  void addPlace(String title, PlaceLocation location) async {
    final newPlace = Place(title: title, location: location);

    final db = await _getDatabase();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });

    state = [newPlace, ...state];
  }
}

final userPlaceProvider =
StateNotifierProvider<UserPlaceNotifier, List<Place>>(
      (ref) => UserPlaceNotifier(),
);