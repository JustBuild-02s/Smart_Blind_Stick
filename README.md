# 🦯 Smart Blind Stick 

## 📌 Overview
The **Smart Blind Stick** is an assistive device designed to improve mobility and safety for visually impaired individuals. The system detects obstacles at different levels and provides alerts through vibration and buzzer feedback.  

The hardware uses **Arduino for sensor processing** and **ESP32 for wireless communication**, which sends data to a mobile application via Bluetooth.

The device is designed as a **modular attachment** that can be mounted on any standard white cane, making it affordable, scalable, and easy to use.

---

## 🎥 Project Demo

[![Watch the video](https://img.youtube.com/vi/pyK723nVZv4/0.jpg)](https://youtu.be/pyK723nVZv4)

---

## 🚀 Features

- Obstacle detection (Head level)
- Ground obstacle detection
- Left and right side obstacle detection
- Pothole / wet surface detection
- Stick fall detection using IMU
- Vibration and buzzer alerts
- SOS emergency trigger
- Bluetooth connectivity with mobile app
- Modular design that can attach to any cane

---

## 🧠 System Architecture

Sensors → **Arduino (Processing)** → **ESP32 (Bluetooth/WiFi)** → **Mobile App**

---

## 📡 Communication

Arduino processes sensor data and sends alerts to **ESP32 through Serial communication**.

ESP32 then transmits this information to the **mobile application via Bluetooth**.

Example alerts:
Obstacle Left
Obstacle Right
Ground Obstacle
Stick Fallen
SOS
