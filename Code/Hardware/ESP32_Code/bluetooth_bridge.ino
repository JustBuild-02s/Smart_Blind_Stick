#include "BluetoothSerial.h"

BluetoothSerial SerialBT;

// ESP32 UART pins
#define RXD2 16
#define TXD2 17

void setup() {

  Serial.begin(115200);          // Serial Monitor
  Serial2.begin(9600, SERIAL_8N1, RXD2, TXD2);   // Arduino communication

  SerialBT.begin("SmartBlindStick");   // Bluetooth name

  Serial.println("System Ready");
  Serial.println("Bluetooth device name: SmartBlindStick");
}

void loop() {

  // Read data coming from Arduino
  if (Serial2.available()) {

    String data = Serial2.readStringUntil('\n');

    // Send to phone via Bluetooth
    SerialBT.println(data);

    // Print in serial monitor for debugging
    Serial.println(data);
  }

  // If phone sends something back (optional)
  if (SerialBT.available()) {

    String phoneData = SerialBT.readStringUntil('\n');

    Serial2.println(phoneData);   // Send back to Arduino if needed

    Serial.println("From Phone: " + phoneData);
  }

}
