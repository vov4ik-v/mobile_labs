import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mobile_labs/models/room.dart';
import 'package:mobile_labs/providers/auth_provider.dart';
import 'package:mobile_labs/providers/room_provider.dart';
import 'package:mobile_labs/services/connectivity_service.dart';
import 'package:mobile_labs/services/mqtt_service.dart';
import 'package:mobile_labs/widgets/home_header.dart';
import 'package:mobile_labs/widgets/reset_dialog.dart';
import 'package:mobile_labs/widgets/room_grid.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<List<ConnectivityResult>>?
      _connectSub;
  StreamSubscription<String>? _tempSub;
  late Future<List<Room>> _roomsFuture;
  bool _wasOffline = false;
  String _avgTemp = '22.5';

  @override
  void initState() {
    super.initState();
    _roomsFuture = Future<List<Room>>.value([]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRooms();
      _initConnectivity();
      _initMqtt();
    });
  }

  void _loadRooms() {
    final token = Provider.of<AuthProvider>(
          context,
          listen: false,
        ).token ??
        '';
    setState(() {
      _roomsFuture = Provider.of<RoomProvider>(
        context,
        listen: false,
      ).loadRooms(token);
    });
  }

  Future<void> _resetTemperature() async {
    final ok = await showResetDialog(context);
    if (!ok || !mounted) return;
    Provider.of<MqttService>(
      context,
      listen: false,
    ).publish('sensor/command/labs', 'ADMIN_RESET');
    setState(() => _avgTemp = '0.0');
  }

  Future<void> _initMqtt() async {
    final mqtt = Provider.of<MqttService>(
      context,
      listen: false,
    );
    await mqtt.connectAndListen();
    if (!mounted) return;
    _tempSub = mqtt.temperatureStream.listen((v) {
      final t = double.tryParse(v);
      if (t != null && mounted) {
        setState(
          () => _avgTemp = t.toStringAsFixed(1),
        );
      }
    });
  }

  Future<void> _initConnectivity() async {
    final svc = Provider.of<ConnectivityService>(
      context,
      listen: false,
    );
    if (!await svc.hasConnection() && mounted) {
      _wasOffline = true;
    }
    _connectSub =
        svc.onConnectivityChanged.listen((r) {
      final off =
          r.contains(ConnectivityResult.none);
      if (!off && _wasOffline && mounted) {
        _wasOffline = false;
        _loadRooms();
      } else if (off) {
        _wasOffline = true;
      }
    });
  }

  @override
  void dispose() {
    _connectSub?.cancel();
    _tempSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = Provider.of<AuthProvider>(context)
            .currentUser
            ?.name ??
        'User';

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: HomeHeader(
                displayName: name,
                avgTemperature: _avgTemp,
                onProfileTap: () =>
                    Navigator.pushNamed(
                  context,
                  '/profile',
                ),
                onResetLongPress:
                    _resetTemperature,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: RoomGrid(roomsFuture: _roomsFuture),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}
