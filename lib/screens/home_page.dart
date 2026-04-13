import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubits/auth_cubit.dart';
import 'package:mobile_labs/cubits/mqtt_cubit.dart';
import 'package:mobile_labs/cubits/mqtt_state.dart';
import 'package:mobile_labs/cubits/room_cubit.dart';
import 'package:mobile_labs/cubits/room_state.dart';
import 'package:mobile_labs/widgets/home_header.dart';
import 'package:mobile_labs/widgets/reset_dialog.dart';
import 'package:mobile_labs/widgets/room_grid.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _resetTemperature(BuildContext context) async {
    final ok = await showResetDialog(context);
    if (!ok || !context.mounted) return;
    context.read<MqttCubit>().resetTemperature();
  }

  @override
  Widget build(BuildContext context) {
    _ensureLoaded(context);
    final name = context.watch<AuthCubit>().currentUser?.name ?? 'User';
    final roomState = context.watch<RoomCubit>().state;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: BlocBuilder<MqttCubit, MqttState>(
                builder: (context, mqttState) {
                  final temp = switch (mqttState) {
                    MqttConnected(temperature: final t) => t,
                    _ => '22.5',
                  };
                  return HomeHeader(
                    displayName: name,
                    avgTemperature: temp,
                    onProfileTap: () =>
                        Navigator.pushNamed(context, '/profile'),
                    onResetLongPress: () => _resetTemperature(context),
                  );
                },
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(child: RoomGrid(state: roomState)),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  void _ensureLoaded(BuildContext context) {
    final roomCubit = context.read<RoomCubit>();
    if (roomCubit.state is RoomInitial) {
      final token = context.read<AuthCubit>().token ?? '';
      roomCubit.loadRooms(token);
      roomCubit.watchConnectivity();
    }
    final mqttCubit = context.read<MqttCubit>();
    if (mqttCubit.state is MqttDisconnected) {
      mqttCubit.connect();
    }
  }
}
