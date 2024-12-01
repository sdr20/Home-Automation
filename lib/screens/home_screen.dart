import 'package:flutter/material.dart';
import '../widgets/room_card.dart';
import '../widgets/custom_app_bar.dart';
import '../services/led_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LEDService _ledService = LEDService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    RoomCard(
                      roomName: 'Bedroom',
                      iconData: Icons.bed,
                      ledId: 0,
                      ledService: _ledService,
                    ),
                    RoomCard(
                      roomName: 'Living Room',
                      iconData: Icons.weekend,
                      ledId: 1,
                      ledService: _ledService,
                    ),
                    RoomCard(
                      roomName: 'Bathroom',
                      iconData: Icons.bathroom,
                      ledId: 2,
                      ledService: _ledService,
                    ),
                    RoomCard(
                      roomName: 'Garage',
                      iconData: Icons.garage,
                      ledId: 3,
                      ledService: _ledService,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}