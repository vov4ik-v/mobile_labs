import 'package:mobile_labs/models/room.dart';
import 'package:mobile_labs/services/api_service.dart';
import 'package:mobile_labs/services/connectivity_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class RoomRepository {
  Future<List<Room>> getRooms(String token);
}

class CachedRoomRepository implements RoomRepository {
  static const _cacheKey = 'cached_rooms';

  final ApiService _apiService;
  final ConnectivityService _connectivity;
  final SharedPreferences _prefs;

  const CachedRoomRepository(
    this._apiService,
    this._connectivity,
    this._prefs,
  );

  @override
  Future<List<Room>> getRooms(String token) async {
    final isOnline = await _connectivity.hasConnection();

    if (isOnline) {
      try {
        final data = await _apiService.getRooms(token);
        final rooms = data
            .map(
              (json) =>
                  Room.fromJson(json as Map<String, dynamic>),
            )
            .toList();
        await _cacheRooms(rooms);
        return rooms;
      } on Exception {
        return _getCachedRooms();
      }
    }

    return _getCachedRooms();
  }

  Future<void> _cacheRooms(List<Room> rooms) async {
    await _prefs.setString(
      _cacheKey,
      Room.toJsonList(rooms),
    );
  }

  List<Room> _getCachedRooms() {
    final cached = _prefs.getString(_cacheKey);
    if (cached == null) return _defaultRooms;
    return Room.fromJsonList(cached);
  }

  static const List<Room> _defaultRooms = [
    Room(
      id: 1,
      name: 'Living Room',
      icon: 'chair_outlined',
      temperature: 23,
      humidity: 45,
      isHeatingOn: true,
    ),
    Room(
      id: 2,
      name: 'Bedroom',
      icon: 'bed_outlined',
      temperature: 21,
      humidity: 50,
      isHeatingOn: false,
    ),
    Room(
      id: 3,
      name: 'Kitchen',
      icon: 'soup_kitchen_outlined',
      temperature: 24,
      humidity: 40,
      isHeatingOn: true,
    ),
    Room(
      id: 4,
      name: 'Office',
      icon: 'desk_outlined',
      temperature: 22,
      humidity: 47,
      isHeatingOn: false,
    ),
  ];
}
