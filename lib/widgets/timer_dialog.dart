import 'package:flutter/material.dart';
import '../services/led_service.dart';

class TimerDialog extends StatefulWidget {
  final String roomName;
  final int ledId;
  final LEDService ledService;

  const TimerDialog({
    Key? key,
    required this.roomName,
    required this.ledId,
    required this.ledService,
  }) : super(key: key);

  @override
  _TimerDialogState createState() => _TimerDialogState();
}

class _TimerDialogState extends State<TimerDialog> {
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Set Timer for ${widget.roomName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimeField('Hours', _hoursController),
              _buildTimeField('Minutes', _minutesController),
              _buildTimeField('Seconds', _secondsController),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final hours = int.tryParse(_hoursController.text) ?? 0;
            final minutes = int.tryParse(_minutesController.text) ?? 0;
            final seconds = int.tryParse(_secondsController.text) ?? 0;
            
            widget.ledService.setTimer(
              widget.ledId,
              hours,
              minutes,
              seconds,
              context,
            );
            
            Navigator.pop(context);
          },
          child: const Text('Set Timer'),
        ),
      ],
    );
  }

  Widget _buildTimeField(String label, TextEditingController controller) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Text(label),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '0',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}