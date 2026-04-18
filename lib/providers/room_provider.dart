import 'package:flutter/material.dart';
import 'package:mobile_labs/models/room.dart';
import 'package:mobile_labs/repositories/room_repository.dart';

class RoomProvider extends ChangeNotifier {
  final RoomRepository _roomRepository;

  List<Room>? _rooms;
  String? _error;

  RoomProvider(this._roomRepository);

  List<Room>? get rooms => _rooms;
  String? get error => _error;

  Future<List<Room>> loadRooms(String token) async {
    try {
      _error = null;
      _rooms = await _roomRepository.getRooms(token);
      notifyListeners();
      return _rooms!;
    } on Exception catch (e) {
      _error = e.toString();
      notifyListeners();
      return _rooms ?? [];
    }
  }
}
