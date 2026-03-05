#include "BluetoothSerial.h"

BluetoothSerial SerialBT;

void setup()
{
Serial.begin(9600); // from Arduino
SerialBT.begin("SmartBlindStick");

Serial.println("Bluetooth Ready");
}

void loop()
{
if(Serial.available())
{
String data = Serial.readStringUntil('\n');

SerialBT.println(data);

Serial.println(data);
}
}
