import 'package:mobile_labs/models/room.dart';

sealed class RoomState {
  const RoomState();
}

class RoomInitial extends RoomState {
  const RoomInitial();
}

class RoomLoading extends RoomState {
  const RoomLoading();
}

class RoomLoaded extends RoomState {
  final List<Room> rooms;
  const RoomLoaded(this.rooms);
}

class RoomError extends RoomState {
  final String message;
  final List<Room> previousRooms;
  const RoomError(this.message, {this.previousRooms = const []});
}
