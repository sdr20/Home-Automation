#include <WiFi.h>
#include <WebServer.h>

// WiFi credentials
const char *ssid = "ESP32-LED-Control";
const char *password = "12345678";

// LED GPIO pins
const int led1 = 16;
const int led2 = 17;
const int led3 = 18;
const int led4 = 19;

WebServer server(80);

void handleLEDControl() {
  if (server.hasArg("id") && server.hasArg("state")) {
    int id = server.arg("id").toInt();
    int state = server.arg("state").toInt();

    // Select the correct LED based on ID
    int ledPin;
    switch (id) {
      case 0: ledPin = led1; break;
      case 1: ledPin = led2; break;
      case 2: ledPin = led3; break;
      case 3: ledPin = led4; break;
      default: server.send(400, "text/plain", "Invalid LED ID"); return;
    }

    // Set the LED state
    digitalWrite(ledPin, state == 1 ? HIGH : LOW);
    server.send(200, "text/plain", "LED controlled");
  } else {
    server.send(400, "text/plain", "Missing parameters");
  }
}

void setup() {
  pinMode(led1, OUTPUT);
  pinMode(led2, OUTPUT);
  pinMode(led3, OUTPUT);
  pinMode(led4, OUTPUT);

  WiFi.softAP(ssid, password);

  server.on("/", handleLEDControl);
  server.begin();
}

void loop() {
  server.handleClient();
}
