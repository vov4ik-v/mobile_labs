import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mobile_labs/providers/auth_provider.dart';
import 'package:mobile_labs/screens/room_detail_page.dart';
import 'package:mobile_labs/services/connectivity_service.dart';
import 'package:mobile_labs/services/mqtt_service.dart';
import 'package:mobile_labs/theme.dart';
import 'package:mobile_labs/widgets/room_card.dart';
import 'package:mobile_labs/widgets/summary_card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  StreamSubscription<String>? _tempSubscription;
  bool _wasOffline = false;
  String _avgTemperature = '22.5';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initConnectivityTracking();
      _initMqtt();
    });
  }

  Future<void> _resetTemperature() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Admin Reset'),
        content: const Text(
          'Send a reset command to the broker?\n'
          'This will set the temperature to 0.0°C for all connected devices.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final mqtt = Provider.of<MqttService>(context, listen: false);
    mqtt.publish('sensor/command/labs', 'ADMIN_RESET');
    setState(() => _avgTemperature = '0.0');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Admin reset command sent to broker'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Future<void> _initMqtt() async {
    final mqtt = Provider.of<MqttService>(context, listen: false);
    await mqtt.connectAndListen();

    if (!mounted) return;

    _tempSubscription = mqtt.temperatureStream.listen((tempString) {
      final temp = double.tryParse(tempString);
      if (temp != null && mounted) {
        setState(() {
          _avgTemperature = temp.toStringAsFixed(1);
        });
      }
    });
  }

  Future<void> _initConnectivityTracking() async {
    final connectivity = Provider.of<ConnectivityService>(
      context,
      listen: false,
    );
    final hasConnection = await connectivity.hasConnection();

    if (!hasConnection && mounted) {
      _wasOffline = true;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Logged in offline mode. Some features may be unavailable.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
    }

    _connectivitySubscription = connectivity.onConnectivityChanged.listen((
      results,
    ) {
      final isOffline = results.contains(ConnectivityResult.none);
      if (isOffline && !_wasOffline) {
        _wasOffline = true;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Internet connection lost. You are now offline.'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } else if (!isOffline && _wasOffline) {
        _wasOffline = false;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Internet connection restored.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _tempSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final displayName = authProvider.currentUser?.name ?? 'User';

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello, $displayName',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Your home climate is under control',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await Navigator.pushNamed(context, '/profile');
                          },
                          child: const CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.primaryLight,
                            child: Icon(Icons.person, color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onLongPress: _resetTemperature,
                      child: SummaryCard(
                        temperature: _avgTemperature,
                        humidity: '48%',
                        mode: 'Comfort',
                        heatingStatus: 'On',
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Rooms',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600
                      ? 3
                      : 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildListDelegate([
                  RoomCard(
                    icon: Icons.chair_outlined,
                    name: 'Living Room',
                    temperature: '23',
                    humidity: '45',
                    isHeatingOn: true,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const RoomDetailPage(
                          name: 'Living Room',
                          temperature: 23,
                          humidity: 45,
                          isHeatingOn: true,
                        ),
                      ),
                    ),
                  ),
                  RoomCard(
                    icon: Icons.bed_outlined,
                    name: 'Bedroom',
                    temperature: '21',
                    humidity: '50',
                    isHeatingOn: false,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const RoomDetailPage(
                          name: 'Bedroom',
                          temperature: 21,
                          humidity: 50,
                          isHeatingOn: false,
                        ),
                      ),
                    ),
                  ),
                  RoomCard(
                    icon: Icons.soup_kitchen_outlined,
                    name: 'Kitchen',
                    temperature: '24',
                    humidity: '40',
                    isHeatingOn: true,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const RoomDetailPage(
                          name: 'Kitchen',
                          temperature: 24,
                          humidity: 40,
                          isHeatingOn: true,
                        ),
                      ),
                    ),
                  ),
                  RoomCard(
                    icon: Icons.desk_outlined,
                    name: 'Office',
                    temperature: '22',
                    humidity: '47',
                    isHeatingOn: false,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const RoomDetailPage(
                          name: 'Office',
                          temperature: 22,
                          humidity: 47,
                          isHeatingOn: false,
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}
