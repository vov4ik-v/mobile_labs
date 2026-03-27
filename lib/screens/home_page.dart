import 'package:flutter/material.dart';
import 'package:mobile_labs/models/user.dart';
import 'package:mobile_labs/repositories/local_auth_repository.dart';
import 'package:mobile_labs/screens/room_detail_page.dart';
import 'package:mobile_labs/theme.dart';
import 'package:mobile_labs/widgets/room_card.dart';
import 'package:mobile_labs/widgets/summary_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final repository = LocalAuthRepository(prefs);
    final user = await repository.getCurrentUser();
    if (mounted) {
      setState(() => _user = user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayName = _user?.name ?? 'User';

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello, $displayName',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight:
                                      FontWeight.bold,
                                  color: AppColors
                                      .textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Your home climate is '
                                'under control',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors
                                      .textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await Navigator.pushNamed(
                              context,
                              '/profile',
                            );
                            _loadUser();
                          },
                          child: const CircleAvatar(
                            radius: 24,
                            backgroundColor:
                                AppColors.primaryLight,
                            child: Icon(
                              Icons.person,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const SummaryCard(
                      temperature: '22.5',
                      humidity: '48%',
                      mode: 'Comfort',
                      heatingStatus: 'On',
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
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              sliver: SliverGrid(
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.width >
                              600
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
                        builder: (_) =>
                            const RoomDetailPage(
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
                        builder: (_) =>
                            const RoomDetailPage(
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
                        builder: (_) =>
                            const RoomDetailPage(
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
                        builder: (_) =>
                            const RoomDetailPage(
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
            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),
    );
  }
}
