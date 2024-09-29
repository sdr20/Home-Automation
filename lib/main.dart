import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESP32 Relay Control',
      debugShowCheckedModeBanner: false,
      home: RelayControl(),
      theme: ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.grey[700], fontSize: 16),
    bodyMedium: TextStyle(color: Colors.grey[600]),
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.grey[800],
    ),
  ),
),
    );
  }
}

class RelayControl extends StatefulWidget {
  @override
  _RelayControlState createState() => _RelayControlState();
}

class _RelayControlState extends State<RelayControl> {
  final String baseUrl = 'http://192.168.4.1/relay';
  List<bool> relayStates = [false, false, false, false];

  Future<void> controlRelay(int id, bool state) async {
    final url = Uri.parse('$baseUrl?id=$id&state=${state ? 1 : 0}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          relayStates[id] = state;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  content: Text('Relay ${id + 1} turned ${state ? 'ON' : 'OFF'}'),
  backgroundColor: state ? Colors.green : Colors.red,
  duration: Duration(seconds: 2), // Delay set to 2 seconds
));
      } else {
        showError('Error: ${response.statusCode}');
      }
    } catch (e) {
      showError('Failed to connect to ESP32: $e');
    }
  }

void showError(String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: Colors.red,
    duration: Duration(seconds: 2), // Delay set to 2 seconds
  ));
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('House Automation', style: TextStyle(fontSize: 24)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade300,
              Colors.blue.shade700,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildRelayRow('Bedroom', 0, 'Living Room', 1),
              SizedBox(height: 20),
              buildRelayRow('Comfort Room', 2, 'Garage', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRelayRow(String name1, int id1, String name2, int id2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: buildRelayCard(name1, id1)),
        SizedBox(width: 20),
        Expanded(child: buildRelayCard(name2, id2)),
      ],
    );
  }

  Widget buildRelayCard(String name, int id) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                relayStates[id] ? 'ON' : 'OFF',
                style: TextStyle(
                  fontSize: 14,
                  color: relayStates[id] ? Colors.green : Colors.red,
                ),
              ),
              Transform.scale(
                scale: 1.5,
                child: Switch(
                  value: relayStates[id],
                  activeColor: Colors.green,
                  inactiveTrackColor: Colors.grey.shade300,
                  onChanged: (value) => controlRelay(id, value),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
