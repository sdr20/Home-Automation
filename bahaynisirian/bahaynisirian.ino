#include <WiFi.h>
#include <WebServer.h>

const char* ssid = "Wifi ng Bahay ni sir ian";
const char* password = "admin123";

WebServer server(80);

const int relayPins[4] = {23, 22, 21, 19}; // Define your relay pins

void setup() {
  Serial.begin(115200);
  WiFi.softAP(ssid, password);
  
  for (int i = 0; i < 4; i++) {
    pinMode(relayPins[i], OUTPUT);
    digitalWrite(relayPins[i], LOW); // Start with relays off
  }
  
  server.on("/", HTTP_GET, []() {
    server.send(200, "text/html", generateHTML());
  });

  server.on("/relay", HTTP_GET, handleRelayControl);

  server.begin();
  Serial.println("Access Point started");
}

void loop() {
  server.handleClient();
}

void handleRelayControl() {
  if (server.hasArg("id") && server.hasArg("state")) {
    int relayId = server.arg("id").toInt();
    int state = server.arg("state").toInt();
    if (relayId >= 0 && relayId < 4) {
      digitalWrite(relayPins[relayId], state);
      server.send(200, "text/plain", "Relay " + String(relayId) + (state ? " ON" : " OFF"));
      return;
    }
  }
  server.send(400, "text/plain", "Invalid parameters");
}

String generateHTML() {
  String html = "<html><body><h1>Relay Control</h1>";
  for (int i = 0; i < 4; i++) {
    html += "<h2>Relay " + String(i) + "</h2>";
    html += "<button onclick=\"fetch('/relay?id=" + String(i) + "&state=1')\">ON</button>";
    html += "<button onclick=\"fetch('/relay?id=" + String(i) + "&state=0')\">OFF</button><br><br>";
  }
  html += "</body></html>";
  return html;
}
