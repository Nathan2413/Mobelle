#include <WiFi.h>
#include <ESP32Servo.h>

// WiFi credentials
const char* ssid = "Hello";
const char* password = "Carl020701T#an"; 

// Servo motor and infrared sensor pins
Servo myservo;
int servoPin = 13;
int irSensorPin = 34;  // Utilisez la broche connectée à SIG du capteur infrarouge
int irSensorValue = 0;

// Ultrasonic sensor pins
const int trigPin = 5;
const int echoPin = 18;
long duration;
int distance;

void setup() {
  Serial.begin(115200);

  // Connect to Wi-Fi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi");

  // Configure servo
  myservo.attach(servoPin);
  myservo.write(-25); // Initialize servo at -25 degrees

  // Configure infrared sensor pin
  pinMode(irSensorPin, INPUT);

  // Configure ultrasonic sensor pins
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
}

void loop() {
  irSensorValue = digitalRead(irSensorPin);  // Read digital value from infrared sensor

  // Measure distance using ultrasonic sensor
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH);
  distance = duration * 0.034 / 2;

  // Print the ultrasonic distance to the Serial Monitor
  Serial.print("Ultrasonic Distance: ");
  Serial.print(distance);
  Serial.println(" cm");

  if (irSensorValue == LOW) {  // Si l'infrarouge détecte un objet
    if (distance >= 2.5 && distance <= 20) {  // Si la distance est comprise entre 2.5 cm et 20 cm
      Serial.println("Infrared detected, Ultrasonic distance between 2.5 cm and 20 cm. Servo at 45 degrees.");
      myservo.write(45); // Déplacer le servo à 45 degrés
    } else {
      Serial.println("Infrared detected, but Ultrasonic distance is out of range. Servo remains at -25 degrees.");
      myservo.write(-25); // Garder le servo à -25 degrés
    }
  } else {
    Serial.println("No infrared detection. Servo remains at -25 degrees.");
    myservo.write(-25); // Garder le servo à -25 degrés
  }
  
  delay(1000); // Attendre 1 seconde avant de vérifier à nouveau
}
