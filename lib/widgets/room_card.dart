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
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  widget.iconData,
                  size: 22,
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
            const SizedBox(height: 4),
            Text(
              widget.roomName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Active: ${widget.ledService.getActiveDuration(widget.ledId)}s',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              height: 32,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
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
                icon: const Icon(Icons.timer, size: 14),
                label: const Text(
                  'Timer',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}