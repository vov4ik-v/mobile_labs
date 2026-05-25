import 'package:flutter/material.dart';
import 'package:mobile_labs/cubits/room_state.dart';
import 'package:mobile_labs/models/room.dart';
import 'package:mobile_labs/screens/room_detail_page.dart';
import 'package:mobile_labs/utils/icon_mapper.dart';
import 'package:mobile_labs/widgets/room_card.dart';

class RoomGrid extends StatelessWidget {
  final RoomState state;

  const RoomGrid({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      RoomLoading() => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      ),
      RoomLoaded(rooms: final rooms) => _buildGrid(context, rooms),
      RoomError(previousRooms: final rooms) => _buildGrid(context, rooms),
      RoomInitial() => const SizedBox.shrink(),
    };
  }

  Widget _buildGrid(BuildContext context, List<Room> rooms) {
    final crossAxisCount = MediaQuery.of(context).size.width > 600 ? 3 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];
        return RoomCard(
          icon: IconMapper.fromString(room.icon),
          name: room.name,
          temperature: room.temperature.toStringAsFixed(0),
          humidity: room.humidity.toString(),
          isHeatingOn: room.isHeatingOn,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => RoomDetailPage(
                name: room.name,
                temperature: room.temperature.round(),
                humidity: room.humidity,
                isHeatingOn: room.isHeatingOn,
              ),
            ),
          ),
        );
      },
    );
  }
}
