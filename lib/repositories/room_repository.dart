import 'package:mobile_labs/models/room.dart';

abstract class RoomRepository {
  Future<List<Room>> getRooms();
}

class HardcodedRoomRepository implements RoomRepository {
  const HardcodedRoomRepository();

  @override
  Future<List<Room>> getRooms() async {
    return const [
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
}
