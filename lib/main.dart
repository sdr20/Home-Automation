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
    );
  }
}

class RelayControl extends StatefulWidget {
  @override
  _RelayControlState createState() => _RelayControlState();
}

class _RelayControlState extends State<RelayControl> {
  final String baseUrl = 'http://192.168.4.1/relay'; // ESP32 IP Address
  List<bool> relayStates = [false, false, false, false]; // Track relay states

  Future<void> controlRelay(int id, bool state) async {
    final url = '$baseUrl?id=${id - 1}&state=${state ? 1 : 0}'; // Adjusting ID for request
    print('Requesting URL: $url'); // Debugging line
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          relayStates[id - 1] = state; // Update the state
        });
        print('Relay $id turned ${state ? 'ON' : 'OFF'}');
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Failed to control relay: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('House Automation'),
        backgroundColor: Colors.blueAccent, // Header color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: buildRelayContainer('Bedroom', 1)),
                SizedBox(width: 20),
                Expanded(child: buildRelayContainer('Living Room', 2)),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: buildRelayContainer('Comfort Room', 3)),
                SizedBox(width: 20),
                Expanded(child: buildRelayContainer('Garage', 4)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRelayContainer(String name, int id) {
    return Container(
      padding: EdgeInsets.all(16.0),
      height: 120, // Increased height
      decoration: BoxDecoration(
        color: Colors.lightBlue[50],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyle(fontSize: 16)), // Smaller font size
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(relayStates[id - 1] ? 'ON' : 'OFF', style: TextStyle(fontSize: 14)), // Smaller font size
              SizedBox(width: 10),
              Switch(
                value: relayStates[id - 1],
                activeColor: Colors.green, // Set the active color to green
                onChanged: (value) => controlRelay(id, value),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
