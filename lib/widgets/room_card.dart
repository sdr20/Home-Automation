import 'package:flutter/material.dart';
import '../services/led_service.dart';
import 'timer_dialog.dart';

class RoomCard extends StatefulWidget {
  final String roomName;
  final IconData iconData;
  final int ledId;
  final LEDService ledService;

  const RoomCard({
    Key? key,
    required this.roomName,
    required this.iconData,
    required this.ledId,
    required this.ledService,
  }) : super(key: key);

  @override
  _RoomCardState createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  widget.iconData,
                  size: 28,
                  color: isOn ? Colors.blue : Colors.grey,
                ),
                Switch(
                  value: isOn,
                  onChanged: (value) async {
                    await widget.ledService.controlLED(
                      widget.ledId,
                      value,
                      context,
                      (newState) {
                        setState(() {
                          isOn = newState;
                        });
                      },
                    );
                  },
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  widget.roomName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Active: ${widget.ledService.getActiveDuration(widget.ledId)}s',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => TimerDialog(
                    roomName: widget.roomName,
                    ledId: widget.ledId,
                    ledService: widget.ledService,
                  ),
                );
              },
              icon: const Icon(Icons.timer, size: 18),
              label: const Text('Timer'),
            ),
          ],
        ),
      ),
    );
  }
}